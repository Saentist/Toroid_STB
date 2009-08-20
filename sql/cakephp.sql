/*
  This is a reworking of the toroid sql schema,
  eventually towards cakephp naming conventions.
  We don't yet have incremental updates/sql alters.
*/

DROP TABLE IF EXISTS `t_channels`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channels` (
  `id` bigint(10) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL COMMENT 'Human identifiable name',
  `description` varchar(255) COMMENT '(optional)',
  `display_name` varchar(64) COMMENT 'Name displayed on client screen (short)',
  `protocol` varchar(20) COMMENT 'Streaming protocol, set as needed. eg. udp',
  `ip_addr` varchar(64) COMMENT 'IP address of channel, eg. multicast addr.',
  `port` smallint unsigned COMMENT 'Port number (optional)',
  `orig_ip_addr` varchar(64) COMMENT 'IP address of unencrypted channel (optional)',
  `orig_port` smallint unsigned COMMENT 'Port number of unencrypted channel (optional)',
  `icon` varchar(255) COMMENT 'URL to channel icon (optional)',
  `status` enum('enabled','hidden','disabled'),
  `language` varchar(128) COMMENT '(optional)',
  `epg_source` enum('tms','xmltv','local'),
  `epg_station_id` varchar(128) COMMENT 'ID to tie to EPG channel, eg. Tribune Media station number (optional)',
  `bitrate` bigint(16) COMMENT 'Normal bitrate (bits per second) (optional)',
  `max_bitrate` bigint(16) COMMENT 'Maximum bitrate (bits per second) (optional)',
  `ppv` bit(1) NOT NULL default B'0' COMMENT 'This Channel is Pay Per View',
/* Need to add a field for default content rating */
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channels/IPTV streams';
SET character_set_client = @saved_cs_client;

INSERT INTO `t_channels` (name, display_name, ip_addr, port, status)  VALUES ('Channel X','Chan X','239.1.2.3',3000,'enabled');


DROP TABLE IF EXISTS `t_genres`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_genres` (
  `id` bigint(10) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) COMMENT '(optional)',
  `audience` varchar(128) COMMENT 'target audience (optional)',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Genres';
SET character_set_client = @saved_cs_client;

INSERT INTO `t_genres` (name) VALUES ('General'),('News'),('Sports'),('Family'),('Local'),
	('Movie'),('Educational'),('Adult'),('Politics'),('Religion'),('Shopping'),('Music'),
	('Comedy'),('Drama');


