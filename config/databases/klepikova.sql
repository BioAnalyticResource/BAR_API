-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: klepikova
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Current Database: `klepikova`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `klepikova` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `klepikova`;

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
INSERT INTO `proj_info` VALUES (1,'Klepikova et al Atlas','Dr. Klepikova','Researcher','Institute for Information Transmission Problems of the Russian Academy of Sciences','Moscow, 127051, Russia',NULL,NULL,NULL,NULL,NULL,'Developmental Atlas',139),(2,'Araport 11','Dr. Cris Town','Professor','J. Craig Venter Institute','9605 Medical Center Drive, Suite 150 Rockville, MD 20850',NULL,NULL,NULL,NULL,NULL,'Pollen',2);
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
INSERT INTO `proj_res_area` VALUES ('developmental atlas','Developmental Atlas'),('pollen','Pollen');
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
INSERT INTO `sample_biosource_info` VALUES (1,1,'SRR3581336','Arabidopsis thaliana','Col-0',NULL,'wt','Hypocotyl',NULL,NULL,'0','0'),(2,1,'SRR3581345','Arabidopsis thaliana','Col-0',NULL,'wt','Cotyledon',NULL,NULL,'0','0'),(3,1,'SRR3581346','Arabidopsis thaliana','Col-0',NULL,'wt','Shoot apical meristem',NULL,NULL,'0','0'),(4,1,'SRR3581347','Arabidopsis thaliana','Col-0',NULL,'wt','Root',NULL,NULL,'0','0'),(5,1,'SRR3581352','Arabidopsis thaliana','Col-0',NULL,'wt','Root Apex',NULL,NULL,'1','0'),(6,1,'SRR3581356','Arabidopsis thaliana','Col-0',NULL,'wt','Root',NULL,NULL,'1','0'),(7,1,'SRR3581383','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'1','0'),(8,1,'SRR3581388','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'1','0'),(9,1,'SRR3581499','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'1','0'),(10,1,'SRR3581591','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'1','0'),(11,1,'SRR3581639','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'1.02','0'),(12,1,'SRR3581672','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf midrib',NULL,NULL,'1.02','0'),(13,1,'SRR3581676','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'1.02','0'),(14,1,'SRR3581678','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'6','0'),(15,1,'SRR3581679','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf midrib',NULL,NULL,'6','0'),(16,1,'SRR3581680','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'6','0'),(17,1,'SRR3581681','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf',NULL,NULL,'6','0'),(18,1,'SRR3581682','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'8','0'),(19,1,'SRR3581683','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf midrib',NULL,NULL,'8','0'),(20,1,'SRR3581684','Arabidopsis thaliana','Col-0',NULL,'wt','Opened Anther',NULL,NULL,'6','0'),(21,1,'SRR3581685','Arabidopsis thaliana','Col-0',NULL,'wt','Carpel',NULL,NULL,'6','0'),(22,1,'SRR3581686','Arabidopsis thaliana','Col-0',NULL,'wt','Anther before opening',NULL,NULL,'6','0'),(23,1,'SRR3581687','Arabidopsis thaliana','Col-0',NULL,'wt','Stamen filament',NULL,NULL,'6','0'),(24,1,'SRR3581688','Arabidopsis thaliana','Col-0',NULL,'wt','Petal',NULL,NULL,'6','0'),(25,1,'SRR3581689','Arabidopsis thaliana','Col-0',NULL,'wt','Sepal',NULL,NULL,'6','0'),(26,1,'SRR3581690','Arabidopsis thaliana','Col-0',NULL,'wt','Young carpel',NULL,NULL,'6.1','0'),(27,1,'SRR3581691','Arabidopsis thaliana','Col-0',NULL,'wt','Young anther',NULL,NULL,'6.1','0'),(28,1,'SRR3581692','Arabidopsis thaliana','Col-0',NULL,'wt','Young sepal',NULL,NULL,'6.1','0'),(29,1,'SRR3581693','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 1',NULL,NULL,'6','0'),(30,1,'SRR3581694','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 2',NULL,NULL,'6','0'),(31,1,'SRR3581695','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 3',NULL,NULL,'6','0'),(32,1,'SRR3581696','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 4',NULL,NULL,'6','0'),(33,1,'SRR3581697','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 5',NULL,NULL,'6','0'),(34,1,'SRR3581698','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 6-8',NULL,NULL,'6','0'),(35,1,'SRR3581699','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 9-11',NULL,NULL,'6','0'),(36,1,'SRR3581700','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 12-14',NULL,NULL,'6','0'),(37,1,'SRR3581701','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 15-18',NULL,NULL,'6','0'),(38,1,'SRR3581702','Arabidopsis thaliana','Col-0',NULL,'wt','Inflorescence',NULL,NULL,'6','0'),(39,1,'SRR3581703','Arabidopsis thaliana','Col-0',NULL,'wt','Pedicel',NULL,NULL,'6','0'),(40,1,'SRR3581704','Arabidopsis thaliana','Col-0',NULL,'wt','Inflorescence axis',NULL,NULL,'6','0'),(41,1,'SRR3581705','Arabidopsis thaliana','Col-0',NULL,'wt','Internode',NULL,NULL,'6','0'),(42,1,'SRR3581706','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 1',NULL,NULL,'6.5','0'),(43,1,'SRR3581707','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 1',NULL,NULL,'6.5','0'),(44,1,'SRR3581708','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 2',NULL,NULL,'6.5','0'),(45,1,'SRR3581709','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 3',NULL,NULL,'6.5','0'),(46,1,'SRR3581710','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 3',NULL,NULL,'6.5','0'),(47,1,'SRR3581711','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 4',NULL,NULL,'6.5','0'),(48,1,'SRR3581712','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 5',NULL,NULL,'6.5','0'),(49,1,'SRR3581713','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 5',NULL,NULL,'6.5','0'),(50,1,'SRR3581714','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 6',NULL,NULL,'6.5','0'),(51,1,'SRR3581715','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 7',NULL,NULL,'6.5','0'),(52,1,'SRR3581716','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 7',NULL,NULL,'6.5','0'),(53,1,'SRR3581717','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 8',NULL,NULL,'6.5','0'),(54,1,'SRR3581719','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 1',NULL,NULL,'6.1','0'),(55,1,'SRR3581720','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 2',NULL,NULL,'6.1','0'),(56,1,'SRR3581721','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 3',NULL,NULL,'6.1','0'),(57,1,'SRR3581724','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 4',NULL,NULL,'6.1','0'),(58,1,'SRR3581726','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 5',NULL,NULL,'6.1','0'),(59,1,'SRR3581727','Arabidopsis thaliana','Col-0',NULL,'wt','Ovule',NULL,NULL,'6.1','0'),(60,1,'SRR3581728','Arabidopsis thaliana','Col-0',NULL,'wt','Stigma',NULL,NULL,'6.1','0'),(61,1,'SRR3581730','Arabidopsis thaliana','Col-0',NULL,'wt','Carpel',NULL,NULL,'6.1','0'),(62,1,'SRR3581731','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0','0'),(63,1,'SRR3581732','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0.1','0'),(64,1,'SRR3581733','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0.5','0'),(65,1,'SRR3581734','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0.6','0'),(66,1,'SRR3581735','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'8','0'),(67,1,'SRR3581736','Arabidopsis thaliana','Col-0',NULL,'wt','Pod',NULL,NULL,'8','0'),(68,1,'SRR3581737','Arabidopsis thaliana','Col-0',NULL,'wt','Silique',NULL,NULL,'8','0'),(69,1,'SRR3581738','Arabidopsis thaliana','Col-0',NULL,'wt','Internode',NULL,NULL,'8','0'),(70,1,'SRR3581740','Arabidopsis thaliana','Col-0',NULL,'wt','Hypocotyl',NULL,NULL,'0','0'),(71,1,'SRR3581831','Arabidopsis thaliana','Col-0',NULL,'wt','Shoot apical meristem',NULL,NULL,'0','0'),(72,1,'SRR3581833','Arabidopsis thaliana','Col-0',NULL,'wt','Cotyledon',NULL,NULL,'0','0'),(73,1,'SRR3581834','Arabidopsis thaliana','Col-0',NULL,'wt','Root',NULL,NULL,'0','0'),(74,1,'SRR3581835','Arabidopsis thaliana','Col-0',NULL,'wt','Root Apex',NULL,NULL,'1','0'),(75,1,'SRR3581836','Arabidopsis thaliana','Col-0',NULL,'wt','Root',NULL,NULL,'1','0'),(76,1,'SRR3581837','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'1','0'),(77,1,'SRR3581838','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'1','0'),(78,1,'SRR3581839','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'1','0'),(79,1,'SRR3581840','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'1','0'),(80,1,'SRR3581841','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'1.02','0'),(81,1,'SRR3581842','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf midrib',NULL,NULL,'1.02','0'),(82,1,'SRR3581843','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'1.02','0'),(83,1,'SRR3581844','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'6','0'),(84,1,'SRR3581845','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf midrib',NULL,NULL,'6','0'),(85,1,'SRR3581846','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf blade',NULL,NULL,'6','0'),(86,1,'SRR3581847','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf',NULL,NULL,'6','0'),(87,1,'SRR3581848','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf petiole',NULL,NULL,'8','0'),(88,1,'SRR3581849','Arabidopsis thaliana','Col-0',NULL,'wt','Leaf midrib',NULL,NULL,'8','0'),(89,1,'SRR3581850','Arabidopsis thaliana','Col-0',NULL,'wt','Opened Anther',NULL,NULL,'6','0'),(90,1,'SRR3581851','Arabidopsis thaliana','Col-0',NULL,'wt','Carpel',NULL,NULL,'6','0'),(91,1,'SRR3581852','Arabidopsis thaliana','Col-0',NULL,'wt','Anther before opening',NULL,NULL,'6','0'),(92,1,'SRR3581853','Arabidopsis thaliana','Col-0',NULL,'wt','Stamen filament',NULL,NULL,'6','0'),(93,1,'SRR3581854','Arabidopsis thaliana','Col-0',NULL,'wt','Petal',NULL,NULL,'6','0'),(94,1,'SRR3581855','Arabidopsis thaliana','Col-0',NULL,'wt','Sepal',NULL,NULL,'6','0'),(95,1,'SRR3581856','Arabidopsis thaliana','Col-0',NULL,'wt','Young carpel',NULL,NULL,'6.1','0'),(96,1,'SRR3581857','Arabidopsis thaliana','Col-0',NULL,'wt','Young anther',NULL,NULL,'6.1','0'),(97,1,'SRR3581858','Arabidopsis thaliana','Col-0',NULL,'wt','Young sepal',NULL,NULL,'6.1','0'),(98,1,'SRR3581859','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 1',NULL,NULL,'6','0'),(99,1,'SRR3581860','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 2',NULL,NULL,'6','0'),(100,1,'SRR3581861','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 3',NULL,NULL,'6','0'),(101,1,'SRR3581862','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 4',NULL,NULL,'6','0'),(102,1,'SRR3581863','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 5',NULL,NULL,'6','0'),(103,1,'SRR3581864','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 6-8',NULL,NULL,'6','0'),(104,1,'SRR3581865','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 9-11',NULL,NULL,'6','0'),(105,1,'SRR3581866','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 12-14',NULL,NULL,'6','0'),(106,1,'SRR3581867','Arabidopsis thaliana','Col-0',NULL,'wt','Flower 15-18',NULL,NULL,'6','0'),(107,1,'SRR3581868','Arabidopsis thaliana','Col-0',NULL,'wt','Inflorescence',NULL,NULL,'6','0'),(108,1,'SRR3581869','Arabidopsis thaliana','Col-0',NULL,'wt','Pedicel',NULL,NULL,'6','0'),(109,1,'SRR3581870','Arabidopsis thaliana','Col-0',NULL,'wt','Inflorescence axis',NULL,NULL,'6','0'),(110,1,'SRR3581871','Arabidopsis thaliana','Col-0',NULL,'wt','Internode',NULL,NULL,'6','0'),(111,1,'SRR3581872','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 1',NULL,NULL,'6.5','0'),(112,1,'SRR3581873','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 1',NULL,NULL,'6.5','0'),(113,1,'SRR3581874','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 2',NULL,NULL,'6.5','0'),(114,1,'SRR3581875','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 3',NULL,NULL,'6.5','0'),(115,1,'SRR3581876','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 3',NULL,NULL,'6.5','0'),(116,1,'SRR3581877','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 4',NULL,NULL,'6.5','0'),(117,1,'SRR3581878','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 5',NULL,NULL,'6.5','0'),(118,1,'SRR3581879','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 5',NULL,NULL,'6.5','0'),(119,1,'SRR3581880','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 6',NULL,NULL,'6.5','0'),(120,1,'SRR3581881','Arabidopsis thaliana','Col-0',NULL,'wt','Seed 7',NULL,NULL,'6.5','0'),(121,1,'SRR3581882','Arabidopsis thaliana','Col-0',NULL,'wt','Pod 7',NULL,NULL,'6.5','0'),(122,1,'SRR3581883','Arabidopsis thaliana','Col-0',NULL,'wt','Silique 8',NULL,NULL,'6.5','0'),(123,1,'SRR3581884','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 1',NULL,NULL,'6.1','0'),(124,1,'SRR3581885','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 2',NULL,NULL,'6.1','0'),(125,1,'SRR3581886','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 3',NULL,NULL,'6.1','0'),(126,1,'SRR3581887','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 4',NULL,NULL,'6.1','0'),(127,1,'SRR3581888','Arabidopsis thaliana','Col-0',NULL,'wt','Seed from silique 5',NULL,NULL,'6.1','0'),(128,1,'SRR3581889','Arabidopsis thaliana','Col-0',NULL,'wt','Ovule',NULL,NULL,'6.1','0'),(129,1,'SRR3581890','Arabidopsis thaliana','Col-0',NULL,'wt','Stigma',NULL,NULL,'6.1','0'),(130,1,'SRR3581891','Arabidopsis thaliana','Col-0',NULL,'wt','Carpel',NULL,NULL,'6.1','0'),(131,1,'SRR3581892','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0','0'),(132,1,'SRR3581893','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0.1','0'),(133,1,'SRR3581894','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0.5','0'),(134,1,'SRR3581895','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'0.6','0'),(135,1,'SRR3581896','Arabidopsis thaliana','Col-0',NULL,'wt','Seed',NULL,NULL,'8','0'),(136,1,'SRR3581897','Arabidopsis thaliana','Col-0',NULL,'wt','Pod',NULL,NULL,'8','0'),(137,1,'SRR3581898','Arabidopsis thaliana','Col-0',NULL,'wt','Silique',NULL,NULL,'8','0'),(138,1,'SRR3581899','Arabidopsis thaliana','Col-0',NULL,'wt','Internode',NULL,NULL,'8','0'),(139,1,'Med_CTRL','Arabidopsis thaliana','Col-0',NULL,'wt','Median_Control',NULL,NULL,'Div','0'),(140,2,'SRR847501','Arabidopsis thaliana','Col-0',NULL,'wt','Pollen',NULL,NULL,'6.3','0'),(141,2,'SRR847502','Arabidopsis thaliana','Col-0',NULL,'wt','Pollen',NULL,NULL,'6.3','0');
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
  `data_call` varchar(2) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_data`
--

LOCK TABLES `sample_data` WRITE;
/*!40000 ALTER TABLE `sample_data` DISABLE KEYS */;
INSERT INTO `sample_data` VALUES ('1',1,'AT1G01010',1.80585,'SRR3581336',NULL);
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
INSERT INTO `sample_general_info` VALUES (1,1,'52','Med_CTRL',NULL,'SRR3581336','SRR3581336','SRR3581336'),(2,1,'50','Med_CTRL',NULL,'SRR3581345','SRR3581345','SRR3581345'),(3,1,'49','Med_CTRL',NULL,'SRR3581346','SRR3581346','SRR3581346'),(4,1,'36','Med_CTRL',NULL,'SRR3581347','SRR3581347','SRR3581347'),(5,1,'24','Med_CTRL',NULL,'SRR3581352','SRR3581352','SRR3581352'),(6,1,'60','Med_CTRL',NULL,'SRR3581356','SRR3581356','SRR3581356'),(7,1,'61','Med_CTRL',NULL,'SRR3581383','SRR3581383','SRR3581383'),(8,1,'62','Med_CTRL',NULL,'SRR3581388','SRR3581388','SRR3581388'),(9,1,'23','Med_CTRL',NULL,'SRR3581499','SRR3581499','SRR3581499'),(10,1,'54','Med_CTRL',NULL,'SRR3581591','SRR3581591','SRR3581591'),(11,1,'25','Med_CTRL',NULL,'SRR3581639','SRR3581639','SRR3581639'),(12,1,'29','Med_CTRL',NULL,'SRR3581672','SRR3581672','SRR3581672'),(13,1,'55','Med_CTRL',NULL,'SRR3581676','SRR3581676','SRR3581676'),(14,1,'35','Med_CTRL',NULL,'SRR3581678','SRR3581678','SRR3581678'),(15,1,'33','Med_CTRL',NULL,'SRR3581679','SRR3581679','SRR3581679'),(16,1,'12','Med_CTRL',NULL,'SRR3581680','SRR3581680','SRR3581680'),(17,1,'48','Med_CTRL',NULL,'SRR3581681','SRR3581681','SRR3581681'),(18,1,'34','Med_CTRL',NULL,'SRR3581682','SRR3581682','SRR3581682'),(19,1,'18','Med_CTRL',NULL,'SRR3581683','SRR3581683','SRR3581683'),(20,1,'67','Med_CTRL',NULL,'SRR3581684','SRR3581684','SRR3581684'),(21,1,'69','Med_CTRL',NULL,'SRR3581685','SRR3581685','SRR3581685'),(22,1,'68','Med_CTRL',NULL,'SRR3581686','SRR3581686','SRR3581686'),(23,1,'66','Med_CTRL',NULL,'SRR3581687','SRR3581687','SRR3581687'),(24,1,'65','Med_CTRL',NULL,'SRR3581688','SRR3581688','SRR3581688'),(25,1,'64','Med_CTRL',NULL,'SRR3581689','SRR3581689','SRR3581689'),(26,1,'38','Med_CTRL',NULL,'SRR3581690','SRR3581690','SRR3581690'),(27,1,'4','Med_CTRL',NULL,'SRR3581691','SRR3581691','SRR3581691'),(28,1,'59','Med_CTRL',NULL,'SRR3581692','SRR3581692','SRR3581692'),(29,1,'28','Med_CTRL',NULL,'SRR3581693','SRR3581693','SRR3581693'),(30,1,'31','Med_CTRL',NULL,'SRR3581694','SRR3581694','SRR3581694'),(31,1,'30','Med_CTRL',NULL,'SRR3581695','SRR3581695','SRR3581695'),(32,1,'27','Med_CTRL',NULL,'SRR3581696','SRR3581696','SRR3581696'),(33,1,'21','Med_CTRL',NULL,'SRR3581697','SRR3581697','SRR3581697'),(34,1,'63','Med_CTRL',NULL,'SRR3581698','SRR3581698','SRR3581698'),(35,1,'32','Med_CTRL',NULL,'SRR3581699','SRR3581699','SRR3581699'),(36,1,'57','Med_CTRL',NULL,'SRR3581700','SRR3581700','SRR3581700'),(37,1,'13','Med_CTRL',NULL,'SRR3581701','SRR3581701','SRR3581701'),(38,1,'51','Med_CTRL',NULL,'SRR3581702','SRR3581702','SRR3581702'),(39,1,'53','Med_CTRL',NULL,'SRR3581703','SRR3581703','SRR3581703'),(40,1,'56','Med_CTRL',NULL,'SRR3581704','SRR3581704','SRR3581704'),(41,1,'22','Med_CTRL',NULL,'SRR3581705','SRR3581705','SRR3581705'),(42,1,'45','Med_CTRL',NULL,'SRR3581706','SRR3581706','SRR3581706'),(43,1,'42','Med_CTRL',NULL,'SRR3581707','SRR3581707','SRR3581707'),(44,1,'6','Med_CTRL',NULL,'SRR3581708','SRR3581708','SRR3581708'),(45,1,'46','Med_CTRL',NULL,'SRR3581709','SRR3581709','SRR3581709'),(46,1,'44','Med_CTRL',NULL,'SRR3581710','SRR3581710','SRR3581710'),(47,1,'7','Med_CTRL',NULL,'SRR3581711','SRR3581711','SRR3581711'),(48,1,'47','Med_CTRL',NULL,'SRR3581712','SRR3581712','SRR3581712'),(49,1,'40','Med_CTRL',NULL,'SRR3581713','SRR3581713','SRR3581713'),(50,1,'8','Med_CTRL',NULL,'SRR3581714','SRR3581714','SRR3581714'),(51,1,'16','Med_CTRL',NULL,'SRR3581715','SRR3581715','SRR3581715'),(52,1,'41','Med_CTRL',NULL,'SRR3581716','SRR3581716','SRR3581716'),(53,1,'1','Med_CTRL',NULL,'SRR3581717','SRR3581717','SRR3581717'),(54,1,'11','Med_CTRL',NULL,'SRR3581719','SRR3581719','SRR3581719'),(55,1,'10','Med_CTRL',NULL,'SRR3581720','SRR3581720','SRR3581720'),(56,1,'9','Med_CTRL',NULL,'SRR3581721','SRR3581721','SRR3581721'),(57,1,'15','Med_CTRL',NULL,'SRR3581724','SRR3581724','SRR3581724'),(58,1,'14','Med_CTRL',NULL,'SRR3581726','SRR3581726','SRR3581726'),(59,1,'20','Med_CTRL',NULL,'SRR3581727','SRR3581727','SRR3581727'),(60,1,'2','Med_CTRL',NULL,'SRR3581728','SRR3581728','SRR3581728'),(61,1,'19','Med_CTRL',NULL,'SRR3581730','SRR3581730','SRR3581730'),(62,1,'5','Med_CTRL',NULL,'SRR3581731','SRR3581731','SRR3581731'),(63,1,'39','Med_CTRL',NULL,'SRR3581732','SRR3581732','SRR3581732'),(64,1,'17','Med_CTRL',NULL,'SRR3581733','SRR3581733','SRR3581733'),(65,1,'37','Med_CTRL',NULL,'SRR3581734','SRR3581734','SRR3581734'),(66,1,'26','Med_CTRL',NULL,'SRR3581735','SRR3581735','SRR3581735'),(67,1,'3','Med_CTRL',NULL,'SRR3581736','SRR3581736','SRR3581736'),(68,1,'58','Med_CTRL',NULL,'SRR3581737','SRR3581737','SRR3581737'),(69,1,'43','Med_CTRL',NULL,'SRR3581738','SRR3581738','SRR3581738'),(70,1,'52','Med_CTRL',NULL,'SRR3581740','SRR3581740','SRR3581740'),(71,1,'49','Med_CTRL',NULL,'SRR3581831','SRR3581831','SRR3581831'),(72,1,'50','Med_CTRL',NULL,'SRR3581833','SRR3581833','SRR3581833'),(73,1,'36','Med_CTRL',NULL,'SRR3581834','SRR3581834','SRR3581834'),(74,1,'24','Med_CTRL',NULL,'SRR3581835','SRR3581835','SRR3581835'),(75,1,'60','Med_CTRL',NULL,'SRR3581836','SRR3581836','SRR3581836'),(76,1,'61','Med_CTRL',NULL,'SRR3581837','SRR3581837','SRR3581837'),(77,1,'62','Med_CTRL',NULL,'SRR3581838','SRR3581838','SRR3581838'),(78,1,'23','Med_CTRL',NULL,'SRR3581839','SRR3581839','SRR3581839'),(79,1,'54','Med_CTRL',NULL,'SRR3581840','SRR3581840','SRR3581840'),(80,1,'25','Med_CTRL',NULL,'SRR3581841','SRR3581841','SRR3581841'),(81,1,'29','Med_CTRL',NULL,'SRR3581842','SRR3581842','SRR3581842'),(82,1,'55','Med_CTRL',NULL,'SRR3581843','SRR3581843','SRR3581843'),(83,1,'35','Med_CTRL',NULL,'SRR3581844','SRR3581844','SRR3581844'),(84,1,'33','Med_CTRL',NULL,'SRR3581845','SRR3581845','SRR3581845'),(85,1,'12','Med_CTRL',NULL,'SRR3581846','SRR3581846','SRR3581846'),(86,1,'48','Med_CTRL',NULL,'SRR3581847','SRR3581847','SRR3581847'),(87,1,'34','Med_CTRL',NULL,'SRR3581848','SRR3581848','SRR3581848'),(88,1,'18','Med_CTRL',NULL,'SRR3581849','SRR3581849','SRR3581849'),(89,1,'67','Med_CTRL',NULL,'SRR3581850','SRR3581850','SRR3581850'),(90,1,'69','Med_CTRL',NULL,'SRR3581851','SRR3581851','SRR3581851'),(91,1,'68','Med_CTRL',NULL,'SRR3581852','SRR3581852','SRR3581852'),(92,1,'66','Med_CTRL',NULL,'SRR3581853','SRR3581853','SRR3581853'),(93,1,'65','Med_CTRL',NULL,'SRR3581854','SRR3581854','SRR3581854'),(94,1,'64','Med_CTRL',NULL,'SRR3581855','SRR3581855','SRR3581855'),(95,1,'38','Med_CTRL',NULL,'SRR3581856','SRR3581856','SRR3581856'),(96,1,'4','Med_CTRL',NULL,'SRR3581857','SRR3581857','SRR3581857'),(97,1,'59','Med_CTRL',NULL,'SRR3581858','SRR3581858','SRR3581858'),(98,1,'28','Med_CTRL',NULL,'SRR3581859','SRR3581859','SRR3581859'),(99,1,'31','Med_CTRL',NULL,'SRR3581860','SRR3581860','SRR3581860'),(100,1,'30','Med_CTRL',NULL,'SRR3581861','SRR3581861','SRR3581861'),(101,1,'27','Med_CTRL',NULL,'SRR3581862','SRR3581862','SRR3581862'),(102,1,'21','Med_CTRL',NULL,'SRR3581863','SRR3581863','SRR3581863'),(103,1,'63','Med_CTRL',NULL,'SRR3581864','SRR3581864','SRR3581864'),(104,1,'32','Med_CTRL',NULL,'SRR3581865','SRR3581865','SRR3581865'),(105,1,'57','Med_CTRL',NULL,'SRR3581866','SRR3581866','SRR3581866'),(106,1,'13','Med_CTRL',NULL,'SRR3581867','SRR3581867','SRR3581867'),(107,1,'51','Med_CTRL',NULL,'SRR3581868','SRR3581868','SRR3581868'),(108,1,'53','Med_CTRL',NULL,'SRR3581869','SRR3581869','SRR3581869'),(109,1,'56','Med_CTRL',NULL,'SRR3581870','SRR3581870','SRR3581870'),(110,1,'22','Med_CTRL',NULL,'SRR3581871','SRR3581871','SRR3581871'),(111,1,'45','Med_CTRL',NULL,'SRR3581872','SRR3581872','SRR3581872'),(112,1,'42','Med_CTRL',NULL,'SRR3581873','SRR3581873','SRR3581873'),(113,1,'6','Med_CTRL',NULL,'SRR3581874','SRR3581874','SRR3581874'),(114,1,'46','Med_CTRL',NULL,'SRR3581875','SRR3581875','SRR3581875'),(115,1,'44','Med_CTRL',NULL,'SRR3581876','SRR3581876','SRR3581876'),(116,1,'7','Med_CTRL',NULL,'SRR3581877','SRR3581877','SRR3581877'),(117,1,'47','Med_CTRL',NULL,'SRR3581878','SRR3581878','SRR3581878'),(118,1,'40','Med_CTRL',NULL,'SRR3581879','SRR3581879','SRR3581879'),(119,1,'8','Med_CTRL',NULL,'SRR3581880','SRR3581880','SRR3581880'),(120,1,'16','Med_CTRL',NULL,'SRR3581881','SRR3581881','SRR3581881'),(121,1,'41','Med_CTRL',NULL,'SRR3581882','SRR3581882','SRR3581882'),(122,1,'1','Med_CTRL',NULL,'SRR3581883','SRR3581883','SRR3581883'),(123,1,'11','Med_CTRL',NULL,'SRR3581884','SRR3581884','SRR3581884'),(124,1,'10','Med_CTRL',NULL,'SRR3581885','SRR3581885','SRR3581885'),(125,1,'9','Med_CTRL',NULL,'SRR3581886','SRR3581886','SRR3581886'),(126,1,'15','Med_CTRL',NULL,'SRR3581887','SRR3581887','SRR3581887'),(127,1,'14','Med_CTRL',NULL,'SRR3581888','SRR3581888','SRR3581888'),(128,1,'20','Med_CTRL',NULL,'SRR3581889','SRR3581889','SRR3581889'),(129,1,'2','Med_CTRL',NULL,'SRR3581890','SRR3581890','SRR3581890'),(130,1,'19','Med_CTRL',NULL,'SRR3581891','SRR3581891','SRR3581891'),(131,1,'5','Med_CTRL',NULL,'SRR3581892','SRR3581892','SRR3581892'),(132,1,'39','Med_CTRL',NULL,'SRR3581893','SRR3581893','SRR3581893'),(133,1,'17','Med_CTRL',NULL,'SRR3581894','SRR3581894','SRR3581894'),(134,1,'37','Med_CTRL',NULL,'SRR3581895','SRR3581895','SRR3581895'),(135,1,'26','Med_CTRL',NULL,'SRR3581896','SRR3581896','SRR3581896'),(136,1,'3','Med_CTRL',NULL,'SRR3581897','SRR3581897','SRR3581897'),(137,1,'58','Med_CTRL',NULL,'SRR3581898','SRR3581898','SRR3581898'),(138,1,'43','Med_CTRL',NULL,'SRR3581899','SRR3581899','SRR3581899'),(139,1,'Med_CTRL','Med_CTRL',NULL,'Med_CTRL','Med_CTRL','Med_CTRL'),(140,2,'70','Med_CTRL',NULL,'SRR847501','SRR847501','SRR847501'),(141,2,'70','Med_CTRL',NULL,'SRR847502','SRR847502','SRR847502');
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

-- Dump completed on 2023-03-29 19:00:09
