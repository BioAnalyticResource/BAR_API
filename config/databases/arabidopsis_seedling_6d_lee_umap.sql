-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: arabidopsis_seedling_6d_lee_umap
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
-- Current Database: `arabidopsis_seedling_6d_lee_umap`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_seedling_6d_lee_umap` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_seedling_6d_lee_umap`;

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
INSERT INTO `umap_coords` VALUES (1,-1.624959,-3.549993,'Stele'),(14,-3.982634,-0.261779,'Epidermal'),(19,3.092637,-4.230665,'Meristematic'),(50,-7.398050,-0.084165,'Meristematic'),(106,-2.365161,0.405073,'Stele'),(118,-3.922566,4.035084,'Epidermal'),(119,1.429272,0.170757,'Epidermal'),(269,-3.150418,1.525333,'Epidermal');
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
INSERT INTO `umap_expression` VALUES ('AT1G01010','{\"106\": 1.420628, \"118\": 1.558638, \"269\": 2.512673}'),('AT1G01020','{\"1\": 1.292535, \"50\": 0.895021, \"119\": 2.362304}'),('AT1G01030','{\"14\": 2.626154, \"19\": 2.423746}');
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
-- Dump completed on 2026-09-02 12:49:23
