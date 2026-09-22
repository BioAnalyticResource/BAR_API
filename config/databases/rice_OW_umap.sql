-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: rice_OW_umap
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
-- Current Database: `rice_OW_umap`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_OW_umap` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_OW_umap`;

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
INSERT INTO `umap_coords` VALUES (28,4.169194,-0.093138,'Mild.Drought_Mestome.Sheath'),(36,1.489732,-4.531291,'Mild.Drought_Phloem.SE'),(38,5.240719,5.009850,'Mild.Drought_Large.Parenchyma'),(40,-1.985161,7.215361,'Mild.Drought_Mesophyll'),(82,3.058005,-1.310818,'Mild.Drought_Bundle.Sheath'),(123,5.759590,1.726379,'Mild.Drought_Phloem.CC'),(180,1.011132,-2.744384,'Mild.Drought_Phloem.SE'),(279,3.111691,-1.251301,'Mild.Drought_Bundle.Sheath');
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
INSERT INTO `umap_expression` VALUES ('Os01g0100100','{\"36\": 1.978312, \"38\": 2.48399, \"40\": 2.624965}'),('Os01g0100200','{\"82\": 1.976703, \"180\": 1.763575, \"279\": 1.730714}'),('Os01g0100400','{\"28\": 1.847175, \"123\": 1.959751}');
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
-- Dump completed on 2026-08-12 01:41:39
