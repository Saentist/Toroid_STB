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


/* Section 4.4.3, import progrec.txt */

DROP TABLE IF EXISTS `tms_programs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tms_programs` (
  `tf_database_key`	char(14) NOT NULL,
/* test char vs. varchar for performance */
  `tf_title`		varchar(120) NOT NULL,
  `tf_reduced_title_70`	char(70) NOT NULL,
  `tf_reduced_title_40`	char(40) NOT NULL,
  `tf_reduced_title_20`	char(20) NOT NULL,
  `tf_reduced_title_10`	char(10) NOT NULL,
  `tf_alt_title`	varchar(120) NOT NULL,
  `tf_reduced_desc_100`	char(100) NOT NULL,
  `tf_reduced_desc_60`	char(60) NOT NULL,
  `tf_reduced_desc_40`	char(40) NOT NULL,
  `tf_advisory_desc_1`	char(30) NOT NULL,
  `tf_advisory_desc_2`	char(30) NOT NULL,
  `tf_advisory_desc_3`	char(30) NOT NULL,
  `tf_advisory_desc_4`	char(30) NOT NULL,
  `tf_advisory_desc_5`	char(30) NOT NULL,
  `tf_advisory_desc_6`	char(30) NOT NULL,
  `tf_cast_first_name_1`	char(20) NOT NULL,
  `tf_cast_last_name_1`	char(20) NOT NULL,
  `tf_cast_role_desc_1`	char(30) NOT NULL,
  `tf_cast_first_name_2`	char(20) NOT NULL,
  `tf_cast_last_name_2`	char(20) NOT NULL,
  `tf_cast_role_desc_2`	char(30) NOT NULL,
  `tf_cast_first_name_3`	char(20) NOT NULL,
  `tf_cast_last_name_3`	char(20) NOT NULL,
  `tf_cast_role_desc_3`	char(30) NOT NULL,
  `tf_cast_first_name_4`	char(20) NOT NULL,
  `tf_cast_last_name_4`	char(20) NOT NULL,
  `tf_cast_role_desc_4`	char(30) NOT NULL,
  `tf_cast_first_name_5`	char(20) NOT NULL,
  `tf_cast_last_name_5`	char(20) NOT NULL,
  `tf_cast_role_desc_5`	char(30) NOT NULL,
  `tf_cast_first_name_6`	char(20) NOT NULL,
  `tf_cast_last_name_6`	char(20) NOT NULL,
  `tf_cast_role_desc_6`	char(30) NOT NULL,
  `tf_cast_first_name_7`	char(20) NOT NULL,
  `tf_cast_last_name_7`	char(20) NOT NULL,
  `tf_cast_role_desc_7`	char(30) NOT NULL,
  `tf_cast_first_name_8`	char(20) NOT NULL,
  `tf_cast_last_name_8`	char(20) NOT NULL,
  `tf_cast_role_desc_8`	char(30) NOT NULL,
  `tf_cast_first_name_9`	char(20) NOT NULL,
  `tf_cast_last_name_9`	char(20) NOT NULL,
  `tf_cast_role_desc_9`	char(30) NOT NULL,
  `tf_cast_first_name_10`	char(20) NOT NULL,
  `tf_cast_last_name_10`	char(20) NOT NULL,
  `tf_cast_role_desc_10`	char(30) NOT NULL,
  `tf_cast_first_name_11`	char(20) NOT NULL,
  `tf_cast_last_name_11`	char(20) NOT NULL,
  `tf_cast_role_desc_11`	char(30) NOT NULL,
  `tf_cast_first_name_12`	char(20) NOT NULL,
  `tf_cast_last_name_12`	char(20) NOT NULL,
  `tf_cast_role_desc_12`	char(30) NOT NULL,
  `tf_cast_first_name_13`	char(20) NOT NULL,
  `tf_cast_last_name_13`	char(20) NOT NULL,
  `tf_cast_role_desc_13`	char(30) NOT NULL,
  `tf_cast_first_name_14`	char(20) NOT NULL,
  `tf_cast_last_name_14`	char(20) NOT NULL,
  `tf_cast_role_desc_14`	char(30) NOT NULL,
  `tf_cast_first_name_15`	char(20) NOT NULL,
  `tf_cast_last_name_15`	char(20) NOT NULL,
  `tf_cast_role_desc_15`	char(30) NOT NULL,
  `tf_cast_first_name_16`	char(20) NOT NULL,
  `tf_cast_last_name_16`	char(20) NOT NULL,
  `tf_cast_role_desc_16`	char(30) NOT NULL,
  `tf_cast_first_name_17`	char(20) NOT NULL,
  `tf_cast_last_name_17`	char(20) NOT NULL,
  `tf_cast_role_desc_17`	char(30) NOT NULL,
  `tf_cast_first_name_18`	char(20) NOT NULL,
  `tf_cast_last_name_18`	char(20) NOT NULL,
  `tf_cast_role_desc_18`	char(30) NOT NULL,
  `tf_cast_first_name_19`	char(20) NOT NULL,
  `tf_cast_last_name_19`	char(20) NOT NULL,
  `tf_cast_role_desc_19`	char(30) NOT NULL,
  `tf_credits_first_name_1`	char(20) NOT NULL,
  `tf_credits_last_name_1`	char(20) NOT NULL,
  `tf_credits_role_desc_1`	char(30) NOT NULL,
  `tf_credits_first_name_2`	char(20) NOT NULL,
  `tf_credits_last_name_2`	char(20) NOT NULL,
  `tf_credits_role_desc_2`	char(30) NOT NULL,
  `tf_credits_first_name_3`	char(20) NOT NULL,
  `tf_credits_last_name_3`	char(20) NOT NULL,
  `tf_credits_role_desc_3`	char(30) NOT NULL,
  `tf_credits_first_name_4`	char(20) NOT NULL,
  `tf_credits_last_name_4`	char(20) NOT NULL,
  `tf_credits_role_desc_4`	char(30) NOT NULL,
  `tf_credits_first_name_5`	char(20) NOT NULL,
  `tf_credits_last_name_5`	char(20) NOT NULL,
  `tf_credits_role_desc_5`	char(30) NOT NULL,
  `tf_credits_first_name_6`	char(20) NOT NULL,
  `tf_credits_last_name_6`	char(20) NOT NULL,
  `tf_credits_role_desc_6`	char(30) NOT NULL,
  `tf_credits_first_name_7`	char(20) NOT NULL,
  `tf_credits_last_name_7`	char(20) NOT NULL,
  `tf_credits_role_desc_7`	char(30) NOT NULL,
  `tf_credits_first_name_8`	char(20) NOT NULL,
  `tf_credits_last_name_8`	char(20) NOT NULL,
  `tf_credits_role_desc_8`	char(30) NOT NULL,
  `tf_credits_first_name_9`	char(20) NOT NULL,
  `tf_credits_last_name_9`	char(20) NOT NULL,
  `tf_credits_role_desc_9`	char(30) NOT NULL,
  `tf_credits_first_name_10`	char(20) NOT NULL,
  `tf_credits_last_name_10`	char(20) NOT NULL,
  `tf_credits_role_desc_10`	char(30) NOT NULL,
  `tf_credits_first_name_11`	char(20) NOT NULL,
  `tf_credits_last_name_11`	char(20) NOT NULL,
  `tf_credits_role_desc_11`	char(30) NOT NULL,
  `tf_credits_first_name_12`	char(20) NOT NULL,
  `tf_credits_last_name_12`	char(20) NOT NULL,
  `tf_credits_role_desc_12`	char(30) NOT NULL,
  `tf_credits_first_name_13`	char(20) NOT NULL,
  `tf_credits_last_name_13`	char(20) NOT NULL,
  `tf_credits_role_desc_13`	char(30) NOT NULL,
  `tf_credits_first_name_14`	char(20) NOT NULL,
  `tf_credits_last_name_14`	char(20) NOT NULL,
  `tf_credits_role_desc_14`	char(30) NOT NULL,
  `tf_credits_first_name_15`	char(20) NOT NULL,
  `tf_credits_last_name_15`	char(20) NOT NULL,
  `tf_credits_role_desc_15`	char(30) NOT NULL,
  `tf_credits_first_name_16`	char(20) NOT NULL,
  `tf_credits_last_name_16`	char(20) NOT NULL,
  `tf_credits_role_desc_16`	char(30) NOT NULL,
  `tf_credits_first_name_17`	char(20) NOT NULL,
  `tf_credits_last_name_17`	char(20) NOT NULL,
  `tf_credits_role_desc_17`	char(30) NOT NULL,
  `tf_credits_first_name_18`	char(20) NOT NULL,
  `tf_credits_last_name_18`	char(20) NOT NULL,
  `tf_credits_role_desc_18`	char(30) NOT NULL,
  `tf_credits_first_name_19`	char(20) NOT NULL,
  `tf_credits_last_name_19`	char(20) NOT NULL,
  `tf_credits_role_desc_19`	char(30) NOT NULL,
  `tf_genre_desc_1`	char(30) NOT NULL,
  `tf_genre_desc_2`	char(30) NOT NULL,
  `tf_genre_desc_3`	char(30) NOT NULL,
  `tf_genre_desc_4`	char(30) NOT NULL,
  `tf_genre_desc_5`	char(30) NOT NULL,
  `tf_genre_desc_6`	char(30) NOT NULL,
  `tf_desc`	varchar(255) NOT NULL,
  `tf_year`	char(4) NOT NULL,
  `tf_mpaa_rating`	char(5) NOT NULL,
  `tf_star_rating`	char(5) NOT NULL,
  `tf_run_time`	char(4) NOT NULL,
  `tf_color_code`	char(20) NOT NULL,
  `tf_program_language`	char(40) NOT NULL,
  `tf_org_country`	char(15) NOT NULL,
  `tf_made_for_tv`	char(1) NOT NULL,
  `tf_source_type`	char(10) NOT NULL,
  `tf_show_type`	char(30) NOT NULL,
  `tf_holiday`	char(30) NOT NULL,
  `tf_syn_epi_num`	char(20) NOT NULL,
  `tf_alt_syn_epi_num`	char(20) NOT NULL,
  `tf_epi_title`	char(150) NOT NULL,
  `tf_user_data_1`	char(1) NOT NULL,
  `tf_user_data_2`	char(1) NOT NULL,
  `tf_actor_desc`	varchar(255) NOT NULL,
  `tf_reduced_actor_desc`	char(100) NOT NULL,
  `tf_org_studio`	char(25) NOT NULL,
  `tf_game_date`	char(8) NOT NULL,
  `tf_game_time`	char(4) NOT NULL,
  `tf_game_time_zone`	char(45) NOT NULL,
  `tf_org_air_date`	char(8) NOT NULL,
  `tf_user_data_3`	char(1) NOT NULL,
  `tf_500_desc`	varchar(500) NOT NULL,

  PRIMARY KEY (tf_database_key)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tribune programs (progrec.txt)';
SET character_set_client = @saved_cs_client;

/*
create unique index station_num_call_sign_idx on tms_stations(tf_station_num, tf_station_call_sign);
*/

alter table tms_schedules add foreign key database_key_idx (tf_database_key) references tms_programs(tf_database_key)
	on update cascade  on delete cascade;


load data infile '/home/jesse/dev/toroid/sql/statrec.txt' replace into table tms_stations fields terminated by '|';
load data infile '/home/jesse/dev/toroid/sql/progrec.txt' replace into table tms_programs fields terminated by '|';
load data infile '/home/jesse/dev/toroid/sql/skedrec.txt' replace into table tms_schedules fields terminated by '|';
