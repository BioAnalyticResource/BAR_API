-- MySQL dump 10.13  Distrib 8.4.4, for Linux (x86_64)
--
-- Host: localhost    Database: canola_nssnp
-- ------------------------------------------------------
-- Server version	8.4.4

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
-- Current Database: `canola_nssnp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `canola_nssnp` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `canola_nssnp`;

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
  PRIMARY KEY (`protein_reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63266 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protein_reference`
--

LOCK TABLES `protein_reference` WRITE;
/*!40000 ALTER TABLE `protein_reference` DISABLE KEYS */;
INSERT INTO `protein_reference` VALUES (1,'BnaC09g12820D','GSBRNA2T00000001001'),(2,'BnaC09g12810D','GSBRNA2T00000003001'),(3,'BnaC09g12800D','GSBRNA2T00000005001'),(4,'BnaC09g12790D','GSBRNA2T00000007001'),(5,'BnaC09g12780D','GSBRNA2T00000008001'),(6,'BnaC09g12770D','GSBRNA2T00000009001'),(7,'BnaC09g12760D','GSBRNA2T00000011001'),(8,'BnaC09g12750D','GSBRNA2T00000012001'),(9,'BnaC09g12740D','GSBRNA2T00000015001'),(10,'BnaC09g12730D','GSBRNA2T00000016001'),(63265,'BnaA07g31480D','GSBRNA2T00102721001');
/*!40000 ALTER TABLE `protein_reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snps_to_protein`
--

DROP TABLE IF EXISTS `snps_to_protein`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `snps_to_protein` (
  `snps_reference_id` int NOT NULL AUTO_INCREMENT,
  `protein_reference_id` int NOT NULL,
  `transcript_pos` int NOT NULL,
  `chromosome` varchar(25) NOT NULL,
  `chromosomal_loci` int NOT NULL,
  `ref_DNA` varchar(1) NOT NULL,
  `alt_DNA` varchar(45) NOT NULL,
  `aa_pos` int NOT NULL,
  `ref_aa` varchar(3) NOT NULL,
  `alt_aa` varchar(3) NOT NULL,
  `type` varchar(50) NOT NULL,
  `effect_impact` varchar(50) NOT NULL,
  `transcript_biotype` varchar(45) DEFAULT NULL,
  `alt_freq` decimal(10,5) NOT NULL,
  PRIMARY KEY (`snps_reference_id`,`protein_reference_id`),
  KEY `protein_fk_idx` (`protein_reference_id`),
  CONSTRAINT `protein_fk` FOREIGN KEY (`protein_reference_id`) REFERENCES `protein_reference` (`protein_reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=327048 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snps_to_protein`
--

LOCK TABLES `snps_to_protein` WRITE;
/*!40000 ALTER TABLE `snps_to_protein` DISABLE KEYS */;
INSERT INTO `snps_to_protein` VALUES (142004,63265,52,'chrA07',21985117,'A','C',18,'Met','Leu','missense_variant','MODERATE','protein_coding',0.00990),(142005,63265,130,'chrA07',21985679,'G','T',44,'Gly','Cys','missense_variant','MODERATE','protein_coding',0.04930),(142006,63265,163,'chrA07',21985712,'C','G',55,'Leu','Val','missense_variant','MODERATE','protein_coding',0.09210),(142007,63265,268,'chrA07',21985817,'G','A',90,'Asp','Asn','missense_variant','MODERATE','protein_coding',0.00660),(142008,63265,284,'chrA07',21985833,'G','C',95,'Arg','Thr','missense_variant','MODERATE','protein_coding',0.01070),(142009,63265,433,'chrA07',21985982,'C','T',145,'Pro','Ser','missense_variant','MODERATE','protein_coding',0.05260),(142010,63265,442,'chrA07',21985991,'G','A',148,'Glu','Lys','missense_variant','MODERATE','protein_coding',0.05260),(142011,63265,445,'chrA07',21985994,'A','G',149,'Thr','Ala','missense_variant','MODERATE','protein_coding',0.05260),(142012,63265,486,'chrA07',21986035,'C','G',162,'His','Gln','missense_variant','MODERATE','protein_coding',0.08310),(142013,63265,500,'chrA07',21986049,'T','G',167,'Ile','Ser','missense_variant','MODERATE','protein_coding',0.08140),(142014,63265,526,'chrA07',21986075,'G','A',176,'Gly','Ser','missense_variant','MODERATE','protein_coding',0.08390),(142015,63265,541,'chrA07',21986090,'T','C',181,'Trp','Arg','missense_variant','MODERATE','protein_coding',0.01070),(142016,63265,634,'chrA07',21986183,'C','A',212,'Leu','Ile','missense_variant','MODERATE','protein_coding',0.08630),(142017,63265,640,'chrA07',21986189,'C','T',214,'Arg','Trp','missense_variant','MODERATE','protein_coding',0.08630),(142018,63265,694,'chrA07',21986243,'G','T',232,'Asp','Tyr','missense_variant','MODERATE','protein_coding',0.01070),(142019,63265,769,'chrA07',21986318,'T','C',257,'Tyr','His','missense_variant','MODERATE','protein_coding',0.05180),(142020,63265,848,'chrA07',21986397,'G','A',283,'Ser','Asn','missense_variant','MODERATE','protein_coding',0.05100),(142021,63265,859,'chrA07',21986408,'T','C',287,'Ser','Pro','missense_variant','MODERATE','protein_coding',0.05920),(142022,63265,889,'chrA07',21986438,'A','G',297,'Lys','Glu','missense_variant','MODERATE','protein_coding',0.06330),(142023,63265,979,'chrA07',21986528,'C','G',327,'His','Asp','missense_variant','MODERATE','protein_coding',0.01150),(142024,63265,995,'chrA07',21986544,'C','T',332,'Thr','Ile','missense_variant','MODERATE','protein_coding',0.01150),(142025,63265,1039,'chrA07',21986588,'C','T',347,'Leu','Phe','missense_variant','MODERATE','protein_coding',0.07070),(142026,63265,1042,'chrA07',21986591,'T','C',348,'Trp','Arg','missense_variant','MODERATE','protein_coding',0.01150),(142027,63265,1060,'chrA07',21986609,'A','G',354,'Asn','Asp','missense_variant','MODERATE','protein_coding',0.01150),(142028,63265,1075,'chrA07',21986624,'T','C',359,'Tyr','His','missense_variant','MODERATE','protein_coding',0.01150),(142029,63265,1267,'chrA07',21986816,'C','G',423,'Arg','Gly','missense_variant','MODERATE','protein_coding',0.07240),(142030,63265,1336,'chrA07',21986885,'C','G',446,'Arg','Gly','missense_variant','MODERATE','protein_coding',0.00330),(142031,63265,1363,'chrA07',21986912,'G','A',455,'Ala','Thr','missense_variant','MODERATE','protein_coding',0.32150),(142032,63265,1420,'chrA07',21986969,'T','A',474,'Ser','Thr','missense_variant','MODERATE','protein_coding',0.01810),(142033,63265,1462,'chrA07',21987011,'C','G',488,'Arg','Gly','missense_variant','MODERATE','protein_coding',0.04610),(142034,63265,1595,'chrA07',21987144,'A','C',532,'Glu','Ala','missense_variant','MODERATE','protein_coding',0.04440),(142035,63265,1735,'chrA07',21987284,'C','G',579,'His','Asp','missense_variant','MODERATE','protein_coding',0.29930),(142036,63265,1744,'chrA07',21987293,'T','C',582,'Tyr','His','missense_variant','MODERATE','protein_coding',0.02380),(142037,63265,1865,'chrA07',21987414,'C','T',622,'Ser','Phe','missense_variant','MODERATE','protein_coding',0.27380),(142038,63265,2077,'chrA07',21987626,'C','G',693,'His','Asp','missense_variant','MODERATE','protein_coding',0.00160),(142039,63265,2086,'chrA07',21987635,'C','A',696,'His','Asn','missense_variant','MODERATE','protein_coding',0.00160),(142040,63265,2089,'chrA07',21987638,'A','G',697,'Arg','Gly','missense_variant','MODERATE','protein_coding',0.00160),(142041,63265,2215,'chrA07',21987764,'A','T',739,'Arg','Trp','missense_variant','MODERATE','protein_coding',0.00160),(142042,63265,2227,'chrA07',21987776,'G','C',743,'Gly','Arg','missense_variant','MODERATE','protein_coding',0.00160),(142043,63265,2233,'chrA07',21987782,'T','C',745,'Tyr','His','missense_variant','MODERATE','protein_coding',0.00160),(142044,63265,2254,'chrA07',21987803,'C','T',752,'Leu','Phe','missense_variant','MODERATE','protein_coding',0.00160),(142045,63265,2323,'chrA07',21987872,'T','C',775,'Phe','Leu','missense_variant','MODERATE','protein_coding',0.28040),(142046,63265,2350,'chrA07',21987899,'G','A',784,'Gly','Arg','missense_variant','MODERATE','protein_coding',0.00160),(142047,63265,2395,'chrA07',21987944,'C','G',799,'Leu','Val','missense_variant','MODERATE','protein_coding',0.00330),(142048,63265,2425,'chrA07',21987974,'G','C',809,'Val','Leu','missense_variant','MODERATE','protein_coding',0.27300),(142049,63265,2434,'chrA07',21987983,'A','G',812,'Ile','Val','missense_variant','MODERATE','protein_coding',0.27300),(142050,63265,2446,'chrA07',21987995,'A','G',816,'Ile','Val','missense_variant','MODERATE','protein_coding',0.27380),(142051,63265,2464,'chrA07',21988013,'A','C',822,'Ser','Arg','missense_variant','MODERATE','protein_coding',0.27140),(142052,63265,2518,'chrA07',21988067,'C','G',840,'Arg','Gly','missense_variant','MODERATE','protein_coding',0.01150),(142053,63265,2521,'chrA07',21988070,'T','G',841,'Leu','Val','missense_variant','MODERATE','protein_coding',0.24180),(142054,63265,2545,'chrA07',21988094,'G','A',849,'Glu','Lys','missense_variant','MODERATE','protein_coding',0.31830),(142055,63265,2596,'chrA07',21988145,'A','G',866,'Arg','Gly','missense_variant','MODERATE','protein_coding',0.26320),(142056,63265,2632,'chrA07',21988181,'T','C',878,'Cys','Arg','missense_variant','MODERATE','protein_coding',0.26730),(142057,63265,2737,'chrA07',21988286,'G','A',913,'Gly','Arg','missense_variant','MODERATE','protein_coding',0.26640),(142058,63265,2770,'chrA07',21988319,'G','A',924,'Val','Met','missense_variant','MODERATE','protein_coding',0.27220),(142059,63265,2800,'chrA07',21988349,'C','T',934,'Arg','Cys','missense_variant','MODERATE','protein_coding',0.05260),(142060,63265,2848,'chrA07',21988397,'T','C',950,'Cys','Arg','missense_variant','MODERATE','protein_coding',0.27380),(142061,63265,2878,'chrA07',21988427,'T','C',960,'Ser','Pro','missense_variant','MODERATE','protein_coding',0.27300),(142062,63265,2881,'chrA07',21988430,'C','T',961,'Leu','Phe','missense_variant','MODERATE','protein_coding',0.02800),(142063,63265,2890,'chrA07',21988439,'G','A',964,'Ala','Thr','missense_variant','MODERATE','protein_coding',0.02800),(142064,63265,2908,'chrA07',21988457,'G','C',970,'Asp','His','missense_variant','MODERATE','protein_coding',0.01320),(142065,63265,2941,'chrA07',21988490,'A','T',981,'Arg','Trp','missense_variant','MODERATE','protein_coding',0.31170),(142066,63265,2968,'chrA07',21988517,'C','T',990,'Arg','Cys','missense_variant','MODERATE','protein_coding',0.02880),(142067,63265,3163,'chrA07',21988712,'G','A',1055,'Ala','Thr','missense_variant','MODERATE','protein_coding',0.27470),(142068,63265,3188,'chrA07',21988737,'C','G',1063,'Ala','Gly','missense_variant','MODERATE','protein_coding',0.27550),(142069,63265,3199,'chrA07',21988748,'A','T',1067,'Ser','Cys','missense_variant','MODERATE','protein_coding',0.32070),(142070,63265,3283,'chrA07',21988832,'G','T',1095,'Val','Phe','missense_variant','MODERATE','protein_coding',0.04360),(142071,63265,3289,'chrA07',21988838,'G','T',1097,'Asp','Tyr','missense_variant','MODERATE','protein_coding',0.04360),(327014,10,191,'chrC09',9191243,'G','A',64,'Ser','Phe','missense_variant','MODERATE','protein_coding',0.44000),(327015,10,188,'chrC09',9191246,'G','T',63,'Pro','Gln','missense_variant','MODERATE','protein_coding',0.00000),(327016,10,164,'chrC09',9191270,'C','T',55,'Arg','Lys','missense_variant','MODERATE','protein_coding',0.44160),(327017,10,43,'chrC09',9191391,'C','T',15,'Gly','Arg','missense_variant','MODERATE','protein_coding',0.43260),(327018,9,169,'chrC09',9195157,'T','C',57,'Phe','Leu','missense_variant','MODERATE','protein_coding',0.00130),(327019,9,457,'chrC09',9195518,'A','G',153,'Thr','Ala','missense_variant','MODERATE','protein_coding',0.00160),(327020,8,67,'chrC09',9230756,'C','T',23,'Arg','Cys','missense_variant','MODERATE','protein_coding',0.00350),(327021,8,81,'chrC09',9230770,'G','C',27,'Glu','Asp','missense_variant','MODERATE','protein_coding',0.43170),(327022,7,2450,'chrC09',9234630,'G','T',817,'Ala','Asp','missense_variant','MODERATE','protein_coding',0.00010),(327023,7,1718,'chrC09',9237814,'A','C',573,'Ile','Ser','missense_variant','MODERATE','protein_coding',0.00900),(327024,7,1408,'chrC09',9238193,'T','C',470,'Ile','Val','missense_variant','MODERATE','protein_coding',0.00740),(327025,7,865,'chrC09',9238736,'C','T',289,'Asp','Asn','missense_variant','MODERATE','protein_coding',0.00200),(327026,7,825,'chrC09',9238776,'G','T',275,'Asn','Lys','missense_variant','MODERATE','protein_coding',0.01230),(327027,7,763,'chrC09',9238838,'A','G',255,'Phe','Leu','missense_variant','MODERATE','protein_coding',0.00740),(327028,7,673,'chrC09',9238928,'C','T',225,'Glu','Lys','missense_variant','MODERATE','protein_coding',0.00660),(327029,7,612,'chrC09',9238989,'A','T',204,'Asn','Lys','missense_variant','MODERATE','protein_coding',0.00660),(327030,6,17,'chrC09',9267233,'A','T',6,'Lys','Ile','missense_variant','MODERATE','protein_coding',0.00000),(327031,6,305,'chrC09',9267521,'G','C',102,'Gly','Ala','missense_variant','MODERATE','protein_coding',0.00000),(327032,6,2093,'chrC09',9270136,'G','T',698,'Gly','Val','missense_variant','MODERATE','protein_coding',0.00490),(327033,5,661,'chrC09',9273716,'G','C',221,'Pro','Ala','missense_variant','MODERATE','protein_coding',0.00990),(327034,5,481,'chrC09',9274017,'A','T',161,'Leu','Met','missense_variant','MODERATE','protein_coding',0.00990),(327035,4,67,'chrC09',9282013,'C','A',23,'Val','Phe','missense_variant','MODERATE','protein_coding',0.00660),(327036,3,385,'chrC09',9301658,'T','A',129,'Phe','Ile','missense_variant','MODERATE','protein_coding',0.00660),(327037,3,419,'chrC09',9301692,'A','G',140,'Glu','Gly','missense_variant','MODERATE','protein_coding',0.00580),(327038,3,726,'chrC09',9301999,'C','G',242,'Phe','Leu','missense_variant','MODERATE','protein_coding',0.00580),(327039,3,896,'chrC09',9302169,'T','A',299,'Val','Asp','missense_variant','MODERATE','protein_coding',0.00250),(327040,3,1106,'chrC09',9302379,'G','T',369,'Arg','Ile','missense_variant','MODERATE','protein_coding',0.00510),(327041,3,1220,'chrC09',9302493,'A','T',407,'Glu','Val','missense_variant','MODERATE','protein_coding',0.00490),(327042,3,1307,'chrC09',9302580,'A','T',436,'His','Leu','missense_variant','MODERATE','protein_coding',0.00660),(327043,3,1576,'chrC09',9302849,'T','A',526,'Cys','Ser','missense_variant','MODERATE','protein_coding',0.00820),(327044,3,1697,'chrC09',9302970,'A','C',566,'Asn','Thr','missense_variant','MODERATE','protein_coding',0.00660),(327045,2,200,'chrC09',9311197,'A','C',67,'His','Pro','missense_variant','MODERATE','protein_coding',0.00820),(327046,1,1319,'chrC09',9319194,'G','A',440,'Ser','Leu','missense_variant','MODERATE','protein_coding',0.00660),(327047,1,1085,'chrC09',9319428,'C','T',362,'Arg','Gln','missense_variant','MODERATE','protein_coding',0.00660);
/*!40000 ALTER TABLE `snps_to_protein` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-29 19:28:13
