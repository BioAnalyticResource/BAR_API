-- MySQL dump 10.13  Distrib 8.4.4, for Linux (x86_64)
--
-- Host: localhost    Database: homologs_db
-- ------------------------------------------------------
-- Server version	8.4.4

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
-- Current Database: `homologs_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `homologs_db` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `homologs_db`;

--
-- Table structure for table `homologs`
--

DROP TABLE IF EXISTS `homologs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homologs` (
  `homologs_id` int NOT NULL AUTO_INCREMENT,
  `search_protein_name` varchar(45) NOT NULL,
  `result_protein_name` varchar(45) NOT NULL,
  `search_species_name` varchar(45) NOT NULL,
  `result_species_name` varchar(45) NOT NULL,
  `Percent_id` decimal(10,5) NOT NULL,
  `e_score` varchar(10) NOT NULL,
  `is_search_structure` int NOT NULL,
  `is_result_structure` int NOT NULL,
  PRIMARY KEY (`homologs_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1356306 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homologs`
--

LOCK TABLES `homologs` WRITE;
/*!40000 ALTER TABLE `homologs` DISABLE KEYS */;
INSERT INTO `homologs` VALUES (1,'AT5G16970.1','BnaC09g40930D','arabidopsis','canola',86.04700,'0.0',0,0),(2,'AT5G16970.1','BnaA10g17570D','arabidopsis','canola',86.04700,'0.0',0,0),(3,'AT5G16970.1','BnaC03g08130D','arabidopsis','canola',85.08800,'0.0',0,0),(4,'AT5G16970.1','BnaA05g32330D','arabidopsis','canola',81.63300,'0.0',0,0),(5,'AT5G16970.1','BnaCnng06210D','arabidopsis','canola',80.87000,'0.0',0,0),(6,'AT5G16970.1','BnaA03g06330D','arabidopsis','canola',85.37300,'0.0',0,0),(7,'AT5G16970.1','BnaA09g28840D','arabidopsis','canola',77.90700,'0.0',0,0),(8,'AT5G16970.1','BnaC05g20410D','arabidopsis','canola',77.32600,'0.0',0,0),(9,'AT5G16970.1','BnaC02g06960D','arabidopsis','canola',76.23200,'0.0',0,0),(10,'AT5G16970.1','BnaA02g03340D','arabidopsis','canola',75.94200,'0.0',0,0),(11,'AT4G32100.1','BnaC01g06360D','arabidopsis','canola',55.28500,'2.18e-39',0,0),(12,'AT4G32100.1','BnaA01g04810D','arabidopsis','canola',55.28500,'1.46e-38',0,0),(13,'AT4G32100.1','BnaA01g04820D','arabidopsis','canola',52.84600,'6.47e-38',0,0),(14,'AT4G32100.1','BnaAnng05770D','arabidopsis','canola',53.33300,'1.23e-37',0,0),(15,'AT4G32100.1','BnaC01g06960D','arabidopsis','canola',51.61300,'1.19e-36',0,0),(16,'AT4G32100.1','BnaC07g18640D','arabidopsis','canola',51.66700,'6.37e-36',0,0),(17,'AT4G32100.1','BnaA01g34870D','arabidopsis','canola',49.19400,'4.15e-35',0,0),(18,'AT4G32100.1','BnaA02g24080D','arabidopsis','canola',49.13800,'3.63e-27',0,0),(19,'AT4G32100.1','BnaA02g24090D','arabidopsis','canola',48.27600,'6.69e-27',0,0),(20,'AT4G32100.1','BnaC02g31830D','arabidopsis','canola',47.41400,'2.72e-25',0,0),(21,'AT2G43120.2','BnaC04g02730D','arabidopsis','canola',90.96600,'0.0',0,0),(22,'AT2G43120.2','BnaC03g24040D','arabidopsis','canola',91.27700,'0.0',0,0),(23,'AT2G43120.2','BnaA03g20050D','arabidopsis','canola',90.65400,'0.0',0,0),(86750,'AT1G74360.1','BnaC06g35270D','arabidopsis','canola',84.27700,'0.0',0,0),(86751,'AT1G74360.1','BnaA07g31480D','arabidopsis','canola',84.02200,'0.0',0,0),(86752,'AT1G74360.1','BnaA02g11590D','arabidopsis','canola',77.97100,'0.0',0,0),(86753,'AT1G74360.1','BnaCnng50590D','arabidopsis','canola',77.97100,'0.0',0,0),(86754,'AT1G74360.1','BnaA08g00410D','arabidopsis','canola',31.84900,'5.39e-154',0,0),(86755,'AT1G74360.1','BnaA06g11580D','arabidopsis','canola',33.86600,'3.20e-153',0,0),(86756,'AT1G74360.1','BnaA02g16780D','arabidopsis','canola',67.03000,'2.11e-152',0,0),(86757,'AT1G74360.1','BnaA06g34400D','arabidopsis','canola',32.93200,'1.50e-151',0,0),(86758,'AT1G74360.1','BnaA08g16520D','arabidopsis','canola',33.89500,'1.68e-150',0,0),(86759,'AT1G74360.1','BnaC07g47240D','arabidopsis','canola',33.88700,'3.05e-150',0,0),(690828,'BnaA07g31480D','AT1G74360.1','canola','arabidopsis',84.02200,'0.0',0,0),(690829,'BnaA07g31480D','AT2G01950.1','canola','arabidopsis',32.34200,'3.57e-149',0,0),(690830,'BnaA07g31480D','AT1G55610.1','canola','arabidopsis',31.71500,'9.47e-148',0,0),(690831,'BnaA07g31480D','AT1G55610.2','canola','arabidopsis',31.71500,'9.47e-148',0,0),(690832,'BnaA07g31480D','AT1G17230.1','canola','arabidopsis',32.44000,'7.99e-146',0,0),(690833,'BnaA07g31480D','AT1G17230.2','canola','arabidopsis',32.44000,'1.34e-145',0,0),(690834,'BnaA07g31480D','AT4G39400.1','canola','arabidopsis',33.15200,'5.71e-145',0,0),(690835,'BnaA07g31480D','AT3G13380.1','canola','arabidopsis',32.44600,'3.05e-143',0,0),(690836,'BnaA07g31480D','AT5G63930.1','canola','arabidopsis',33.05600,'1.84e-142',0,0),(690837,'BnaA07g31480D','AT5G63930.2','canola','arabidopsis',33.23900,'3.94e-141',0,0),(824264,'BnaC07g23540D','AT5G65470.1','canola','arabidopsis',39.72900,'9.91e-109',0,0),(824265,'BnaC07g23540D','AT4G24530.1','canola','arabidopsis',36.96500,'1.03e-108',0,0),(824266,'BnaC07g23540D','AT2G01480.1','canola','arabidopsis',41.78400,'2.97e-107',0,0),(824267,'BnaC07g23540D','AT2G01480.2','canola','arabidopsis',43.07700,'6.19e-104',0,0),(824268,'BnaC07g23540D','AT1G14970.2','canola','arabidopsis',40.00000,'1.03e-103',0,0),(824269,'BnaC07g23540D','AT1G14970.1','canola','arabidopsis',40.00000,'2.33e-102',0,0),(824270,'BnaC07g23540D','AT1G14970.3','canola','arabidopsis',40.24700,'2.02e-101',0,0),(824271,'BnaC07g23540D','AT1G38065.2','canola','arabidopsis',39.86200,'2.00e-95',0,0),(824272,'BnaC07g23550D','AT3G26400.1','canola','arabidopsis',77.19600,'0.0',0,0),(824273,'BnaC07g23550D','AT1G13020.1','canola','arabidopsis',67.31400,'1.71e-180',0,0),(824274,'BnaC07g23560D','AT3G26410.1','canola','arabidopsis',93.21100,'0.0',0,0),(824275,'BnaC07g23570D','AT3G26420.1','canola','arabidopsis',79.75700,'1.69e-126',0,0),(824276,'BnaC07g23570D','AT2G21660.1','canola','arabidopsis',60.49400,'1.99e-30',0,0),(824277,'BnaC07g23570D','AT4G39260.3','canola','arabidopsis',57.31700,'6.84e-30',0,0),(824278,'BnaC07g23570D','AT5G04280.1','canola','arabidopsis',41.95100,'2.88e-29',0,0),(824279,'BnaC07g23570D','AT4G39260.2','canola','arabidopsis',58.02500,'4.78e-29',0,0),(824280,'BnaC07g23570D','AT1G60650.2','canola','arabidopsis',40.44100,'3.40e-28',0,0),(824281,'BnaC07g23570D','AT1G60650.1','canola','arabidopsis',40.44100,'3.40e-28',0,0),(824282,'BnaC07g23570D','AT4G39260.4','canola','arabidopsis',56.06100,'2.46e-21',0,0),(824283,'BnaC07g23580D','AT3G26430.1','canola','arabidopsis',84.21100,'0.0',0,0),(824284,'BnaC07g23580D','AT1G67830.1','canola','arabidopsis',60.58800,'2.97e-155',0,0),(824285,'BnaC07g23580D','AT5G14450.1','canola','arabidopsis',50.66000,'4.50e-131',0,0),(1320148,'BnaA10g09850D','BnaA10g09850D','canola','canola',100.00000,'5.68e-110',0,0),(1320149,'BnaA10g09850D','BnaC09g32290D','canola','canola',93.59000,'5.28e-93',0,0),(1320150,'BnaA10g09850D','BnaC02g12890D','canola','canola',72.85700,'3.68e-26',0,0),(1320151,'BnaA10g09860D','BnaA10g09860D','canola','canola',100.00000,'0.0',0,0),(1320152,'BnaA10g09860D','BnaC09g32300D','canola','canola',86.68300,'0.0',0,0),(1320153,'BnaA10g09860D','BnaA02g08940D','canola','canola',69.50900,'0.0',0,0),(1320154,'BnaA10g09860D','BnaC02g12870D','canola','canola',83.58500,'0.0',0,0),(1320155,'BnaA10g09860D','BnaC08g12230D','canola','canola',58.34400,'1.15e-177',0,0),(1320156,'BnaA10g09860D','BnaA01g15750D','canola','canola',55.24900,'1.77e-162',0,0),(1320157,'BnaA10g09860D','BnaC01g18800D','canola','canola',62.35600,'5.48e-116',0,0),(1320158,'BnaA10g09860D','BnaA06g19020D','canola','canola',34.15200,'4.23e-50',0,0),(1320159,'BnaA10g09860D','BnaC09g05960D','canola','canola',44.25500,'2.79e-46',0,0),(1320160,'BnaA10g09860D','BnaA06g22700D','canola','canola',42.16900,'2.31e-43',0,0),(1320161,'BnaA10g09870D','BnaA10g09870D','canola','canola',100.00000,'0.0',0,0),(1320162,'BnaA10g09870D','BnaC09g32310D','canola','canola',90.82800,'0.0',0,0),(1320163,'BnaA10g09870D','BnaA02g08930D','canola','canola',72.72700,'0.0',0,0),(1320164,'BnaA10g09870D','BnaC02g12860D','canola','canola',70.51700,'0.0',0,0),(1320165,'BnaA10g09870D','BnaA03g11280D','canola','canola',70.32600,'0.0',0,0),(1320166,'BnaA10g09870D','BnaC03g71710D','canola','canola',87.03700,'1.49e-113',0,0),(1320167,'BnaA10g09880D','BnaA10g09880D','canola','canola',100.00000,'0.0',0,0),(1320168,'BnaA10g09880D','BnaC09g32320D','canola','canola',98.12600,'0.0',0,0),(1320169,'BnaA10g09880D','BnaA02g08870D','canola','canola',85.38300,'0.0',0,0),(1320170,'BnaA10g09880D','BnaA01g20560D','canola','canola',51.22000,'1.02e-130',0,0),(1320171,'BnaA10g09880D','BnaC01g25850D','canola','canola',51.81100,'9.19e-130',0,0),(1320172,'BnaA10g09880D','BnaA06g19130D','canola','canola',51.24000,'4.00e-128',0,0),(1356296,'BnaA07g31480D','BnaA07g31480D','canola','canola',100.00000,'0.0',0,0),(1356297,'BnaA07g31480D','BnaC06g35270D','canola','canola',96.79400,'0.0',0,0),(1356298,'BnaA07g31480D','BnaCnng50590D','canola','canola',75.29100,'5.45e-180',0,0),(1356299,'BnaA07g31480D','BnaA02g11590D','canola','canola',74.41900,'3.01e-178',0,0),(1356300,'BnaA07g31480D','BnaC05g13410D','canola','canola',32.51300,'7.21e-153',0,0),(1356301,'BnaA07g31480D','BnaA06g11580D','canola','canola',33.08800,'1.36e-152',0,0),(1356302,'BnaA07g31480D','BnaC07g47240D','canola','canola',33.42600,'6.47e-151',0,0),(1356303,'BnaA07g31480D','BnaA01g05490D','canola','canola',33.58100,'3.69e-148',0,0),(1356304,'BnaA07g31480D','BnaC07g21390D','canola','canola',32.23900,'2.77e-147',0,0),(1356305,'BnaA07g31480D','BnaA06g34400D','canola','canola',31.89600,'3.39e-147',0,0);
/*!40000 ALTER TABLE `homologs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-29 19:28:31
