-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_shoot_zhang_pseudobulk
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
-- Current Database: `arabidopsis_shoot_zhang_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_shoot_zhang_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_shoot_zhang_pseudobulk`;

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
INSERT INTO `sample_data` VALUES ('AT1G01010',0.0118031,0.117995,'Proliferating cell'),('AT1G01010',0.00625838,0.0816509,'Unknown'),('AT1G01010',0.00710315,0.0839763,'Shoot system epidermis'),('AT1G01010',0.0307755,0.237696,'Shoot system vascular system'),('AT1G01010',0.00195312,0.044151,'Shoot system endodermis'),('AT1G01010',0.0153229,0.162467,'Mesophyll cell'),('AT1G01010',0.00417537,0.0644818,'Leaf guard cell'),('AT1G01010',0.0108696,0.116056,'Companion cell'),('AT1G01010',0.00943396,0.0966693,'Shoot apical meristem'),('AT1G01010',0.011989,0.13384,'Mean_CTRL'),('AT1G01020',0.0889001,0.315935,'Proliferating cell'),('AT1G01020',0.0449262,0.225724,'Unknown'),('AT1G01020',0.0600679,0.253937,'Shoot system epidermis'),('AT1G01020',0.0523184,0.238686,'Shoot system vascular system'),('AT1G01020',0.0145399,0.130132,'Shoot system endodermis'),('AT1G01020',0.0923021,0.313079,'Mesophyll cell'),('AT1G01020',0.0688935,0.269254,'Leaf guard cell'),('AT1G01020',0.0258152,0.158582,'Companion cell'),('AT1G01020',0.132075,0.413806,'Shoot apical meristem'),('AT1G01020',0.0622745,0.262763,'Mean_CTRL'),('AT1G01030',0.0754646,0.33195,'Proliferating cell'),('AT1G01030',0.00178811,0.0422495,'Unknown'),('AT1G01030',0.0220815,0.165718,'Shoot system epidermis'),('AT1G01030',0.00287238,0.0572252,'Shoot system vascular system'),('AT1G01030',0.00195312,0.044151,'Shoot system endodermis'),('AT1G01030',0.104159,0.44295,'Mesophyll cell'),('AT1G01030',0.00626305,0.0788914,'Leaf guard cell'),('AT1G01030',0.00679348,0.110371,'Companion cell'),('AT1G01030',0,0,'Shoot apical meristem'),('AT1G01030',0.038467,0.251784,'Mean_CTRL');
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
-- Dump completed on 2026-09-02 12:38:13
