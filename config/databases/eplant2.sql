-- MariaDB dump 10.18  Distrib 10.5.8-MariaDB, for OpenBSD (amd64)
--
-- Host: localhost    Database: eplant2
-- ------------------------------------------------------
-- Server version	10.5.8-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `eplant2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant2` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `eplant2`;

--
-- Table structure for table `isoforms`
--

DROP TABLE IF EXISTS `isoforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `isoforms` (
  `gene` varchar(10) NOT NULL,
  `isoform` varchar(12) NOT NULL,
  KEY `idx_gene_isoform` (`gene`,`isoform`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `isoforms`
--

LOCK TABLES `isoforms` WRITE;
/*!40000 ALTER TABLE `isoforms` DISABLE KEYS */;
INSERT INTO `isoforms` VALUES ('AT1G01010','AT1G01010.1'),('AT1G01020','AT1G01020.1'),('AT1G01020','AT1G01020.2');
/*!40000 ALTER TABLE `isoforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publications`
--

CREATE TABLE `publications` (
  `gene` varchar(12) CHARACTER SET latin1 NOT NULL,
  `author` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` varchar(6) CHARACTER SET latin1 NOT NULL,
  `journal` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `pubmed` varchar(16) CHARACTER SET latin1 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Dumping data for table `publications`
--

LOCK TABLES `publications` WRITE;
/*!40000 ALTER TABLE `publications` DISABLE KEYS */;
INSERT INTO `publications` VALUES
('AT1G01010', 'Arabidopsis Interactome Mapping Consortium', '2011', 'Science', 'Evidence for network evolution in an Arabidopsis interactome map.', '21798944'),
('AT1G01010', 'Gaudinier A', '2018', 'Nature', 'Transcriptional regulation of nitrogen-associated metabolism and growth.', '30356219'),
('AT1G01010', 'Riechmann JL', '2000', 'Science', 'Arabidopsis transcription factors: genome-wide comparative analysis among eukaryotes.', '11118137'),
('AT1G01010', 'Theologis A', '2000', 'Nature', 'Sequence and analysis of chromosome 1 of the plant Arabidopsis thaliana.', '11130712'),
('AT1G01010', 'Trigg SA', '2017', 'Nat. Methods', 'CrY2H-seq: a massively multiplexed assay for deep-coverage interactome mapping.', '28650476'),
('AT1G01020', 'Forés O', '2006', 'Biochim. Biophys. Acta', 'Arabidopsis thaliana expresses two functional isoforms of Arvp, a protein involved in the regulation of cellular lipid homeostasis.', '16725371'),
('AT1G01020', 'Theologis A', '2000', 'Nature', 'Sequence and analysis of chromosome 1 of the plant Arabidopsis thaliana.', '11130712'),
('AT4G10090', 'Gaudet P', '2011', 'Brief. Bioinformatics', 'Phylogenetic-based propagation of functional annotations within the Gene Ontology consortium.', '21873635'),
('AT4G10090', 'Leitner J', '2015', 'Cell Rep', 'Meta-regulation of Arabidopsis auxin responses depends on tRNA maturation.', '25892242'),
('AT4G10090', 'Mayer K', '1999', 'Nature', 'Sequence and analysis of chromosome 4 of the plant Arabidopsis thaliana.', '10617198'),
('AT4G10090', 'Nelissen H', '2010', 'Proc. Natl. Acad. Sci. U.S.A.', 'Plant Elongator regulates auxin-related genes during RNA polymerase II transcription elongation.', '20080602'),
('AT4G10090', 'Zhou X', '2009', 'Plant J.', 'Elongator mediates ABA responses, oxidative stress resistance and anthocyanin biosynthesis in Arabidopsis.', '19500300');
/*!40000 ALTER TABLE `publications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agi_annotation`
--

DROP TABLE IF EXISTS `agi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_annotation` (
  `agi` varchar(11) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agi_annotation`
--
-- WHERE:  1 limit 5

LOCK TABLES `agi_annotation` WRITE;
/*!40000 ALTER TABLE `agi_annotation` DISABLE KEYS */;
INSERT INTO `agi_annotation` VALUES ('At1g01010','ANAC001_NAC001_NTL10__NAC domain containing protein 1'),('At1g01020','ARV1__Arv1-like protein'),('At1g01030','NGA3__AP2/B3-like transcriptional factor family protein'),('At1g01040','ASU1_ATDCL1_CAF_DCL1_EMB60_EMB76_SIN1_SUS1__dicer-like 1'),('At1g01046','MIR838A__MIR838a; miRNA');
/*!40000 ALTER TABLE `agi_annotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TAIR10_functional_descriptions`
--

DROP TABLE IF EXISTS `TAIR10_functional_descriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TAIR10_functional_descriptions` (
  `Model_name` varchar(32) NOT NULL,
  `Type` varchar(32) NOT NULL,
  `Short_description` text,
  `Curator_summary` text,
  `Computational_description` text,
  KEY `Model_name_idx` (`Model_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TAIR10_functional_descriptions`
--
-- WHERE:  1 limit 5

LOCK TABLES `TAIR10_functional_descriptions` WRITE;
/*!40000 ALTER TABLE `TAIR10_functional_descriptions` DISABLE KEYS */;
INSERT INTO `TAIR10_functional_descriptions` VALUES ('AT3G27990.1','antisense_long_noncoding_rna','other RNA',NULL,'None;(source:Araport11)'),('AT1G69587.1','antisense_long_noncoding_rna','other RNA',NULL,'Natural antisense transcript overlaps with AT1G69588;(source:Araport11)'),('AT2G31751.1','antisense_long_noncoding_rna','unknown gene','Potential natural antisense gene, locus overlaps with AT2G31750','Natural antisense transcript overlaps with AT2G31750;(source:Araport11)'),('AT1G01448.1','antisense_long_noncoding_rna','other RNA',NULL,'Natural antisense transcript overlaps with AT1G01450;(source:Araport11)'),('AT1G01448.2','antisense_long_noncoding_rna','other RNA',NULL,'Natural antisense transcript overlaps with AT1G01450;(source:Araport11)');
/*!40000 ALTER TABLE `TAIR10_functional_descriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `geneRIFs`
--

DROP TABLE IF EXISTS `geneRIFs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geneRIFs` (
  `gene` varchar(16) NOT NULL,
  `pubmed` varchar(16) NOT NULL,
  `RIF` text NOT NULL,
  KEY `rifs` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geneRIFs`
--
-- WHERE:  1 limit 5

LOCK TABLES `geneRIFs` WRITE;
/*!40000 ALTER TABLE `geneRIFs` DISABLE KEYS */;
INSERT INTO `geneRIFs` VALUES ('AT2G01110','18930082','An approximately equimolar ratio of the TatB and TatC components was observed in tissues from Arabidopsis thaliana, whereas TatA was detectable only in minor amounts. [TatC]'),('AT2G01110','19207210','Chloroplast TatC targets to thylakoid membranes via a stromal intermediate, and that cpTatC membrane integration is not altered by competition with precursors of the cpSec and cpTat pathways.'),('AT2G01110','27609835','mitochondrial-encoded TatC is a functional gene that is translated into a protein in the model plant Arabidopsis thaliana A TatB--like subunit localized to the inner membrane was also identified that is nuclear-encoded and is essential for plant growth and development.'),('AT2G01110','29216369','MEF31 does not directly target site tatC-586, and only indirectly influences editing at this site.'),('AT2G01150','21478367','RHA2b and RHA2a may have redundant yet distinguishable functions in the regulation of abscissic acid responses.');
/*!40000 ALTER TABLE `geneRIFs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-29 22:25:37
