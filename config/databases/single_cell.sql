-- MySQL dump 10.13  Distrib 8.4.2, for Linux (x86_64)
--
-- Host: localhost    Database: single_cell
-- ------------------------------------------------------
-- Server version	8.4.2

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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_data`
--

LOCK TABLES `sample_data` WRITE;
/*!40000 ALTER TABLE `sample_data` DISABLE KEYS */;
INSERT INTO `sample_data` VALUES ('1',1,'AT1G01010',0.330615,'cluster0_WT1.ExprMean'),('1',2,'AT1G01010',0.376952,'cluster0_WT2.ExprMean'),('1',3,'AT1G01010',0.392354,'cluster0_WT3.ExprMean'),('1',4,'AT1G01010',0.104124,'cluster1_WT1.ExprMean'),('1',5,'AT1G01010',0.183412,'cluster1_WT2.ExprMean'),('1',6,'AT1G01010',0.165289,'cluster1_WT3.ExprMean'),('1',7,'AT1G01010',0.0327218,'cluster2_WT1.ExprMean'),('1',8,'AT1G01010',0.0337024,'cluster2_WT2.ExprMean'),('1',9,'AT1G01010',0.0206359,'cluster2_WT3.ExprMean'),('1',10,'AT1G01010',0.214786,'cluster3_WT1.ExprMean'),('1',11,'AT1G01010',0.241307,'cluster3_WT2.ExprMean'),('1',12,'AT1G01010',0.134913,'cluster3_WT3.ExprMean'),('1',13,'AT1G01010',0.117571,'cluster4_WT1.ExprMean'),('1',14,'AT1G01010',0.0735138,'cluster4_WT2.ExprMean'),('1',15,'AT1G01010',0.116268,'cluster4_WT3.ExprMean'),('1',16,'AT1G01010',0.0439212,'cluster5_WT1.ExprMean'),('1',17,'AT1G01010',0.0570379,'cluster5_WT2.ExprMean'),('1',18,'AT1G01010',0.0779526,'cluster5_WT3.ExprMean'),('1',19,'AT1G01010',0.379817,'cluster6_WT1.ExprMean'),('1',20,'AT1G01010',0.640221,'cluster6_WT2.ExprMean'),('1',21,'AT1G01010',0.357844,'cluster6_WT3.ExprMean'),('1',22,'AT1G01010',0.555463,'cluster7_WT1.ExprMean'),('1',23,'AT1G01010',0.671035,'cluster7_WT2.ExprMean'),('1',24,'AT1G01010',0.505183,'cluster7_WT3.ExprMean'),('1',25,'AT1G01010',0.0302899,'cluster8_WT1.ExprMean'),('1',26,'AT1G01010',0,'cluster8_WT2.ExprMean'),('1',27,'AT1G01010',0.0236176,'cluster8_WT3.ExprMean'),('1',28,'AT1G01010',0.675148,'cluster9_WT1.ExprMean'),('1',29,'AT1G01010',0.750971,'cluster9_WT2.ExprMean'),('1',30,'AT1G01010',0.613557,'cluster9_WT3.ExprMean'),('1',31,'AT1G01010',0.0399103,'cluster10_WT1.ExprMean'),('1',32,'AT1G01010',0.0128781,'cluster10_WT2.ExprMean'),('1',33,'AT1G01010',0.00493557,'cluster10_WT3.ExprMean'),('1',34,'AT1G01010',0.180303,'cluster11_WT1.ExprMean'),('1',35,'AT1G01010',0.292895,'cluster11_WT2.ExprMean'),('1',36,'AT1G01010',0.113247,'cluster11_WT3.ExprMean'),('1',37,'AT1G01010',0.225366,'cluster12_WT1.ExprMean'),('1',38,'AT1G01010',0.31592,'cluster12_WT2.ExprMean'),('1',39,'AT1G01010',0.255742,'cluster12_WT3.ExprMean'),('1',40,'AT1G01010',0.147108,'cluster13_WT1.ExprMean'),('1',41,'AT1G01010',0.241902,'cluster13_WT2.ExprMean'),('1',42,'AT1G01010',0.251595,'cluster13_WT3.ExprMean'),('1',43,'AT1G01010',0.683089,'cluster14_WT1.ExprMean'),('1',44,'AT1G01010',0.75138,'cluster14_WT2.ExprMean'),('1',45,'AT1G01010',0.616441,'cluster14_WT3.ExprMean'),('1',46,'AT1G01010',0.0577139,'cluster15_WT1.ExprMean'),('1',47,'AT1G01010',0.115468,'cluster15_WT2.ExprMean'),('1',48,'AT1G01010',0.0141389,'cluster15_WT3.ExprMean'),('1',49,'AT1G01010',0.177473,'cluster16_WT1.ExprMean'),('1',50,'AT1G01010',0.222742,'cluster16_WT2.ExprMean'),('1',51,'AT1G01010',0.0914264,'cluster16_WT3.ExprMean'),('1',52,'AT1G01010',0.0408065,'cluster17_WT1.ExprMean'),('1',53,'AT1G01010',0.0645613,'cluster17_WT2.ExprMean'),('1',54,'AT1G01010',0.0309355,'cluster17_WT3.ExprMean'),('1',55,'AT1G01010',0.697676,'cluster18_WT1.ExprMean'),('1',56,'AT1G01010',0.794452,'cluster18_WT2.ExprMean'),('1',57,'AT1G01010',0.951476,'cluster18_WT3.ExprMean'),('1',58,'AT1G01010',0.314653,'cluster19_WT1.ExprMean'),('1',59,'AT1G01010',0.456848,'cluster19_WT2.ExprMean'),('1',60,'AT1G01010',0.337701,'cluster19_WT3.ExprMean'),('1',61,'AT1G01010',0.311621,'cluster20_WT1.ExprMean'),('1',62,'AT1G01010',0.505607,'cluster20_WT2.ExprMean'),('1',63,'AT1G01010',0.466686,'cluster20_WT3.ExprMean'),('1',64,'AT1G01010',0.279148,'cluster21_WT1.ExprMean'),('1',65,'AT1G01010',0.307624,'cluster21_WT2.ExprMean'),('1',66,'AT1G01010',0.273229,'cluster21_WT3.ExprMean'),('1',67,'AT1G01010',0.154758,'cluster22_WT1.ExprMean'),('1',68,'AT1G01010',0.246915,'cluster22_WT2.ExprMean'),('1',69,'AT1G01010',0.215633,'cluster22_WT3.ExprMean'),('1',70,'AT1G01010',0.278561,'cluster23_WT1.ExprMean'),('1',71,'AT1G01010',0.313757,'cluster23_WT2.ExprMean'),('1',72,'AT1G01010',0.341591,'cluster23_WT3.ExprMean'),('1',73,'AT1G01010',0.399525,'cluster24_WT1.ExprMean'),('1',74,'AT1G01010',0.326986,'cluster24_WT2.ExprMean'),('1',75,'AT1G01010',0.328818,'cluster24_WT3.ExprMean'),('1',76,'AT1G01010',0.0799877,'cluster25_WT1.ExprMean'),('1',77,'AT1G01010',0.0296777,'cluster25_WT2.ExprMean'),('1',78,'AT1G01010',0.0202025,'cluster25_WT3.ExprMean'),('1',79,'AT1G01010',0.0290226,'cluster26_WT1.ExprMean'),('1',80,'AT1G01010',0,'cluster26_WT2.ExprMean'),('1',81,'AT1G01010',0,'cluster26_WT3.ExprMean'),('1',82,'AT1G01010',0.0924709,'cluster27_WT1.ExprMean'),('1',83,'AT1G01010',0.0508237,'cluster27_WT2.ExprMean'),('1',84,'AT1G01010',0.00982657,'cluster27_WT3.ExprMean'),('1',85,'AT1G01010',0.0557328,'cluster28_WT1.ExprMean'),('1',86,'AT1G01010',0.101592,'cluster28_WT2.ExprMean'),('1',87,'AT1G01010',0.107528,'cluster28_WT3.ExprMean'),('1',88,'AT1G01010',0.291406,'cluster29_WT1.ExprMean'),('1',89,'AT1G01010',0.231561,'cluster29_WT2.ExprMean'),('1',90,'AT1G01010',0.201914,'cluster29_WT3.ExprMean'),('1',91,'AT1G01010',0.0319319,'cluster30_WT1.ExprMean'),('1',92,'AT1G01010',0.111761,'cluster30_WT2.ExprMean'),('1',93,'AT1G01010',0.157263,'cluster30_WT3.ExprMean'),('1',94,'AT1G01010',0.52613,'cluster31_WT1.ExprMean'),('1',95,'AT1G01010',0.566468,'cluster31_WT2.ExprMean'),('1',96,'AT1G01010',0.436468,'cluster31_WT3.ExprMean'),('1',97,'AT1G01010',0.342944,'cluster32_WT1.ExprMean'),('1',98,'AT1G01010',0.371802,'cluster32_WT2.ExprMean'),('1',99,'AT1G01010',0.275506,'cluster32_WT3.ExprMean'),('1',100,'AT1G01010',0.147324,'cluster33_WT1.ExprMean'),('1',101,'AT1G01010',0,'cluster33_WT2.ExprMean'),('1',102,'AT1G01010',0.0330883,'cluster33_WT3.ExprMean'),('1',103,'AT1G01010',0.0535194,'cluster34_WT1.ExprMean'),('1',104,'AT1G01010',0,'cluster34_WT2.ExprMean'),('1',105,'AT1G01010',0,'cluster34_WT3.ExprMean'),('1',106,'AT1G01010',0.224244,'cluster35_WT1.ExprMean'),('1',107,'AT1G01010',0,'cluster35_WT2.ExprMean'),('1',108,'AT1G01010',0.118697,'cluster35_WT3.ExprMean'),('1',109,'AT1G01010',0.192663,'Med_CTRL');
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

-- Dump completed on 2024-07-29 11:17:56
