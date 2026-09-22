-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_stem_lee_pseudobulk
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
-- Current Database: `arabidopsis_stem_lee_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_stem_lee_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_stem_lee_pseudobulk`;

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
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0026444,0.0804203,'Phloem'),('AT1G01010',0.00903136,0.147637,'Unknown'),('AT1G01010',0.0100426,0.14251,'Epidermal'),('AT1G01010',0,0,'Vascular'),('AT1G01010',0.00801156,0.146785,'Cambium'),('AT1G01010',0.00498133,0.106099,'Xylem'),('AT1G01010',0.0197243,0.216412,'Trichome'),('AT1G01010',0.00864758,0.124717,'Guard'),('AT1G01010',0.00751716,0.131966,'Mean_CTRL'),('AT1G01020',0.048775,0.353962,'Phloem'),('AT1G01020',0.0779243,0.433307,'Unknown'),('AT1G01020',0.0590652,0.326225,'Epidermal'),('AT1G01020',0.0375977,0.304534,'Vascular'),('AT1G01020',0.0735435,0.410739,'Cambium'),('AT1G01020',0.084458,0.451044,'Xylem'),('AT1G01020',0.067462,0.376558,'Trichome'),('AT1G01020',0.0487924,0.267407,'Guard'),('AT1G01020',0.0695734,0.401791,'Mean_CTRL'),('AT1G01030',0,0,'Phloem'),('AT1G01030',0,0,'Unknown'),('AT1G01030',0,0,'Epidermal'),('AT1G01030',0.00520999,0.101695,'Vascular'),('AT1G01030',0.00204135,0.0641324,'Cambium'),('AT1G01030',0.000738231,0.0423181,'Xylem'),('AT1G01030',0,0,'Trichome'),('AT1G01030',0.0130387,0.133916,'Guard'),('AT1G01030',0.00053516,0.0321555,'Mean_CTRL');
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
-- Dump completed on 2026-07-30 00:25:06
