-- MySQL dump 10.13  Distrib 8.3.0, for macos14.2 (arm64)
--
-- Host: localhost    Database: llama3_summaries
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Current Database: `llama3_summaries`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `llama3_summaries` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `llama3_summaries`;

--
-- Table structure for table `summaries`
--

DROP TABLE IF EXISTS `summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `summaries` (
  `gene_id` varchar(13) NOT NULL,
  `summary` longtext NOT NULL,
  `bert_score` decimal(8,7) NOT NULL,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `summaries`
--

LOCK TABLES `summaries` WRITE;
/*!40000 ALTER TABLE `summaries` DISABLE KEYS */;
INSERT INTO `summaries` VALUES
('AT3G18890','The gene AT3G18890, also known as TIC62, has been found to be correlated with PSII electron transfer rate and cyclic electron transport (PubMed ID 33118270). Additionally, TIC62 has been shown to repress protein import (PubMed ID 19403728). Research has also demonstrated that TIC62 shuttles between the envelope and stroma (PubMed ID 20040542), interacts with FNR (PubMed ID 20040542), localizes to thylakoids (PubMed ID 20040542), binds to FNR (PubMed ID 20040542), stabilizes FNR (PubMed ID 20040542), and dynamically regulates FNR (PubMed ID 20040542). Furthermore, TIC62 has been found to form complexes with LIR1 and TROL (PubMed ID 26941088), and LIR1 enhances the affinity of LFNR for TIC62 (PubMed ID 26941088). Moreover, TIC62 has been shown to participate in anchoring ATLFNRs (PubMed ID 36138316).',0.9898241),
('AT3G17820','The gene AT3G17820, also known as GLN1;3, plays a crucial role in regulating glutamine biosynthesis, as demonstrated by research in PubMed ID 28007952, which shows that GLN1;3 represses glutamine biosynthesis. Additionally, GLN1;3 localizes to the pericycle (PubMed ID 28007952) and encodes for cytosolic GS (PubMed ID 31034969). Furthermore, ATPDF2.1 has been found to enhance the expression of GLN1.3 and GLN1.5 (PubMed ID 31842759), which produce glutamine synthetase (PubMed ID 31842759). Interestingly, the GLN1;1, GLN1;2, and GLN1;3 genes have been shown to affect N remobilization (PubMed ID 29873769), which is also linked to vegetative growth (PubMed ID 30649517).',0.9829522),
('AT3G18850','The gene AT3G18850, also known as LPAT5, has been found to localize to the endoplasmic reticulum (ER) (PubMed ID 31211859). This localization is crucial for its function, as LPAT5 is responsible for producing phospholipids and triacylglycerol (TAG) (PubMed ID 31211859).',0.9839827);
/*!40000 ALTER TABLE `summaries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-26 22:23:56
