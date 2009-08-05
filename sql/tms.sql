/*
   These tables are specified in Tribune's 
   'TV Schedules 5.2.pdf' (Sept. 11, 2008),
   and used to direct import files from their
   'TV Schedules, US' product.  This schema
   and associated tools are released opensource,
   but Tribune's service is a commercial offering;
   contact them for an account to use this.
 */

/* Section 4.4.1, import skedrec.txt */

DROP TABLE IF EXISTS `tms_schedules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tms_schedules` (
  `tf_station_num`	char(10) NOT NULL,
  `tf_database_key`	char(14) NOT NULL,
  `tf_air_date`		char(8) NOT NULL,
  `tf_air_time`		char(4) NOT NULL,
  `tf_duration`		char(4) NOT NULL,
  `tf_part_num`		char(3) NOT NULL,
  `tf_num_of_parts`	char(3) NOT NULL,
  `tf_cc`		char(1) NOT NULL,
  `tf_stereo`		char(1) NOT NULL,
  `tf_user_data`	char(1) NOT NULL,
  `tf_live_tape_delay`	char(5) NOT NULL,
  `tf_subtitled`	char(1) NOT NULL,
  `tf_premiere_finale`	char(15) NOT NULL,
  `tf_joined_in_progress`	char(1) NOT NULL,
  `tf_cable_in_the_classroom`	char(1) NOT NULL,
  `tf_tv_rating`	char(4) NOT NULL,
  `tf_sap`		char(1) NOT NULL,
  `tf_user_data1`	char(1) NOT NULL,
  `tf_sex_rating`	char(1) NOT NULL,
  `tf_violence_rating`	char(1) NOT NULL,
  `tf_language_rating`	char(1) NOT NULL,
  `tf_dialog_rating`	char(1) NOT NULL,
  `tf_fv_rating`	char(1) NOT NULL,
  `tf_enhanced`		char(1) NOT NULL,
  `tf_three_d`		char(1) NOT NULL,
  `tf_letterbox`	char(1) NOT NULL,
  `tf_hdtv`		char(1) NOT NULL,
  `tf_dolby`		char(5) NOT NULL,
  `tf_dvs`		char(1) NOT NULL,
  `tf_user_data2`	char(1) NOT NULL,
  `tf_new`		char(3) NOT NULL,
  `tf_net_syn_source`	char(10) NOT NULL,
  `tf_net_syn_type`	char(21) NOT NULL,
  `tf_subject_to_blackout`	char(20) NOT NULL,
  `tf_time_approximate`	char(16) NOT NULL,
  `tf_dubbed`		char(1) NOT NULL,
  `tf_dubbed_language`	char(40) NOT NULL,
  `tf_ei`		char(3) NOT NULL,
  `tf_sap_language`	char(40) NOT NULL,
  `tf_subtitled_language`	char(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tribune schedules (skedrec.txt)';
SET character_set_client = @saved_cs_client;

create unique index station_date_time_idx on tms_schedules(tf_station_num, tf_air_date, tf_air_time);
create index air_date_idx on tms_schedules(tf_air_date);


/* Section 4.4.2, import statrec.txt */

DROP TABLE IF EXISTS `tms_stations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tms_stations` (
  `tf_station_num`	char(10) NOT NULL,
  `tf_station_time_zone`	char(45) NOT NULL,
  `tf_station_name`	char(40) NOT NULL,
  `tf_station_call_sign`	char(10) NOT NULL,
  `tf_station_affil`	char(25) NOT NULL,
  `tf_station_city`	char(20) NOT NULL,
  `tf_station_state`	char(15) NOT NULL,
  `tf_station_zip_code`	char(12) NOT NULL,
  `tf_station_country`	char(15) NOT NULL,
  `tf_dma_name`		char(70) NOT NULL,
  `tf_dma_num`		char(10) NOT NULL,
  `tf_fcc_channel_num`	char(8) NOT NULL,
  `tf_station_language`	char(40) NOT NULL,
  PRIMARY KEY (tf_station_num)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tribune stations (statrec.txt)';
SET character_set_client = @saved_cs_client;

create unique index station_num_call_sign_idx on tms_stations(tf_station_num, tf_station_call_sign);

alter table tms_schedules add foreign key station_num_idx (tf_station_num) references tms_stations(tf_station_num)
	on update cascade  on delete cascade;

/* this will be a foreign key to the programs table */
create index database_key_idx on tms_schedules(tf_database_key);

load data infile '/home/jesse/dev/toroid/sql/statrec.txt' replace into table tms_stations fields terminated by '|';
load data infile '/home/jesse/dev/toroid/sql/skedrec.txt' replace into table tms_schedules fields terminated by '|';
