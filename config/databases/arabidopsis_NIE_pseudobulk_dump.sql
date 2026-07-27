-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_NIE_pseudobulk
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
-- Current Database: `arabidopsis_NIE_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_NIE_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_NIE_pseudobulk`;

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
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0346533,0.224356,'D0_Mesophyll'),('AT1G01010',0.0251518,0.185286,'D0_Sieve element_responsive'),('AT1G01010',0.0297745,0.203837,'D0_Guard'),('AT1G01010',0.0550332,0.260401,'D0_Defense state'),('AT1G01010',0.0424581,0.239094,'D0_Epidermal'),('AT1G01010',0.0163655,0.146177,'D0_Phloem Parenchyma'),('AT1G01010',0.0389615,0.234467,'D0_Metabolic stress state'),('AT1G01010',0.0292404,0.198967,'D0_Phloem companion'),('AT1G01010',0.0510094,0.226118,'D0_Trichome'),('AT1G01010',0.027103,0.181704,'D0_Dividing'),('AT1G01010',0.0692417,0.276578,'D0_Stress responsive'),('AT1G01010',0.0110158,0.119154,'D0_Sugar metabolic state'),('AT1G01010',0.0565404,0.272046,'D0_Immune active'),('AT1G01010',0.0513775,0.273271,'D0_Hydathode'),('AT1G01010',0.045102,0.247266,'D0_Vascular'),('AT1G01010',0.0256331,0.169289,'D0_Myrosin'),('AT1G01010',0.0274436,0.177235,'W0_Vascular'),('AT1G01010',0.024174,0.172252,'W0_Mesophyll'),('AT1G01010',0.0213485,0.15354,'W0_Phloem Parenchyma'),('AT1G01010',0.0286998,0.178188,'W0_Dividing'),('AT1G01010',0.0278313,0.182473,'W0_Epidermal'),('AT1G01010',0.0563447,0.251333,'W0_Immune active'),('AT1G01010',0.0343054,0.201204,'W0_Sieve element_responsive'),('AT1G01010',0.0574457,0.253535,'W0_Defense state'),('AT1G01010',0.0136855,0.12117,'W0_Guard'),('AT1G01010',0.0272221,0.169833,'W0_Phloem companion'),('AT1G01010',0.0715313,0.271057,'W0_Stress responsive'),('AT1G01010',0.00820466,0.0673068,'W0_Myrosin'),('AT1G01010',0.0393423,0.199799,'W0_Sugar metabolic state'),('AT1G01010',0.0339956,0.217678,'W0_Metabolic stress state'),('AT1G01010',0.0214199,0.133693,'W0_Trichome'),('AT1G01010',0.0571251,0.236552,'W0_Hydathode'),('AT1G01010',0.0422542,0.250415,'W15_Dividing'),('AT1G01010',0.0446,0.254963,'W15_Mesophyll'),('AT1G01010',0.037824,0.236808,'W15_Phloem Parenchyma'),('AT1G01010',0.0420744,0.251218,'W15_Immune active'),('AT1G01010',0.0387755,0.241218,'W15_Epidermal'),('AT1G01010',0.104241,0.43291,'W15_Hydathode'),('AT1G01010',0.104467,0.324257,'W15_Stress responsive'),('AT1G01010',0.03282,0.228891,'W15_Guard'),('AT1G01010',0.0783275,0.325689,'W15_Defense state'),('AT1G01010',0.0205945,0.15169,'W15_Myrosin'),('AT1G01010',0.0290853,0.203305,'W15_Phloem companion'),('AT1G01010',0.0409241,0.246531,'W15_Vascular'),('AT1G01010',0,0,'W15_Trichome'),('AT1G01010',0.0304135,0.206024,'W15_Sieve element_responsive'),('AT1G01010',0,0,'W15_Sugar metabolic state'),('AT1G01010',0.0573618,0.262866,'W15_Metabolic stress state'),('AT1G01010',0.0187317,0.156752,'R15_Sieve element_responsive'),('AT1G01010',0.0287312,0.191696,'R15_Immune active'),('AT1G01010',0.0329913,0.213788,'R15_Mesophyll'),('AT1G01010',0.0130775,0.14382,'R15_Guard'),('AT1G01010',0.0547408,0.257222,'R15_Defense state'),('AT1G01010',0.0541722,0.243631,'R15_Stress responsive'),('AT1G01010',0.02531,0.180358,'R15_Phloem Parenchyma'),('AT1G01010',0.0400045,0.239473,'R15_Epidermal'),('AT1G01010',0.0300884,0.196556,'R15_Vascular'),('AT1G01010',0.0282214,0.199286,'R15_Dividing'),('AT1G01010',0.034919,0.214859,'R15_Phloem companion'),('AT1G01010',0.018792,0.157063,'R15_Metabolic stress state'),('AT1G01010',0.0528136,0.261553,'R15_Trichome'),('AT1G01010',0,0,'R15_Myrosin'),('AT1G01010',0.0564275,0.281679,'R15_Hydathode'),('AT1G01010',0.0462055,0.222434,'R15_Sugar metabolic state');
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0242853,0.114475,'W0_Phloem average');
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0228029,0.123446,'D0_Phloem average');
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0301145,0.140262,'R15_Phloem average');
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0334546,0.156053,'W15_Phloem average');
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
-- Dump completed on 2026-07-17 01:32:31
