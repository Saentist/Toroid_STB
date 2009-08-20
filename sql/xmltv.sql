/*
 * These tables are used when importing EPG data with XMLTV.
 * Currently only setup for Schedules Direct (US).
 */

DROP TABLE IF EXISTS `t_sd_lineups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_sd_lineups` (
  `id` smallint NOT NULL auto_increment,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `timeoffset` varchar(15) NOT NULL,
  `lineup` varchar(20) NOT NULL COMMET 'SchedulesDirect lineup id',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='XMLTV lineup settings for Schedules Direct';
SET character_set_client = @saved_cs_client;


LOCK TABLES `t_sd_lineups` WRITE;
/*!40000 ALTER TABLE `t_sd_lineups` DISABLE KEYS */;
INSERT INTO `t_sd_lineups` VALUES (1,'username','password','-0700','ID58906:X');
/*!40000 ALTER TABLE `t_sd_lineups` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `t_xmltv_channels`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_xmltv_channels` (
  `id` varchar(60) NOT NULL,
  `name` varchar(60) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Channel listing as imported from XMLTV';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_xmltv_channels`
--

LOCK TABLES `t_xmltv_channels` WRITE;
/*!40000 ALTER TABLE `t_xmltv_channels` DISABLE KEYS */;
INSERT INTO `t_xmltv_channels` VALUES ('I10021','55 AMC');
/*!40000 ALTER TABLE `t_xmltv_channels` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `t_xmltv_programs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_xmltv_programs` (
  `id` mediumint(10) NOT NULL auto_increment,
  `progid` varchar(70) NOT NULL,
  `start` varchar(70) NOT NULL,
  `stop` varchar(70) NOT NULL,
  `channelid` varchar(70) NOT NULL,
  `title` varchar(100) NOT NULL,
  `descr` varchar(500) NOT NULL,
  `credit_directors` varchar(500) NOT NULL,
  `credit_actors` varchar(500) NOT NULL,
  `credit_producers` varchar(500) NOT NULL,
  `date` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `length` varchar(50) NOT NULL,
  `subtitles` varchar(50) NOT NULL,
  `rating_vchip` varchar(50) NOT NULL,
  `rating_advisory` varchar(50) NOT NULL,
  `rating_mpaa` varchar(50) NOT NULL,
  `rating_star` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT 'XMLTV program guide data';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_xmltv_programs`
--

LOCK TABLES `t_xmltv_programs` WRITE;
/*!40000 ALTER TABLE `t_xmltv_programs` DISABLE KEYS */;
INSERT INTO `t_xmltv_programs` VALUES (1,'MV00003492.0000','20080628013000 -0700','20080628031500 -0700','I10021','And Now the Screaming Starts','An English doctor (Peter Cushing) helps a lord and his bride (Stephanie Beacham) cope with a severed hand and a curse.','credit_directors','credit_actors','credit_producers','1973','Horror','87','','TV-14','rating_advisory','rating_mpaa','rating_star'),(2,'MV00001992.0000','20080628031500 -0700','20080628051500 -0700','I10021','Drums Along the Mohawk','Newlyweds (Claudette Colbert, Henry Fonda) face Indians and the British in upstate New York during the Revolution.','credit_directors','credit_actors','credit_producers','1939','Historical drama','103','','TV-PG','rating_advisory','rating_mpaa','rating_star');
/*!40000 ALTER TABLE `t_xmltv_programs` ENABLE KEYS */;
UNLOCK TABLES;

