#!/bin/bash

#/*
# * Copyright (c) 2009, Kentec Communications, Inc.
# * All rights reserved.
# *
# * Redistribution and use in source and binary forms, with or without
# * modification, are permitted provided that the following conditions are met:
# *
# *     * Redistributions of source code must retain the above copyright
# *       notice, this list of conditions and the following disclaimer.
# *     * Redistributions in binary form must reproduce the above copyright
# *       notice, this list of conditions and the following disclaimer in the
# *       documentation and/or other materials provided with the distribution.
# *     * Neither the name of Kentec Communications, Inc. nor the names of its
# *       contributors may be used to endorse or promote products derived
# *       from this software without specific prior written permission.
# *
# * THIS SOFTWARE IS PROVIDED BY THE AUTHOR OR CONTRIBUTORS ``AS IS'' AND ANY
# * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY
# * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# */

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH

# Toroid top level directory
TOROID_DIR=/opt/toroid

# Directory to download files to
IMPORT_DIR=${TOROID_DIR}/import/data

TMS_HOST=ftp.tmstv.com
TMS_PATH="pub/"

# these are the files to download (leave off .gz)
TMS_FILES="statrec.txt progrec.txt skedrec.txt tranrec.txt timezonerec.txt"
# these are the files to insert
DB_FILES=(statrec.txt progrec.txt skedrec.txt tranrec.txt timezonerec.txt)
# these are the tables to insert into; match the order with DB_FILES
DB_TABLES=(tms_stations tms_programs tms_schedules tms_translations tms_timezones)

LOG_DIR="${TOROID_DIR}/log"
LOG="${LOG_DIR}/`basename $0 .sh`.log"

MW_DB="toroid"
MW_DB_HOST="localhost"
MW_DB_USER="toroid"
MW_DB_PW="ToRoidPASS"

# if you have tms tables in a separate database:
TMS_DB=${MW_DB}
TMS_DB_HOST=${MW_DB_HOST}
TMS_DB_USER=${MW_DB_USER}
TMS_DB_PW=${MW_DB_PW}

log()
{
	DT="`date '+%Y%m%d %T'`"
	if [ "X$1" == "X-e" ]; then shift; echo ${1} 1>&2; fi
	echo ${DT} ${1} >> ${LOG}
}

if [ ! -d ${IMPORT_DIR} ]
then
	echo "Error: ${IMPORT_DIR} is not a directory" 1>&2
	exit 1
fi

cd ${IMPORT_DIR}
touch _IMPORT_DIR_TEST_ 2>/dev/null

if [ $? -gt 0 ] || [ ! -w _IMPORT_DIR_TEST_ ]
then
	echo "Error: can't write test file to ${IMPORT_DIR}" 1>&2
	exit 1
else
	rm -f _IMPORT_DIR_TEST_
fi

touch ${LOG}

if [ ! -w ${LOG} ]
then
	echo "Error: can't write to log file ${LOG}" 1>&2
	exit 1
fi

log "Looking up Tribune username/password"

sql="select value from t_settings where module = 'eas' and name='tms_username'"
TMS_USER="`mysql -u ${MW_DB_USER} --password=${MW_DB_PW} -f --batch ${MW_DB} -N -e \"${sql}\"`"

sql="select value from t_settings where module = 'eas' and name='tms_password'"
TMS_PASS="`mysql -u ${MW_DB_USER} --password=${MW_DB_PW} -f --batch ${MW_DB} -N -e \"${sql}\"`"

TMS_URL="ftp://${TMS_USER}:${TMS_PASS}@${TMS_HOST}/${TMS_PATH}/"

if [ "${TMS_USER}" == "" ] || [ "${TMS_PASS}" == "" ]
then
	exit -1
fi

if command -v wget >/dev/null
then
	GET="wget -Nnv -a ${LOG} "
elif command -v curl >/dev/null
then
	GET="curl -sO "
else
	log -e "Error: can't run, please install wget or curl"
	exit 1
fi

log "==========="
log "Starting"

trap "log -e 'Error: exiting abnormally'" 0

for F in ${TMS_FILES}
do
	GZ=${F}.gz
	rm -f ${F}
	if ! ${GET} ${TMS_URL}/${GZ}
	then
		log -e "Error getting ${F}, aborting!"
		trap 0; exit 1
	fi
	umask 022
	gunzip --stdout ${GZ} > ${F}
done

i=0
for f in ${DB_FILES[@]}
do
	file=${IMPORT_DIR}/${DB_FILES[$i]}
	tabl=${DB_TABLES[$i]}
	if [ -f ${file} ]
	then
		log "Inserting ${file} into ${tabl}"
		sql="load data infile '${file}' replace into table ${tabl} fields terminated by '|';"
		mysql -u ${TMS_DB_USER} --password=${TMS_DB_PW} --tee=${LOG} -f --batch ${TMS_DB} -e "${sql}" | grep -v 'Logging to file'
	else
		log -e "Error: ${file} not found"
	fi

	i=`expr $i + 1`
done

log "Ending"
log "==========="

trap 0
exit

