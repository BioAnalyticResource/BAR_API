-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: localhost    Database: cannabis
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Current Database: `fastpheno`
--

DROP DATABASE IF EXISTS `fastpheno` ;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fastpheno` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fastpheno`;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites` ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sites` (
  `sites_pk` INT NOT NULL AUTO_INCREMENT,
  `site_name` VARCHAR(45) UNIQUE NOT NULL,
  `site_desc` VARCHAR(999) NULL,
  PRIMARY KEY (`sites_pk`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'Pintendre', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'),(2,'Pickering','Lorem ipsum dolor sit amet,');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trees`
--

DROP TABLE IF EXISTS `trees` ;

CREATE TABLE IF NOT EXISTS `trees` (
  `trees_pk` INT NOT NULL AUTO_INCREMENT,
  `sites_pk` INT NOT NULL,
  `longitude` DECIMAL(10) NOT NULL,
  `latitude` DECIMAL(10) NOT NULL,
  `genotype_id` VARCHAR(5) NULL,
  `external_link` VARCHAR(200) NULL,
  `tree_given_id` VARCHAR(25) NULL,
  PRIMARY KEY (`trees_pk`),
  INDEX `sites_fk_idx` (`sites_pk` ASC),
  CONSTRAINT `sites_fk`
    FOREIGN KEY (`sites_pk`)
    REFERENCES `sites` (`sites_pk`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trees`
--

LOCK TABLES `trees` WRITE;
/*!40000 ALTER TABLE `trees` DISABLE KEYS */;
INSERT INTO `trees` VALUES (1,1,336839,5178557,'C','example','11'),(2,1,336872,5178486,'C','example2','11'),(3,1,346872,5278486,'C','example3','B'),(4,2,330502,5262486,'XZ','example4','K123');
/*!40000 ALTER TABLE `trees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `band`
--

DROP TABLE IF EXISTS `band` ;

CREATE TABLE IF NOT EXISTS `band` (
  `trees_pk` INT NOT NULL,
  `month` ENUM('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `band` VARCHAR(100) NOT NULL,
  `value` DECIMAL(20,15) NOT NULL,
  INDEX `trees_fk_idx` (`trees_pk` ASC),
  PRIMARY KEY (`trees_pk`, `month`, `band`),
  CONSTRAINT `trees_fk`
    FOREIGN KEY (`trees_pk`)
    REFERENCES `trees` (`trees_pk`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `band`
--

LOCK TABLES `band` WRITE;
/*!40000 ALTER TABLE `band` DISABLE KEYS */;
INSERT INTO `band` VALUES (1,'jan','band_1',0.025796278000000),(1,'jan','band_2',0.025796278000000),(1,'feb','band_1',0.025796278000000),(1,'mar','band_1',0.0234423232241),(1,'apr','band_1',0.089900613000000),(2,'feb','band_1',0.183586478000000),(4,'feb','band_1',0.223586478000000);
/*!40000 ALTER TABLE `band` ENABLE KEYS */;
UNLOCK TABLES;


-- -----------------------------------------------------
-- Table `height`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `height` ;

CREATE TABLE IF NOT EXISTS `height` (
  `trees_pk` INT NOT NULL,
  `month` ENUM('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `tree_height_proxy` DECIMAL(20,15) NOT NULL,
  `ground_height_proxy` DECIMAL(20,15) NOT NULL,
  INDEX `tree_fk_idx` (`trees_pk` ASC),
  PRIMARY KEY (`trees_pk`, `month`),
  CONSTRAINT `tree_fk`
    FOREIGN KEY (`trees_pk`)
    REFERENCES `trees` (`trees_pk`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `height`
--

LOCK TABLES `height` WRITE;
/*!40000 ALTER TABLE `height` DISABLE KEYS */;
INSERT INTO `height` VALUES (1,'jan',2.23428942871000000,45.106719970000000),(1,'feb',3.478942871000000,49.106719970000000),(1,'mar',2.383630037000000,48.887859340000000),(1,'apr',1.376412749000000,49.052417760000000),(2,'feb',2.383630037000000,48.12341242131163),(4,'feb',2.623630037000000,45.22341242131163);
/*!40000 ALTER TABLE `height` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-07 14:37:50
