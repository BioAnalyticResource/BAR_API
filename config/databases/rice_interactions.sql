-- MySQL dump 10.13  Distrib 8.4.2, for Linux (x86_64)
--
-- Host: localhost    Database: rice_interactions
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
-- Table structure for table `RGI_annotation`
--

DROP TABLE IF EXISTS `RGI_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RGI_annotation` (
  `loc` varchar(14) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RGI_annotation`
--

LOCK TABLES `RGI_annotation` WRITE;
/*!40000 ALTER TABLE `RGI_annotation` DISABLE KEYS */;
INSERT INTO `RGI_annotation` VALUES ('LOC_Os01g01080','protein decarboxylase, putative, expressed','2009-11-13'),('LOC_Os01g52560','protein Plant PDR ABC transporter associated domain containing protein, expressed','2009-11-13');
/*!40000 ALTER TABLE `RGI_annotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rice_mPLoc`
--

DROP TABLE IF EXISTS `Rice_mPLoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rice_mPLoc` (
  `gene_id` varchar(20) NOT NULL,
  `alias` text,
  `lab_description` text,
  `gfp` text,
  `mass_spec` text,
  `swissprot` text,
  `amigo` text,
  `annotation` text,
  `pred_ipsort` text,
  `pred_mitopred` text,
  `pred_mitopred2` text,
  `pred_predator` text,
  `pred_peroxp` text,
  `pred_subloc` text,
  `pred_targetp` text,
  `pred_wolfpsort` text,
  `pred_multiloc` text,
  `pred_loctree` text,
  `pred_mPLoc` text,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rice_mPLoc`
--

LOCK TABLES `Rice_mPLoc` WRITE;
/*!40000 ALTER TABLE `Rice_mPLoc` DISABLE KEYS */;
INSERT INTO `Rice_mPLoc` VALUES ('LOC_Os01g01080.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Endoplasmic reticulum'),('LOC_Os01g52560.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Cellmembrane,Chloroplast');
/*!40000 ALTER TABLE `Rice_mPLoc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(14) NOT NULL,
  `Protein2` varchar(14) NOT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '1',
  `Num_species` tinyint NOT NULL DEFAULT '1',
  `Quality` smallint NOT NULL DEFAULT '1',
  `Index` tinyint NOT NULL DEFAULT '0',
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  PRIMARY KEY (`Protein1`,`Protein2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interactions`
--

LOCK TABLES `interactions` WRITE;
/*!40000 ALTER TABLE `interactions` DISABLE KEYS */;
INSERT INTO `interactions` VALUES ('LOC_Os01g01080','LOC_Os01g52560',0,0,0,0,0,0,0,1,1,1,0,0.65,NULL),('LOC_Os01g01080','LOC_Os01g62244',0,0,0,0,0,0,0,1,1,1,0,0,NULL),('LOC_Os01g01080','LOC_Os01g70380',0,0,0,0,0,0,0,2,1,2,0,0.789,NULL),('LOC_Os01g52560','LOC_Os01g73310',0,0,0,0,0,0,0,1,1,1,0,-0.116,NULL);
/*!40000 ALTER TABLE `interactions` ENABLE KEYS */;
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
