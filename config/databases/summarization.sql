-- MySQL dump 10.17  Distrib 10.3.23-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: summarization
-- ------------------------------------------------------
-- Server version	10.3.23-MariaDB-0+deb10u1

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
-- Current Database: `single_cell`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `summarization` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `summarization`;

--
-- Table structure for table `bb5a52387069485486b2f4861c2826dd`
--


DROP TABLE IF EXISTS `bb5a52387069485486b2f4861c2826dd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bb5a52387069485486b2f4861c2826dd` (
  `index` bigint(20) DEFAULT NULL,
  `Gene` text DEFAULT NULL,
  `Sample` text DEFAULT NULL,
  `Value` float DEFAULT NULL,
  KEY `ix_bb5a52387069485486b2f4861c2826dd_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bb5a52387069485486b2f4861c2826dd`
--

LOCK TABLES `bb5a52387069485486b2f4861c2826dd` WRITE;
/*!40000 ALTER TABLE `bb5a52387069485486b2f4861c2826dd` DISABLE KEYS */;
INSERT INTO `bb5a52387069485486b2f4861c2826dd` VALUES (0,'AT1G01010','sample1',32),(1,'AT1G01020','sample1',546),(2,'AT1G01030','sample1',43),(3,'AT1G01010','sample2',54),(4,'AT1G01020','sample2',65),(5,'AT1G01030','sample2',123);
/*!40000 ALTER TABLE `bb5a52387069485486b2f4861c2826dd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `first_name` text DEFAULT NULL,
  `last_name` text DEFAULT NULL,
  `email` text DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES ('Some','Request','request@gmail.com','Test notes');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `first_name` varchar(32) DEFAULT NULL,
  `last_name` varchar(32) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `api_key` varchar(120) NOT NULL,
  `status` varchar(32) DEFAULT NULL,
  `date_added` date NOT NULL,
  `uses_left` int(11) DEFAULT NULL,
  PRIMARY KEY (`api_key`),
  UNIQUE KEY `ix_users_email` (`email`),
  KEY `ix_users_status` (`status`),
  KEY `ix_users_last_name` (`last_name`),
  KEY `ix_users_uses_left` (`uses_left`),
  KEY `ix_users_first_name` (`first_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('Test','User','test@gmail.com','bb5a52387069485486b2f4861c2826dd','user','2020-12-07',100);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-12 18:22:44
