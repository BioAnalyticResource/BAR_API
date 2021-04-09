-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: tomato_nssnp
-- ------------------------------------------------------
-- Server version	8.0.23

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
-- Current Database: `tomato_nssnp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_nssnp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_nssnp`;

--
-- Table structure for table `protein_reference`
--

DROP TABLE IF EXISTS `protein_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protein_reference` (
  `protein_reference_id` int NOT NULL AUTO_INCREMENT,
  `gene_identifier` varchar(45) NOT NULL,
  `gene_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`protein_reference_id`),
  UNIQUE KEY `gene_identifier_UNIQUE` (`gene_identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=55981 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protein_reference`
--

LOCK TABLES `protein_reference` WRITE;
/*!40000 ALTER TABLE `protein_reference` DISABLE KEYS */;
INSERT INTO `protein_reference` VALUES (1,'Solyc00g005060.1.1',NULL);
/*!40000 ALTER TABLE `protein_reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snps_reference`
--

DROP TABLE IF EXISTS `snps_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snps_reference` (
  `snps_reference_id` int NOT NULL AUTO_INCREMENT,
  `chromosome` int NOT NULL,
  `chromosomal_loci` int NOT NULL,
  `ref_allele` varchar(1) NOT NULL,
  `alt_allele` varchar(1) NOT NULL,
  `sample_id` varchar(45) NOT NULL,
  PRIMARY KEY (`snps_reference_id`),
  UNIQUE KEY `preventdupe` (`chromosome`,`chromosomal_loci`,`ref_allele`,`alt_allele`,`sample_id`),
  INDEX `index2` (`sample_id` ASC)
) ENGINE=InnoDB AUTO_INCREMENT=25980390 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snps_reference`
--

LOCK TABLES `snps_reference` WRITE;
/*!40000 ALTER TABLE `snps_reference` DISABLE KEYS */;
INSERT INTO `snps_reference` VALUES (1,0,723860,'A','C','001');
/*!40000 ALTER TABLE `snps_reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snps_to_protein`
--

DROP TABLE IF EXISTS `snps_to_protein`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snps_to_protein` (
  `snps_reference_id` int NOT NULL,
  `protein_reference_id` int NOT NULL,
  `transcript_pos` int NOT NULL,
  `ref_DNA` varchar(1) NOT NULL,
  `alt_DNA` varchar(45) NOT NULL,
  `aa_pos` int NOT NULL,
  `ref_aa` varchar(3) NOT NULL,
  `alt_aa` varchar(3) NOT NULL,
  `type` varchar(50) NOT NULL,
  `effect_impact` varchar(50) NOT NULL,
  `transcript_biotype` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`snps_reference_id`,`protein_reference_id`),
  KEY `protein_fk_idx` (`protein_reference_id`),
  CONSTRAINT `protein_fk` FOREIGN KEY (`protein_reference_id`) REFERENCES `protein_reference` (`protein_reference_id`),
  CONSTRAINT `snp_fk` FOREIGN KEY (`snps_reference_id`) REFERENCES `snps_reference` (`snps_reference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snps_to_protein`
--

LOCK TABLES `snps_to_protein` WRITE;
/*!40000 ALTER TABLE `snps_to_protein` DISABLE KEYS */;
INSERT INTO `snps_to_protein` VALUES (1,1,154,'T','G',52,'Trp','Gly','transcript','MODERATE',NULL);
/*!40000 ALTER TABLE `snps_to_protein` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

-- 
-- Table structure for table `lines_lookup`
--
DROP TABLE IF EXISTS `lines_lookup` ;

CREATE TABLE IF NOT EXISTS `lines_lookup` (
  `lines_id` varchar(45) NOT NULL,
  `species` varchar(35) NULL,
  `alias` varchar(35) NULL,
  PRIMARY KEY (`lines_id`),
  CONSTRAINT `lines_id`
    FOREIGN KEY (`lines_id`)
    REFERENCES `snps_reference` (`sample_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- 
-- Dunping data for table `lines_lookup`
--

LOCK TABLES `lines_lookup` WRITE;
/*!40000 ALTER TABLE `lines_lookup` DISABLE KEYS */;
INSERT INTO `lines_lookup` VALUES ('001','Solanum lycopersicum','Moneymaker');
/*!40000 ALTER TABLE `lines_lookup` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump copied from poplar_nssnp
