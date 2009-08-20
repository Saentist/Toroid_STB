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
  `tf_part_num`		enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'),
  `tf_num_of_parts`	enum('2','3','4','5','6','7','8','9','10','11','12','13','14','15'),
  `tf_cc`		enum('Y','N'),
  `tf_stereo`		enum('Y','N'),
  `tf_user_data_1`	char(1) NOT NULL,
  `tf_live_tape_delay`	enum('Live','Tape','Delay'),
  `tf_subtitled`	enum('Y','N'),
  `tf_premiere_finale`	enum('Premiere','Season Premiere','Series Premiere','Season Finale','Series Finale'),
  `tf_joined_in_progress`	enum('Y','N'),
  `tf_cable_in_the_classroom`	enum('Y','N'),
  `tf_tv_rating`	enum('TVY','TVY7','TVG','TVPG','TV14','TVMA'),
  `tf_sap`		enum('Y','N'),
  `tf_user_data_2`	char(1) NOT NULL,
  `tf_sex_rating`	enum('Y','N'),
  `tf_violence_rating`	enum('Y','N'),
  `tf_language_rating`	enum('Y','N'),
  `tf_dialog_rating`	enum('Y','N'),
  `tf_fv_rating`	enum('Y','N'),
  `tf_enhanced`		enum('Y','N'),
  `tf_three_d`		enum('Y','N'),
  `tf_letterbox`	enum('Y','N'),
  `tf_hdtv`		enum('Y','N'),
  `tf_dolby`		enum('Dolby','DD','DD5.1','DSS'),
  `tf_dvs`		enum('Y','N'),
  `tf_user_data_3`	char(1) NOT NULL,
  `tf_new`		char(3) NOT NULL,
  `tf_net_syn_source`	char(10) NOT NULL,
  `tf_net_syn_type`	char(21) NOT NULL,
  `tf_subject_to_blackout`	char(20) NOT NULL,
  `tf_time_approximate`	char(16) NOT NULL,
  `tf_dubbed`		enum('Y','N'),
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
  `tf_advisory_desc_1`	enum('Adult Situations', 'Brief Nudity', 'Graphic Language',
'Graphic Violence', 'Language', 'Mild Violence', 'Nudity', 'Rape', 'Strong Sexual Content', 'Violence'),
  `tf_advisory_desc_2`	enum('Adult Situations', 'Brief Nudity', 'Graphic Language',
'Graphic Violence', 'Language', 'Mild Violence', 'Nudity', 'Rape', 'Strong Sexual Content', 'Violence'),
  `tf_advisory_desc_3`	enum('Adult Situations', 'Brief Nudity', 'Graphic Language',
'Graphic Violence', 'Language', 'Mild Violence', 'Nudity', 'Rape', 'Strong Sexual Content', 'Violence'),
  `tf_advisory_desc_4`	enum('Adult Situations', 'Brief Nudity', 'Graphic Language',
'Graphic Violence', 'Language', 'Mild Violence', 'Nudity', 'Rape', 'Strong Sexual Content', 'Violence'),
  `tf_advisory_desc_5`	enum('Adult Situations', 'Brief Nudity', 'Graphic Language',
'Graphic Violence', 'Language', 'Mild Violence', 'Nudity', 'Rape', 'Strong Sexual Content', 'Violence'),
  `tf_advisory_desc_6`	enum('Adult Situations', 'Brief Nudity', 'Graphic Language',
'Graphic Violence', 'Language', 'Mild Violence', 'Nudity', 'Rape', 'Strong Sexual Content', 'Violence'),
  `tf_cast_first_name_1`	char(20) NOT NULL,
  `tf_cast_last_name_1`	char(20) NOT NULL,
  `tf_cast_role_desc_1`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_2`	char(20) NOT NULL,
  `tf_cast_last_name_2`	char(20) NOT NULL,
  `tf_cast_role_desc_2`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_3`	char(20) NOT NULL,
  `tf_cast_last_name_3`	char(20) NOT NULL,
  `tf_cast_role_desc_3`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_4`	char(20) NOT NULL,
  `tf_cast_last_name_4`	char(20) NOT NULL,
  `tf_cast_role_desc_4`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_5`	char(20) NOT NULL,
  `tf_cast_last_name_5`	char(20) NOT NULL,
  `tf_cast_role_desc_5`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_6`	char(20) NOT NULL,
  `tf_cast_last_name_6`	char(20) NOT NULL,
  `tf_cast_role_desc_6`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_7`	char(20) NOT NULL,
  `tf_cast_last_name_7`	char(20) NOT NULL,
  `tf_cast_role_desc_7`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_8`	char(20) NOT NULL,
  `tf_cast_last_name_8`	char(20) NOT NULL,
  `tf_cast_role_desc_8`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_9`	char(20) NOT NULL,
  `tf_cast_last_name_9`	char(20) NOT NULL,
  `tf_cast_role_desc_9`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_10`	char(20) NOT NULL,
  `tf_cast_last_name_10`	char(20) NOT NULL,
  `tf_cast_role_desc_10`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_11`	char(20) NOT NULL,
  `tf_cast_last_name_11`	char(20) NOT NULL,
  `tf_cast_role_desc_11`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_12`	char(20) NOT NULL,
  `tf_cast_last_name_12`	char(20) NOT NULL,
  `tf_cast_role_desc_12`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_13`	char(20) NOT NULL,
  `tf_cast_last_name_13`	char(20) NOT NULL,
  `tf_cast_role_desc_13`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_14`	char(20) NOT NULL,
  `tf_cast_last_name_14`	char(20) NOT NULL,
  `tf_cast_role_desc_14`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_15`	char(20) NOT NULL,
  `tf_cast_last_name_15`	char(20) NOT NULL,
  `tf_cast_role_desc_15`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_16`	char(20) NOT NULL,
  `tf_cast_last_name_16`	char(20) NOT NULL,
  `tf_cast_role_desc_16`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_17`	char(20) NOT NULL,
  `tf_cast_last_name_17`	char(20) NOT NULL,
  `tf_cast_role_desc_17`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_18`	char(20) NOT NULL,
  `tf_cast_last_name_18`	char(20) NOT NULL,
  `tf_cast_role_desc_18`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_cast_first_name_19`	char(20) NOT NULL,
  `tf_cast_last_name_19`	char(20) NOT NULL,
  `tf_cast_role_desc_19`	enum('Actor', 'Guest Star', 'Narrator', 'Judge', 'Contestant', 'Guest', 'Music Guest', 'Anchor'),
  `tf_credits_first_name_1`	char(20) NOT NULL,
  `tf_credits_last_name_1`	char(20) NOT NULL,
  `tf_credits_role_desc_1`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_2`	char(20) NOT NULL,
  `tf_credits_last_name_2`	char(20) NOT NULL,
  `tf_credits_role_desc_2`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_3`	char(20) NOT NULL,
  `tf_credits_last_name_3`	char(20) NOT NULL,
  `tf_credits_role_desc_3`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_4`	char(20) NOT NULL,
  `tf_credits_last_name_4`	char(20) NOT NULL,
  `tf_credits_role_desc_4`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_5`	char(20) NOT NULL,
  `tf_credits_last_name_5`	char(20) NOT NULL,
  `tf_credits_role_desc_5`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_6`	char(20) NOT NULL,
  `tf_credits_last_name_6`	char(20) NOT NULL,
  `tf_credits_role_desc_6`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_7`	char(20) NOT NULL,
  `tf_credits_last_name_7`	char(20) NOT NULL,
  `tf_credits_role_desc_7`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_8`	char(20) NOT NULL,
  `tf_credits_last_name_8`	char(20) NOT NULL,
  `tf_credits_role_desc_8`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_9`	char(20) NOT NULL,
  `tf_credits_last_name_9`	char(20) NOT NULL,
  `tf_credits_role_desc_9`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_10`	char(20) NOT NULL,
  `tf_credits_last_name_10`	char(20) NOT NULL,
  `tf_credits_role_desc_10`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_11`	char(20) NOT NULL,
  `tf_credits_last_name_11`	char(20) NOT NULL,
  `tf_credits_role_desc_11`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_12`	char(20) NOT NULL,
  `tf_credits_last_name_12`	char(20) NOT NULL,
  `tf_credits_role_desc_12`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_13`	char(20) NOT NULL,
  `tf_credits_last_name_13`	char(20) NOT NULL,
  `tf_credits_role_desc_13`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_14`	char(20) NOT NULL,
  `tf_credits_last_name_14`	char(20) NOT NULL,
  `tf_credits_role_desc_14`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_15`	char(20) NOT NULL,
  `tf_credits_last_name_15`	char(20) NOT NULL,
  `tf_credits_role_desc_15`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_16`	char(20) NOT NULL,
  `tf_credits_last_name_16`	char(20) NOT NULL,
  `tf_credits_role_desc_16`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_17`	char(20) NOT NULL,
  `tf_credits_last_name_17`	char(20) NOT NULL,
  `tf_credits_role_desc_17`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_18`	char(20) NOT NULL,
  `tf_credits_last_name_18`	char(20) NOT NULL,
  `tf_credits_role_desc_18`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_credits_first_name_19`	char(20) NOT NULL,
  `tf_credits_last_name_19`	char(20) NOT NULL,
  `tf_credits_role_desc_19`	enum('Director', 'Executive Producer', 'Host', 'Producer', 'Writer'),
  `tf_genre_desc_1`	char(30) NOT NULL,
  `tf_genre_desc_2`	char(30) NOT NULL,
  `tf_genre_desc_3`	char(30) NOT NULL,
  `tf_genre_desc_4`	char(30) NOT NULL,
  `tf_genre_desc_5`	char(30) NOT NULL,
  `tf_genre_desc_6`	char(30) NOT NULL,
  `tf_desc`	varchar(255) NOT NULL,
  `tf_year`	char(4) NOT NULL,
  `tf_mpaa_rating`	enum('AO','GP','G','NC-17','NR','PG','PG-13','M','X','R'),
  `tf_star_rating`	enum('*','*+','**','**+','***','***+','****'),
  `tf_run_time`	char(4) NOT NULL,
  `tf_color_code`	enum('B & W', 'Color', 'Color and B & W', 'Colorized'),
  `tf_program_language`	char(40) NOT NULL,
  `tf_org_country`	char(15) NOT NULL,
  `tf_made_for_tv`	enum('Y','N'),
  `tf_source_type`	enum('Block','Local','Network','Syndicated'),
  `tf_show_type`	enum('Limited Series','Miniseries','Paid Programming','Serial','Series','Short Film','Special'),
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

alter table tms_schedules add foreign key database_key_idx (tf_database_key) references tms_programs(tf_database_key)
	on update cascade  on delete cascade;


/* Section 4.4.4, import tranrec.txt */

DROP TABLE IF EXISTS `tms_translations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tms_translations` (
  `tf_english_trans`	char(30) NOT NULL,
  `tf_program_language`	char(40) NOT NULL,
  `tf_language_trans`	char(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tribune translations (tranrec.txt)';
SET character_set_client = @saved_cs_client;


/* Section 4.4.5, import timezonerec.txt */

DROP TABLE IF EXISTS `tms_timezones`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tms_timezones` (
  `tf_time_zone_name`	char(45) NOT NULL,
  `tf_date1`	char(8) NOT NULL,
  `tf_time1`	char(4) NOT NULL,
  `tf_date2`	char(8) NOT NULL,
  `tf_time2`	char(4) NOT NULL,
  `tf_utc_std_offset`	char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tribune timezones (timezonerec.txt)';
SET character_set_client = @saved_cs_client;


