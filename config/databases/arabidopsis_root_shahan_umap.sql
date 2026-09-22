-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_root_shahan_umap
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
-- Current Database: `arabidopsis_root_shahan_umap`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_root_shahan_umap` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_root_shahan_umap`;

--
-- Table structure for table `umap_coords`
--

DROP TABLE IF EXISTS `umap_coords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `umap_coords` (
  `cell_id`   INT          NOT NULL,
  `umap_1`    FLOAT        NOT NULL,
  `umap_2`    FLOAT        NOT NULL,
  `cell_type` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`cell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `umap_coords`
--

LOCK TABLES `umap_coords` WRITE;
/*!40000 ALTER TABLE `umap_coords` DISABLE KEYS */;
INSERT INTO `umap_coords` VALUES (3,-5.369063,13.085638,'col0_Root endodermis'),(16,-2.009994,7.254005,'col0_Phloem'),(36,-0.523138,2.255024,'col0_Phloem pole pericycle'),(44,-0.023207,2.463476,'col0_Phloem pole pericycle'),(62,6.431638,11.482953,'col0_Metaxylem'),(82,-4.284084,-11.077536,'col0_Root hair'),(89,5.733176,3.742696,'col0_Lateral root cap'),(159,-0.406075,15.254973,'col0_Root endodermis');
/*!40000 ALTER TABLE `umap_coords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `umap_expression`
--

DROP TABLE IF EXISTS `umap_expression`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `umap_expression` (
  `gene_id`    VARCHAR(32) NOT NULL,
  `expression` JSON        NOT NULL,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `umap_expression`
--

LOCK TABLES `umap_expression` WRITE;
/*!40000 ALTER TABLE `umap_expression` DISABLE KEYS */;
INSERT INTO `umap_expression` VALUES ('AT1G01010','{\"3\": 2.205624, \"16\": 0.762018, \"44\": 1.738013, \"159\": 0.902622}'),('AT1G01020','{\"36\": 1.82633, \"62\": 0.80323, \"82\": 0.967385, \"89\": 1.572109}'),('AT1G01030','{\"89\": 1.572109, \"159\": 0.549872}');
/*!40000 ALTER TABLE `umap_expression` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
-- Dump completed on 2026-08-12 01:40:46
