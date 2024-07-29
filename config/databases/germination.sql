-- MySQL dump 10.13  Distrib 8.4.2, for Linux (x86_64)
--
-- Host: localhost    Database: germination
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
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `proj_title` tinytext,
  `proj_pi` tinytext,
  `proj_pi_title` tinytext,
  `proj_pi_inst` tinytext,
  `proj_pi_addr` tinytext,
  `proj_keyw1` tinytext,
  `proj_keyw2` tinytext,
  `proj_keyw3` tinytext,
  `proj_keyw4` tinytext,
  `proj_keyw5` tinytext,
  `proj_res_area` tinytext,
  `proj_num_samps` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`proj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proj_info`
--

LOCK TABLES `proj_info` WRITE;
/*!40000 ALTER TABLE `proj_info` DISABLE KEYS */;
INSERT INTO `proj_info` VALUES (1,'Germination','Reena Narsai','Researcher','Australian Research Council Centre of Excellence in Plant Energy Biology','University of Western Australia, Crawley, Western Australia 6009, Australia',NULL,NULL,NULL,NULL,NULL,'Germination',31);
/*!40000 ALTER TABLE `proj_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proj_res_area`
--

DROP TABLE IF EXISTS `proj_res_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_res_area` (
  `proj_res_index` tinytext,
  `proj_res_area` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proj_res_area`
--

LOCK TABLES `proj_res_area` WRITE;
/*!40000 ALTER TABLE `proj_res_area` DISABLE KEYS */;
INSERT INTO `proj_res_area` VALUES ('germination','Germination');
/*!40000 ALTER TABLE `proj_res_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `sample_bio_name` tinytext,
  `sample_organism` tinytext,
  `sample_alias` tinytext,
  `sample_stock_code` tinytext,
  `sample_genetic_var` tinytext,
  `sample_tissue` tinytext,
  `sample_diseased` tinytext,
  `sample_growth_cond` tinytext,
  `sample_growth_stage` tinytext,
  `sample_time_point` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_biosource_info`
--

LOCK TABLES `sample_biosource_info` WRITE;
/*!40000 ALTER TABLE `sample_biosource_info` DISABLE KEYS */;
INSERT INTO `sample_biosource_info` VALUES (1,1,'0h_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(2,1,'0h_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(3,1,'0h_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(4,1,'12hS_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(5,1,'12hS_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(6,1,'12hS_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(7,1,'12hSL_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(8,1,'12hSL_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(9,1,'12hSL_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(10,1,'1hS_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(11,1,'1hS_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(12,1,'1hS_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(13,1,'1hSL_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(14,1,'1hSL_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(15,1,'1hSL_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(16,1,'24hSL_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(17,1,'24hSL_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(18,1,'24hSL_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(19,1,'48hS_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(20,1,'48hS_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(21,1,'48hS_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(22,1,'48hSL_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(23,1,'48hSL_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(24,1,'48hSL_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(25,1,'6hSL_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(26,1,'6hSL_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(27,1,'6hSL_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(28,1,'harvest_1','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(29,1,'harvest_2','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(30,1,'harvest_3','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0'),(31,1,'Med_CTRL','Arabidopsis thaliana','Col-0','NULL','wt','Seed','NULL','NULL','0','0');
/*!40000 ALTER TABLE `sample_biosource_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(3) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_data`
--

LOCK TABLES `sample_data` WRITE;
/*!40000 ALTER TABLE `sample_data` DISABLE KEYS */;
INSERT INTO `sample_data` VALUES ('1',1,'AT1G01010',2.79788,'0h_1');
/*!40000 ALTER TABLE `sample_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext NOT NULL,
  `sample_name` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_general_info`
--

LOCK TABLES `sample_general_info` WRITE;
/*!40000 ALTER TABLE `sample_general_info` DISABLE KEYS */;
INSERT INTO `sample_general_info` VALUES (1,1,'1','Med_CTRL','NULL','0h_1','0h_1','0h_1'),(2,1,'1','Med_CTRL','NULL','0h_2','0h_2','0h_2'),(3,1,'1','Med_CTRL','NULL','0h_3','0h_3','0h_3'),(4,1,'2','Med_CTRL','NULL','12hS_1','12hS_1','12hS_1'),(5,1,'2','Med_CTRL','NULL','12hS_2','12hS_2','12hS_2'),(6,1,'2','Med_CTRL','NULL','12hS_3','12hS_3','12hS_3'),(7,1,'3','Med_CTRL','NULL','12hSL_1','12hSL_1','12hSL_1'),(8,1,'3','Med_CTRL','NULL','12hSL_2','12hSL_2','12hSL_2'),(9,1,'3','Med_CTRL','NULL','12hSL_3','12hSL_3','12hSL_3'),(10,1,'4','Med_CTRL','NULL','1hS_1','1hS_1','1hS_1'),(11,1,'4','Med_CTRL','NULL','1hS_2','1hS_2','1hS_2'),(12,1,'4','Med_CTRL','NULL','1hS_3','1hS_3','1hS_3'),(13,1,'5','Med_CTRL','NULL','1hSL_1','1hSL_1','1hSL_1'),(14,1,'5','Med_CTRL','NULL','1hSL_2','1hSL_2','1hSL_2'),(15,1,'5','Med_CTRL','NULL','1hSL_3','1hSL_3','1hSL_3'),(16,1,'6','Med_CTRL','NULL','24hSL_1','24hSL_1','24hSL_1'),(17,1,'6','Med_CTRL','NULL','24hSL_2','24hSL_2','24hSL_2'),(18,1,'6','Med_CTRL','NULL','24hSL_3','24hSL_3','24hSL_3'),(19,1,'7','Med_CTRL','NULL','48hS_1','48hS_1','48hS_1'),(20,1,'7','Med_CTRL','NULL','48hS_2','48hS_2','48hS_2'),(21,1,'7','Med_CTRL','NULL','48hS_3','48hS_3','48hS_3'),(22,1,'8','Med_CTRL','NULL','48hSL_1','48hSL_1','48hSL_1'),(23,1,'8','Med_CTRL','NULL','48hSL_2','48hSL_2','48hSL_2'),(24,1,'8','Med_CTRL','NULL','48hSL_3','48hSL_3','48hSL_3'),(25,1,'9','Med_CTRL','NULL','6hSL_1','6hSL_1','6hSL_1'),(26,1,'9','Med_CTRL','NULL','6hSL_2','6hSL_2','6hSL_2'),(27,1,'9','Med_CTRL','NULL','6hSL_3','6hSL_3','6hSL_3'),(28,1,'10','Med_CTRL','NULL','harvest_1','harvest_1','harvest_1'),(29,1,'10','Med_CTRL','NULL','harvest_2','harvest_2','harvest_2'),(30,1,'10','Med_CTRL','NULL','harvest_3','harvest_3','harvest_3'),(31,1,'Med_CTRL','Med_CTRL','NULL','Med_CTRL','Med_CTRL','Med_CTRL');
/*!40000 ALTER TABLE `sample_general_info` ENABLE KEYS */;
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
