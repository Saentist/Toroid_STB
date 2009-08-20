/*
  This is a reworking of the toroid sql schema according to cakephp naming conventions,
  plus ongoing additions/work.  We don't yet have incremental updates/sql alters.
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
/*
  Need to add some field for things like:
	default content rating
	encoding format (mpeg 2/4, etc.)
	sd / hd
*/
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channels/IPTV streams';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_channels`
--

LOCK TABLES `t_channels` WRITE;
INSERT INTO `t_channels` VALUES (1,'EAS','EAS','225.0.0.1',3000,1),(2,'CBS','KMVT','226.0.0.2',3000,1);
UNLOCK TABLES;


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

LOCK TABLES `t_genres` WRITE;
INSERT INTO `t_genres` (name) VALUES ('General'),('News'),('Sports'),('Family'),('Local'),
	('Movie'),('Educational'),('Adult'),('Politics'),('Religion'),('Shopping'),('Music'),
	('Comedy'),('Drama');
UNLOCK TABLES;


DROP TABLE IF EXISTS `t_channel_genres`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channel_genres` (
  `id` bigint(10) NOT NULL auto_increment,
  `channel_id` bigint(10) NOT NULL,
  `genre_id` bigint(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Toroid Channel/Genre tie table';
SET character_set_client = @saved_cs_client;


alter table t_channel_genres add foreign key (channel_id) references t_channels(id)
        on update cascade  on delete cascade;
alter table t_channel_genres add foreign key (genre_id) references t_genres(id)
        on update cascade  on delete cascade;

create unique index t_channel_genre_idx on t_channel_genres(channel_id, genre_id);


