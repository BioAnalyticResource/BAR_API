-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_root_rs_pseudobulk
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
-- Current Database: `arabidopsis_root_rs_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_root_rs_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_root_rs_pseudobulk`;

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
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0291868,0.110369,'shr2_top_endodermis'),('AT1G01010',0.0291868,0.110369,'shr2_side_endodermis'),('AT1G01010',0.0291868,0.110369,'shr2_tip_endodermis'),('AT1G01010',0.0841449,0.295676,'shr2_tip_lateral_root_cap'),('AT1G01010',0.541465,0.453214,'shr2_top_phloem'),('AT1G01010',0.541465,0.453214,'shr2_side_phloem'),('AT1G01010',0.186628,0.498255,'shr2_top_procambium'),('AT1G01010',0.186628,0.498255,'shr2_side_procambium'),('AT1G01010',0.325798,0.468653,'shr2_tip_cortex'),('AT1G01010',0.325798,0.468653,'shr2_top_cortex'),('AT1G01010',0.325798,0.468653,'shr2_side_cortex'),('AT1G01010',0.212179,0.587404,'shr2_xpp_circle'),('AT1G01010',0.336566,0.545843,'shr2_proto_circle'),('AT1G01010',0.870751,0.69034,'shr2_ppp_circle'),('AT1G01010',0,0,'shr2_meta_circle'),('AT1G01010',0.173986,0.34659,'scr4_top_endodermis'),('AT1G01010',0.173986,0.34659,'scr4_side_endodermis'),('AT1G01010',0.173986,0.34659,'scr4_tip_endodermis'),('AT1G01010',0.0555967,0.238622,'scr4_tip_lateral_root_cap'),('AT1G01010',0.480513,0.469044,'scr4_top_phloem'),('AT1G01010',0.480513,0.469044,'scr4_side_phloem'),('AT1G01010',0.27563,0.544907,'scr4_top_procambium'),('AT1G01010',0.27563,0.544907,'scr4_side_procambium'),('AT1G01010',0.3307,0.475607,'scr4_tip_cortex'),('AT1G01010',0.3307,0.475607,'scr4_top_cortex'),('AT1G01010',0.3307,0.475607,'scr4_side_cortex'),('AT1G01010',0.246466,0.658447,'scr4_xpp_circle'),('AT1G01010',0.344688,0.528917,'scr4_proto_circle'),('AT1G01010',0.71456,0.668174,'scr4_ppp_circle'),('AT1G01010',0.158992,0.395162,'scr4_meta_circle'),('AT1G01010',0.217057,0.420266,'col0_top_endodermis'),('AT1G01010',0.217057,0.420266,'col0_side_endodermis'),('AT1G01010',0.217057,0.420266,'col0_tip_endodermis'),('AT1G01010',0.0437373,0.236872,'col0_tip_lateral_root_cap'),('AT1G01010',0.337514,0.407831,'col0_top_phloem'),('AT1G01010',0.337514,0.407831,'col0_side_phloem'),('AT1G01010',0.0994925,0.402853,'col0_top_procambium'),('AT1G01010',0.0994925,0.402853,'col0_side_procambium'),('AT1G01010',0.193213,0.463268,'col0_tip_cortex'),('AT1G01010',0.193213,0.463268,'col0_top_cortex'),('AT1G01010',0.193213,0.463268,'col0_side_cortex'),('AT1G01010',0.104103,0.383042,'col0_xpp_circle'),('AT1G01010',0.128259,0.352872,'col0_proto_circle'),('AT1G01010',0.570925,0.720127,'col0_ppp_circle'),('AT1G01010',0.0538516,0.257377,'col0_meta_circle'),('AT1G01010',0.168283,0.272921,'shr2_top_xylem'),('AT1G01010',0.168283,0.272921,'shr2_side_xylem'),('AT1G01010',0.25184,0.330116,'scr4_top_xylem'),('AT1G01010',0.25184,0.330116,'scr4_side_xylem'),('AT1G01010',0.0910555,0.218381,'col0_top_xylem'),('AT1G01010',0.0910555,0.218381,'col0_side_xylem');
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
-- Dump completed on 2026-07-17 01:37:36
