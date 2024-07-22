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
-- Table structure for table `tair10_gff3`
--

CREATE TABLE `tair10_gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(10) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(20) DEFAULT NULL,
  `geneId` varchar(20) DEFAULT NULL,
  `Parent` varchar(40) DEFAULT NULL,
  `Attributes` varchar(256) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`),
  KEY `type_geneId` (`Type`,`geneId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Dumping data for table `tair10_gff3`
--

LOCK TABLES `tair10_gff3` WRITE;
/*!40000 ALTER TABLE `tair10_gff3` DISABLE KEYS */;
INSERT INTO `tair10_gff3` VALUES
('1', 'TAIR10', 'five_prime_UTR', 3631, 3759, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'CDS', 3760, 3913, NULL, '+', '0', NULL, 'AT1G01010.1', 'AT1G01010.1,AT1G01010.1-Protein', ''),
('1', 'TAIR10', 'exon', 3631, 3913, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'CDS', 3996, 4276, NULL, '+', '2', NULL, 'AT1G01010.1', 'AT1G01010.1,AT1G01010.1-Protein', ''),
('1', 'TAIR10', 'exon', 3996, 4276, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'CDS', 4486, 4605, NULL, '+', '0', NULL, 'AT1G01010.1', 'AT1G01010.1,AT1G01010.1-Protein', ''),
('1', 'TAIR10', 'exon', 4486, 4605, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'CDS', 4706, 5095, NULL, '+', '0', NULL, 'AT1G01010.1', 'AT1G01010.1,AT1G01010.1-Protein', ''),
('1', 'TAIR10', 'exon', 4706, 5095, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'CDS', 5174, 5326, NULL, '+', '0', NULL, 'AT1G01010.1', 'AT1G01010.1,AT1G01010.1-Protein', ''),
('1', 'TAIR10', 'exon', 5174, 5326, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'CDS', 5439, 5630, NULL, '+', '0', NULL, 'AT1G01010.1', 'AT1G01010.1,AT1G01010.1-Protein', ''),
('1', 'TAIR10', 'protein', 3760, 5630, NULL, '+', NULL, 'AT1G01010.1-Protein', 'AT1G01010.1', NULL, 'Derives_from=AT1G01010.1'),
('1', 'TAIR10', 'exon', 5439, 5899, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'three_prime_UTR', 5631, 5899, NULL, '+', NULL, NULL, 'AT1G01010.1', 'AT1G01010.1', ''),
('1', 'TAIR10', 'mRNA', 3631, 5899, NULL, '+', NULL, 'AT1G01010.1', 'AT1G01010.1', 'AT1G01010', 'Name=AT1G01010.1;Index=1'),
('1', 'TAIR10', 'gene', 3631, 5899, NULL, '+', NULL, 'AT1G01010', 'AT1G01010', NULL, 'Note=protein_coding_gene;Name=AT1G01010'),
('1', 'TAIR10', 'exon', 5928, 6263, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'three_prime_UTR', 5928, 6263, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'three_prime_UTR', 6437, 6914, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 6915, 7069, NULL, '-', '2', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'exon', 6790, 7069, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'three_prime_UTR', 6790, 7069, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'exon', 6437, 7069, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'exon', 7157, 7232, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 7157, 7232, NULL, '-', '0', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'three_prime_UTR', 7157, 7314, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'exon', 7384, 7450, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 7384, 7450, NULL, '-', '1', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'exon', 7157, 7450, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'three_prime_UTR', 7157, 7314, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'exon', 7384, 7450, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 7384, 7450, NULL, '-', '1', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'exon', 7157, 7450, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'CDS', 7315, 7450, NULL, '-', '1', NULL, 'AT1G01020.2', 'AT1G01020.2,AT1G01020.2-Protein', ''),
('1', 'TAIR10', 'exon', 7564, 7649, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'CDS', 7564, 7649, NULL, '-', '0', NULL, 'AT1G01020.2', 'AT1G01020.2,AT1G01020.2-Protein', ''),
('1', 'TAIR10', 'exon', 7564, 7649, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 7564, 7649, NULL, '-', '0', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'exon', 7762, 7835, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'CDS', 7762, 7835, NULL, '-', '2', NULL, 'AT1G01020.2', 'AT1G01020.2,AT1G01020.2-Protein', ''),
('1', 'TAIR10', 'exon', 7762, 7835, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 7762, 7835, NULL, '-', '2', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'exon', 7942, 7987, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'CDS', 7942, 7987, NULL, '-', '0', NULL, 'AT1G01020.2', 'AT1G01020.2,AT1G01020.2-Protein', ''),
('1', 'TAIR10', 'exon', 7942, 7987, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 7942, 7987, NULL, '-', '0', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'exon', 8236, 8325, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'CDS', 8236, 8325, NULL, '-', '0', NULL, 'AT1G01020.2', 'AT1G01020.2,AT1G01020.2-Protein', ''),
('1', 'TAIR10', 'exon', 8236, 8325, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 8236, 8325, NULL, '-', '0', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'exon', 8417, 8464, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'CDS', 8417, 8464, NULL, '-', '0', NULL, 'AT1G01020.2', 'AT1G01020.2,AT1G01020.2-Protein', ''),
('1', 'TAIR10', 'exon', 8417, 8464, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'CDS', 8417, 8464, NULL, '-', '0', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'CDS', 8571, 8666, NULL, '-', '0', NULL, 'AT1G01020.2', 'AT1G01020.2,AT1G01020.2-Protein', ''),
('1', 'TAIR10', 'CDS', 8571, 8666, NULL, '-', '0', NULL, 'AT1G01020.1', 'AT1G01020.1,AT1G01020.1-Protein', ''),
('1', 'TAIR10', 'protein', 7315, 8666, NULL, '-', NULL, 'AT1G01020.2-Protein', 'AT1G01020.2', NULL, 'Derives_from=AT1G01020.2'),
('1', 'TAIR10', 'protein', 6915, 8666, NULL, '-', NULL, 'AT1G01020.1-Protein', 'AT1G01020.1', NULL, 'Derives_from=AT1G01020.1'),
('1', 'TAIR10', 'five_prime_UTR', 8667, 8737, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'five_prime_UTR', 8667, 8737, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'exon', 8571, 8737, NULL, '-', NULL, NULL, 'AT1G01020.2', 'AT1G01020.2', ''),
('1', 'TAIR10', 'exon', 8571, 8737, NULL, '-', NULL, NULL, 'AT1G01020.1', 'AT1G01020.1', ''),
('1', 'TAIR10', 'mRNA', 6790, 8737, NULL, '-', NULL, 'AT1G01020.2', 'AT1G01020.2', 'AT1G01020', 'Name=AT1G01020.2;Index=1'),
('1', 'TAIR10', 'mRNA', 5928, 8737, NULL, '-', NULL, 'AT1G01020.1', 'AT1G01020.1', 'AT1G01020', 'Name=AT1G01020.1;Index=1'),
('1', 'TAIR10', 'gene', 5928, 8737, NULL, '-', NULL, 'AT1G01020', 'AT1G01020', NULL, 'Note=protein_coding_gene;Name=AT1G01020'),
('1', 'TAIR10', 'three_prime_UTR', 11649, 11863, NULL, '-', NULL, NULL, 'AT1G01030.1', 'AT1G01030.1', ''),
('1', 'TAIR10', 'CDS', 11864, 12940, NULL, '-', '0', NULL, 'AT1G01030.1', 'AT1G01030.1,AT1G01030.1-Protein', ''),
('1', 'TAIR10', 'protein', 11864, 12940, NULL, '-', NULL, 'AT1G01030.1-Protein', 'AT1G01030.1', NULL, 'Derives_from=AT1G01030.1'),
('1', 'TAIR10', 'five_prime_UTR', 12941, 13173, NULL, '-', NULL, NULL, 'AT1G01030.1', 'AT1G01030.1', ''),
('1', 'TAIR10', 'exon', 11649, 13173, NULL, '-', NULL, NULL, 'AT1G01030.1', 'AT1G01030.1', ''),
('1', 'TAIR10', 'exon', 13335, 13714, NULL, '-', NULL, NULL, 'AT1G01030.1', 'AT1G01030.1', ''),
('1', 'TAIR10', 'five_prime_UTR', 13335, 13714, NULL, '-', NULL, NULL, 'AT1G01030.1', 'AT1G01030.1', ''),
('1', 'TAIR10', 'mRNA', 11649, 13714, NULL, '-', NULL, 'AT1G01030.1', 'AT1G01030.1', 'AT1G01030', 'Name=AT1G01030.1;Index=1'),
('1', 'TAIR10', 'gene', 11649, 13714, NULL, '-', NULL, 'AT1G01030', 'AT1G01030', NULL, 'Note=protein_coding_gene;Name=AT1G01030'),
('1', 'TAIR10', 'five_prime_UTR', 23416, 23518, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'five_prime_UTR', 23146, 23518, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 23519, 24451, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'CDS', 23519, 24451, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 23416, 24451, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'exon', 23146, 24451, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 24542, 24655, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 24542, 24655, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 24542, 24655, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 24542, 24655, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 24752, 24962, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 24752, 24962, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 24752, 24962, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 24752, 24962, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 25041, 25435, NULL, '+', '2', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 25041, 25435, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 25041, 25435, NULL, '+', '2', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 25041, 25435, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 25524, 25743, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 25524, 25743, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 25524, 25743, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 25524, 25743, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'exon', 25825, 25997, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 25825, 25997, NULL, '+', '2', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'CDS', 25825, 25997, NULL, '+', '2', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 25825, 25997, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 26081, 26203, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 26081, 26203, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 26081, 26203, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 26081, 26203, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 26292, 26452, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 26292, 26452, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 26292, 26452, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 26292, 26452, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 26543, 26776, NULL, '+', '1', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 26543, 26776, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 26543, 26776, NULL, '+', '1', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 26543, 26776, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 26862, 27012, NULL, '+', '1', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 26862, 27012, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 26862, 27012, NULL, '+', '1', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 26862, 27012, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 27099, 27281, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 27099, 27281, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 27099, 27281, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 27099, 27281, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 27372, 27533, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 27372, 27533, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 27372, 27536, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 27372, 27536, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 27618, 27713, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 27618, 27713, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 27618, 27713, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 27618, 27713, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'exon', 27803, 28431, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 27803, 28431, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'CDS', 27803, 28431, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 27803, 28431, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'exon', 28500, 28706, NULL, '+', NULL, NULL, 'AT1G01046.1', 'AT1G01046.1', ''),
('1', 'TAIR10', 'miRNA', 28500, 28706, NULL, '+', NULL, 'AT1G01046.1', 'AT1G01046.1', 'AT1G01046', 'Name=AT1G01046.1;Index=1'),
('1', 'TAIR10', 'gene', 28500, 28706, NULL, '+', NULL, 'AT1G01046', 'AT1G01046', NULL, 'Note=miRNA;Name=AT1G01046'),
('1', 'TAIR10', 'CDS', 28708, 28805, NULL, '+', '1', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 28708, 28805, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 28708, 28805, NULL, '+', '1', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 28708, 28805, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'exon', 28890, 29080, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 28890, 29080, NULL, '+', '2', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'CDS', 28890, 29080, NULL, '+', '2', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 28890, 29080, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 29160, 30065, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 29160, 30065, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 29160, 30065, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 29160, 30065, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 30147, 30311, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 30147, 30311, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 30147, 30311, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 30147, 30311, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 30410, 30816, NULL, '+', '0', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'exon', 30410, 30816, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'CDS', 30410, 30816, NULL, '+', '0', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'exon', 30410, 30816, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'CDS', 30902, 31079, NULL, '+', '1', NULL, 'AT1G01040.2', 'AT1G01040.2,AT1G01040.2-Protein', ''),
('1', 'TAIR10', 'CDS', 30902, 31079, NULL, '+', '1', NULL, 'AT1G01040.1', 'AT1G01040.1,AT1G01040.1-Protein', ''),
('1', 'TAIR10', 'protein', 23519, 31079, NULL, '+', NULL, 'AT1G01040.2-Protein', 'AT1G01040.2', NULL, 'Derives_from=AT1G01040.2'),
('1', 'TAIR10', 'protein', 23519, 31079, NULL, '+', NULL, 'AT1G01040.1-Protein', 'AT1G01040.1', NULL, 'Derives_from=AT1G01040.1'),
('1', 'TAIR10', 'three_prime_UTR', 31080, 31120, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'exon', 30902, 31120, NULL, '+', NULL, NULL, 'AT1G01040.2', 'AT1G01040.2', ''),
('1', 'TAIR10', 'mRNA', 23416, 31120, NULL, '+', NULL, 'AT1G01040.2', 'AT1G01040.2', 'AT1G01040', 'Name=AT1G01040.2;Index=1'),
('1', 'TAIR10', 'three_prime_UTR', 31080, 31227, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'exon', 30902, 31227, NULL, '+', NULL, NULL, 'AT1G01040.1', 'AT1G01040.1', ''),
('1', 'TAIR10', 'mRNA', 23146, 31227, NULL, '+', NULL, 'AT1G01040.1', 'AT1G01040.1', 'AT1G01040', 'Name=AT1G01040.1;Index=1'),
('1', 'TAIR10', 'gene', 23146, 31227, NULL, '+', NULL, 'AT1G01040', 'AT1G01040', NULL, 'Note=protein_coding_gene;Name=AT1G01040'),
('1', 'TAIR10', 'three_prime_UTR', 31170, 31381, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 31382, 31424, NULL, '-', '1', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'exon', 31170, 31424, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'exon', 31521, 31602, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 31521, 31602, NULL, '-', '2', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'exon', 31693, 31813, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 31693, 31813, NULL, '-', '0', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'exon', 31933, 31998, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 31933, 31998, NULL, '-', '0', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'exon', 32088, 32195, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 32088, 32195, NULL, '-', '0', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'exon', 32282, 32347, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 32282, 32347, NULL, '-', '0', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'exon', 32431, 32459, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 32431, 32459, NULL, '-', '2', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'exon', 32547, 32670, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'CDS', 32547, 32670, NULL, '-', '0', NULL, 'AT1G01050.1', 'AT1G01050.1,AT1G01050.1-Protein', ''),
('1', 'TAIR10', 'protein', 31382, 32670, NULL, '-', NULL, 'AT1G01050.1-Protein', 'AT1G01050.1', NULL, 'Derives_from=AT1G01050.1'),
('1', 'TAIR10', 'exon', 33029, 33153, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'five_prime_UTR', 33029, 33153, NULL, '-', NULL, NULL, 'AT1G01050.1', 'AT1G01050.1', ''),
('1', 'TAIR10', 'mRNA', 31170, 33153, NULL, '-', NULL, 'AT1G01050.1', 'AT1G01050.1', 'AT1G01050', 'Name=AT1G01050.1;Index=1'),
('1', 'TAIR10', 'gene', 31170, 33153, NULL, '-', NULL, 'AT1G01050', 'AT1G01050', NULL, 'Note=protein_coding_gene;Name=AT1G01050'),
('1', 'TAIR10', 'exon', 33379, 33589, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'three_prime_UTR', 33379, 33589, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'three_prime_UTR', 33981, 33991, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'three_prime_UTR', 33967, 33991, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'three_prime_UTR', 33666, 33991, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'three_prime_UTR', 33666, 33991, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'three_prime_UTR', 33666, 33991, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'CDS', 33992, 34327, NULL, '-', '0', NULL, 'AT1G01060.5', 'AT1G01060.5,AT1G01060.5-Protein', ''),
('1', 'TAIR10', 'CDS', 33992, 34327, NULL, '-', '0', NULL, 'AT1G01060.4', 'AT1G01060.4,AT1G01060.4-Protein', ''),
('1', 'TAIR10', 'CDS', 33992, 34327, NULL, '-', '0', NULL, 'AT1G01060.3', 'AT1G01060.3,AT1G01060.3-Protein', ''),
('1', 'TAIR10', 'CDS', 33992, 34327, NULL, '-', '0', NULL, 'AT1G01060.2', 'AT1G01060.2,AT1G01060.2-Protein', ''),
('1', 'TAIR10', 'CDS', 33992, 34327, NULL, '-', '0', NULL, 'AT1G01060.1', 'AT1G01060.1,AT1G01060.1-Protein', ''),
('1', 'TAIR10', 'exon', 33981, 34327, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'exon', 33967, 34327, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'exon', 33666, 34327, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'exon', 33666, 34327, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'exon', 33666, 34327, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'exon', 34401, 35471, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'CDS', 34401, 35471, NULL, '-', '0', NULL, 'AT1G01060.4', 'AT1G01060.4,AT1G01060.4-Protein', ''),
('1', 'TAIR10', 'exon', 34401, 35474, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'CDS', 34401, 35474, NULL, '-', '0', NULL, 'AT1G01060.5', 'AT1G01060.5,AT1G01060.5-Protein', ''),
('1', 'TAIR10', 'exon', 34401, 35474, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'CDS', 34401, 35474, NULL, '-', '0', NULL, 'AT1G01060.3', 'AT1G01060.3,AT1G01060.3-Protein', ''),
('1', 'TAIR10', 'exon', 34401, 35474, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'CDS', 34401, 35474, NULL, '-', '0', NULL, 'AT1G01060.2', 'AT1G01060.2,AT1G01060.2-Protein', ''),
('1', 'TAIR10', 'exon', 34401, 35474, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'CDS', 34401, 35474, NULL, '-', '0', NULL, 'AT1G01060.1', 'AT1G01060.1,AT1G01060.1-Protein', ''),
('1', 'TAIR10', 'exon', 35567, 35647, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'CDS', 35567, 35647, NULL, '-', '0', NULL, 'AT1G01060.5', 'AT1G01060.5,AT1G01060.5-Protein', ''),
('1', 'TAIR10', 'exon', 35567, 35647, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'exon', 35567, 35647, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'CDS', 35567, 35647, NULL, '-', '0', NULL, 'AT1G01060.4', 'AT1G01060.4,AT1G01060.4-Protein', ''),
('1', 'TAIR10', 'CDS', 35567, 35647, NULL, '-', '0', NULL, 'AT1G01060.3', 'AT1G01060.3,AT1G01060.3-Protein', ''),
('1', 'TAIR10', 'exon', 35567, 35647, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'CDS', 35567, 35647, NULL, '-', '0', NULL, 'AT1G01060.2', 'AT1G01060.2,AT1G01060.2-Protein', ''),
('1', 'TAIR10', 'exon', 35567, 35647, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'CDS', 35567, 35647, NULL, '-', '0', NULL, 'AT1G01060.1', 'AT1G01060.1,AT1G01060.1-Protein', ''),
('1', 'TAIR10', 'exon', 35730, 35963, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'CDS', 35730, 35963, NULL, '-', '0', NULL, 'AT1G01060.4', 'AT1G01060.4,AT1G01060.4-Protein', ''),
('1', 'TAIR10', 'exon', 35730, 35963, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'CDS', 35730, 35963, NULL, '-', '0', NULL, 'AT1G01060.3', 'AT1G01060.3,AT1G01060.3-Protein', ''),
('1', 'TAIR10', 'exon', 35730, 35963, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'CDS', 35730, 35963, NULL, '-', '0', NULL, 'AT1G01060.2', 'AT1G01060.2,AT1G01060.2-Protein', ''),
('1', 'TAIR10', 'exon', 35730, 35963, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'CDS', 35730, 35963, NULL, '-', '0', NULL, 'AT1G01060.1', 'AT1G01060.1,AT1G01060.1-Protein', ''),
('1', 'TAIR10', 'exon', 35730, 35999, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'CDS', 35730, 35999, NULL, '-', '0', NULL, 'AT1G01060.5', 'AT1G01060.5,AT1G01060.5-Protein', ''),
('1', 'TAIR10', 'exon', 36090, 36171, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'CDS', 36090, 36171, NULL, '-', '1', NULL, 'AT1G01060.5', 'AT1G01060.5,AT1G01060.5-Protein', ''),
('1', 'TAIR10', 'exon', 36624, 36685, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'CDS', 36624, 36685, NULL, '-', '0', NULL, 'AT1G01060.5', 'AT1G01060.5,AT1G01060.5-Protein', ''),
('1', 'TAIR10', 'exon', 36624, 36685, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'CDS', 36624, 36685, NULL, '-', '2', NULL, 'AT1G01060.4', 'AT1G01060.4,AT1G01060.4-Protein', ''),
('1', 'TAIR10', 'exon', 36624, 36685, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'CDS', 36624, 36685, NULL, '-', '2', NULL, 'AT1G01060.3', 'AT1G01060.3,AT1G01060.3-Protein', ''),
('1', 'TAIR10', 'exon', 36624, 36685, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'CDS', 36624, 36685, NULL, '-', '2', NULL, 'AT1G01060.2', 'AT1G01060.2,AT1G01060.2-Protein', ''),
('1', 'TAIR10', 'exon', 36624, 36685, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'CDS', 36624, 36685, NULL, '-', '2', NULL, 'AT1G01060.1', 'AT1G01060.1,AT1G01060.1-Protein', ''),
('1', 'TAIR10', 'CDS', 36810, 36836, NULL, '-', '0', NULL, 'AT1G01060.5', 'AT1G01060.5,AT1G01060.5-Protein', ''),
('1', 'TAIR10', 'protein', 33992, 36836, NULL, '-', NULL, 'AT1G01060.5-Protein', 'AT1G01060.5', NULL, 'Derives_from=AT1G01060.5'),
('1', 'TAIR10', 'five_prime_UTR', 36837, 36921, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'exon', 36810, 36921, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'exon', 36810, 36921, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'CDS', 36810, 36921, NULL, '-', '0', NULL, 'AT1G01060.4', 'AT1G01060.4,AT1G01060.4-Protein', ''),
('1', 'TAIR10', 'exon', 36810, 36921, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'CDS', 36810, 36921, NULL, '-', '0', NULL, 'AT1G01060.3', 'AT1G01060.3,AT1G01060.3-Protein', ''),
('1', 'TAIR10', 'exon', 36810, 36921, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'CDS', 36810, 36921, NULL, '-', '0', NULL, 'AT1G01060.2', 'AT1G01060.2,AT1G01060.2-Protein', ''),
('1', 'TAIR10', 'exon', 36810, 36921, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'CDS', 36810, 36921, NULL, '-', '0', NULL, 'AT1G01060.1', 'AT1G01060.1,AT1G01060.1-Protein', ''),
('1', 'TAIR10', 'CDS', 37023, 37061, NULL, '-', '0', NULL, 'AT1G01060.4', 'AT1G01060.4,AT1G01060.4-Protein', ''),
('1', 'TAIR10', 'CDS', 37023, 37061, NULL, '-', '0', NULL, 'AT1G01060.3', 'AT1G01060.3,AT1G01060.3-Protein', ''),
('1', 'TAIR10', 'CDS', 37023, 37061, NULL, '-', '0', NULL, 'AT1G01060.2', 'AT1G01060.2,AT1G01060.2-Protein', ''),
('1', 'TAIR10', 'CDS', 37023, 37061, NULL, '-', '0', NULL, 'AT1G01060.1', 'AT1G01060.1,AT1G01060.1-Protein', ''),
('1', 'TAIR10', 'protein', 33992, 37061, NULL, '-', NULL, 'AT1G01060.4-Protein', 'AT1G01060.4', NULL, 'Derives_from=AT1G01060.4'),
('1', 'TAIR10', 'protein', 33992, 37061, NULL, '-', NULL, 'AT1G01060.3-Protein', 'AT1G01060.3', NULL, 'Derives_from=AT1G01060.3'),
('1', 'TAIR10', 'protein', 33992, 37061, NULL, '-', NULL, 'AT1G01060.2-Protein', 'AT1G01060.2', NULL, 'Derives_from=AT1G01060.2'),
('1', 'TAIR10', 'protein', 33992, 37061, NULL, '-', NULL, 'AT1G01060.1-Protein', 'AT1G01060.1', NULL, 'Derives_from=AT1G01060.1'),
('1', 'TAIR10', 'five_prime_UTR', 37062, 37203, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'five_prime_UTR', 37062, 37203, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'five_prime_UTR', 37062, 37203, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'exon', 37023, 37203, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'five_prime_UTR', 37062, 37203, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'five_prime_UTR', 37023, 37203, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'exon', 37023, 37203, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'exon', 37023, 37203, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'exon', 37023, 37203, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'exon', 37023, 37203, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'exon', 37373, 37398, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'five_prime_UTR', 37373, 37398, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'exon', 37373, 37398, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'five_prime_UTR', 37373, 37398, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'exon', 37373, 37398, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'five_prime_UTR', 37373, 37398, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'exon', 37569, 37757, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'five_prime_UTR', 37569, 37757, NULL, '-', NULL, NULL, 'AT1G01060.3', 'AT1G01060.3', ''),
('1', 'TAIR10', 'mRNA', 33379, 37757, NULL, '-', NULL, 'AT1G01060.3', 'AT1G01060.3', 'AT1G01060', 'Name=AT1G01060.3;Index=1'),
('1', 'TAIR10', 'exon', 37569, 37780, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'five_prime_UTR', 37569, 37780, NULL, '-', NULL, NULL, 'AT1G01060.4', 'AT1G01060.4', ''),
('1', 'TAIR10', 'exon', 37373, 37780, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'five_prime_UTR', 37373, 37780, NULL, '-', NULL, NULL, 'AT1G01060.2', 'AT1G01060.2', ''),
('1', 'TAIR10', 'mRNA', 33666, 37780, NULL, '-', NULL, 'AT1G01060.4', 'AT1G01060.4', 'AT1G01060', 'Name=AT1G01060.4;Index=1'),
('1', 'TAIR10', 'mRNA', 33666, 37780, NULL, '-', NULL, 'AT1G01060.2', 'AT1G01060.2', 'AT1G01060', 'Name=AT1G01060.2;Index=1'),
('1', 'TAIR10', 'exon', 37569, 37840, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'five_prime_UTR', 37569, 37840, NULL, '-', NULL, NULL, 'AT1G01060.1', 'AT1G01060.1', ''),
('1', 'TAIR10', 'mRNA', 33666, 37840, NULL, '-', NULL, 'AT1G01060.1', 'AT1G01060.1', 'AT1G01060', 'Name=AT1G01060.1;Index=1'),
('1', 'TAIR10', 'exon', 37373, 37871, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'five_prime_UTR', 37373, 37871, NULL, '-', NULL, NULL, 'AT1G01060.5', 'AT1G01060.5', ''),
('1', 'TAIR10', 'mRNA', 33967, 37871, NULL, '-', NULL, 'AT1G01060.5', 'AT1G01060.5', 'AT1G01060', 'Name=AT1G01060.5;Index=1'),
('1', 'TAIR10', 'gene', 33379, 37871, NULL, '-', NULL, 'AT1G01060', 'AT1G01060', NULL, 'Note=protein_coding_gene;Name=AT1G01060'),
('1', 'TAIR10', 'three_prime_UTR', 38752, 38897, NULL, '-', NULL, NULL, 'AT1G01070.2', 'AT1G01070.2', ''),
('1', 'TAIR10', 'three_prime_UTR', 38752, 38897, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'CDS', 38898, 39054, NULL, '-', '1', NULL, 'AT1G01070.2', 'AT1G01070.2,AT1G01070.2-Protein', ''),
('1', 'TAIR10', 'CDS', 38898, 39054, NULL, '-', '1', NULL, 'AT1G01070.1', 'AT1G01070.1,AT1G01070.1-Protein', ''),
('1', 'TAIR10', 'exon', 38752, 39054, NULL, '-', NULL, NULL, 'AT1G01070.2', 'AT1G01070.2', ''),
('1', 'TAIR10', 'exon', 38752, 39054, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'exon', 39136, 39287, NULL, '-', NULL, NULL, 'AT1G01070.2', 'AT1G01070.2', ''),
('1', 'TAIR10', 'CDS', 39136, 39287, NULL, '-', '0', NULL, 'AT1G01070.2', 'AT1G01070.2,AT1G01070.2-Protein', ''),
('1', 'TAIR10', 'exon', 39136, 39287, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'CDS', 39136, 39287, NULL, '-', '0', NULL, 'AT1G01070.1', 'AT1G01070.1,AT1G01070.1-Protein', ''),
('1', 'TAIR10', 'exon', 39409, 39814, NULL, '-', NULL, NULL, 'AT1G01070.2', 'AT1G01070.2', ''),
('1', 'TAIR10', 'CDS', 39409, 39814, NULL, '-', '1', NULL, 'AT1G01070.2', 'AT1G01070.2,AT1G01070.2-Protein', ''),
('1', 'TAIR10', 'exon', 39409, 39814, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'CDS', 39409, 39814, NULL, '-', '1', NULL, 'AT1G01070.1', 'AT1G01070.1,AT1G01070.1-Protein', ''),
('1', 'TAIR10', 'exon', 40213, 40329, NULL, '-', NULL, NULL, 'AT1G01070.2', 'AT1G01070.2', ''),
('1', 'TAIR10', 'CDS', 40213, 40329, NULL, '-', '1', NULL, 'AT1G01070.2', 'AT1G01070.2,AT1G01070.2-Protein', ''),
('1', 'TAIR10', 'exon', 40213, 40329, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'CDS', 40213, 40329, NULL, '-', '1', NULL, 'AT1G01070.1', 'AT1G01070.1,AT1G01070.1-Protein', ''),
('1', 'TAIR10', 'exon', 40473, 40535, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'CDS', 40473, 40535, NULL, '-', '1', NULL, 'AT1G01070.1', 'AT1G01070.1,AT1G01070.1-Protein', ''),
('1', 'TAIR10', 'CDS', 40473, 40597, NULL, '-', '0', NULL, 'AT1G01070.2', 'AT1G01070.2,AT1G01070.2-Protein', ''),
('1', 'TAIR10', 'protein', 38898, 40597, NULL, '-', NULL, 'AT1G01070.2-Protein', 'AT1G01070.2', NULL, 'Derives_from=AT1G01070.2'),
('1', 'TAIR10', 'CDS', 40675, 40877, NULL, '-', '0', NULL, 'AT1G01070.1', 'AT1G01070.1,AT1G01070.1-Protein', ''),
('1', 'TAIR10', 'protein', 38898, 40877, NULL, '-', NULL, 'AT1G01070.1-Protein', 'AT1G01070.1', NULL, 'Derives_from=AT1G01070.1'),
('1', 'TAIR10', 'five_prime_UTR', 40598, 40927, NULL, '-', NULL, NULL, 'AT1G01070.2', 'AT1G01070.2', ''),
('1', 'TAIR10', 'exon', 40473, 40927, NULL, '-', NULL, NULL, 'AT1G01070.2', 'AT1G01070.2', ''),
('1', 'TAIR10', 'mRNA', 38752, 40927, NULL, '-', NULL, 'AT1G01070.2', 'AT1G01070.2', 'AT1G01070', 'Name=AT1G01070.2;Index=1'),
('1', 'TAIR10', 'exon', 40675, 40944, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'five_prime_UTR', 40878, 40944, NULL, '-', NULL, NULL, 'AT1G01070.1', 'AT1G01070.1', ''),
('1', 'TAIR10', 'mRNA', 38752, 40944, NULL, '-', NULL, 'AT1G01070.1', 'AT1G01070.1', 'AT1G01070', 'Name=AT1G01070.1;Index=1'),
('1', 'TAIR10', 'gene', 38752, 40944, NULL, '-', NULL, 'AT1G01070', 'AT1G01070', NULL, 'Note=protein_coding_gene;Name=AT1G01070'),
('1', 'TAIR10', 'CDS', 44677, 44787, NULL, '+', '0', NULL, 'AT1G01073.1', 'AT1G01073.1,AT1G01073.1-Protein', ''),
('1', 'TAIR10', 'exon', 44677, 44787, NULL, '+', NULL, NULL, 'AT1G01073.1', 'AT1G01073.1', ''),
('1', 'TAIR10', 'protein', 44677, 44787, NULL, '+', NULL, 'AT1G01073.1-Protein', 'AT1G01073.1', NULL, 'Derives_from=AT1G01073.1'),
('1', 'TAIR10', 'mRNA', 44677, 44787, NULL, '+', NULL, 'AT1G01073.1', 'AT1G01073.1', 'AT1G01073', 'Name=AT1G01073.1;Index=1'),
('1', 'TAIR10', 'gene', 44677, 44787, NULL, '+', NULL, 'AT1G01073', 'AT1G01073', NULL, 'Note=protein_coding_gene;Name=AT1G01073'),
('1', 'TAIR10', 'three_prime_UTR', 45296, 45502, NULL, '-', NULL, NULL, 'AT1G01080.2', 'AT1G01080.2', ''),
('1', 'TAIR10', 'three_prime_UTR', 45296, 45502, NULL, '-', NULL, NULL, 'AT1G01080.1', 'AT1G01080.1', ''),
('1', 'TAIR10', 'CDS', 45503, 45559, NULL, '-', '0', NULL, 'AT1G01080.2', 'AT1G01080.2,AT1G01080.2-Protein', ''),
('1', 'TAIR10', 'CDS', 45503, 45559, NULL, '-', '0', NULL, 'AT1G01080.1', 'AT1G01080.1,AT1G01080.1-Protein', ''),
('1', 'TAIR10', 'exon', 45296, 45559, NULL, '-', NULL, NULL, 'AT1G01080.1', 'AT1G01080.1', ''),
('1', 'TAIR10', 'exon', 45296, 45559, NULL, '-', NULL, NULL, 'AT1G01080.2', 'AT1G01080.2', ''),
('1', 'TAIR10', 'exon', 45646, 45954, NULL, '-', NULL, NULL, 'AT1G01080.2', 'AT1G01080.2', ''),
('1', 'TAIR10', 'CDS', 45646, 45954, NULL, '-', '0', NULL, 'AT1G01080.2', 'AT1G01080.2,AT1G01080.2-Protein', ''),
('1', 'TAIR10', 'exon', 45646, 45954, NULL, '-', NULL, NULL, 'AT1G01080.1', 'AT1G01080.1', ''),
('1', 'TAIR10', 'CDS', 45646, 45954, NULL, '-', '0', NULL, 'AT1G01080.1', 'AT1G01080.1,AT1G01080.1-Protein', ''),
('1', 'TAIR10', 'exon', 46044, 46145, NULL, '-', NULL, NULL, 'AT1G01080.2', 'AT1G01080.2', ''),
('1', 'TAIR10', 'CDS', 46044, 46145, NULL, '-', '0', NULL, 'AT1G01080.2', 'AT1G01080.2,AT1G01080.2-Protein', ''),
('1', 'TAIR10', 'exon', 46044, 46145, NULL, '-', NULL, NULL, 'AT1G01080.1', 'AT1G01080.1', ''),
('1', 'TAIR10', 'CDS', 46044, 46145, NULL, '-', '0', NULL, 'AT1G01080.1', 'AT1G01080.1,AT1G01080.1-Protein', ''),
('1', 'TAIR10', 'CDS', 46376, 46789, NULL, '-', '0', NULL, 'AT1G01080.1', 'AT1G01080.1,AT1G01080.1-Protein', ''),
('1', 'TAIR10', 'CDS', 46373, 46789, NULL, '-', '0', NULL, 'AT1G01080.2', 'AT1G01080.2,AT1G01080.2-Protein', ''),
('1', 'TAIR10', 'protein', 45503, 46789, NULL, '-', NULL, 'AT1G01080.2-Protein', 'AT1G01080.2', NULL, 'Derives_from=AT1G01080.2'),
('1', 'TAIR10', 'protein', 45503, 46789, NULL, '-', NULL, 'AT1G01080.1-Protein', 'AT1G01080.1', NULL, 'Derives_from=AT1G01080.1'),
('1', 'TAIR10', 'five_prime_UTR', 46790, 47019, NULL, '-', NULL, NULL, 'AT1G01080.2', 'AT1G01080.2', ''),
('1', 'TAIR10', 'five_prime_UTR', 46790, 47019, NULL, '-', NULL, NULL, 'AT1G01080.1', 'AT1G01080.1', ''),
('1', 'TAIR10', 'exon', 46376, 47019, NULL, '-', NULL, NULL, 'AT1G01080.1', 'AT1G01080.1', ''),
('1', 'TAIR10', 'exon', 46373, 47019, NULL, '-', NULL, NULL, 'AT1G01080.2', 'AT1G01080.2', ''),
('1', 'TAIR10', 'mRNA', 45296, 47019, NULL, '-', NULL, 'AT1G01080.2', 'AT1G01080.2', 'AT1G01080', 'Name=AT1G01080.2;Index=1'),
('1', 'TAIR10', 'mRNA', 45296, 47019, NULL, '-', NULL, 'AT1G01080.1', 'AT1G01080.1', 'AT1G01080', 'Name=AT1G01080.1;Index=1'),
('1', 'TAIR10', 'gene', 45296, 47019, NULL, '-', NULL, 'AT1G01080', 'AT1G01080', NULL, 'Note=protein_coding_gene;Name=AT1G01080'),
('1', 'TAIR10', 'three_prime_UTR', 47485, 47704, NULL, '-', NULL, NULL, 'AT1G01090.1', 'AT1G01090.1', ''),
('1', 'TAIR10', 'CDS', 47705, 47982, NULL, '-', '2', NULL, 'AT1G01090.1', 'AT1G01090.1,AT1G01090.1-Protein', ''),
('1', 'TAIR10', 'exon', 47485, 47982, NULL, '-', NULL, NULL, 'AT1G01090.1', 'AT1G01090.1', ''),
('1', 'TAIR10', 'exon', 48075, 48852, NULL, '-', NULL, NULL, 'AT1G01090.1', 'AT1G01090.1', ''),
('1', 'TAIR10', 'CDS', 48075, 48852, NULL, '-', '0', NULL, 'AT1G01090.1', 'AT1G01090.1,AT1G01090.1-Protein', ''),
('1', 'TAIR10', 'CDS', 48936, 49166, NULL, '-', '0', NULL, 'AT1G01090.1', 'AT1G01090.1,AT1G01090.1-Protein', ''),
('1', 'TAIR10', 'protein', 47705, 49166, NULL, '-', NULL, 'AT1G01090.1-Protein', 'AT1G01090.1', NULL, 'Derives_from=AT1G01090.1'),
('1', 'TAIR10', 'five_prime_UTR', 49167, 49286, NULL, '-', NULL, NULL, 'AT1G01090.1', 'AT1G01090.1', ''),
('1', 'TAIR10', 'exon', 48936, 49286, NULL, '-', NULL, NULL, 'AT1G01090.1', 'AT1G01090.1', ''),
('1', 'TAIR10', 'mRNA', 47485, 49286, NULL, '-', NULL, 'AT1G01090.1', 'AT1G01090.1', 'AT1G01090', 'Name=AT1G01090.1;Index=1'),
('1', 'TAIR10', 'gene', 47485, 49286, NULL, '-', NULL, 'AT1G01090', 'AT1G01090', NULL, 'Note=protein_coding_gene;Name=AT1G01090'),
('1', 'TAIR10', 'three_prime_UTR', 50090, 50283, NULL, '-', NULL, NULL, 'AT1G01100.4', 'AT1G01100.4', ''),
('1', 'TAIR10', 'three_prime_UTR', 50090, 50283, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'three_prime_UTR', 50090, 50283, NULL, '-', NULL, NULL, 'AT1G01100.1', 'AT1G01100.1', ''),
('1', 'TAIR10', 'three_prime_UTR', 50075, 50283, NULL, '-', NULL, NULL, 'AT1G01100.2', 'AT1G01100.2', ''),
('1', 'TAIR10', 'CDS', 50284, 50337, NULL, '-', '0', NULL, 'AT1G01100.4', 'AT1G01100.4,AT1G01100.4-Protein', ''),
('1', 'TAIR10', 'CDS', 50284, 50337, NULL, '-', '0', NULL, 'AT1G01100.3', 'AT1G01100.3,AT1G01100.3-Protein', ''),
('1', 'TAIR10', 'CDS', 50284, 50337, NULL, '-', '0', NULL, 'AT1G01100.2', 'AT1G01100.2,AT1G01100.2-Protein', ''),
('1', 'TAIR10', 'CDS', 50284, 50337, NULL, '-', '0', NULL, 'AT1G01100.1', 'AT1G01100.1,AT1G01100.1-Protein', ''),
('1', 'TAIR10', 'exon', 50090, 50337, NULL, '-', NULL, NULL, 'AT1G01100.4', 'AT1G01100.4', ''),
('1', 'TAIR10', 'exon', 50090, 50337, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'exon', 50090, 50337, NULL, '-', NULL, NULL, 'AT1G01100.1', 'AT1G01100.1', ''),
('1', 'TAIR10', 'exon', 50075, 50337, NULL, '-', NULL, NULL, 'AT1G01100.2', 'AT1G01100.2', ''),
('1', 'TAIR10', 'exon', 50419, 50447, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'CDS', 50419, 50447, NULL, '-', '2', NULL, 'AT1G01100.3', 'AT1G01100.3,AT1G01100.3-Protein', ''),
('1', 'TAIR10', 'exon', 50496, 50631, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'CDS', 50496, 50631, NULL, '-', '0', NULL, 'AT1G01100.3', 'AT1G01100.3,AT1G01100.3-Protein', ''),
('1', 'TAIR10', 'exon', 50419, 50631, NULL, '-', NULL, NULL, 'AT1G01100.4', 'AT1G01100.4', ''),
('1', 'TAIR10', 'CDS', 50419, 50631, NULL, '-', '0', NULL, 'AT1G01100.4', 'AT1G01100.4,AT1G01100.4-Protein', ''),
('1', 'TAIR10', 'exon', 50419, 50631, NULL, '-', NULL, NULL, 'AT1G01100.2', 'AT1G01100.2', ''),
('1', 'TAIR10', 'CDS', 50419, 50631, NULL, '-', '0', NULL, 'AT1G01100.2', 'AT1G01100.2,AT1G01100.2-Protein', ''),
('1', 'TAIR10', 'exon', 50419, 50631, NULL, '-', NULL, NULL, 'AT1G01100.1', 'AT1G01100.1', ''),
('1', 'TAIR10', 'CDS', 50419, 50631, NULL, '-', '0', NULL, 'AT1G01100.1', 'AT1G01100.1,AT1G01100.1-Protein', ''),
('1', 'TAIR10', 'CDS', 50883, 50954, NULL, '-', '0', NULL, 'AT1G01100.4', 'AT1G01100.4,AT1G01100.4-Protein', ''),
('1', 'TAIR10', 'CDS', 50883, 50954, NULL, '-', '0', NULL, 'AT1G01100.3', 'AT1G01100.3,AT1G01100.3-Protein', ''),
('1', 'TAIR10', 'CDS', 50883, 50954, NULL, '-', '0', NULL, 'AT1G01100.2', 'AT1G01100.2,AT1G01100.2-Protein', ''),
('1', 'TAIR10', 'CDS', 50883, 50954, NULL, '-', '0', NULL, 'AT1G01100.1', 'AT1G01100.1,AT1G01100.1-Protein', ''),
('1', 'TAIR10', 'protein', 50284, 50954, NULL, '-', NULL, 'AT1G01100.4-Protein', 'AT1G01100.4', NULL, 'Derives_from=AT1G01100.4'),
('1', 'TAIR10', 'protein', 50284, 50954, NULL, '-', NULL, 'AT1G01100.3-Protein', 'AT1G01100.3', NULL, 'Derives_from=AT1G01100.3'),
('1', 'TAIR10', 'protein', 50284, 50954, NULL, '-', NULL, 'AT1G01100.2-Protein', 'AT1G01100.2', NULL, 'Derives_from=AT1G01100.2'),
('1', 'TAIR10', 'protein', 50284, 50954, NULL, '-', NULL, 'AT1G01100.1-Protein', 'AT1G01100.1', NULL, 'Derives_from=AT1G01100.1'),
('1', 'TAIR10', 'five_prime_UTR', 50955, 50963, NULL, '-', NULL, NULL, 'AT1G01100.4', 'AT1G01100.4', ''),
('1', 'TAIR10', 'five_prime_UTR', 50955, 50963, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'five_prime_UTR', 50955, 50963, NULL, '-', NULL, NULL, 'AT1G01100.2', 'AT1G01100.2', ''),
('1', 'TAIR10', 'five_prime_UTR', 50955, 50963, NULL, '-', NULL, NULL, 'AT1G01100.1', 'AT1G01100.1', ''),
('1', 'TAIR10', 'exon', 50883, 50963, NULL, '-', NULL, NULL, 'AT1G01100.4', 'AT1G01100.4', ''),
('1', 'TAIR10', 'exon', 50883, 50963, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'exon', 50883, 50963, NULL, '-', NULL, NULL, 'AT1G01100.2', 'AT1G01100.2', ''),
('1', 'TAIR10', 'exon', 50883, 50963, NULL, '-', NULL, NULL, 'AT1G01100.1', 'AT1G01100.1', ''),
('1', 'TAIR10', 'exon', 51064, 51108, NULL, '-', NULL, NULL, 'AT1G01100.1', 'AT1G01100.1', ''),
('1', 'TAIR10', 'five_prime_UTR', 51064, 51108, NULL, '-', NULL, NULL, 'AT1G01100.1', 'AT1G01100.1', ''),
('1', 'TAIR10', 'mRNA', 50090, 51108, NULL, '-', NULL, 'AT1G01100.1', 'AT1G01100.1', 'AT1G01100', 'Name=AT1G01100.1;Index=1'),
('1', 'TAIR10', 'exon', 51123, 51187, NULL, '-', NULL, NULL, 'AT1G01100.4', 'AT1G01100.4', ''),
('1', 'TAIR10', 'five_prime_UTR', 51123, 51187, NULL, '-', NULL, NULL, 'AT1G01100.4', 'AT1G01100.4', ''),
('1', 'TAIR10', 'mRNA', 50090, 51187, NULL, '-', NULL, 'AT1G01100.4', 'AT1G01100.4', 'AT1G01100', 'Name=AT1G01100.4;Index=1'),
('1', 'TAIR10', 'exon', 51126, 51197, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'five_prime_UTR', 51126, 51197, NULL, '-', NULL, NULL, 'AT1G01100.3', 'AT1G01100.3', ''),
('1', 'TAIR10', 'mRNA', 50090, 51197, NULL, '-', NULL, 'AT1G01100.3', 'AT1G01100.3', 'AT1G01100', 'Name=AT1G01100.3;Index=1'),
('1', 'TAIR10', 'exon', 51126, 51199, NULL, '-', NULL, NULL, 'AT1G01100.2', 'AT1G01100.2', ''),
('1', 'TAIR10', 'five_prime_UTR', 51126, 51199, NULL, '-', NULL, NULL, 'AT1G01100.2', 'AT1G01100.2', ''),
('1', 'TAIR10', 'mRNA', 50075, 51199, NULL, '-', NULL, 'AT1G01100.2', 'AT1G01100.2', 'AT1G01100', 'Name=AT1G01100.2;Index=1'),
('1', 'TAIR10', 'gene', 50075, 51199, NULL, '-', NULL, 'AT1G01100', 'AT1G01100', NULL, 'Note=protein_coding_gene;Name=AT1G01100'),
('1', 'TAIR10', 'CDS', 52239, 52346, NULL, '+', '0', NULL, 'AT1G01110.2', 'AT1G01110.2,AT1G01110.2-Protein', ''),
('1', 'TAIR10', 'exon', 52239, 52346, NULL, '+', NULL, NULL, 'AT1G01110.2', 'AT1G01110.2', ''),
('1', 'TAIR10', 'CDS', 52434, 52730, NULL, '+', '0', NULL, 'AT1G01110.2', 'AT1G01110.2,AT1G01110.2-Protein', ''),
('1', 'TAIR10', 'exon', 52434, 52730, NULL, '+', NULL, NULL, 'AT1G01110.2', 'AT1G01110.2', ''),
('1', 'TAIR10', 'five_prime_UTR', 52869, 53021, NULL, '+', NULL, NULL, 'AT1G01110.1', 'AT1G01110.1', ''),
('1', 'TAIR10', 'CDS', 53022, 53183, NULL, '+', '0', NULL, 'AT1G01110.1', 'AT1G01110.1,AT1G01110.1-Protein', ''),
('1', 'TAIR10', 'CDS', 52938, 53183, NULL, '+', '0', NULL, 'AT1G01110.2', 'AT1G01110.2,AT1G01110.2-Protein', ''),
('1', 'TAIR10', 'exon', 52938, 53183, NULL, '+', NULL, NULL, 'AT1G01110.2', 'AT1G01110.2', ''),
('1', 'TAIR10', 'exon', 52869, 53183, NULL, '+', NULL, NULL, 'AT1G01110.1', 'AT1G01110.1', ''),
('1', 'TAIR10', 'CDS', 53484, 53624, NULL, '+', '0', NULL, 'AT1G01110.2', 'AT1G01110.2,AT1G01110.2-Protein', ''),
('1', 'TAIR10', 'exon', 53484, 53624, NULL, '+', NULL, NULL, 'AT1G01110.2', 'AT1G01110.2', ''),
('1', 'TAIR10', 'CDS', 53484, 53624, NULL, '+', '0', NULL, 'AT1G01110.1', 'AT1G01110.1,AT1G01110.1-Protein', ''),
('1', 'TAIR10', 'exon', 53484, 53624, NULL, '+', NULL, NULL, 'AT1G01110.1', 'AT1G01110.1', ''),
('1', 'TAIR10', 'CDS', 53703, 54494, NULL, '+', '0', NULL, 'AT1G01110.2', 'AT1G01110.2,AT1G01110.2-Protein', ''),
('1', 'TAIR10', 'CDS', 53703, 54494, NULL, '+', '0', NULL, 'AT1G01110.1', 'AT1G01110.1,AT1G01110.1-Protein', ''),
('1', 'TAIR10', 'protein', 53022, 54494, NULL, '+', NULL, 'AT1G01110.1-Protein', 'AT1G01110.1', NULL, 'Derives_from=AT1G01110.1'),
('1', 'TAIR10', 'protein', 52239, 54494, NULL, '+', NULL, 'AT1G01110.2-Protein', 'AT1G01110.2', NULL, 'Derives_from=AT1G01110.2'),
('1', 'TAIR10', 'three_prime_UTR', 54495, 54685, NULL, '+', NULL, NULL, 'AT1G01110.1', 'AT1G01110.1', ''),
('1', 'TAIR10', 'exon', 53703, 54685, NULL, '+', NULL, NULL, 'AT1G01110.1', 'AT1G01110.1', ''),
('1', 'TAIR10', 'mRNA', 52869, 54685, NULL, '+', NULL, 'AT1G01110.1', 'AT1G01110.1', 'AT1G01110', 'Name=AT1G01110.1;Index=1'),
('1', 'TAIR10', 'three_prime_UTR', 54495, 54692, NULL, '+', NULL, NULL, 'AT1G01110.2', 'AT1G01110.2', ''),
('1', 'TAIR10', 'exon', 53703, 54692, NULL, '+', NULL, NULL, 'AT1G01110.2', 'AT1G01110.2', ''),
('1', 'TAIR10', 'mRNA', 52239, 54692, NULL, '+', NULL, 'AT1G01110.2', 'AT1G01110.2', 'AT1G01110', 'Name=AT1G01110.2;Index=1'),
('1', 'TAIR10', 'gene', 52239, 54692, NULL, '+', NULL, 'AT1G01110', 'AT1G01110', NULL, 'Note=protein_coding_gene;Name=AT1G01110'),
('1', 'TAIR10', 'CDS', 56624, 56740, NULL, '+', '0', NULL, 'AT1G01115.1', 'AT1G01115.1,AT1G01115.1-Protein', ''),
('1', 'TAIR10', 'exon', 56624, 56740, NULL, '+', NULL, NULL, 'AT1G01115.1', 'AT1G01115.1', ''),
('1', 'TAIR10', 'protein', 56624, 56740, NULL, '+', NULL, 'AT1G01115.1-Protein', 'AT1G01115.1', NULL, 'Derives_from=AT1G01115.1'),
('1', 'TAIR10', 'mRNA', 56624, 56740, NULL, '+', NULL, 'AT1G01115.1', 'AT1G01115.1', 'AT1G01115', 'Name=AT1G01115.1;Index=1'),
('1', 'TAIR10', 'gene', 56624, 56740, NULL, '+', NULL, 'AT1G01115', 'AT1G01115', NULL, 'Note=protein_coding_gene;Name=AT1G01115'),
('1', 'TAIR10', 'three_prime_UTR', 57269, 57391, NULL, '-', NULL, NULL, 'AT1G01120.1', 'AT1G01120.1', ''),
('1', 'TAIR10', 'CDS', 57392, 58978, NULL, '-', '0', NULL, 'AT1G01120.1', 'AT1G01120.1,AT1G01120.1-Protein', ''),
('1', 'TAIR10', 'protein', 57392, 58978, NULL, '-', NULL, 'AT1G01120.1-Protein', 'AT1G01120.1', NULL, 'Derives_from=AT1G01120.1'),
('1', 'TAIR10', 'five_prime_UTR', 58979, 59167, NULL, '-', NULL, NULL, 'AT1G01120.1', 'AT1G01120.1', ''),
('1', 'TAIR10', 'exon', 57269, 59167, NULL, '-', NULL, NULL, 'AT1G01120.1', 'AT1G01120.1', ''),
('1', 'TAIR10', 'mRNA', 57269, 59167, NULL, '-', NULL, 'AT1G01120.1', 'AT1G01120.1', 'AT1G01120', 'Name=AT1G01120.1;Index=1'),
('1', 'TAIR10', 'gene', 57269, 59167, NULL, '-', NULL, 'AT1G01120', 'AT1G01120', NULL, 'Note=protein_coding_gene;Name=AT1G01120'),
('1', 'TAIR10', 'exon', 61905, 61949, NULL, '-', NULL, NULL, 'AT1G01130.1', 'AT1G01130.1', ''),
('1', 'TAIR10', 'CDS', 61905, 61949, NULL, '-', '0', NULL, 'AT1G01130.1', 'AT1G01130.1,AT1G01130.1-Protein', ''),
('1', 'TAIR10', 'exon', 62050, 62124, NULL, '-', NULL, NULL, 'AT1G01130.1', 'AT1G01130.1', ''),
('1', 'TAIR10', 'CDS', 62050, 62124, NULL, '-', '0', NULL, 'AT1G01130.1', 'AT1G01130.1,AT1G01130.1-Protein', ''),
('1', 'TAIR10', 'exon', 63557, 63811, NULL, '-', NULL, NULL, 'AT1G01130.1', 'AT1G01130.1', ''),
('1', 'TAIR10', 'CDS', 63557, 63811, NULL, '-', '0', NULL, 'AT1G01130.1', 'AT1G01130.1,AT1G01130.1-Protein', ''),
('1', 'TAIR10', 'protein', 61905, 63811, NULL, '-', NULL, 'AT1G01130.1-Protein', 'AT1G01130.1', NULL, 'Derives_from=AT1G01130.1'),
('1', 'TAIR10', 'mRNA', 61905, 63811, NULL, '-', NULL, 'AT1G01130.1', 'AT1G01130.1', 'AT1G01130', 'Name=AT1G01130.1;Index=1'),
('1', 'TAIR10', 'gene', 61905, 63811, NULL, '-', NULL, 'AT1G01130', 'AT1G01130', NULL, 'Note=protein_coding_gene;Name=AT1G01130'),
('1', 'TAIR10', 'three_prime_UTR', 64167, 64397, NULL, '-', NULL, NULL, 'AT1G01140.3', 'AT1G01140.3', ''),
('1', 'TAIR10', 'three_prime_UTR', 64167, 64397, NULL, '-', NULL, NULL, 'AT1G01140.2', 'AT1G01140.2', ''),
('1', 'TAIR10', 'three_prime_UTR', 64166, 64397, NULL, '-', NULL, NULL, 'AT1G01140.1', 'AT1G01140.1', ''),
('1', 'TAIR10', 'CDS', 64398, 64475, NULL, '-', '0', NULL, 'AT1G01140.3', 'AT1G01140.3,AT1G01140.3-Protein', ''),
('1', 'TAIR10', 'CDS', 64398, 64475, NULL, '-', '0', NULL, 'AT1G01140.2', 'AT1G01140.2,AT1G01140.2-Protein', '');
INSERT INTO `tair10_gff3` (`SeqID`, `Source`, `Type`, `Start`, `End`, `Score`, `Strand`, `Phase`, `Id`, `geneId`, `Parent`, `Attributes`) VALUES
('1', 'TAIR10', 'CDS', 64398, 64475, NULL, '-', '0', NULL, 'AT1G01140.1', 'AT1G01140.1,AT1G01140.1-Protein', ''),
('1', 'TAIR10', 'exon', 64167, 64475, NULL, '-', NULL, NULL, 'AT1G01140.3', 'AT1G01140.3', ''),
('1', 'TAIR10', 'exon', 64167, 64475, NULL, '-', NULL, NULL, 'AT1G01140.2', 'AT1G01140.2', ''),
('1', 'TAIR10', 'exon', 64166, 64475, NULL, '-', NULL, NULL, 'AT1G01140.1', 'AT1G01140.1', ''),
('1', 'TAIR10', 'exon', 64582, 64656, NULL, '-', NULL, NULL, 'AT1G01140.2', 'AT1G01140.2', ''),
('1', 'TAIR10', 'CDS', 64582, 64656, NULL, '-', '0', NULL, 'AT1G01140.2', 'AT1G01140.2,AT1G01140.2-Protein', ''),
('1', 'TAIR10', 'exon', 64582, 64656, NULL, '-', NULL, NULL, 'AT1G01140.1', 'AT1G01140.1', ''),
('1', 'TAIR10', 'CDS', 64582, 64656, NULL, '-', '0', NULL, 'AT1G01140.1', 'AT1G01140.1,AT1G01140.1-Protein', ''),
('1', 'TAIR10', 'exon', 64570, 64656, NULL, '-', NULL, NULL, 'AT1G01140.3', 'AT1G01140.3', ''),
('1', 'TAIR10', 'CDS', 64570, 64656, NULL, '-', '0', NULL, 'AT1G01140.3', 'AT1G01140.3,AT1G01140.3-Protein', ''),
('1', 'TAIR10', 'exon', 64751, 64807, NULL, '-', NULL, NULL, 'AT1G01140.3', 'AT1G01140.3', ''),
('1', 'TAIR10', 'CDS', 64751, 64807, NULL, '-', '0', NULL, 'AT1G01140.3', 'AT1G01140.3,AT1G01140.3-Protein', ''),
('1', 'TAIR10', 'exon', 64751, 64807, NULL, '-', NULL, NULL, 'AT1G01140.2', 'AT1G01140.2', ''),
('1', 'TAIR10', 'CDS', 64751, 64807, NULL, '-', '0', NULL, 'AT1G01140.2', 'AT1G01140.2,AT1G01140.2-Protein', ''),
('1', 'TAIR10', 'exon', 64751, 64807, NULL, '-', NULL, NULL, 'AT1G01140.1', 'AT1G01140.1', ''),
('1', 'TAIR10', 'CDS', 64751, 64807, NULL, '-', '0', NULL, 'AT1G01140.1', 'AT1G01140.1,AT1G01140.1-Protein', ''),
('1', 'TAIR10', 'exon', 64901, 65017, NULL, '-', NULL, NULL, 'AT1G01140.3', 'AT1G01140.3', ''),
('1', 'TAIR10', 'CDS', 64901, 65017, NULL, '-', '0', NULL, 'AT1G01140.3', 'AT1G01140.3,AT1G01140.3-Protein', ''),
('1', 'TAIR10', 'exon', 64901, 65017, NULL, '-', NULL, NULL, 'AT1G01140.2', 'AT1G01140.2', ''),
('1', 'TAIR10', 'CDS', 64901, 65017, NULL, '-', '0', NULL, 'AT1G01140.2', 'AT1G01140.2,AT1G01140.2-Protein', ''),
('1', 'TAIR10', 'exon', 64901, 65017, NULL, '-', NULL, NULL, 'AT1G01140.1', 'AT1G01140.1', ''),
('1', 'TAIR10', 'CDS', 64901, 65017, NULL, '-', '0', NULL, 'AT1G01140.1', 'AT1G01140.1,AT1G01140.1-Protein', ''),
('1', 'TAIR10', 'exon', 65110, 65217, NULL, '-', NULL, NULL, 'AT1G01140.3', 'AT1G01140.3', ''),
('1', 'TAIR10', 'CDS', 65110, 65217, NULL, '-', '0', NULL, 'AT1G01140.3', 'AT1G01140.3,AT1G01140.3-Protein', ''),
('1', 'TAIR10', 'exon', 65110, 65217, NULL, '-', NULL, NULL, 'AT1G01140.2', 'AT1G01140.2', ''),
('1', 'TAIR10', 'CDS', 65110, 65217, NULL, '-', '0', NULL, 'AT1G01140.2', 'AT1G01140.2,AT1G01140.2-Protein', ''),
('1', 'TAIR10', 'exon', 65110, 65217, NULL, '-', NULL, NULL, 'AT1G01140.1', 'AT1G01140.1', ''),
('1', 'TAIR10', 'CDS', 65110, 65217, NULL, '-', '0', NULL, 'AT1G01140.1', 'AT1G01140.1,AT1G01140.1-Protein', ''),
('1', 'TAIR10', 'exon', 65331, 65456, NULL, '-', NULL, NULL, 'AT1G01140.3', 'AT1G01140.3', ''),
('1', 'TAIR10', 'CDS', 65331, 65456, NULL, '-', '0', NULL, 'AT1G01140.3', 'AT1G01140.3,AT1G01140.3-Protein', ''),
('1', 'TAIR10', 'exon', 65331, 65456, NULL, '-', NULL, NULL, 'AT1G01140.2', 'AT1G01140.2', '');
/*!40000 ALTER TABLE `tair10_gff3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agi_alias`
--

CREATE TABLE `agi_alias` (
  `agi` varchar(30) NOT NULL,
  `alias` varchar(30) NOT NULL,
  PRIMARY KEY (`agi`, `alias`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agi_alias`
--

LOCK TABLES `agi_alias` WRITE;
/*!40000 ALTER TABLE `agi_alias` DISABLE KEYS */;
INSERT INTO `agi_alias` VALUES
('AT1G01010', 'ANAC001'),
('AT1G01010', 'NAC001'),
('AT1G01010', 'NTL10'),
('AT1G01020', 'ARV1'),
('AT1G01030', 'NGA3'),
('AT1G01040', 'ASU1'),
('AT1G01040', 'ATDCL1'),
('AT1G01040', 'CAF'),
('AT1G01040', 'DCL1'),
('AT1G01040', 'EMB60'),
('AT1G01040', 'EMB76'),
('AT1G01040', 'SIN1'),
('AT1G01040', 'SUS1'),
('AT1G01046', 'MIR838A'),
('AT1G01050', 'AtPPa1'),
('AT1G01050', 'PPa1'),
('AT1G01060', 'LHY'),
('AT1G01060', 'LHY1'),
('AT1G01070', 'UMAMIT28'),
('AT1G01080', 'CP28B'),
('AT1G01090', 'PDH-E1 ALPHA'),
('AT1G01100', 'RPP1.1'),
('AT1G01100', 'RPP1A'),
('AT1G01110', 'IQD18'),
('AT1G01120', 'KCS1'),
('AT1G01140', 'CIPK9'),
('AT1G01140', 'PKS6'),
('AT1G01140', 'SnRK3.12'),
('AT1G01160', 'GIF2'),
('AT1G01183', 'MIR165'),
('AT1G01183', 'MIR165A'),
('AT1G01184', 'miPEP165a'),
('AT1G01190', 'CYP78A8'),
('AT1G01200', 'ATRAB-A3'),
('AT1G01200', 'ATRABA3'),
('AT1G01200', 'RABA3'),
('AT1G01220', 'AtFKGP'),
('AT1G01220', 'FKGP'),
('AT1G01230', 'AtORM1'),
('AT1G01230', 'ORM1'),
('AT1G01260', 'bHLH013'),
('AT1G01260', 'bHLH13'),
('AT1G01260', 'JAM2'),
('AT1G01280', 'CYP703'),
('AT1G01280', 'CYP703A2'),
('AT1G01290', 'CNX3'),
('AT1G01320', 'FLL2'),
('AT1G01320', 'REC1'),
('AT1G01335', 'AREP1'),
('AT1G01340', 'ACBK1'),
('AT1G01340', 'ATCNGC10');
/*!40000 ALTER TABLE `agi_alias` ENABLE KEYS */;
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