DROP TABLE IF EXISTS `t_channel_genres_tie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channel_genres_tie` (
  `id` bigint(10) NOT NULL auto_increment,
  `channel_id` bigint(10) NOT NULL,
  `genre_id` bigint(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channel/Genre tie table';
SET character_set_client = @saved_cs_client;

alter table t_channel_genres_tie add foreign key (channel_id) references t_channels(id)
        on update cascade  on delete cascade;
alter table t_channel_genres_tie add foreign key (genre_id) references t_genres_tie(id)
        on update cascade  on delete cascade;
create unique index t_channel_genre_idx on t_channel_genres_tie(channel_id, genre_id);



DROP TABLE IF EXISTS `t_channel_prop`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channel_prop` (
  `id` bigint(10) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  `description` varchar(128) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channel Properties';
SET character_set_client = @saved_cs_client;

INSERT INTO `t_channel_prop` (name) VALUES ('MPEG-2'),('MPEG-4'),('SD'),('HD');


DROP TABLE IF EXISTS `t_channel_prop_tie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channel_prop_tie` (
  `id` bigint(10) NOT NULL auto_increment,
  `channel_id` bigint(10) NOT NULL,
  `channel_property_id` bigint(10) NOT NULL,
  `mandatory` bit(1) NOT NULL default B'1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channel/Property tie table';
SET character_set_client = @saved_cs_client;

alter table t_channel_prop_tie add foreign key (channel_id) references t_channels(id)
        on update cascade  on delete cascade;
alter table t_channel_prop_tie add foreign key (channel_property_id) references t_channel_prop(id)
        on update cascade  on delete cascade;
create unique index t_channel_prop_tie_idx on t_channel_prop_tie(channel_id, channel_property_id);


DROP TABLE IF EXISTS `t_channel_groups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channel_groups` (
  `id` bigint(10) NOT NULL auto_increment,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL,
  `enabled` bit(1) NOT NULL default B'1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channel Groups';
SET character_set_client = @saved_cs_client;

INSERT INTO `t_channel_groups` (name) VALUES ('Basic'),('Expanded'),('Music'),
	('HBO'),('Cinemax'),('Showtime'),('Starz'),
	('Sports'),('News'),('Locals');



DROP TABLE IF EXISTS `t_channel_group_tie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channel_group_tie` (
  `id` bigint(10) NOT NULL auto_increment,
  `channel_group_id` bigint(10) NOT NULL,
  `channel_num` bigint(10) NOT NULL,
  `channel_id` bigint(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channel/Group tie table';
SET character_set_client = @saved_cs_client;

alter table t_channel_group_tie add foreign key (channel_group_id) references t_channel_groups(id)
        on update cascade  on delete cascade;
alter table t_channel_group_tie add foreign key (channel_id) references t_channels(id)
        on update cascade  on delete cascade;
create unique index t_channel_group_tie_idx on t_channel_group_tie(channel_group_id, channel_num);



DROP TABLE IF EXISTS `t_packages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_packages` (
  `id` bigint(10) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `description` varchar(255) NOT NULL,
  `enabled` bit(1) NOT NULL default B'1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channel Package';
SET character_set_client = @saved_cs_client;

INSERT INTO `t_channel_groups` (name) VALUES ('Basic'),('Premium'),('HBO Promo');


DROP TABLE IF EXISTS `t_package_group_tie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_package_group_tie` (
  `id` bigint(10) NOT NULL auto_increment,
  `package_id` bigint(10) NOT NULL,
  `channel_group_id` bigint(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Package/Group tie table';
SET character_set_client = @saved_cs_client;

alter table t_package_group_tie add foreign key (package_id) references t_packages(id)
        on update cascade  on delete cascade;
alter table t_package_group_tie add foreign key (channel_group_id) references t_channel_groups(id)
        on update cascade  on delete cascade;
create unique index t_package_group_tie_idx on t_package_group_tie(package_id, channel_group_id);



DROP TABLE IF EXISTS `t_package_channel_tie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_package_channel_tie` (
  `id` bigint(10) NOT NULL auto_increment,
  `package_id` bigint(10) NOT NULL,
  `channel_num` bigint(10) NOT NULL,
  `channel_id` bigint(10) NOT NULL,
  `ppv` bit(1) COMMENT 'Override Channel Pay Per View within this Package',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Package/Channel tie table';
SET character_set_client = @saved_cs_client;

alter table t_package_channel_tie add foreign key (package_id) references t_packages(id)
        on update cascade  on delete cascade;
alter table t_package_channel_tie add foreign key (channel_id) references t_channels(id)
        on update cascade  on delete cascade;
create unique index t_package_channel_tie_idx on t_package_channel_tie(package_id, channel_num);



DROP TABLE IF EXISTS `t_company`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_company` (
  `id` mediumint(10) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `address1` varchar(50) NOT NULL,
  `address2` varchar(50) NOT NULL,
  `address3` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `zip` varchar(5) NOT NULL,
  `default` int(1) NOT NULL default '0',
  `enabled` int(1) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=latin1 COMMENT='Companies table for Toroid';
SET character_set_client = @saved_cs_client;


DROP TABLE IF EXISTS `t_operators`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_operators` (
  `id` smallint unsigned NOT NULL auto_increment,
  `username` varchar(64) NOT NULL,
  `password` varchar(128) NOT NULL,
  `firstname` varchar(32),
  `lastname` varchar(32),
  `email` varchar(90) NOT NULL,
  `enabled` bit(1) NOT NULL default B'1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Operators allowed to login to Toroid management';
SET character_set_client = @saved_cs_client;

INSERT INTO `t_operators` VALUES (1,'admin','1b2a7ebf667c4af863afe00866265c1b','System','Administrator','',1);



DROP TABLE IF EXISTS `t_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_settings` (
  `id` int(10) NOT NULL auto_increment,
  `module` varchar(32) NULL,
  `name` varchar(64) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Toroid specific settings';
SET character_set_client = @saved_cs_client;

create unique index t_settings_idx on t_settings(module, name);

