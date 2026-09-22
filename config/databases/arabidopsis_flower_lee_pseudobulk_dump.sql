-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_flower_lee_pseudobulk
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
-- Current Database: `arabidopsis_flower_lee_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_flower_lee_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_flower_lee_pseudobulk`;

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
INSERT INTO `sample_data` VALUES ('AT1G01010',0.00849616,0.149845,'Unknown'),('AT1G01010',0.00382709,0.0747515,'Tapetum'),('AT1G01010',0.00555427,0.11437,'Gynoecium and developing ovule'),('AT1G01010',0.0165317,0.193183,'Anther'),('AT1G01010',0.0168979,0.204127,'Epidermal'),('AT1G01010',0.0129372,0.163582,'Male meiocyte'),('AT1G01010',0.00575536,0.116394,'Pollen'),('AT1G01010',0.0666808,0.380699,'Vascular'),('AT1G01010',0,0,'Developing ovule'),('AT1G01010',0.0116959,0.167702,'Mean_CTRL'),('AT1G01020',0.0269661,0.272391,'Unknown'),('AT1G01020',0.0461319,0.33191,'Tapetum'),('AT1G01020',0.0293728,0.20296,'Gynoecium and developing ovule'),('AT1G01020',0.0247412,0.224438,'Anther'),('AT1G01020',0.00594706,0.115624,'Epidermal'),('AT1G01020',0.0889595,0.422899,'Male meiocyte'),('AT1G01020',0.0318393,0.28948,'Pollen'),('AT1G01020',0.0792938,0.40418,'Vascular'),('AT1G01020',0.0426172,0.292169,'Developing ovule'),('AT1G01020',0.03165,0.277587,'Mean_CTRL'),('AT1G01030',0.0345644,0.306613,'Unknown'),('AT1G01030',0.0224953,0.231296,'Tapetum'),('AT1G01030',0.0265322,0.225368,'Gynoecium and developing ovule'),('AT1G01030',0.0483986,0.335871,'Anther'),('AT1G01030',0.0118251,0.163059,'Epidermal'),('AT1G01030',0.0297713,0.270059,'Male meiocyte'),('AT1G01030',0.0856332,0.416266,'Pollen'),('AT1G01030',0.047488,0.339749,'Vascular'),('AT1G01030',0.0739971,0.359961,'Developing ovule'),('AT1G01030',0.0373011,0.306399,'Mean_CTRL');
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
-- Dump completed on 2026-07-30 00:24:07
