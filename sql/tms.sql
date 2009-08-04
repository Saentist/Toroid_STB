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
  `tf_user_data1`	char(4) NOT NULL,
  `tf_sex_rating`	char(4) NOT NULL,
  `tf_violence_rating`	char(4) NOT NULL,
  `tf_language_rating`	char(4) NOT NULL,
  `tf_dialog_rating`	char(4) NOT NULL,
  `tf_fv_rating`	char(4) NOT NULL,
  `tf_enhanced`		char(4) NOT NULL,
  `tf_three_d`		char(4) NOT NULL,
  `tf_letterbox`	char(4) NOT NULL,
  `tf_hdtv`		char(4) NOT NULL,
  `tf_dolby`		char(4) NOT NULL,
  `tf_dvs`		char(4) NOT NULL,
  `tf_user_data2`	char(4) NOT NULL,
  `tf_new`		char(4) NOT NULL,
  `tf_net_syn_source`	char(4) NOT NULL,
  `tf_net_syn_type`	char(4) NOT NULL,
  `tf_subject_to_blackout`	char(4) NOT NULL,
  `tf_time_approximate`	char(4) NOT NULL,
  `tf_dubbed`		char(4) NOT NULL,
  `tf_dubbed_language`	char(4) NOT NULL,
  `tf_ei`		char(4) NOT NULL,
  `tf_sap_language`	char(4) NOT NULL,
  `tf_subtitled_language`	char(4) NOT NULL,
  `tf_left_in_progress`	char(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tribune schedules (skedrec.txt)';
SET character_set_client = @saved_cs_client;

