-- MySQL dump 10.13  Distrib 8.4.2, for Linux (x86_64)
--
-- Host: localhost    Database: eplant_poplar
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
-- Current Database: `eplant_poplar`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_poplar` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_poplar`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(20) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gene_annotation`
--

LOCK TABLES `gene_annotation` WRITE;
/*!40000 ALTER TABLE `gene_annotation` DISABLE KEYS */;
INSERT INTO `gene_annotation` VALUES ('Potri.001G000500.1','multi-copper oxidase type 1 family protein; similar to pollen-specific BP10 protein (SP|Q00624|Brassica)(napus ; [ co-ortholog (3of4) of At1g55570, At3g13390, ]'),('Potri.001G000600.1','multi-copper oxidase type 1 family protein; similar to pollen-specific BP10 protein (SP|Q00624|Brassica)(napus ; [ co-ortholog (2of4) of At1g55570, At3g13390, ]'),('Potri.001G000700.1','similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); [ co-ortholog (1of2) of At2g32080, ]'),('Potri.001G000700.2','similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); similar to PUR alpha-1 protein; similar to PUR alpha-1 GI:5081612 from (Arabidopsis thaliana); [ co-ortholog (1of2) of At2g32080, ]'),('Potri.001G000900.1','similar to expressed protein in Arabidopsis thaliana; [ ortholog of At3g13410,]');
/*!40000 ALTER TABLE `gene_annotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `isoforms`
--

DROP TABLE IF EXISTS `isoforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `isoforms` (
  `gene` varchar(20) NOT NULL,
  `isoform` varchar(24) NOT NULL,
  KEY `idx_gene_isoform` (`gene`,`isoform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `isoforms`
--

LOCK TABLES `isoforms` WRITE;
/*!40000 ALTER TABLE `isoforms` DISABLE KEYS */;
INSERT INTO `isoforms` VALUES ('Potri.001G000300','Potri.001G000300.1'),('Potri.001G000400','Potri.001G000400.1'),('Potri.001G000400','Potri.001G000400.2'),('Potri.001G000400','Potri.001G000400.3'),('Potri.001G000400','Potri.001G000400.4');
/*!40000 ALTER TABLE `isoforms` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-29 11:30:25
