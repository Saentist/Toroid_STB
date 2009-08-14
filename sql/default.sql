-- Host: localhost    Database: toroid

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `t_channels`
--

DROP TABLE IF EXISTS `t_channels`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_channels` (
  `id` bigint(10) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `callsign` varchar(10) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `port` bigint(7) NOT NULL default '2000',
  `enabled` int(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COMMENT='Toroids Channel List';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_channels`
--

LOCK TABLES `t_channels` WRITE;
/*!40000 ALTER TABLE `t_channels` DISABLE KEYS */;
INSERT INTO `t_channels` VALUES (1,'EAS','EAS','225.0.0.1',3000,1),(2,'CBS','KMVT','226.0.0.2',3000,1);
/*!40000 ALTER TABLE `t_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_company`
--

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

--
-- Dumping data for table `t_company`
--

LOCK TABLES `t_company` WRITE;
/*!40000 ALTER TABLE `t_company` DISABLE KEYS */;
INSERT INTO `t_company` VALUES (28,'PMT','pmt@pmt.org','507 G. Street','','','Rupert','ID','83350',0,1);
/*!40000 ALTER TABLE `t_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_epg_channels`
--

DROP TABLE IF EXISTS `t_epg_channels`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_epg_channels` (
  `id` varchar(60) NOT NULL,
  `name` varchar(60) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Toroid EPG channel listings';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_epg_channels`
--

LOCK TABLES `t_epg_channels` WRITE;
/*!40000 ALTER TABLE `t_epg_channels` DISABLE KEYS */;
INSERT INTO `t_epg_channels` VALUES ('I10021','55 AMC');
/*!40000 ALTER TABLE `t_epg_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_epg_lineups`
--

DROP TABLE IF EXISTS `t_epg_lineups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_epg_lineups` (
  `id` mediumint(10) NOT NULL auto_increment,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `timeoffset` varchar(15) NOT NULL,
  `lineup` varchar(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Toroid lineup selection settings for tmsdatadirect';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_epg_lineups`
--

LOCK TABLES `t_epg_lineups` WRITE;
/*!40000 ALTER TABLE `t_epg_lineups` DISABLE KEYS */;
INSERT INTO `t_epg_lineups` VALUES (1,'username','password','-0700','ID58906:X');
/*!40000 ALTER TABLE `t_epg_lineups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_epg_programs`
--

DROP TABLE IF EXISTS `t_epg_programs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_epg_programs` (
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
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_epg_programs`
--

LOCK TABLES `t_epg_programs` WRITE;
/*!40000 ALTER TABLE `t_epg_programs` DISABLE KEYS */;
INSERT INTO `t_epg_programs` VALUES (1,'MV00003492.0000','20080628013000 -0700','20080628031500 -0700','I10021','And Now the Screaming Starts','An English doctor (Peter Cushing) helps a lord and his bride (Stephanie Beacham) cope with a severed hand and a curse.','credit_directors','credit_actors','credit_producers','1973','Horror','87','','TV-14','rating_advisory','rating_mpaa','rating_star'),(2,'MV00001992.0000','20080628031500 -0700','20080628051500 -0700','I10021','Drums Along the Mohawk','Newlyweds (Claudette Colbert, Henry Fonda) face Indians and the British in upstate New York during the Revolution.','credit_directors','credit_actors','credit_producers','1939','Historical drama','103','','TV-PG','rating_advisory','rating_mpaa','rating_star');
/*!40000 ALTER TABLE `t_epg_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_operators`
--

DROP TABLE IF EXISTS `t_operators`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_operators` (
  `id` mediumint(9) NOT NULL auto_increment,
  `username` varchar(20) NOT NULL,
  `password` varchar(90) NOT NULL,
  `firstname` varchar(20) NOT NULL,
  `lastname` varchar(20) NOT NULL,
  `email` varchar(90) NOT NULL,
  `enabled` int(1) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `uid` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COMMENT='Operators allowed to login to the Toroid management portal';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_operators`
--

LOCK TABLES `t_operators` WRITE;
/*!40000 ALTER TABLE `t_operators` DISABLE KEYS */;
INSERT INTO `t_operators` VALUES (1,'admin','1b2a7ebf667c4af863afe00866265c1b','System','Administrator','',1),(4,'brian','9106d106125d95b0dab1469dace5466c','Brian','McManus','bmcmanus@gmail.com',1);
/*!40000 ALTER TABLE `t_operators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_settings`
--

DROP TABLE IF EXISTS `t_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_settings` (
  `id` int(10) NOT NULL auto_increment,
  `module` varchar(30) NULL,
  `name` varchar(60) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Toroid specific settings';
SET character_set_client = @saved_cs_client;

create unique index t_settings_idx on t_settings(module, name);


--
-- Dumping data for table `t_settings`
--

LOCK TABLES `t_settings` WRITE;
/*!40000 ALTER TABLE `t_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_stbprofiles`
--

DROP TABLE IF EXISTS `t_stbprofiles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `t_stbprofiles` (
  `id` int(10) NOT NULL auto_increment,
  `stbname` varchar(50) NOT NULL,
  `vendor` varchar(50) NOT NULL,
  `stbmac` varchar(50) NOT NULL,
  `supportshtml` int(1) NOT NULL,
  `supportsjava` int(1) NOT NULL,
  `supportsaminet` int(1) NOT NULL,
  `enabled` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='This is the STBCap, or database of stb''s and the features th';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `t_stbprofiles`
--

LOCK TABLES `t_stbprofiles` WRITE;
/*!40000 ALTER TABLE `t_stbprofiles` DISABLE KEYS */;
INSERT INTO `t_stbprofiles` VALUES (1,'Amino 103','Amino','000202*',1,0,1,1),(2,'Amino 110','Amino','000202*',1,1,1,1);
/*!40000 ALTER TABLE `t_stbprofiles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2008-06-28 20:28:56
