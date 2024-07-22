-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_ecotypes
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Current Database: `arabidopsis_ecotypes.sql`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_ecotypes` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_ecotypes`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `proj_title` tinytext,
  `proj_pi` tinytext,
  `proj_pi_title` tinytext,
  `proj_pi_inst` tinytext,
  `proj_pi_addr` tinytext,
  `proj_keyw1` tinytext,
  `proj_keyw2` tinytext,
  `proj_keyw3` tinytext,
  `proj_keyw4` tinytext,
  `proj_keyw5` tinytext,
  `proj_res_area` tinytext,
  `proj_num_samps` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`proj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proj_info`
--

LOCK TABLES `proj_info` WRITE;
/*!40000 ALTER TABLE `proj_info` DISABLE KEYS */;
INSERT INTO `proj_info` VALUES ('AIR:1008803961','Regulation of Transcription','Detlef Weigel','Professor','Max Planck Institute for Developmental Biology','Department of Molecular Biology Spemannstrasse 27-29 D-72076 Tuebingen , 00000 Germany',NULL,NULL,NULL,NULL,NULL,'Ecotype Comparsion in triplicate arrays',30);
/*!40000 ALTER TABLE `proj_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_bio_name` tinytext,
  `sample_organism` tinytext,
  `sample_alias` tinytext,
  `sample_stock_code` tinytext,
  `sample_genetic_var` tinytext,
  `sample_tissue` tinytext,
  `sample_diseased` tinytext,
  `sample_growth_cond` tinytext,
  `sample_growth_stage` tinytext,
  `sample_time_point` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_biosource_info`
--

LOCK TABLES `sample_biosource_info` WRITE;
/*!40000 ALTER TABLE `sample_biosource_info` DISABLE KEYS */;
INSERT INTO `sample_biosource_info` VALUES (1,'AIR:1008803961','ATGE_111_A','Arabidopsis thaliana','Bay-0','CS6608',NULL,'seed',NULL,'Bay-0 (CS6608) from Bayreuth, Germany','0.5',NULL),(2,'AIR:1008803961','ATGE_111_B','Arabidopsis thaliana','Bay-0','CS6608',NULL,'seed',NULL,'Bay-0 (CS6608) from Bayreuth, Germany','0.5',NULL);
/*!40000 ALTER TABLE `sample_biosource_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext DEFAULT NULL,
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext DEFAULT NULL,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_data`
--

LOCK TABLES `sample_data` WRITE;
/*!40000 ALTER TABLE `sample_data` DISABLE KEYS */;
INSERT INTO `sample_data` VALUES
(1,'AIR:1008803961','ATGE_111_A.txt','261585_at',6.9,NULL,0,'ATGE_111_A'),
(2,'AIR:1008803961','ATGE_111_B.txt','261585_at',6.55,NULL,0,'ATGE_111_B'),
(3,'AIR:1008803961','ATGE_111_C.txt','261585_at',10,NULL,0,'ATGE_111_C');
/*!40000 ALTER TABLE `sample_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext NOT NULL,
  `sample_name` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_general_info`
--

LOCK TABLES `sample_general_info` WRITE;
/*!40000 ALTER TABLE `sample_general_info` DISABLE KEYS */;
INSERT INTO `sample_general_info` VALUES 
(1,'AIR:1008803961','1','3','Longitude/Latitude/Elevation: E11/N50 at ~300m','ATGE_111_A.txt','ATGE_111_A','ATGE_111_A'),
(2,'AIR:1008803961','1','3','Longitude/Latitude/Elevation: E11/N50 at ~300m','ATGE_111_B.txt','ATGE_111_B','ATGE_111_B'),
(3,'AIR:1008803961','1','3','Longitude/Latitude/Elevation: E11/N50 at ~300m','ATGE_111_C.txt','ATGE_111_C','ATGE_111_C'),
/*!40000 ALTER TABLE `sample_general_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-19 19:00:09, copied from klepikova.sql with modifications from Vincent