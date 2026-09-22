-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_seedling_3d_lee_pseudobulk
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
-- Current Database: `arabidopsis_seedling_3d_lee_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_seedling_3d_lee_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_seedling_3d_lee_pseudobulk`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal`      float       DEFAULT '0',
  `data_signal_std`  float       DEFAULT '0',
  `data_bot_id`      varchar(64) NOT NULL,
  UNIQUE KEY `uq_probeset_bot` (`data_probeset_id`,`data_bot_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_data`
--

LOCK TABLES `sample_data` WRITE;
/*!40000 ALTER TABLE `sample_data` DISABLE KEYS */;
INSERT INTO `sample_data` VALUES ('AT1G01010',0.00802182,0.0751622,'Vascular'),('AT1G01010',0.00601548,0.0642921,'Mesophyll'),('AT1G01010',0.00874817,0.0786151,'Unknown'),('AT1G01010',0.00450096,0.0556738,'Epidermis'),('AT1G01010',0.00560685,0.0620883,'Phloem'),('AT1G01010',0.00415403,0.0563294,'Dividing'),('AT1G01010',0.00653912,0.0670061,'Trichoblast'),('AT1G01010',0,0,'Phloem parenchyma'),('AT1G01010',0.00687618,0.0697902,'Mean_CTRL'),('AT1G01020',0.0171793,0.111266,'Vascular'),('AT1G01020',0.00984352,0.0820136,'Mesophyll'),('AT1G01020',0.00947456,0.0804824,'Unknown'),('AT1G01020',0.00900191,0.0784769,'Epidermis'),('AT1G01020',0.0159479,0.110233,'Phloem'),('AT1G01020',0.0115125,0.0894566,'Dividing'),('AT1G01020',0.0052313,0.0599891,'Trichoblast'),('AT1G01020',0,0,'Phloem parenchyma'),('AT1G01020',0.0117318,0.0909308,'Mean_CTRL'),('AT1G01030',0.00764325,0.0746365,'Vascular'),('AT1G01030',0.00344112,0.0504889,'Mesophyll'),('AT1G01030',0.00496287,0.0584419,'Unknown'),('AT1G01030',0,0,'Epidermis'),('AT1G01030',0.00140171,0.0311389,'Phloem'),('AT1G01030',0.00580647,0.0631734,'Dividing'),('AT1G01030',0.00392347,0.0520014,'Trichoblast'),('AT1G01030',0,0,'Phloem parenchyma'),('AT1G01030',0.00505709,0.0598023,'Mean_CTRL');
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
-- Dump completed on 2026-09-02 12:39:03
