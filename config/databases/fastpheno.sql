-- MySQL dump 10.13  Distrib 8.4.2, for Linux (x86_64)
--
-- Host: localhost    Database: fastpheno
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
-- Table structure for table `band`
--

DROP TABLE IF EXISTS `band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `band` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `band` varchar(100) NOT NULL,
  `value` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`,`band`),
  KEY `trees_fk_idx` (`trees_pk`),
  CONSTRAINT `trees_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `band`
--

LOCK TABLES `band` WRITE;
/*!40000 ALTER TABLE `band` DISABLE KEYS */;
INSERT INTO `band` VALUES (1,'jan','band_1',0.025796278000000),(1,'jan','band_2',0.025796278000000),(1,'feb','band_1',0.025796278000000),(1,'mar','band_1',0.023442323224100),(1,'apr','band_1',0.089900613000000),(2,'feb','band_1',0.183586478000000),(4,'feb','band_1',0.223586478000000);
/*!40000 ALTER TABLE `band` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `height`
--

DROP TABLE IF EXISTS `height`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `height` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `tree_height_proxy` decimal(20,15) NOT NULL,
  `ground_height_proxy` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`),
  KEY `tree_fk_idx` (`trees_pk`),
  CONSTRAINT `tree_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `height`
--

LOCK TABLES `height` WRITE;
/*!40000 ALTER TABLE `height` DISABLE KEYS */;
INSERT INTO `height` VALUES (1,'jan',2.234289428710000,45.106719970000000),(1,'feb',3.478942871000000,49.106719970000000),(1,'mar',2.383630037000000,48.887859340000000),(1,'apr',1.376412749000000,49.052417760000000),(2,'feb',2.383630037000000,48.123412421311630),(4,'feb',2.623630037000000,45.223412421311630);
/*!40000 ALTER TABLE `height` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `sites_pk` int NOT NULL AUTO_INCREMENT,
  `site_name` varchar(45) NOT NULL,
  `site_desc` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`sites_pk`),
  UNIQUE KEY `site_name` (`site_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'Pintendre','Lorem ipsum dolor sit amet, consectetur adipiscing elit'),(2,'Pickering','Lorem ipsum dolor sit amet,');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trees`
--

DROP TABLE IF EXISTS `trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trees` (
  `trees_pk` int NOT NULL AUTO_INCREMENT,
  `sites_pk` int NOT NULL,
  `longitude` decimal(10,0) NOT NULL,
  `latitude` decimal(10,0) NOT NULL,
  `genotype_id` varchar(5) DEFAULT NULL,
  `external_link` varchar(200) DEFAULT NULL,
  `tree_given_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`trees_pk`),
  KEY `sites_fk_idx` (`sites_pk`),
  CONSTRAINT `sites_fk` FOREIGN KEY (`sites_pk`) REFERENCES `sites` (`sites_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trees`
--

LOCK TABLES `trees` WRITE;
/*!40000 ALTER TABLE `trees` DISABLE KEYS */;
INSERT INTO `trees` VALUES (1,1,336839,5178557,'C','example','11'),(2,1,336872,5178486,'C','example2','11'),(3,1,346872,5278486,'C','example3','B'),(4,2,330502,5262486,'XZ','example4','K123');
/*!40000 ALTER TABLE `trees` ENABLE KEYS */;
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
