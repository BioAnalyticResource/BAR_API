-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: rice_OW_pseudobulk
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Current Database: `rice_OW_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_OW_pseudobulk` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_OW_pseudobulk`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal`      float       DEFAULT '0',
  `data_signal_std`  float       DEFAULT '0',
  `data_bot_id`      varchar(64) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_data`
--

LOCK TABLES `sample_data` WRITE;
/*!40000 ALTER TABLE `sample_data` DISABLE KEYS */;
INSERT INTO `sample_data` VALUES ('Os01g0100100',0.129185,0.530995,'Mild.Drought_Mesophyll.Precursor'),('Os01g0100100',0.106975,0.46405,'Mild.Drought_Mesophyll'),('Os01g0100100',0.151811,0.516815,'Mild.Drought_Meristem'),('Os01g0100100',0.132724,0.488526,'Mild.Drought_Phloem.SE'),('Os01g0100100',0.12683,0.500265,'Mild.Drought_Procambium'),('Os01g0100100',0.109141,0.484893,'Mild.Drought_Mestome.Sheath'),('Os01g0100100',0.125236,0.505634,'Mild.Drought_Large.Parenchyma'),('Os01g0100100',0.120893,0.502762,'Mild.Drought_Epidermis'),('Os01g0100100',0.132058,0.495218,'Mild.Drought_Epidermal.Precursor'),('Os01g0100100',0.112158,0.505641,'Mild.Drought_Xylem.Parenchyma'),('Os01g0100100',0.100015,0.453001,'Mild.Drought_Bundle.Sheath'),('Os01g0100100',0.160374,0.525898,'Mild.Drought_Xylem'),('Os01g0100100',0.0934676,0.425296,'Mild.Drought_Phloem.CC'),('Os01g0100100',0.082868,0.397654,'Mild.Drought_Fibre'),('Os01g0100100',0.113234,0.451226,'Mild.Salinity_Epidermis'),('Os01g0100100',0.141241,0.501154,'Mild.Salinity_Large.Parenchyma'),('Os01g0100100',0.113952,0.443924,'Mild.Salinity_Mesophyll'),('Os01g0100100',0.144946,0.533016,'Mild.Salinity_Mesophyll.Precursor'),('Os01g0100100',0.153651,0.510159,'Mild.Salinity_Epidermal.Precursor'),('Os01g0100100',0.152906,0.515587,'Mild.Salinity_Fibre'),('Os01g0100100',0.182268,0.550966,'Mild.Salinity_Meristem'),('Os01g0100100',0.165656,0.54804,'Mild.Salinity_Procambium'),('Os01g0100100',0.166638,0.613442,'Mild.Salinity_Xylem.Parenchyma'),('Os01g0100100',0.148959,0.490888,'Mild.Salinity_Bundle.Sheath'),('Os01g0100100',0.114692,0.460839,'Mild.Salinity_Phloem.CC'),('Os01g0100100',0.11211,0.447056,'Mild.Salinity_Phloem.SE'),('Os01g0100100',0.172487,0.576142,'Mild.Salinity_Xylem'),('Os01g0100100',0.0550576,0.286011,'Mild.Salinity_Mestome.Sheath'),('Os01g0100100',0.175404,0.526929,'Moderate.Drought_Meristem'),('Os01g0100100',0.100094,0.421708,'Moderate.Drought_Mesophyll'),('Os01g0100100',0.145837,0.504885,'Moderate.Drought_Epidermal.Precursor'),('Os01g0100100',0.134881,0.516218,'Moderate.Drought_Mesophyll.Precursor'),('Os01g0100100',0.145586,0.509715,'Moderate.Drought_Large.Parenchyma'),('Os01g0100100',0.178613,0.567032,'Moderate.Drought_Fibre'),('Os01g0100100',0.145843,0.517616,'Moderate.Drought_Procambium'),('Os01g0100100',0.126689,0.484529,'Moderate.Drought_Epidermis'),('Os01g0100100',0.117171,0.466344,'Moderate.Drought_Bundle.Sheath'),('Os01g0100100',0.136332,0.489258,'Moderate.Drought_Phloem.SE'),('Os01g0100100',0.186774,0.540855,'Moderate.Drought_Xylem'),('Os01g0100100',0.107581,0.458867,'Moderate.Drought_Phloem.CC'),('Os01g0100100',0.101266,0.447594,'Moderate.Drought_Xylem.Parenchyma'),('Os01g0100100',0.0869355,0.377102,'Moderate.Drought_Mestome.Sheath'),('Os01g0100100',0.143541,0.521343,'Moderate.Salinity_Mesophyll.Precursor'),('Os01g0100100',0.141676,0.508878,'Moderate.Salinity_Procambium'),('Os01g0100100',0.130862,0.486061,'Moderate.Salinity_Large.Parenchyma'),('Os01g0100100',0.0963355,0.419142,'Moderate.Salinity_Epidermis'),('Os01g0100100',0.10797,0.438712,'Moderate.Salinity_Mesophyll'),('Os01g0100100',0.154966,0.49645,'Moderate.Salinity_Meristem'),('Os01g0100100',0.13686,0.494768,'Moderate.Salinity_Epidermal.Precursor'),('Os01g0100100',0.195956,0.551093,'Moderate.Salinity_Xylem'),('Os01g0100100',0.185312,0.579004,'Moderate.Salinity_Bundle.Sheath'),('Os01g0100100',0.123884,0.457882,'Moderate.Salinity_Phloem.SE'),('Os01g0100100',0.135465,0.490025,'Moderate.Salinity_Phloem.CC'),('Os01g0100100',0.231051,0.662818,'Moderate.Salinity_Fibre'),('Os01g0100100',0.0416138,0.259696,'Moderate.Salinity_Mestome.Sheath'),('Os01g0100100',0.120685,0.538305,'Moderate.Salinity_Xylem.Parenchyma'),('Os01g0100100',0.161996,0.54257,'Well.Watered_Epidermal.Precursor'),('Os01g0100100',0.152254,0.531447,'Well.Watered_Procambium'),('Os01g0100100',0.142733,0.529409,'Well.Watered_Mesophyll.Precursor'),('Os01g0100100',0.139095,0.497106,'Well.Watered_Large.Parenchyma'),('Os01g0100100',0.104085,0.452645,'Well.Watered_Epidermis'),('Os01g0100100',0.143517,0.504735,'Well.Watered_Fibre'),('Os01g0100100',0.111729,0.461803,'Well.Watered_Mesophyll'),('Os01g0100100',0.164855,0.528581,'Well.Watered_Meristem'),('Os01g0100100',0.0873551,0.367031,'Well.Watered_Phloem.SE'),('Os01g0100100',0.155796,0.530873,'Well.Watered_Phloem.CC'),('Os01g0100100',0.140626,0.509396,'Well.Watered_Bundle.Sheath'),('Os01g0100100',0.208249,0.594796,'Well.Watered_Xylem'),('Os01g0100100',0.118218,0.481877,'Well.Watered_Xylem.Parenchyma'),('Os01g0100100',0.171145,0.540487,'Well.Watered_Mestome.Sheath');
/*!40000 ALTER TABLE `sample_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
-- Dump completed on 2026-07-17 01:33:32
