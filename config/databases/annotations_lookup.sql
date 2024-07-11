-- MariaDB dump 10.17  Distrib 10.4.12-MariaDB, for OpenBSD (amd64)
--
-- Host: localhost    Database: annotations_lookup
-- ------------------------------------------------------
-- Server version	10.4.12-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `annotations_lookup`;

--
-- Table structure for table `agi_alias`
--

DROP TABLE IF EXISTS `agi_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agi_alias` (
  `agi` varchar(30) NOT NULL,
  `alias` varchar(30) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`agi`,`alias`,`date`),
  KEY `alias_date_agi` (`alias`,`date`,`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agi_alias`
--

LOCK TABLES `agi_alias` WRITE;
/*!40000 ALTER TABLE `agi_alias` DISABLE KEYS */;
INSERT INTO `agi_alias` VALUES ('At3g24650','ABI3','2019-04-02'),('At3g24650','AtABI3','2019-04-02'),('At3g24650','SIS10','2019-04-02');
/*!40000 ALTER TABLE `agi_alias` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

--
-- Table structure for table `at_agi_lookup`
--

DROP TABLE IF EXISTS `at_agi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `at_agi_lookup` (
  `probeset` varchar(60) NOT NULL,
  `agi` varchar(30) NOT NULL,
  `date` date NOT NULL DEFAULT '1000-01-01',
  PRIMARY KEY (`probeset`,`agi`,`date`),
  KEY `probeset_date_agi` (`probeset`,`agi`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `at_agi_lookup`
--

LOCK TABLES `at_agi_lookup` WRITE;
/*!40000 ALTER TABLE `at_agi_lookup` DISABLE KEYS */;
INSERT INTO `at_agi_lookup` VALUES ('261585_at','At1g01010','2010-12-20'),('261585_at','At1g01010','2009-07-29'),('261568_at','At1g01030','2010-12-20');
/*!40000 ALTER TABLE `at_agi_lookup` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-06-26 15:59:53