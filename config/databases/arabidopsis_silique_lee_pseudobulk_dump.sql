-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_silique_lee_pseudobulk
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `arabidopsis_silique_lee_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_silique_lee_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_silique_lee_pseudobulk`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal`      float       DEFAULT '0',
  `data_signal_std`  float       DEFAULT '0',
  `data_bot_id`      varchar(64) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_data`
--

LOCK TABLES `sample_data` WRITE;
/*!40000 ALTER TABLE `sample_data` DISABLE KEYS */;
INSERT INTO `sample_data` VALUES ('AT1G01010',0.00320834,0.0470464,'Young_silique'),('AT1G01010',0.00849673,0.0783515,'Meristematic'),('AT1G01010',0.00426805,0.0556196,'Seed_(silique)'),('AT1G01010',0.0048397,0.0583574,'Stele'),('AT1G01010',0.00538508,0.0616613,'Epidermal'),('AT1G01010',0.00467711,0.0567459,'Guard'),('AT1G01010',0.00333244,0.0479455,'Mature_silique'),('AT1G01010',0.00496354,0.0593082,'Mean_CTRL'),('AT1G01020',0.011807,0.0915424,'Young_silique'),('AT1G01020',0.0236043,0.126986,'Meristematic'),('AT1G01020',0.0279497,0.138574,'Seed_(silique)'),('AT1G01020',0.023964,0.130114,'Stele'),('AT1G01020',0.0182852,0.11307,'Epidermal'),('AT1G01020',0.033481,0.149623,'Guard'),('AT1G01020',0.0166622,0.106168,'Mature_silique'),('AT1G01020',0.0222446,0.124802,'Mean_CTRL'),('AT1G01030',0.000875002,0.0246138,'Young_silique'),('AT1G01030',0.00210105,0.0381041,'Meristematic'),('AT1G01030',0.000714585,0.0222437,'Seed_(silique)'),('AT1G01030',0.0014921,0.0330832,'Stele'),('AT1G01030',0.0012279,0.0291472,'Epidermal'),('AT1G01030',0.000467711,0.0179991,'Guard'),('AT1G01030',0,0,'Mature_silique'),('AT1G01030',0.00131167,0.0306192,'Mean_CTRL');
/*!40000 ALTER TABLE `sample_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
-- Dump completed on 2026-07-30 00:24:58
