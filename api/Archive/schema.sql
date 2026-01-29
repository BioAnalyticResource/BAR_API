-- MySQL dump 10.13  Distrib 8.4.8, for Linux (x86_64)
--
-- Host: localhost    Database: 
-- ------------------------------------------------------
-- Server version	8.4.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!50606 SET @OLD_INNODB_STATS_AUTO_RECALC=@@INNODB_STATS_AUTO_RECALC */;
/*!50606 SET GLOBAL INNODB_STATS_AUTO_RECALC=OFF */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `mysql`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mysql` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mysql`;

--
-- Table structure for table `columns_priv`
--

DROP TABLE IF EXISTS `columns_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `columns_priv` (
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `User` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Table_name` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Column_name` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Column_priv` set('Select','Insert','Update','References') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`,`User`,`Db`,`Table_name`,`Column_name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Column privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `component`
--

DROP TABLE IF EXISTS `component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `component` (
  `component_id` int unsigned NOT NULL AUTO_INCREMENT,
  `component_group_id` int unsigned NOT NULL,
  `component_urn` text NOT NULL,
  PRIMARY KEY (`component_id`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='Components';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db`
--

DROP TABLE IF EXISTS `db`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db` (
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `User` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Select_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Insert_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Update_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Delete_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Drop_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Grant_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `References_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Index_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Alter_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Lock_tables_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_view_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Show_view_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_routine_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Alter_routine_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Execute_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Event_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Trigger_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Host`,`User`,`Db`),
  KEY `User` (`User`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Database privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `default_roles`
--

DROP TABLE IF EXISTS `default_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `default_roles` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `USER` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `DEFAULT_ROLE_HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '%',
  `DEFAULT_ROLE_USER` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`HOST`,`USER`,`DEFAULT_ROLE_HOST`,`DEFAULT_ROLE_USER`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Default roles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `engine_cost`
--

DROP TABLE IF EXISTS `engine_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `engine_cost` (
  `engine_name` varchar(64) NOT NULL,
  `device_type` int NOT NULL,
  `cost_name` varchar(64) NOT NULL,
  `cost_value` float DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` varchar(1024) DEFAULT NULL,
  `default_value` float GENERATED ALWAYS AS ((case `cost_name` when _utf8mb3'io_block_read_cost' then 1.0 when _utf8mb3'memory_block_read_cost' then 0.25 else NULL end)) VIRTUAL,
  PRIMARY KEY (`cost_name`,`engine_name`,`device_type`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `func`
--

DROP TABLE IF EXISTS `func`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `func` (
  `name` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `ret` tinyint NOT NULL DEFAULT '0',
  `dl` char(128) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `type` enum('function','aggregate') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='User defined functions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `global_grants`
--

DROP TABLE IF EXISTS `global_grants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `global_grants` (
  `USER` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `PRIV` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `WITH_GRANT_OPTION` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`USER`,`HOST`,`PRIV`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Extended global grants';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gtid_executed`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `gtid_executed` (
  `source_uuid` char(36) NOT NULL COMMENT 'uuid of the source where the transaction was originally executed.',
  `interval_start` bigint NOT NULL COMMENT 'First number of interval.',
  `interval_end` bigint NOT NULL COMMENT 'Last number of interval.',
  `gtid_tag` char(32) NOT NULL COMMENT 'GTID Tag.',
  PRIMARY KEY (`source_uuid`,`gtid_tag`,`interval_start`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_category`
--

DROP TABLE IF EXISTS `help_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_category` (
  `help_category_id` smallint unsigned NOT NULL,
  `name` char(64) NOT NULL,
  `parent_category_id` smallint unsigned DEFAULT NULL,
  `url` text NOT NULL,
  PRIMARY KEY (`help_category_id`),
  UNIQUE KEY `name` (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='help categories';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_keyword`
--

DROP TABLE IF EXISTS `help_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_keyword` (
  `help_keyword_id` int unsigned NOT NULL,
  `name` char(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='help keywords';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_relation`
--

DROP TABLE IF EXISTS `help_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_relation` (
  `help_topic_id` int unsigned NOT NULL,
  `help_keyword_id` int unsigned NOT NULL,
  PRIMARY KEY (`help_keyword_id`,`help_topic_id`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='keyword-topic relation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_topic`
--

DROP TABLE IF EXISTS `help_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_topic` (
  `help_topic_id` int unsigned NOT NULL,
  `name` char(64) NOT NULL,
  `help_category_id` smallint unsigned NOT NULL,
  `description` text NOT NULL,
  `example` text NOT NULL,
  `url` text NOT NULL,
  PRIMARY KEY (`help_topic_id`),
  UNIQUE KEY `name` (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='help topics';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ndb_binlog_index`
--

DROP TABLE IF EXISTS `ndb_binlog_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndb_binlog_index` (
  `Position` bigint unsigned NOT NULL,
  `File` varchar(255) NOT NULL,
  `epoch` bigint unsigned NOT NULL,
  `inserts` int unsigned NOT NULL,
  `updates` int unsigned NOT NULL,
  `deletes` int unsigned NOT NULL,
  `schemaops` int unsigned NOT NULL,
  `orig_server_id` int unsigned NOT NULL,
  `orig_epoch` bigint unsigned NOT NULL,
  `gci` int unsigned NOT NULL,
  `next_position` bigint unsigned NOT NULL,
  `next_file` varchar(255) NOT NULL,
  PRIMARY KEY (`epoch`,`orig_server_id`,`orig_epoch`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=latin1 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `password_history`
--

DROP TABLE IF EXISTS `password_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_history` (
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `User` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Password_timestamp` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `Password` text COLLATE utf8mb3_bin,
  PRIMARY KEY (`Host`,`User`,`Password_timestamp` DESC)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Password history for user accounts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plugin`
--

DROP TABLE IF EXISTS `plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin` (
  `name` varchar(64) NOT NULL DEFAULT '',
  `dl` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='MySQL plugins';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `procs_priv`
--

DROP TABLE IF EXISTS `procs_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procs_priv` (
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `User` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Routine_name` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `Routine_type` enum('FUNCTION','PROCEDURE') COLLATE utf8mb3_bin NOT NULL,
  `Grantor` varchar(288) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Proc_priv` set('Execute','Alter Routine','Grant') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`,`User`,`Db`,`Routine_name`,`Routine_type`),
  KEY `Grantor` (`Grantor`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Procedure privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxies_priv`
--

DROP TABLE IF EXISTS `proxies_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proxies_priv` (
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `User` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Proxied_host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `Proxied_user` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `With_grant` tinyint(1) NOT NULL DEFAULT '0',
  `Grantor` varchar(288) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`,`User`,`Proxied_host`,`Proxied_user`),
  KEY `Grantor` (`Grantor`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='User proxy privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replication_asynchronous_connection_failover`
--

DROP TABLE IF EXISTS `replication_asynchronous_connection_failover`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replication_asynchronous_connection_failover` (
  `Channel_name` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'The replication channel name that connects source and replica.',
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'The source hostname that the replica will attempt to switch over the replication connection to in case of a failure.',
  `Port` int unsigned NOT NULL COMMENT 'The source port that the replica will attempt to switch over the replication connection to in case of a failure.',
  `Network_namespace` char(64) NOT NULL COMMENT 'The source network namespace that the replica will attempt to switch over the replication connection to in case of a failure. If its value is empty, connections use the default (global) namespace.',
  `Weight` tinyint unsigned NOT NULL COMMENT 'The order in which the replica shall try to switch the connection over to when there are failures. Weight can be set to a number between 1 and 100, where 100 is the highest weight and 1 the lowest.',
  `Managed_name` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT 'The name of the group which this server belongs to.',
  PRIMARY KEY (`Channel_name`,`Host`,`Port`,`Network_namespace`,`Managed_name`),
  KEY `Channel_name` (`Channel_name`,`Managed_name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='The source configuration details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replication_asynchronous_connection_failover_managed`
--

DROP TABLE IF EXISTS `replication_asynchronous_connection_failover_managed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replication_asynchronous_connection_failover_managed` (
  `Channel_name` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'The replication channel name that connects source and replica.',
  `Managed_name` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT 'The name of the source which needs to be managed.',
  `Managed_type` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT 'Determines the managed type.',
  `Configuration` json DEFAULT NULL COMMENT 'The data to help manage group. For Managed_type = GroupReplication, Configuration value should contain {"Primary_weight": 80, "Secondary_weight": 60}, so that it assigns weight=80 to PRIMARY of the group, and weight=60 for rest of the members in mysql.replication_asynchronous_connection_failover table.',
  PRIMARY KEY (`Channel_name`,`Managed_name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='The managed source configuration details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replication_group_configuration_version`
--

DROP TABLE IF EXISTS `replication_group_configuration_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replication_group_configuration_version` (
  `name` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'The configuration name.',
  `version` bigint unsigned NOT NULL COMMENT 'The version of the configuration name.',
  PRIMARY KEY (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='The group configuration version.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replication_group_member_actions`
--

DROP TABLE IF EXISTS `replication_group_member_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replication_group_member_actions` (
  `name` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'The action name.',
  `event` char(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'The event that will trigger the action.',
  `enabled` tinyint(1) NOT NULL COMMENT 'Whether the action is enabled.',
  `type` char(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'The action type.',
  `priority` tinyint unsigned NOT NULL COMMENT 'The order on which the action will be run, value between 1 and 100, lower values first.',
  `error_handling` char(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'On errors during the action will be handled: IGNORE, CRITICAL.',
  PRIMARY KEY (`name`,`event`),
  KEY `event` (`event`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='The member actions configuration.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_edges`
--

DROP TABLE IF EXISTS `role_edges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_edges` (
  `FROM_HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `FROM_USER` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `TO_HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `TO_USER` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `WITH_ADMIN_OPTION` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`FROM_HOST`,`FROM_USER`,`TO_HOST`,`TO_USER`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Role hierarchy and role grants';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `server_cost`
--

DROP TABLE IF EXISTS `server_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `server_cost` (
  `cost_name` varchar(64) NOT NULL,
  `cost_value` float DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` varchar(1024) DEFAULT NULL,
  `default_value` float GENERATED ALWAYS AS ((case `cost_name` when _utf8mb3'disk_temptable_create_cost' then 20.0 when _utf8mb3'disk_temptable_row_cost' then 0.5 when _utf8mb3'key_compare_cost' then 0.05 when _utf8mb3'memory_temptable_create_cost' then 1.0 when _utf8mb3'memory_temptable_row_cost' then 0.1 when _utf8mb3'row_evaluate_cost' then 0.1 else NULL end)) VIRTUAL,
  PRIMARY KEY (`cost_name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `servers`
--

DROP TABLE IF EXISTS `servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servers` (
  `Server_name` char(64) NOT NULL DEFAULT '',
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `Db` char(64) NOT NULL DEFAULT '',
  `Username` char(64) NOT NULL DEFAULT '',
  `Password` char(64) NOT NULL DEFAULT '',
  `Port` int NOT NULL DEFAULT '0',
  `Socket` char(64) NOT NULL DEFAULT '',
  `Wrapper` char(64) NOT NULL DEFAULT '',
  `Owner` char(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`Server_name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='MySQL Foreign Servers table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slave_master_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `slave_master_info` (
  `Number_of_lines` int unsigned NOT NULL COMMENT 'Number of lines in the file.',
  `Master_log_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'The name of the master binary log currently being read from the master.',
  `Master_log_pos` bigint unsigned NOT NULL COMMENT 'The master log position of the last read event.',
  `Host` varchar(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL COMMENT 'The host name of the source.',
  `User_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The user name used to connect to the master.',
  `User_password` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The password used to connect to the master.',
  `Port` int unsigned NOT NULL COMMENT 'The network port used to connect to the master.',
  `Connect_retry` int unsigned NOT NULL COMMENT 'The period (in seconds) that the slave will wait before trying to reconnect to the master.',
  `Enabled_ssl` tinyint(1) NOT NULL COMMENT 'Indicates whether the server supports SSL connections.',
  `Ssl_ca` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The file used for the Certificate Authority (CA) certificate.',
  `Ssl_capath` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The path to the Certificate Authority (CA) certificates.',
  `Ssl_cert` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The name of the SSL certificate file.',
  `Ssl_cipher` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The name of the cipher in use for the SSL connection.',
  `Ssl_key` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The name of the SSL key file.',
  `Ssl_verify_server_cert` tinyint(1) NOT NULL COMMENT 'Whether to verify the server certificate.',
  `Heartbeat` float NOT NULL,
  `Bind` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'Displays which interface is employed when connecting to the MySQL server',
  `Ignored_server_ids` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The number of server IDs to be ignored, followed by the actual server IDs',
  `Uuid` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The master server uuid.',
  `Retry_count` bigint unsigned NOT NULL COMMENT 'Number of reconnect attempts, to the master, before giving up.',
  `Ssl_crl` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The file used for the Certificate Revocation List (CRL)',
  `Ssl_crlpath` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The path used for Certificate Revocation List (CRL) files',
  `Enabled_auto_position` tinyint(1) NOT NULL COMMENT 'Indicates whether GTIDs will be used to retrieve events from the master.',
  `Channel_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'The channel on which the replica is connected to a source. Used in Multisource Replication',
  `Tls_version` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'Tls version',
  `Public_key_path` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The file containing public key of master server.',
  `Get_public_key` tinyint(1) NOT NULL COMMENT 'Preference to get public key from master.',
  `Network_namespace` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'Network namespace used for communication with the master server.',
  `Master_compression_algorithm` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'Compression algorithm supported for data transfer between source and replica.',
  `Master_zstd_compression_level` int unsigned NOT NULL COMMENT 'Compression level associated with zstd compression algorithm.',
  `Tls_ciphersuites` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'Ciphersuites used for TLS 1.3 communication with the master server.',
  `Source_connection_auto_failover` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether the channel connection failover is enabled.',
  `Gtid_only` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this channel only uses GTIDs and does not persist positions.',
  PRIMARY KEY (`Channel_name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Master Information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slave_relay_log_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `slave_relay_log_info` (
  `Number_of_lines` int unsigned NOT NULL COMMENT 'Number of lines in the file or rows in the table. Used to version table definitions.',
  `Relay_log_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The name of the current relay log file.',
  `Relay_log_pos` bigint unsigned DEFAULT NULL COMMENT 'The relay log position of the last executed event.',
  `Master_log_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'The name of the master binary log file from which the events in the relay log file were read.',
  `Master_log_pos` bigint unsigned DEFAULT NULL COMMENT 'The master log position of the last executed event.',
  `Sql_delay` int DEFAULT NULL COMMENT 'The number of seconds that the slave must lag behind the master.',
  `Number_of_workers` int unsigned DEFAULT NULL,
  `Id` int unsigned DEFAULT NULL COMMENT 'Internal Id that uniquely identifies this record.',
  `Channel_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'The channel on which the replica is connected to a source. Used in Multisource Replication',
  `Privilege_checks_username` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'Username part of PRIVILEGE_CHECKS_USER.',
  `Privilege_checks_hostname` varchar(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL COMMENT 'Hostname part of PRIVILEGE_CHECKS_USER.',
  `Require_row_format` tinyint(1) NOT NULL COMMENT 'Indicates whether the channel shall only accept row based events.',
  `Require_table_primary_key_check` enum('STREAM','ON','OFF','GENERATE') NOT NULL DEFAULT 'STREAM' COMMENT 'Indicates what is the channel policy regarding tables without primary keys on create and alter table queries',
  `Assign_gtids_to_anonymous_transactions_type` enum('OFF','LOCAL','UUID') NOT NULL DEFAULT 'OFF' COMMENT 'Indicates whether the channel will generate a new GTID for anonymous transactions. OFF means that anonymous transactions will remain anonymous. LOCAL means that anonymous transactions will be assigned a newly generated GTID based on server_uuid. UUID indicates that anonymous transactions will be assigned a newly generated GTID based on Assign_gtids_to_anonymous_transactions_value',
  `Assign_gtids_to_anonymous_transactions_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT 'Indicates the UUID used while generating GTIDs for anonymous transactions',
  PRIMARY KEY (`Channel_name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Relay Log Information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slave_worker_info`
--

DROP TABLE IF EXISTS `slave_worker_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slave_worker_info` (
  `Id` int unsigned NOT NULL,
  `Relay_log_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `Relay_log_pos` bigint unsigned NOT NULL,
  `Master_log_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `Master_log_pos` bigint unsigned NOT NULL,
  `Checkpoint_relay_log_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `Checkpoint_relay_log_pos` bigint unsigned NOT NULL,
  `Checkpoint_master_log_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `Checkpoint_master_log_pos` bigint unsigned NOT NULL,
  `Checkpoint_seqno` int unsigned NOT NULL,
  `Checkpoint_group_size` int unsigned NOT NULL,
  `Checkpoint_group_bitmap` blob NOT NULL,
  `Channel_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'The channel on which the replica is connected to a source. Used in Multisource Replication',
  PRIMARY KEY (`Channel_name`,`Id`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Worker Information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tables_priv`
--

DROP TABLE IF EXISTS `tables_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tables_priv` (
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `User` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Table_name` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Grantor` varchar(288) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Table_priv` set('Select','Insert','Update','Delete','Create','Drop','Grant','References','Index','Alter','Create View','Show view','Trigger') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `Column_priv` set('Select','Insert','Update','References') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`,`User`,`Db`,`Table_name`),
  KEY `Grantor` (`Grantor`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Table privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone`
--

DROP TABLE IF EXISTS `time_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_zone` (
  `Time_zone_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Use_leap_seconds` enum('Y','N') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Time_zone_id`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Time zones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_leap_second`
--

DROP TABLE IF EXISTS `time_zone_leap_second`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_zone_leap_second` (
  `Transition_time` bigint NOT NULL,
  `Correction` int NOT NULL,
  PRIMARY KEY (`Transition_time`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Leap seconds information for time zones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_name`
--

DROP TABLE IF EXISTS `time_zone_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_zone_name` (
  `Name` char(64) NOT NULL,
  `Time_zone_id` int unsigned NOT NULL,
  PRIMARY KEY (`Name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Time zone names';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_transition`
--

DROP TABLE IF EXISTS `time_zone_transition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_zone_transition` (
  `Time_zone_id` int unsigned NOT NULL,
  `Transition_time` bigint NOT NULL,
  `Transition_type_id` int unsigned NOT NULL,
  PRIMARY KEY (`Time_zone_id`,`Transition_time`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Time zone transitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_transition_type`
--

DROP TABLE IF EXISTS `time_zone_transition_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_zone_transition_type` (
  `Time_zone_id` int unsigned NOT NULL,
  `Transition_type_id` int unsigned NOT NULL,
  `Offset` int NOT NULL DEFAULT '0',
  `Is_DST` tinyint unsigned NOT NULL DEFAULT '0',
  `Abbreviation` char(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`Time_zone_id`,`Transition_type_id`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Time zone transition types';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `Host` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `User` char(32) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `Select_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Insert_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Update_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Delete_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Drop_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Reload_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Shutdown_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Process_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `File_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Grant_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `References_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Index_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Alter_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Show_db_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Super_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Lock_tables_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Execute_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Repl_slave_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Repl_client_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_view_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Show_view_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_routine_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Alter_routine_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_user_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Event_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Trigger_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_tablespace_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `ssl_type` enum('','ANY','X509','SPECIFIED') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `ssl_cipher` blob NOT NULL,
  `x509_issuer` blob NOT NULL,
  `x509_subject` blob NOT NULL,
  `max_questions` int unsigned NOT NULL DEFAULT '0',
  `max_updates` int unsigned NOT NULL DEFAULT '0',
  `max_connections` int unsigned NOT NULL DEFAULT '0',
  `max_user_connections` int unsigned NOT NULL DEFAULT '0',
  `plugin` char(64) COLLATE utf8mb3_bin NOT NULL DEFAULT 'caching_sha2_password',
  `authentication_string` text COLLATE utf8mb3_bin,
  `password_expired` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `password_last_changed` timestamp NULL DEFAULT NULL,
  `password_lifetime` smallint unsigned DEFAULT NULL,
  `account_locked` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Create_role_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Drop_role_priv` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'N',
  `Password_reuse_history` smallint unsigned DEFAULT NULL,
  `Password_reuse_time` smallint unsigned DEFAULT NULL,
  `Password_require_current` enum('N','Y') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `User_attributes` json DEFAULT NULL,
  PRIMARY KEY (`Host`,`User`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='Users and global privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `general_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `general_log` (
  `event_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `user_host` mediumtext NOT NULL,
  `thread_id` bigint unsigned NOT NULL,
  `server_id` int unsigned NOT NULL,
  `command_type` varchar(64) NOT NULL,
  `argument` mediumblob NOT NULL
) ENGINE=CSV DEFAULT CHARSET=utf8mb3 COMMENT='General log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slow_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `slow_log` (
  `start_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `user_host` mediumtext NOT NULL,
  `query_time` time(6) NOT NULL,
  `lock_time` time(6) NOT NULL,
  `rows_sent` int NOT NULL,
  `rows_examined` int NOT NULL,
  `db` varchar(512) NOT NULL,
  `last_insert_id` int NOT NULL,
  `insert_id` int NOT NULL,
  `server_id` int unsigned NOT NULL,
  `sql_text` mediumblob NOT NULL,
  `thread_id` bigint unsigned NOT NULL
) ENGINE=CSV DEFAULT CHARSET=utf8mb3 COMMENT='Slow log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `3ddi_wiki`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `3ddi_wiki` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `3ddi_wiki`;

--
-- Table structure for table `actor`
--

DROP TABLE IF EXISTS `actor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actor` (
  `actor_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `actor_user` int unsigned DEFAULT NULL,
  `actor_name` varbinary(255) NOT NULL,
  PRIMARY KEY (`actor_id`),
  UNIQUE KEY `actor_name` (`actor_name`),
  UNIQUE KEY `actor_user` (`actor_user`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `archive`
--

DROP TABLE IF EXISTS `archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archive` (
  `ar_id` int unsigned NOT NULL AUTO_INCREMENT,
  `ar_namespace` int NOT NULL DEFAULT '0',
  `ar_title` varbinary(255) NOT NULL DEFAULT '',
  `ar_comment_id` bigint unsigned NOT NULL,
  `ar_actor` bigint unsigned NOT NULL,
  `ar_timestamp` binary(14) NOT NULL,
  `ar_minor_edit` tinyint NOT NULL DEFAULT '0',
  `ar_rev_id` int unsigned NOT NULL,
  `ar_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `ar_len` int unsigned DEFAULT NULL,
  `ar_page_id` int unsigned DEFAULT NULL,
  `ar_parent_id` int unsigned DEFAULT NULL,
  `ar_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`ar_id`),
  UNIQUE KEY `ar_revid_uniq` (`ar_rev_id`),
  KEY `ar_actor_timestamp` (`ar_actor`,`ar_timestamp`),
  KEY `ar_name_title_timestamp` (`ar_namespace`,`ar_title`,`ar_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bot_passwords`
--

DROP TABLE IF EXISTS `bot_passwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_passwords` (
  `bp_user` int unsigned NOT NULL,
  `bp_app_id` varbinary(32) NOT NULL,
  `bp_password` tinyblob NOT NULL,
  `bp_token` binary(32) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `bp_restrictions` blob NOT NULL,
  `bp_grants` blob NOT NULL,
  PRIMARY KEY (`bp_user`,`bp_app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `cat_id` int unsigned NOT NULL AUTO_INCREMENT,
  `cat_title` varbinary(255) NOT NULL,
  `cat_pages` int NOT NULL DEFAULT '0',
  `cat_subcats` int NOT NULL DEFAULT '0',
  `cat_files` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`cat_id`),
  UNIQUE KEY `cat_title` (`cat_title`),
  KEY `cat_pages` (`cat_pages`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categorylinks`
--

DROP TABLE IF EXISTS `categorylinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorylinks` (
  `cl_from` int unsigned NOT NULL DEFAULT '0',
  `cl_to` varbinary(255) NOT NULL DEFAULT '',
  `cl_sortkey` varbinary(230) NOT NULL DEFAULT '',
  `cl_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cl_sortkey_prefix` varbinary(255) NOT NULL DEFAULT '',
  `cl_collation` varbinary(32) NOT NULL DEFAULT '',
  `cl_type` enum('page','subcat','file') NOT NULL DEFAULT 'page',
  PRIMARY KEY (`cl_from`,`cl_to`),
  KEY `cl_timestamp` (`cl_to`,`cl_timestamp`),
  KEY `cl_sortkey` (`cl_to`,`cl_type`,`cl_sortkey`,`cl_from`),
  KEY `cl_collation_ext` (`cl_collation`,`cl_to`,`cl_type`,`cl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `change_tag`
--

DROP TABLE IF EXISTS `change_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `change_tag` (
  `ct_id` int unsigned NOT NULL AUTO_INCREMENT,
  `ct_rc_id` int DEFAULT NULL,
  `ct_log_id` int unsigned DEFAULT NULL,
  `ct_rev_id` int unsigned DEFAULT NULL,
  `ct_params` blob,
  `ct_tag_id` int unsigned NOT NULL,
  PRIMARY KEY (`ct_id`),
  UNIQUE KEY `ct_rc_tag_id` (`ct_rc_id`,`ct_tag_id`),
  UNIQUE KEY `ct_log_tag_id` (`ct_log_id`,`ct_tag_id`),
  UNIQUE KEY `ct_rev_tag_id` (`ct_rev_id`,`ct_tag_id`),
  KEY `ct_tag_id_id` (`ct_tag_id`,`ct_rc_id`,`ct_rev_id`,`ct_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `change_tag_def`
--

DROP TABLE IF EXISTS `change_tag_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `change_tag_def` (
  `ctd_id` int unsigned NOT NULL AUTO_INCREMENT,
  `ctd_name` varbinary(255) NOT NULL,
  `ctd_user_defined` tinyint(1) NOT NULL,
  `ctd_count` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ctd_id`),
  UNIQUE KEY `ctd_name` (`ctd_name`),
  KEY `ctd_count` (`ctd_count`),
  KEY `ctd_user_defined` (`ctd_user_defined`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `comment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `comment_hash` int NOT NULL,
  `comment_text` blob NOT NULL,
  `comment_data` blob,
  PRIMARY KEY (`comment_id`),
  KEY `comment_hash` (`comment_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content` (
  `content_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `content_size` int unsigned NOT NULL,
  `content_sha1` varbinary(32) NOT NULL,
  `content_model` smallint unsigned NOT NULL,
  `content_address` varbinary(255) NOT NULL,
  PRIMARY KEY (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_models`
--

DROP TABLE IF EXISTS `content_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_models` (
  `model_id` int NOT NULL AUTO_INCREMENT,
  `model_name` varbinary(64) NOT NULL,
  PRIMARY KEY (`model_id`),
  UNIQUE KEY `model_name` (`model_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `externallinks`
--

DROP TABLE IF EXISTS `externallinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `externallinks` (
  `el_id` int unsigned NOT NULL AUTO_INCREMENT,
  `el_from` int unsigned NOT NULL DEFAULT '0',
  `el_to` blob NOT NULL,
  `el_index` blob NOT NULL,
  `el_index_60` varbinary(60) NOT NULL,
  PRIMARY KEY (`el_id`),
  KEY `el_from` (`el_from`,`el_to`(40)),
  KEY `el_to` (`el_to`(60),`el_from`),
  KEY `el_index` (`el_index`(60)),
  KEY `el_index_60` (`el_index_60`,`el_id`),
  KEY `el_from_index_60` (`el_from`,`el_index_60`,`el_id`)
) ENGINE=InnoDB AUTO_INCREMENT=658440 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `filearchive`
--

DROP TABLE IF EXISTS `filearchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `filearchive` (
  `fa_id` int unsigned NOT NULL AUTO_INCREMENT,
  `fa_name` varbinary(255) NOT NULL DEFAULT '',
  `fa_archive_name` varbinary(255) DEFAULT '',
  `fa_storage_group` varbinary(16) DEFAULT NULL,
  `fa_storage_key` varbinary(64) DEFAULT '',
  `fa_deleted_user` int DEFAULT NULL,
  `fa_deleted_timestamp` binary(14) DEFAULT NULL,
  `fa_deleted_reason_id` bigint unsigned NOT NULL,
  `fa_size` int unsigned DEFAULT '0',
  `fa_width` int DEFAULT '0',
  `fa_height` int DEFAULT '0',
  `fa_metadata` mediumblob,
  `fa_bits` int DEFAULT '0',
  `fa_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `fa_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') DEFAULT 'unknown',
  `fa_minor_mime` varbinary(100) DEFAULT 'unknown',
  `fa_description_id` bigint unsigned NOT NULL,
  `fa_actor` bigint unsigned NOT NULL,
  `fa_timestamp` binary(14) DEFAULT NULL,
  `fa_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `fa_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`fa_id`),
  KEY `fa_name` (`fa_name`,`fa_timestamp`),
  KEY `fa_storage_group` (`fa_storage_group`,`fa_storage_key`),
  KEY `fa_deleted_timestamp` (`fa_deleted_timestamp`),
  KEY `fa_sha1` (`fa_sha1`(10)),
  KEY `fa_actor_timestamp` (`fa_actor`,`fa_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `img_name` varbinary(255) NOT NULL DEFAULT '',
  `img_size` int unsigned NOT NULL DEFAULT '0',
  `img_width` int NOT NULL DEFAULT '0',
  `img_height` int NOT NULL DEFAULT '0',
  `img_metadata` mediumblob NOT NULL,
  `img_bits` int NOT NULL DEFAULT '0',
  `img_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `img_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') NOT NULL DEFAULT 'unknown',
  `img_minor_mime` varbinary(100) NOT NULL DEFAULT 'unknown',
  `img_description_id` bigint unsigned NOT NULL,
  `img_actor` bigint unsigned NOT NULL,
  `img_timestamp` binary(14) NOT NULL,
  `img_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`img_name`),
  KEY `img_size` (`img_size`),
  KEY `img_timestamp` (`img_timestamp`),
  KEY `img_sha1` (`img_sha1`),
  KEY `img_media_mime` (`img_media_type`,`img_major_mime`,`img_minor_mime`),
  KEY `img_actor_timestamp` (`img_actor`,`img_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `imagelinks`
--

DROP TABLE IF EXISTS `imagelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imagelinks` (
  `il_from` int unsigned NOT NULL DEFAULT '0',
  `il_to` varbinary(255) NOT NULL DEFAULT '',
  `il_from_namespace` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`il_from`,`il_to`),
  KEY `il_backlinks_namespace` (`il_from_namespace`,`il_to`,`il_from`),
  KEY `il_to` (`il_to`,`il_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interwiki`
--

DROP TABLE IF EXISTS `interwiki`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interwiki` (
  `iw_prefix` varchar(32) NOT NULL,
  `iw_url` blob NOT NULL,
  `iw_local` tinyint(1) NOT NULL,
  `iw_trans` tinyint NOT NULL DEFAULT '0',
  `iw_api` blob NOT NULL,
  `iw_wikiid` varchar(64) NOT NULL,
  PRIMARY KEY (`iw_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_changes`
--

DROP TABLE IF EXISTS `ip_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_changes` (
  `ipc_rev_id` int unsigned NOT NULL DEFAULT '0',
  `ipc_rev_timestamp` binary(14) NOT NULL,
  `ipc_hex` varbinary(35) NOT NULL DEFAULT '',
  PRIMARY KEY (`ipc_rev_id`),
  KEY `ipc_rev_timestamp` (`ipc_rev_timestamp`),
  KEY `ipc_hex_time` (`ipc_hex`,`ipc_rev_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ipblocks`
--

DROP TABLE IF EXISTS `ipblocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ipblocks` (
  `ipb_id` int unsigned NOT NULL AUTO_INCREMENT,
  `ipb_address` tinyblob NOT NULL,
  `ipb_user` int unsigned NOT NULL DEFAULT '0',
  `ipb_by` int unsigned NOT NULL DEFAULT '0',
  `ipb_by_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `ipb_by_actor` bigint unsigned NOT NULL DEFAULT '0',
  `ipb_reason_id` bigint unsigned NOT NULL,
  `ipb_timestamp` binary(14) NOT NULL,
  `ipb_auto` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_anon_only` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_create_account` tinyint(1) NOT NULL DEFAULT '1',
  `ipb_enable_autoblock` tinyint(1) NOT NULL DEFAULT '1',
  `ipb_expiry` varbinary(14) NOT NULL,
  `ipb_range_start` tinyblob NOT NULL,
  `ipb_range_end` tinyblob NOT NULL,
  `ipb_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_block_email` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_allow_usertalk` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_parent_block_id` int unsigned DEFAULT NULL,
  `ipb_sitewide` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ipb_id`),
  UNIQUE KEY `ipb_address_unique` (`ipb_address`(255),`ipb_user`,`ipb_auto`),
  KEY `ipb_user` (`ipb_user`),
  KEY `ipb_range` (`ipb_range_start`(8),`ipb_range_end`(8)),
  KEY `ipb_timestamp` (`ipb_timestamp`),
  KEY `ipb_expiry` (`ipb_expiry`),
  KEY `ipb_parent_block_id` (`ipb_parent_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ipblocks_restrictions`
--

DROP TABLE IF EXISTS `ipblocks_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ipblocks_restrictions` (
  `ir_ipb_id` int unsigned NOT NULL,
  `ir_type` tinyint NOT NULL,
  `ir_value` int unsigned NOT NULL,
  PRIMARY KEY (`ir_ipb_id`,`ir_type`,`ir_value`),
  KEY `ir_type_value` (`ir_type`,`ir_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iwlinks`
--

DROP TABLE IF EXISTS `iwlinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `iwlinks` (
  `iwl_from` int unsigned NOT NULL DEFAULT '0',
  `iwl_prefix` varbinary(32) NOT NULL DEFAULT '',
  `iwl_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`iwl_from`,`iwl_prefix`,`iwl_title`),
  KEY `iwl_prefix_title_from` (`iwl_prefix`,`iwl_title`,`iwl_from`),
  KEY `iwl_prefix_from_title` (`iwl_prefix`,`iwl_from`,`iwl_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job` (
  `job_id` int unsigned NOT NULL AUTO_INCREMENT,
  `job_cmd` varbinary(60) NOT NULL DEFAULT '',
  `job_namespace` int NOT NULL,
  `job_title` varbinary(255) NOT NULL,
  `job_params` mediumblob NOT NULL,
  `job_timestamp` binary(14) DEFAULT NULL,
  `job_random` int unsigned NOT NULL DEFAULT '0',
  `job_token` varbinary(32) NOT NULL DEFAULT '',
  `job_token_timestamp` binary(14) DEFAULT NULL,
  `job_sha1` varbinary(32) NOT NULL DEFAULT '',
  `job_attempts` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`job_id`),
  KEY `job_cmd` (`job_cmd`,`job_namespace`,`job_title`),
  KEY `job_timestamp` (`job_timestamp`),
  KEY `job_sha1` (`job_sha1`),
  KEY `job_cmd_token` (`job_cmd`,`job_token`,`job_random`),
  KEY `job_cmd_token_id` (`job_cmd`,`job_token`,`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `l10n_cache`
--

DROP TABLE IF EXISTS `l10n_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `l10n_cache` (
  `lc_lang` varbinary(35) NOT NULL,
  `lc_key` varchar(255) NOT NULL,
  `lc_value` mediumblob NOT NULL,
  PRIMARY KEY (`lc_lang`,`lc_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `langlinks`
--

DROP TABLE IF EXISTS `langlinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `langlinks` (
  `ll_from` int unsigned NOT NULL DEFAULT '0',
  `ll_lang` varbinary(35) NOT NULL DEFAULT '',
  `ll_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ll_from`,`ll_lang`),
  KEY `ll_lang` (`ll_lang`,`ll_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `linktarget`
--

DROP TABLE IF EXISTS `linktarget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `linktarget` (
  `lt_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `lt_namespace` int NOT NULL,
  `lt_title` varbinary(255) NOT NULL,
  PRIMARY KEY (`lt_id`),
  UNIQUE KEY `lt_namespace_title` (`lt_namespace`,`lt_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log_search`
--

DROP TABLE IF EXISTS `log_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_search` (
  `ls_field` varbinary(32) NOT NULL,
  `ls_value` varchar(255) NOT NULL,
  `ls_log_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ls_field`,`ls_value`,`ls_log_id`),
  KEY `ls_log_id` (`ls_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logging`
--

DROP TABLE IF EXISTS `logging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logging` (
  `log_id` int unsigned NOT NULL AUTO_INCREMENT,
  `log_type` varbinary(32) NOT NULL,
  `log_action` varbinary(32) NOT NULL,
  `log_timestamp` binary(14) NOT NULL DEFAULT '19700101000000',
  `log_namespace` int NOT NULL DEFAULT '0',
  `log_title` varbinary(255) NOT NULL DEFAULT '',
  `log_comment_id` bigint unsigned NOT NULL,
  `log_params` blob NOT NULL,
  `log_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `log_actor` bigint unsigned NOT NULL,
  `log_page` int unsigned DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `log_page_id_time` (`log_page`,`log_timestamp`),
  KEY `log_actor_type_time` (`log_actor`,`log_type`,`log_timestamp`),
  KEY `log_type_action` (`log_type`,`log_action`,`log_timestamp`),
  KEY `log_type_time` (`log_type`,`log_timestamp`),
  KEY `log_actor_time` (`log_actor`,`log_timestamp`),
  KEY `log_page_time` (`log_namespace`,`log_title`,`log_timestamp`),
  KEY `log_times` (`log_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `math`
--

DROP TABLE IF EXISTS `math`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `math` (
  `math_inputhash` varbinary(16) NOT NULL,
  `math_outputhash` varbinary(16) NOT NULL,
  `math_html_conservativeness` tinyint NOT NULL,
  `math_html` text,
  `math_mathml` text,
  UNIQUE KEY `math_inputhash` (`math_inputhash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `module_deps`
--

DROP TABLE IF EXISTS `module_deps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_deps` (
  `md_module` varbinary(255) NOT NULL,
  `md_skin` varbinary(32) NOT NULL,
  `md_deps` mediumblob NOT NULL,
  PRIMARY KEY (`md_module`,`md_skin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `objectcache`
--

DROP TABLE IF EXISTS `objectcache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objectcache` (
  `keyname` varbinary(255) NOT NULL DEFAULT '',
  `value` mediumblob,
  `exptime` binary(14) NOT NULL,
  `modtoken` varchar(17) NOT NULL DEFAULT '00000000000000000',
  `flags` int unsigned DEFAULT NULL,
  PRIMARY KEY (`keyname`),
  KEY `exptime` (`exptime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oldimage`
--

DROP TABLE IF EXISTS `oldimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oldimage` (
  `oi_name` varbinary(255) NOT NULL DEFAULT '',
  `oi_archive_name` varbinary(255) NOT NULL DEFAULT '',
  `oi_size` int unsigned NOT NULL DEFAULT '0',
  `oi_width` int NOT NULL DEFAULT '0',
  `oi_height` int NOT NULL DEFAULT '0',
  `oi_bits` int NOT NULL DEFAULT '0',
  `oi_description_id` bigint unsigned NOT NULL,
  `oi_actor` bigint unsigned NOT NULL,
  `oi_timestamp` binary(14) NOT NULL,
  `oi_metadata` mediumblob NOT NULL,
  `oi_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `oi_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') NOT NULL DEFAULT 'unknown',
  `oi_minor_mime` varbinary(100) NOT NULL DEFAULT 'unknown',
  `oi_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `oi_sha1` varbinary(32) NOT NULL DEFAULT '',
  KEY `oi_name_timestamp` (`oi_name`,`oi_timestamp`),
  KEY `oi_name_archive_name` (`oi_name`,`oi_archive_name`(14)),
  KEY `oi_sha1` (`oi_sha1`),
  KEY `oi_actor_timestamp` (`oi_actor`,`oi_timestamp`),
  KEY `oi_timestamp` (`oi_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `page`
--

DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `page` (
  `page_id` int unsigned NOT NULL AUTO_INCREMENT,
  `page_namespace` int NOT NULL,
  `page_title` varbinary(255) NOT NULL,
  `page_is_redirect` tinyint unsigned NOT NULL DEFAULT '0',
  `page_is_new` tinyint unsigned NOT NULL DEFAULT '0',
  `page_random` double unsigned NOT NULL,
  `page_touched` binary(14) NOT NULL,
  `page_latest` int unsigned NOT NULL,
  `page_len` int unsigned NOT NULL,
  `page_content_model` varbinary(32) DEFAULT NULL,
  `page_links_updated` varbinary(14) DEFAULT NULL,
  `page_lang` varbinary(35) DEFAULT NULL,
  PRIMARY KEY (`page_id`),
  UNIQUE KEY `page_name_title` (`page_namespace`,`page_title`),
  KEY `page_random` (`page_random`),
  KEY `page_len` (`page_len`),
  KEY `page_redirect_namespace_len` (`page_is_redirect`,`page_namespace`,`page_len`)
) ENGINE=InnoDB AUTO_INCREMENT=9888 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `page_props`
--

DROP TABLE IF EXISTS `page_props`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `page_props` (
  `pp_page` int unsigned NOT NULL,
  `pp_propname` varbinary(60) NOT NULL,
  `pp_value` blob NOT NULL,
  `pp_sortkey` float DEFAULT NULL,
  PRIMARY KEY (`pp_page`,`pp_propname`),
  UNIQUE KEY `pp_propname_page` (`pp_propname`,`pp_page`),
  UNIQUE KEY `pp_propname_sortkey_page` (`pp_propname`,`pp_sortkey`,`pp_page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `page_restrictions`
--

DROP TABLE IF EXISTS `page_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `page_restrictions` (
  `pr_page` int unsigned NOT NULL,
  `pr_type` varbinary(60) NOT NULL,
  `pr_level` varbinary(60) NOT NULL,
  `pr_cascade` tinyint NOT NULL,
  `pr_expiry` varbinary(14) DEFAULT NULL,
  `pr_id` int unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`pr_id`),
  UNIQUE KEY `pr_pagetype` (`pr_page`,`pr_type`),
  KEY `pr_typelevel` (`pr_type`,`pr_level`),
  KEY `pr_level` (`pr_level`),
  KEY `pr_cascade` (`pr_cascade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pagelinks`
--

DROP TABLE IF EXISTS `pagelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagelinks` (
  `pl_from` int unsigned NOT NULL DEFAULT '0',
  `pl_namespace` int NOT NULL DEFAULT '0',
  `pl_title` varbinary(255) NOT NULL DEFAULT '',
  `pl_from_namespace` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`pl_from`,`pl_namespace`,`pl_title`),
  KEY `pl_backlinks_namespace` (`pl_from_namespace`,`pl_namespace`,`pl_title`,`pl_from`),
  KEY `pl_namespace` (`pl_namespace`,`pl_title`,`pl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protected_titles`
--

DROP TABLE IF EXISTS `protected_titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protected_titles` (
  `pt_namespace` int NOT NULL,
  `pt_title` varbinary(255) NOT NULL,
  `pt_user` int unsigned NOT NULL,
  `pt_reason_id` bigint unsigned NOT NULL,
  `pt_timestamp` binary(14) NOT NULL,
  `pt_expiry` varbinary(14) NOT NULL,
  `pt_create_perm` varbinary(60) NOT NULL,
  PRIMARY KEY (`pt_namespace`,`pt_title`),
  KEY `pt_timestamp` (`pt_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `querycache`
--

DROP TABLE IF EXISTS `querycache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `querycache` (
  `qc_type` varbinary(32) NOT NULL,
  `qc_value` int unsigned NOT NULL DEFAULT '0',
  `qc_namespace` int NOT NULL DEFAULT '0',
  `qc_title` varbinary(255) NOT NULL DEFAULT '',
  KEY `qc_type` (`qc_type`,`qc_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `querycache_info`
--

DROP TABLE IF EXISTS `querycache_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `querycache_info` (
  `qci_type` varbinary(32) NOT NULL DEFAULT '',
  `qci_timestamp` binary(14) NOT NULL DEFAULT '19700101000000',
  PRIMARY KEY (`qci_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `querycachetwo`
--

DROP TABLE IF EXISTS `querycachetwo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `querycachetwo` (
  `qcc_type` varbinary(32) NOT NULL,
  `qcc_value` int unsigned NOT NULL DEFAULT '0',
  `qcc_namespace` int NOT NULL DEFAULT '0',
  `qcc_title` varbinary(255) NOT NULL DEFAULT '',
  `qcc_namespacetwo` int NOT NULL DEFAULT '0',
  `qcc_titletwo` varbinary(255) NOT NULL DEFAULT '',
  KEY `qcc_type` (`qcc_type`,`qcc_value`),
  KEY `qcc_title` (`qcc_type`,`qcc_namespace`,`qcc_title`),
  KEY `qcc_titletwo` (`qcc_type`,`qcc_namespacetwo`,`qcc_titletwo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recentchanges`
--

DROP TABLE IF EXISTS `recentchanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recentchanges` (
  `rc_id` int unsigned NOT NULL AUTO_INCREMENT,
  `rc_timestamp` binary(14) NOT NULL,
  `rc_actor` bigint unsigned NOT NULL,
  `rc_namespace` int NOT NULL DEFAULT '0',
  `rc_title` varbinary(255) NOT NULL DEFAULT '',
  `rc_comment_id` bigint unsigned NOT NULL,
  `rc_minor` tinyint unsigned NOT NULL DEFAULT '0',
  `rc_bot` tinyint unsigned NOT NULL DEFAULT '0',
  `rc_new` tinyint unsigned NOT NULL DEFAULT '0',
  `rc_cur_id` int unsigned NOT NULL DEFAULT '0',
  `rc_this_oldid` int unsigned NOT NULL DEFAULT '0',
  `rc_last_oldid` int unsigned NOT NULL DEFAULT '0',
  `rc_type` tinyint unsigned NOT NULL DEFAULT '0',
  `rc_patrolled` tinyint unsigned NOT NULL DEFAULT '0',
  `rc_ip` varbinary(40) NOT NULL DEFAULT '',
  `rc_old_len` int DEFAULT NULL,
  `rc_new_len` int DEFAULT NULL,
  `rc_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `rc_logid` int unsigned NOT NULL DEFAULT '0',
  `rc_log_type` varbinary(255) DEFAULT NULL,
  `rc_log_action` varbinary(255) DEFAULT NULL,
  `rc_params` blob,
  `rc_source` varbinary(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`rc_id`),
  KEY `rc_timestamp` (`rc_timestamp`),
  KEY `rc_cur_id` (`rc_cur_id`),
  KEY `rc_ip` (`rc_ip`),
  KEY `rc_name_type_patrolled_timestamp` (`rc_namespace`,`rc_type`,`rc_patrolled`,`rc_timestamp`),
  KEY `rc_ns_actor` (`rc_namespace`,`rc_actor`),
  KEY `rc_actor` (`rc_actor`,`rc_timestamp`),
  KEY `rc_namespace_title_timestamp` (`rc_namespace`,`rc_title`,`rc_timestamp`),
  KEY `rc_this_oldid` (`rc_this_oldid`),
  KEY `rc_new_name_timestamp` (`rc_new`,`rc_namespace`,`rc_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=109495 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `redirect`
--

DROP TABLE IF EXISTS `redirect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `redirect` (
  `rd_from` int unsigned NOT NULL DEFAULT '0',
  `rd_namespace` int NOT NULL DEFAULT '0',
  `rd_title` varbinary(255) NOT NULL DEFAULT '',
  `rd_interwiki` varchar(32) DEFAULT NULL,
  `rd_fragment` varbinary(255) DEFAULT NULL,
  PRIMARY KEY (`rd_from`),
  KEY `rd_ns_title` (`rd_namespace`,`rd_title`,`rd_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `revision`
--

DROP TABLE IF EXISTS `revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `revision` (
  `rev_id` int unsigned NOT NULL AUTO_INCREMENT,
  `rev_page` int unsigned NOT NULL,
  `rev_comment_id` bigint unsigned NOT NULL DEFAULT '0',
  `rev_actor` bigint unsigned NOT NULL DEFAULT '0',
  `rev_timestamp` binary(14) NOT NULL,
  `rev_minor_edit` tinyint unsigned NOT NULL DEFAULT '0',
  `rev_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `rev_len` int unsigned DEFAULT NULL,
  `rev_parent_id` int unsigned DEFAULT NULL,
  `rev_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`rev_id`),
  KEY `rev_timestamp` (`rev_timestamp`),
  KEY `rev_actor_timestamp` (`rev_actor`,`rev_timestamp`,`rev_id`),
  KEY `rev_page_actor_timestamp` (`rev_page`,`rev_actor`,`rev_timestamp`),
  KEY `rev_page_timestamp` (`rev_page`,`rev_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=104442 DEFAULT CHARSET=utf8mb3 MAX_ROWS=10000000 AVG_ROW_LENGTH=1024;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `revision_comment_temp`
--

DROP TABLE IF EXISTS `revision_comment_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `revision_comment_temp` (
  `revcomment_rev` int unsigned NOT NULL,
  `revcomment_comment_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`revcomment_rev`,`revcomment_comment_id`),
  UNIQUE KEY `revcomment_rev` (`revcomment_rev`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `searchindex`
--

DROP TABLE IF EXISTS `searchindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `searchindex` (
  `si_page` int unsigned NOT NULL,
  `si_title` varchar(255) NOT NULL DEFAULT '',
  `si_text` mediumtext NOT NULL,
  UNIQUE KEY `si_page` (`si_page`),
  FULLTEXT KEY `si_title` (`si_title`),
  FULLTEXT KEY `si_text` (`si_text`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `site_identifiers`
--

DROP TABLE IF EXISTS `site_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_identifiers` (
  `si_site` int unsigned NOT NULL,
  `si_type` varbinary(32) NOT NULL,
  `si_key` varbinary(32) NOT NULL,
  PRIMARY KEY (`si_type`,`si_key`),
  KEY `si_site` (`si_site`),
  KEY `si_key` (`si_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `site_stats`
--

DROP TABLE IF EXISTS `site_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_stats` (
  `ss_row_id` int unsigned NOT NULL,
  `ss_total_edits` bigint unsigned DEFAULT NULL,
  `ss_good_articles` bigint unsigned DEFAULT NULL,
  `ss_total_pages` bigint unsigned DEFAULT NULL,
  `ss_users` bigint unsigned DEFAULT NULL,
  `ss_active_users` bigint unsigned DEFAULT NULL,
  `ss_images` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`ss_row_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `site_id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_global_key` varbinary(64) NOT NULL,
  `site_type` varbinary(32) NOT NULL,
  `site_group` varbinary(32) NOT NULL,
  `site_source` varbinary(32) NOT NULL,
  `site_language` varbinary(35) NOT NULL,
  `site_protocol` varbinary(32) NOT NULL,
  `site_domain` varchar(255) NOT NULL,
  `site_data` blob NOT NULL,
  `site_forward` tinyint(1) NOT NULL,
  `site_config` blob NOT NULL,
  PRIMARY KEY (`site_id`),
  UNIQUE KEY `site_global_key` (`site_global_key`),
  KEY `site_type` (`site_type`),
  KEY `site_group` (`site_group`),
  KEY `site_source` (`site_source`),
  KEY `site_language` (`site_language`),
  KEY `site_protocol` (`site_protocol`),
  KEY `site_domain` (`site_domain`),
  KEY `site_forward` (`site_forward`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slot_roles`
--

DROP TABLE IF EXISTS `slot_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slot_roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varbinary(64) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slots`
--

DROP TABLE IF EXISTS `slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slots` (
  `slot_revision_id` bigint unsigned NOT NULL,
  `slot_role_id` smallint unsigned NOT NULL,
  `slot_content_id` bigint unsigned NOT NULL,
  `slot_origin` bigint unsigned NOT NULL,
  PRIMARY KEY (`slot_revision_id`,`slot_role_id`),
  KEY `slot_revision_origin_role` (`slot_revision_id`,`slot_origin`,`slot_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `templatelinks`
--

DROP TABLE IF EXISTS `templatelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `templatelinks` (
  `tl_from` int unsigned NOT NULL DEFAULT '0',
  `tl_from_namespace` int NOT NULL DEFAULT '0',
  `tl_target_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tl_from`,`tl_target_id`),
  KEY `tl_target_id` (`tl_target_id`,`tl_from`),
  KEY `tl_backlinks_namespace_target_id` (`tl_from_namespace`,`tl_target_id`,`tl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `text`
--

DROP TABLE IF EXISTS `text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `text` (
  `old_id` int unsigned NOT NULL AUTO_INCREMENT,
  `old_text` mediumblob NOT NULL,
  `old_flags` tinyblob NOT NULL,
  PRIMARY KEY (`old_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104439 DEFAULT CHARSET=utf8mb3 MAX_ROWS=10000000 AVG_ROW_LENGTH=10240;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trackbacks`
--

DROP TABLE IF EXISTS `trackbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trackbacks` (
  `tb_id` int NOT NULL AUTO_INCREMENT,
  `tb_page` int DEFAULT NULL,
  `tb_title` varchar(255) NOT NULL,
  `tb_url` blob NOT NULL,
  `tb_ex` text,
  `tb_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tb_id`),
  KEY `tb_page` (`tb_page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `updatelog`
--

DROP TABLE IF EXISTS `updatelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `updatelog` (
  `ul_key` varchar(255) NOT NULL,
  `ul_value` blob,
  PRIMARY KEY (`ul_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uploadstash`
--

DROP TABLE IF EXISTS `uploadstash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uploadstash` (
  `us_id` int unsigned NOT NULL AUTO_INCREMENT,
  `us_user` int unsigned NOT NULL,
  `us_key` varchar(255) NOT NULL,
  `us_orig_path` varchar(255) NOT NULL,
  `us_path` varchar(255) NOT NULL,
  `us_source_type` varchar(50) DEFAULT NULL,
  `us_timestamp` binary(14) NOT NULL,
  `us_status` varchar(50) NOT NULL,
  `us_size` int unsigned NOT NULL,
  `us_sha1` varchar(31) NOT NULL,
  `us_mime` varchar(255) DEFAULT NULL,
  `us_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `us_image_width` int unsigned DEFAULT NULL,
  `us_image_height` int unsigned DEFAULT NULL,
  `us_image_bits` smallint unsigned DEFAULT NULL,
  `us_chunk_inx` int unsigned DEFAULT NULL,
  `us_props` blob,
  PRIMARY KEY (`us_id`),
  UNIQUE KEY `us_key` (`us_key`),
  KEY `us_user` (`us_user`),
  KEY `us_timestamp` (`us_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varbinary(255) NOT NULL DEFAULT '',
  `user_real_name` varbinary(255) NOT NULL DEFAULT '',
  `user_password` tinyblob NOT NULL,
  `user_newpassword` tinyblob NOT NULL,
  `user_newpass_time` binary(14) DEFAULT NULL,
  `user_email` tinyblob NOT NULL,
  `user_touched` binary(14) NOT NULL,
  `user_token` binary(32) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `user_email_authenticated` binary(14) DEFAULT NULL,
  `user_email_token` binary(32) DEFAULT NULL,
  `user_email_token_expires` binary(14) DEFAULT NULL,
  `user_registration` binary(14) DEFAULT NULL,
  `user_editcount` int unsigned DEFAULT NULL,
  `user_password_expires` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  KEY `user_email_token` (`user_email_token`),
  KEY `user_email` (`user_email`(50))
) ENGINE=InnoDB AUTO_INCREMENT=5049 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_autocreate_serial`
--

DROP TABLE IF EXISTS `user_autocreate_serial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_autocreate_serial` (
  `uas_shard` int unsigned NOT NULL,
  `uas_value` int unsigned NOT NULL,
  PRIMARY KEY (`uas_shard`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_former_groups`
--

DROP TABLE IF EXISTS `user_former_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_former_groups` (
  `ufg_user` int unsigned NOT NULL DEFAULT '0',
  `ufg_group` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ufg_user`,`ufg_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_groups` (
  `ug_user` int unsigned NOT NULL DEFAULT '0',
  `ug_group` varbinary(255) NOT NULL DEFAULT '',
  `ug_expiry` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`ug_user`,`ug_group`),
  KEY `ug_group` (`ug_group`),
  KEY `ug_expiry` (`ug_expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_newtalk`
--

DROP TABLE IF EXISTS `user_newtalk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_newtalk` (
  `user_id` int unsigned NOT NULL DEFAULT '0',
  `user_ip` varbinary(40) NOT NULL DEFAULT '',
  `user_last_timestamp` binary(14) DEFAULT NULL,
  KEY `un_user_id` (`user_id`),
  KEY `un_user_ip` (`user_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_properties`
--

DROP TABLE IF EXISTS `user_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_properties` (
  `up_user` int unsigned NOT NULL,
  `up_property` varbinary(255) NOT NULL,
  `up_value` blob,
  PRIMARY KEY (`up_user`,`up_property`),
  KEY `up_property` (`up_property`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `watchlist`
--

DROP TABLE IF EXISTS `watchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `watchlist` (
  `wl_id` int unsigned NOT NULL AUTO_INCREMENT,
  `wl_user` int unsigned NOT NULL,
  `wl_namespace` int NOT NULL DEFAULT '0',
  `wl_title` varbinary(255) NOT NULL DEFAULT '',
  `wl_notificationtimestamp` binary(14) DEFAULT NULL,
  PRIMARY KEY (`wl_id`),
  UNIQUE KEY `wl_user` (`wl_user`,`wl_namespace`,`wl_title`),
  KEY `wl_user_notificationtimestamp` (`wl_user`,`wl_notificationtimestamp`),
  KEY `wl_namespace_title` (`wl_namespace`,`wl_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `watchlist_expiry`
--

DROP TABLE IF EXISTS `watchlist_expiry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `watchlist_expiry` (
  `we_item` int unsigned NOT NULL,
  `we_expiry` binary(14) NOT NULL,
  PRIMARY KEY (`we_item`),
  KEY `we_expiry` (`we_expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `AnnoJ`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `AnnoJ` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `AnnoJ`;

--
-- Current Database: `BAR_Search`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `BAR_Search` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `BAR_Search`;

--
-- Table structure for table `arrays`
--

DROP TABLE IF EXISTS `arrays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arrays` (
  `array_id` int DEFAULT NULL,
  `array_platform` varchar(50) DEFAULT NULL,
  `array_name` varchar(50) DEFAULT NULL,
  KEY `array_id` (`array_id`),
  CONSTRAINT `arrays_ibfk_1` FOREIGN KEY (`array_id`) REFERENCES `species_array` (`array_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `species_array`
--

DROP TABLE IF EXISTS `species_array`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `species_array` (
  `identifier` varchar(40) NOT NULL,
  `species_id` int NOT NULL,
  `array_id` int NOT NULL,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `species_id` (`species_id`),
  UNIQUE KEY `array_id` (`array_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `species_template_tool`
--

DROP TABLE IF EXISTS `species_template_tool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `species_template_tool` (
  `species_id` int DEFAULT NULL,
  `species_name` varchar(50) DEFAULT NULL,
  `tool_name` varchar(50) DEFAULT NULL,
  `base_url` varchar(500) DEFAULT NULL,
  `on_array` int DEFAULT NULL,
  `image_name` varchar(255) DEFAULT NULL,
  KEY `species_id` (`species_id`),
  CONSTRAINT `species_template_tool_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species_array` (`species_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `CDD3D`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `CDD3D` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `CDD3D`;

--
-- Table structure for table `SWISSVAR_06052015`
--

DROP TABLE IF EXISTS `SWISSVAR_06052015`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SWISSVAR_06052015` (
  `EntryID` int NOT NULL AUTO_INCREMENT,
  `SV_ID` varchar(100) NOT NULL,
  `SP_ID` varchar(10) NOT NULL,
  `ANNOT` varchar(100) NOT NULL,
  `MUTN` mediumtext NOT NULL,
  `DESCR` text,
  `PDB_ID` varchar(4) NOT NULL,
  `PDB_CHAIN` varchar(1) NOT NULL,
  `SITE` int NOT NULL,
  PRIMARY KEY (`EntryID`),
  KEY `PDB_ID` (`PDB_ID`,`PDB_CHAIN`)
) ENGINE=InnoDB AUTO_INCREMENT=529208 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `NASCArrays`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `NASCArrays` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `NASCArrays`;

--
-- Table structure for table `Experiments`
--

DROP TABLE IF EXISTS `Experiments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Experiments` (
  `ExpID` int NOT NULL,
  `Title` varchar(100) NOT NULL,
  `Description` text,
  `ExpDate` date DEFAULT NULL,
  `Link` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ExpID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Slides`
--

DROP TABLE IF EXISTS `Slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Slides` (
  `ExpID` int NOT NULL,
  `SlideID` varchar(100) NOT NULL,
  `Slide_Name` int DEFAULT NULL,
  `Genetic_Background` varchar(50) DEFAULT NULL,
  `Tissue` varchar(200) DEFAULT NULL,
  `Treatment` text,
  `Stock_Code` varchar(100) DEFAULT NULL,
  `Cel_File` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`SlideID`),
  KEY `ExpID` (`ExpID`),
  CONSTRAINT `Slides_ibfk_1` FOREIGN KEY (`ExpID`) REFERENCES `Experiments` (`ExpID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `NGM`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `NGM` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `NGM`;

--
-- Table structure for table `chr_seq_annotation`
--

DROP TABLE IF EXISTS `chr_seq_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation` (
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
  KEY `range` (`Source`,`SeqID`,`Start`,`End`),
  KEY `seqend` (`Source`,`SeqID`,`End`),
  KEY `typeid` (`SeqID`,`Source`,`Type`,`Parent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `known_snps`
--

DROP TABLE IF EXISTS `known_snps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `known_snps` (
  `source` varchar(10) NOT NULL DEFAULT 'TAIR9',
  `seqId` varchar(10) NOT NULL,
  `pos` int NOT NULL,
  PRIMARY KEY (`source`,`seqId`,`pos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='known SNPs in gene sequence';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `TRTCFungarium`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `TRTCFungarium` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `TRTCFungarium`;

--
-- Table structure for table `collections`
--

DROP TABLE IF EXISTS `collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collections` (
  `Rev_Date` varchar(250) DEFAULT NULL,
  `Collection` varchar(250) NOT NULL DEFAULT '',
  `Coll_ID` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`Collection`,`Coll_ID`),
  KEY `coll_id` (`Coll_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `link`
--

DROP TABLE IF EXISTS `link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `link` (
  `Rev_Date` varchar(250) DEFAULT NULL,
  `Accession_No` varchar(250) NOT NULL DEFAULT '',
  `Coll_ID` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`Accession_No`,`Coll_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `main`
--

DROP TABLE IF EXISTS `main`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main` (
  `Rev_Date` varchar(250) DEFAULT NULL,
  `Reviewer` varchar(250) DEFAULT NULL,
  `Rec_Enter` varchar(250) DEFAULT NULL,
  `Rec_Date` varchar(250) DEFAULT NULL,
  `TRTC_Loc` varchar(250) DEFAULT NULL,
  `Qtyr` varchar(250) DEFAULT NULL,
  `TRTC` varchar(250) DEFAULT NULL,
  `Accession_No` varchar(250) NOT NULL DEFAULT '',
  `Museum_Coll` varchar(250) DEFAULT NULL,
  `Kingdom` varchar(250) DEFAULT NULL,
  `Phyllum` varchar(250) DEFAULT NULL,
  `Class` varchar(250) DEFAULT NULL,
  `Organism` varchar(250) DEFAULT NULL,
  `Family` varchar(250) DEFAULT NULL,
  `Genus` varchar(250) DEFAULT NULL,
  `Species` varchar(250) DEFAULT NULL,
  `Species_Auth` varchar(250) DEFAULT NULL,
  `Subspecies` varchar(250) DEFAULT NULL,
  `Subspecies_Auth` varchar(250) DEFAULT NULL,
  `Variety` varchar(250) DEFAULT NULL,
  `Variety_Auth` varchar(250) DEFAULT NULL,
  `Formae` varchar(250) DEFAULT NULL,
  `Formae_Auth` varchar(250) DEFAULT NULL,
  `Other_Tax_Level` varchar(250) DEFAULT NULL,
  `Other_Tax_Lev_Auth` varchar(250) DEFAULT NULL,
  `Image` varchar(250) DEFAULT NULL,
  `Notes_Image` varchar(250) DEFAULT NULL,
  `Sequence` varchar(250) DEFAULT NULL,
  `Sampled_for_DNA` varchar(250) DEFAULT NULL,
  `Specimen_status` varchar(250) DEFAULT NULL,
  `Exsiccatae` varchar(250) DEFAULT NULL,
  `Exsic_No` varchar(250) DEFAULT NULL,
  `Host_Genus` varchar(250) DEFAULT NULL,
  `Host_sp` varchar(250) DEFAULT NULL,
  `Collector` varchar(250) DEFAULT NULL,
  `Coll_no` varchar(250) DEFAULT NULL,
  `Other_Coll` varchar(250) DEFAULT NULL,
  `Coll_Date` varchar(250) DEFAULT NULL,
  `Id_Name` varchar(250) DEFAULT NULL,
  `Herb_Name` varchar(250) DEFAULT NULL,
  `Cross_Ref` varchar(250) DEFAULT NULL,
  `Country` varchar(250) DEFAULT NULL,
  `Province` varchar(250) DEFAULT NULL,
  `District` varchar(250) DEFAULT NULL,
  `County` varchar(250) DEFAULT NULL,
  `Township` varchar(250) DEFAULT NULL,
  `Other` varchar(250) DEFAULT NULL,
  `LatN` varchar(250) DEFAULT NULL,
  `LatS` varchar(250) DEFAULT NULL,
  `LongE` varchar(250) DEFAULT NULL,
  `LongW` varchar(250) DEFAULT NULL,
  `UTM_E` varchar(250) DEFAULT NULL,
  `UTM_N` varchar(250) DEFAULT NULL,
  `UTM_Z` varchar(250) DEFAULT NULL,
  `Map_Ref` varchar(250) DEFAULT NULL,
  `Elevation` varchar(250) DEFAULT NULL,
  `Units_Elevation` varchar(250) DEFAULT NULL,
  `Location` varchar(250) DEFAULT NULL,
  `Loc_Description` varchar(250) DEFAULT NULL,
  `Habitat` varchar(250) DEFAULT NULL,
  `Substrate` varchar(250) DEFAULT NULL,
  `Notes_Other` varchar(250) DEFAULT NULL,
  `Notes_on_specimen` varchar(250) DEFAULT NULL,
  `Notes` varchar(250) DEFAULT NULL,
  `Publications` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`Accession_No`),
  KEY `image` (`Image`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `actinidia_bud_development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `actinidia_bud_development` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `actinidia_bud_development`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `actinidia_flower_fruit_development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `actinidia_flower_fruit_development` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `actinidia_flower_fruit_development`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `actinidia_postharvest`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `actinidia_postharvest` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `actinidia_postharvest`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `actinidia_vegetative_growth`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `actinidia_vegetative_growth` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `actinidia_vegetative_growth`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `affydb`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `affydb` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `affydb`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` int unsigned NOT NULL AUTO_INCREMENT,
  `proj_date_submit` date NOT NULL DEFAULT '0000-00-00',
  `proj_date_ready` date NOT NULL DEFAULT '0000-00-00',
  `proj_date_complete` date NOT NULL DEFAULT '0000-00-00',
  `proj_paid_date` date NOT NULL DEFAULT '0000-00-00',
  `proj_paid_amount` decimal(6,2) NOT NULL DEFAULT '0.00',
  `proj_title` tinytext,
  `proj_pi` tinytext,
  `proj_pi_title` tinytext,
  `proj_pi_inst` tinytext,
  `proj_pi_addr` tinytext,
  `proj_pi_tel` tinytext,
  `proj_pi_fax` tinytext,
  `proj_pi_email` tinytext,
  `proj_keyw1` tinytext,
  `proj_keyw2` tinytext,
  `proj_keyw3` tinytext,
  `proj_keyw4` tinytext,
  `proj_keyw5` tinytext,
  `proj_res_area` tinytext,
  `proj_abstr` text,
  `proj_prop` text,
  `proj_fund_src` text,
  `proj_num_samps` tinyint unsigned NOT NULL DEFAULT '0',
  `proj_num_arrays` tinyint unsigned NOT NULL DEFAULT '0',
  `proj_ht3_array` tinytext,
  PRIMARY KEY (`proj_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proj_res_area`
--

DROP TABLE IF EXISTS `proj_res_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_res_area` (
  `proj_res_index` text,
  `proj_res_area` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `sample_file_name` tinytext NOT NULL,
  `data_num` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL DEFAULT '0',
  `data_bot_id` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_ext_param`
--

DROP TABLE IF EXISTS `sample_ext_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_ext_param` (
  `sample_param_type` tinytext,
  `sample_param_index` tinytext NOT NULL,
  `sample_param_data` tinytext NOT NULL,
  `sample_param_ontology` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_extraction_info`
--

DROP TABLE IF EXISTS `sample_extraction_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_extraction_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_protocol_name` tinytext NOT NULL,
  `sample_protocol_method` tinytext,
  `sample_amplification` tinytext,
  `sample_other_info` tinytext,
  `sample_type` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL AUTO_INCREMENT,
  `proj_id` int unsigned DEFAULT NULL,
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_name` tinytext,
  `sample_desc` longtext,
  `sample_od` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_mass` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_vol` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB AUTO_INCREMENT=486 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybrid_blocking_agent`
--

DROP TABLE IF EXISTS `sample_hybrid_blocking_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybrid_blocking_agent` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `blocking_agent` tinytext,
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybrid_solution`
--

DROP TABLE IF EXISTS `sample_hybrid_solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybrid_solution` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `solution` tinytext,
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybrid_wash`
--

DROP TABLE IF EXISTS `sample_hybrid_wash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybrid_wash` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `step_num` int DEFAULT NULL,
  `wash_step` tinytext,
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybridization_info`
--

DROP TABLE IF EXISTS `sample_hybridization_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybridization_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_protocol_name` tinytext,
  `sample_amount` tinytext,
  `sample_time` int DEFAULT NULL,
  `sample_concentration` int DEFAULT NULL,
  `sample_volume` int DEFAULT NULL,
  `sample_temperature` int DEFAULT NULL,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_image_analysis_info`
--

DROP TABLE IF EXISTS `sample_image_analysis_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_image_analysis_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_image_name` tinytext,
  `sample_scaling_factor` float DEFAULT NULL,
  `sample_software_name` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_label_info`
--

DROP TABLE IF EXISTS `sample_label_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_label_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_protocol_name` tinytext,
  `sample_label_amount` int unsigned DEFAULT NULL,
  `sample_label_name` tinytext,
  `sample_label_method` tinytext,
  `sample_other_info` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_norm_info`
--

DROP TABLE IF EXISTS `sample_norm_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_norm_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_strategy` tinytext,
  `sample_algorithm` tinytext,
  `sample_ctrl_elem` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_scan_info`
--

DROP TABLE IF EXISTS `sample_scan_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_scan_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_protocol_name` tinytext,
  `sample_image_width` int unsigned DEFAULT NULL,
  `sample_image_height` int unsigned DEFAULT NULL,
  `sample_x_res` int unsigned DEFAULT NULL,
  `sample_y_res` int unsigned DEFAULT NULL,
  `sample_scanner_name` tinytext,
  `sample_software_name` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_slide_info`
--

DROP TABLE IF EXISTS `sample_slide_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_slide_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_date_hybridized` tinytext,
  `sample_slide_design_name` tinytext,
  `sample_array_source` tinytext,
  `sample_array_type` tinytext,
  `sample_num_array_spots` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_temp_data`
--

DROP TABLE IF EXISTS `sample_temp_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_temp_data` (
  `data_probeset_id` tinytext,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `data_signal` float NOT NULL DEFAULT '0',
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL DEFAULT '0',
  `data_bot_id` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `annotations_lookup`;

--
-- Table structure for table `agi_alias`
--

DROP TABLE IF EXISTS `agi_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_alias` (
  `agi` varchar(30) NOT NULL,
  `alias` varchar(30) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`agi`,`alias`,`date`),
  KEY `alias_date_agi` (`alias`,`date`,`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_annotation`
--

DROP TABLE IF EXISTS `agi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_annotation` (
  `agi` varchar(11) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`agi`,`date`),
  KEY `date_agi` (`date`,`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_ncbi_geneid`
--

DROP TABLE IF EXISTS `agi_ncbi_geneid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_ncbi_geneid` (
  `agi` varchar(30) NOT NULL,
  `geneid` varchar(30) NOT NULL,
  `date` date NOT NULL,
  KEY `gene_gi` (`geneid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_ncbi_ids`
--

DROP TABLE IF EXISTS `agi_ncbi_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_ncbi_ids` (
  `agi` varchar(30) NOT NULL DEFAULT '',
  `geneid` varchar(30) DEFAULT NULL,
  `protid` varchar(30) DEFAULT NULL,
  `date` date NOT NULL,
  KEY `agi_geneid_prot_id_date` (`agi`,`geneid`,`protid`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_ncbi_mrnaid`
--

DROP TABLE IF EXISTS `agi_ncbi_mrnaid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_ncbi_mrnaid` (
  `agi` varchar(30) NOT NULL,
  `mrnaid` varchar(30) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`mrnaid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_ncbi_protid`
--

DROP TABLE IF EXISTS `agi_ncbi_protid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_ncbi_protid` (
  `agi` varchar(30) NOT NULL,
  `protid` varchar(30) NOT NULL,
  `date` date NOT NULL,
  KEY `prot_gi` (`protid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_uniprot_lookup`
--

DROP TABLE IF EXISTS `agi_uniprot_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_uniprot_lookup` (
  `agi` varchar(30) NOT NULL,
  `uniprot` varchar(30) NOT NULL,
  `date` date NOT NULL,
  KEY `date_agi_uniport` (`date`,`agi`,`uniprot`),
  KEY `date_uniport_agi` (`date`,`uniprot`,`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `araport11_gff3`
--

DROP TABLE IF EXISTS `araport11_gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `araport11_gff3` (
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
  `Parent` varchar(512) DEFAULT NULL,
  `Attributes` varchar(256) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_agi_lookup`
--

DROP TABLE IF EXISTS `at_agi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_agi_lookup` (
  `probeset` varchar(60) NOT NULL DEFAULT '',
  `agi` varchar(30) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`probeset`,`agi`,`date`),
  KEY `date_agi_probeset` (`date`,`agi`,`probeset`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation`
--

DROP TABLE IF EXISTS `chr_seq_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation` (
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
  KEY `range` (`Source`,`SeqID`,`Start`,`End`),
  KEY `seqend` (`Source`,`SeqID`,`End`),
  KEY `typeid` (`SeqID`,`Source`,`Type`,`Parent`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`),
  KEY `Id_idx` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_upload`
--

DROP TABLE IF EXISTS `chr_upload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_upload` (
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
  `Attributes` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_annotations`
--

DROP TABLE IF EXISTS `gene_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotations` (
  `agi` varchar(12) NOT NULL,
  `annotation` longtext NOT NULL,
  `source` varchar(10) NOT NULL,
  PRIMARY KEY (`agi`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pbi_agi_lookup`
--

DROP TABLE IF EXISTS `pbi_agi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pbi_agi_lookup` (
  `probeset` varchar(60) NOT NULL DEFAULT '',
  `agi` varchar(30) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`probeset`,`agi`,`date`),
  KEY `agi` (`agi`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tair_ncbi_refseq_mapping_prot`
--

DROP TABLE IF EXISTS `tair_ncbi_refseq_mapping_prot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tair_ncbi_refseq_mapping_prot` (
  `agi` varchar(30) NOT NULL,
  `ncbi` varchar(30) NOT NULL,
  `refseq_acc` varchar(30) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tair_ncbi_refseq_mapping_rna`
--

DROP TABLE IF EXISTS `tair_ncbi_refseq_mapping_rna`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tair_ncbi_refseq_mapping_rna` (
  `agi` varchar(30) NOT NULL,
  `ncbi` varchar(30) NOT NULL,
  `refseq_acc` varchar(30) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `apple`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `apple` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `apple`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `arabidopsis_ecotypes`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_ecotypes` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_ecotypes`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Current Database: `arabidopsis_proteomics`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_proteomics` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_proteomics`;

--
-- Table structure for table `abundance`
--

DROP TABLE IF EXISTS `abundance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abundance` (
  `genotype` int NOT NULL,
  `AGI` text NOT NULL,
  `replicant` int NOT NULL,
  `zt` int NOT NULL,
  `value` decimal(10,8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rhythmicity`
--

DROP TABLE IF EXISTS `rhythmicity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rhythmicity` (
  `genotype` int NOT NULL,
  `AGI` text NOT NULL,
  `cs_acrophase` decimal(10,8) NOT NULL,
  `cs_amplitude` decimal(10,8) NOT NULL,
  `cs_pval` decimal(25,23) NOT NULL,
  `cs_qval` decimal(25,23) NOT NULL,
  `cs_mean` decimal(25,18) NOT NULL,
  `jtk_acrophase` decimal(10,8) NOT NULL,
  `jtk_amplitude` decimal(10,8) NOT NULL,
  `jtk_pval` decimal(25,23) NOT NULL,
  `jtk_qval` decimal(25,23) NOT NULL,
  `jtk_mean` decimal(25,18) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `arabidopsis_transcriptomics`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arabidopsis_transcriptomics` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arabidopsis_transcriptomics`;

--
-- Table structure for table `abundance`
--

DROP TABLE IF EXISTS `abundance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abundance` (
  `genotype` int NOT NULL,
  `AGI` varchar(12) NOT NULL,
  `replicant` int NOT NULL,
  `zt` int NOT NULL,
  `value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rhythmicity`
--

DROP TABLE IF EXISTS `rhythmicity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rhythmicity` (
  `genotype` int NOT NULL,
  `AGI` text NOT NULL,
  `cs_acrophase` decimal(10,8) NOT NULL,
  `cs_amplitude` decimal(10,8) NOT NULL,
  `cs_pval` decimal(25,23) NOT NULL,
  `cs_qval` decimal(25,23) NOT NULL,
  `cs_mean` decimal(25,18) NOT NULL,
  `jtk_acrophase` decimal(10,8) NOT NULL,
  `jtk_amplitude` decimal(10,8) NOT NULL,
  `jtk_pval` decimal(25,23) NOT NULL,
  `jtk_qval` decimal(25,23) NOT NULL,
  `jtk_mean` decimal(25,18) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `arachis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `arachis` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `arachis`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(5) NOT NULL,
  `proj_id` varchar(24) NOT NULL,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(65) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `atgenexp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `atgenexp` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `atgenexp`;

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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(50) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_ext_param`
--

DROP TABLE IF EXISTS `sample_ext_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_ext_param` (
  `sample_param_type` tinytext,
  `sample_param_index` tinytext NOT NULL,
  `sample_param_data` tinytext NOT NULL,
  `sample_param_ontology` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `sample_temp_data`
--

DROP TABLE IF EXISTS `sample_temp_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_temp_data` (
  `data_probeset_id` tinytext,
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `atgenexp_hormone`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `atgenexp_hormone` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `atgenexp_hormone`;

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
  `sample_growth_condition` tinytext,
  `sample_growth_stage` tinytext,
  `sample_time_point` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(50) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_ext_param`
--

DROP TABLE IF EXISTS `sample_ext_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_ext_param` (
  `sample_param_type` tinytext NOT NULL,
  `sample_param_index` tinytext,
  `sample_param_data` tinytext,
  `sample_param_ontology` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `sample_temp_data`
--

DROP TABLE IF EXISTS `sample_temp_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_temp_data` (
  `data_probeset_id` tinytext,
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seed_data`
--

DROP TABLE IF EXISTS `seed_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seed_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` tinytext,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(6)),
  KEY `data_probeset_id` (`data_probeset_id`(6),`data_bot_id`(20)),
  KEY `data_bot_id` (`data_bot_id`(20))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `atgenexp_pathogen`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `atgenexp_pathogen` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `atgenexp_pathogen`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL,
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
  `proj_num_samps` tinytext,
  PRIMARY KEY (`proj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_bio_name` tinytext,
  `sample_organism` tinytext,
  `sample_alias` tinytext,
  `sample_stock_code` tinytext,
  `sample_genetic_var` tinytext,
  `sample_tissue` tinytext,
  `sample_diseased` tinytext,
  `sample_growth_condition` tinytext,
  `sample_growth_stage` tinytext,
  `sample_time_point` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float DEFAULT NULL,
  `data_call` tinytext,
  `data_p_val` float DEFAULT NULL,
  `data_bot_id` varchar(50) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_ext_param`
--

DROP TABLE IF EXISTS `sample_ext_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_ext_param` (
  `sample_param_type` tinytext NOT NULL,
  `sample_param_index` tinytext,
  `sample_param_data` tinytext,
  `sample_param_ontology` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext,
  `sample_name` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_temp_data`
--

DROP TABLE IF EXISTS `sample_temp_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_temp_data` (
  `data_probeset_id` tinytext,
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `atgenexp_plus`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `atgenexp_plus` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `atgenexp_plus`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `ranks`
--

DROP TABLE IF EXISTS `ranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ranks` (
  `expression` float DEFAULT NULL,
  `rank` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`rank`),
  KEY `expression_idx` (`expression`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(50) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_ext_param`
--

DROP TABLE IF EXISTS `sample_ext_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_ext_param` (
  `sample_param_type` tinytext,
  `sample_param_index` tinytext NOT NULL,
  `sample_param_data` tinytext NOT NULL,
  `sample_param_ontology` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext NOT NULL,
  `sample_name` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `proj_id` (`proj_id`),
  KEY `idx` (`proj_id`,`sample_repl`(12),`sample_ctrl`(12),`sample_bot_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_temp_data`
--

DROP TABLE IF EXISTS `sample_temp_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_temp_data` (
  `data_probeset_id` tinytext,
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `atgenexp_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `atgenexp_stress` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `atgenexp_stress`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(30) DEFAULT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_call` varchar(20) DEFAULT NULL,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(40) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_ext_param`
--

DROP TABLE IF EXISTS `sample_ext_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_ext_param` (
  `sample_param_type` tinytext,
  `sample_param_index` tinytext NOT NULL,
  `sample_param_data` tinytext NOT NULL,
  `sample_param_ontology` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_temp_data`
--

DROP TABLE IF EXISTS `sample_temp_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_temp_data` (
  `data_probeset_id` tinytext,
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `bar_api_db_api_test`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bar_api_db_api_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `bar_api_db_api_test`;

--
-- Current Database: `barley_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `barley_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `barley_annotations_lookup`;

--
-- Table structure for table `at_bar_lookup`
--

DROP TABLE IF EXISTS `at_bar_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_bar_lookup` (
  `bar` varchar(30) NOT NULL,
  `probeset` varchar(30) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`bar`,`date`),
  KEY `date_gene` (`bar`,`probeset`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bar_annotation`
--

DROP TABLE IF EXISTS `bar_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bar_annotation` (
  `bar` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `go_annotation` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`bar`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `barley_seed_lookup`
--

DROP TABLE IF EXISTS `barley_seed_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barley_seed_lookup` (
  `gene` varchar(32) NOT NULL,
  `probeset` varchar(32) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`gene`,`date`),
  KEY `date_gene` (`gene`,`probeset`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `barley_mas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `barley_mas` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `barley_mas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  `sample_tissue` varchar(20) DEFAULT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `barley_rma`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `barley_rma` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `barley_rma`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `barley_seed`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `barley_seed` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `barley_seed`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `barley_spike_meristem`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `barley_spike_meristem` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `barley_spike_meristem`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `barley_spike_meristem_v3`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `barley_spike_meristem_v3` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `barley_spike_meristem_v3`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `bayer_canola_expressolog`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bayer_canola_expressolog` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `bayer_canola_expressolog`;

--
-- Table structure for table `annotations`
--

DROP TABLE IF EXISTS `annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annotations` (
  `gene` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis`
--

DROP TABLE IF EXISTS `arabidopsis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_canola_expressolog`
--

DROP TABLE IF EXISTS `arabidopsis_canola_expressolog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_canola_expressolog` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `canola`
--

DROP TABLE IF EXISTS `canola`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `canola` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`),
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tissue_equivalency`
--

DROP TABLE IF EXISTS `tissue_equivalency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tissue_equivalency` (
  `Tissue_A` varchar(100) DEFAULT NULL,
  `Species_A` varchar(100) DEFAULT NULL,
  `Tissue_B` varchar(100) DEFAULT NULL,
  `Species_B` varchar(100) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `brachypodium`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `brachypodium` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `brachypodium`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(50) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `brachypodium_Bd21`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `brachypodium_Bd21` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `brachypodium_Bd21`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `brachypodium_embryogenesis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `brachypodium_embryogenesis` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `brachypodium_embryogenesis`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(50) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `brachypodium_grains`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `brachypodium_grains` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `brachypodium_grains`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `brachypodium_metabolites_map`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `brachypodium_metabolites_map` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `brachypodium_metabolites_map`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_signal` float DEFAULT NULL,
  `data_bot_id` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `brachypodium_photo_thermocycle`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `brachypodium_photo_thermocycle` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `brachypodium_photo_thermocycle`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `brassica_rapa`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `brassica_rapa` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `brassica_rapa`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(10) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_developmental_atlas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_developmental_atlas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_developmental_atlas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_developmental_atlas_sca`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_developmental_atlas_sca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_developmental_atlas_sca`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_drought_diurnal_atlas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_drought_diurnal_atlas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_drought_diurnal_atlas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_drought_diurnal_atlas_sca`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_drought_diurnal_atlas_sca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_drought_diurnal_atlas_sca`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_infection`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_infection` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_infection`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(24) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_leaf`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_leaf` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_leaf`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_meristem_atlas_sca`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_meristem_atlas_sca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_meristem_atlas_sca`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(24) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cacao_seed_atlas_sca`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cacao_seed_atlas_sca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cacao_seed_atlas_sca`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(24) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `camelina`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `camelina` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `camelina`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(5) NOT NULL,
  `proj_id` varchar(5) NOT NULL,
  `sample_file_name` varchar(20) DEFAULT NULL,
  `data_probeset_id` varchar(20) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`),
  KEY `data_bot_id` (`data_bot_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `camelina_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `camelina_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `camelina_annotations_lookup`;

--
-- Table structure for table `camelina_lookup`
--

DROP TABLE IF EXISTS `camelina_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `camelina_lookup` (
  `camelina_gene` varchar(30) NOT NULL,
  `arabidopsis_gene` varchar(15) NOT NULL,
  `date` date NOT NULL,
  KEY `agi` (`arabidopsis_gene`),
  KEY `camelina` (`camelina_gene`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `camelina_tpm`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `camelina_tpm` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `camelina_tpm`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(5) NOT NULL,
  `proj_id` varchar(5) NOT NULL,
  `sample_file_name` varchar(20) DEFAULT NULL,
  `data_probeset_id` varchar(20) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`),
  KEY `data_bot_id` (`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cannabis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cannabis` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cannabis`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `canola`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `canola` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `canola`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(100) NOT NULL DEFAULT '0',
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
  `proj_num_samps` tinyint unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(200) NOT NULL DEFAULT '0',
  `sample_bio_name` tinytext,
  `sample_organism` tinytext,
  `sample_alias` tinytext,
  `sample_stock_code` tinytext,
  `sample_genetic_var` tinytext,
  `sample_tissue` tinytext,
  `sample_diseased` tinytext,
  `sample_growth_cond` tinytext,
  `sample_growth_stage` tinytext,
  `sample_time_point` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` text NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(100)),
  KEY `data_probeset_id` (`data_probeset_id`(30),`data_bot_id`(20)),
  KEY `data_bot_id` (`data_bot_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(100) NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext NOT NULL,
  `sample_name` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `canola_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `canola_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `canola_annotations_lookup`;

--
-- Table structure for table `gene_annotation_lookup`
--

DROP TABLE IF EXISTS `gene_annotation_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation_lookup` (
  `gene` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_annotation_lookup_v5`
--

DROP TABLE IF EXISTS `gene_annotation_lookup_v5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation_lookup_v5` (
  `gene` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `canola_nssnp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `canola_nssnp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `canola_nssnp`;

--
-- Table structure for table `protein_reference`
--

DROP TABLE IF EXISTS `protein_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protein_reference` (
  `protein_reference_id` int NOT NULL AUTO_INCREMENT,
  `gene_name` varchar(45) NOT NULL,
  `gene_identifier` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`protein_reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101041 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=398050 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `canola_original`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `canola_original` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `canola_original`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(100) NOT NULL DEFAULT '0',
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
  `proj_num_samps` tinyint unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(200) NOT NULL DEFAULT '0',
  `sample_bio_name` tinytext,
  `sample_organism` tinytext,
  `sample_alias` tinytext,
  `sample_stock_code` tinytext,
  `sample_genetic_var` tinytext,
  `sample_tissue` tinytext,
  `sample_diseased` tinytext,
  `sample_growth_cond` tinytext,
  `sample_growth_stage` tinytext,
  `sample_time_point` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` text NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(100)),
  KEY `data_probeset_id` (`data_probeset_id`(100))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(100) NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext NOT NULL,
  `sample_name` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `canola_original_v2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `canola_original_v2` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `canola_original_v2`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(100) NOT NULL DEFAULT '0',
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
  `proj_num_samps` tinyint unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(200) NOT NULL DEFAULT '0',
  `sample_bio_name` tinytext,
  `sample_organism` tinytext,
  `sample_alias` tinytext,
  `sample_stock_code` tinytext,
  `sample_genetic_var` tinytext,
  `sample_tissue` tinytext,
  `sample_diseased` tinytext,
  `sample_growth_cond` tinytext,
  `sample_growth_stage` tinytext,
  `sample_time_point` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` text NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(100)),
  KEY `data_probeset_id` (`data_probeset_id`(100))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(100) NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext NOT NULL,
  `sample_name` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `canola_seed`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `canola_seed` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `canola_seed`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cassava_atlas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cassava_atlas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cassava_atlas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cassava_cbb`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cassava_cbb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cassava_cbb`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cassava_eacmv`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cassava_eacmv` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cassava_eacmv`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `circadian_mutants`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `circadian_mutants` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `circadian_mutants`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(18) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cistome`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cistome` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cistome`;

--
-- Table structure for table `agis`
--

DROP TABLE IF EXISTS `agis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agis` (
  `uniq` int NOT NULL,
  `id` int NOT NULL,
  `motif` varchar(30) NOT NULL,
  `agi` varchar(30) NOT NULL,
  `alias` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`uniq`),
  KEY `agi` (`agi`),
  KEY `motif_agi_alias` (`motif`,`agi`,`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_agis`
--

DROP TABLE IF EXISTS `cluster_agis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_agis` (
  `id` varchar(4) NOT NULL,
  `cluster` varchar(50) NOT NULL,
  `agis` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data`
--

DROP TABLE IF EXISTS `data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data` (
  `id` int NOT NULL,
  `cluster` varchar(100) NOT NULL,
  `pssm` text NOT NULL,
  `consensus` varchar(200) NOT NULL,
  `agis` mediumtext NOT NULL,
  `ref_free_text` varchar(100) DEFAULT NULL,
  `ref_pubmed_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_pssm_idx` (`pssm`(20)),
  KEY `cluster_agis` (`cluster`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jaspar_consensus`
--

DROP TABLE IF EXISTS `jaspar_consensus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jaspar_consensus` (
  `ID` varchar(10) NOT NULL,
  `consensus` varchar(30) NOT NULL,
  `alias` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `premapped_jaspar_motifs`
--

DROP TABLE IF EXISTS `premapped_jaspar_motifs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `premapped_jaspar_motifs` (
  `SeqID` varchar(15) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Score` float DEFAULT NULL,
  `pvalue` float DEFAULT NULL,
  `qvalue` float DEFAULT NULL,
  `match_seq` varchar(40) DEFAULT NULL,
  `motif` varchar(20) DEFAULT NULL,
  `ic` float DEFAULT NULL,
  `fd` float DEFAULT NULL,
  `Attribute` varchar(50) DEFAULT NULL,
  KEY `premapped_idx` (`SeqID`,`End`,`Start`,`qvalue`,`pvalue`,`Strand`,`match_seq`,`motif`,`ic`,`fd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `premapped_weirauch_motifs`
--

DROP TABLE IF EXISTS `premapped_weirauch_motifs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `premapped_weirauch_motifs` (
  `SeqID` varchar(15) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Score` float DEFAULT NULL,
  `pvalue` float DEFAULT NULL,
  `qvalue` float DEFAULT NULL,
  `match_seq` varchar(40) DEFAULT NULL,
  `motif` varchar(20) DEFAULT NULL,
  `ic` float DEFAULT NULL,
  `fd` float DEFAULT NULL,
  `Attribute` varchar(50) DEFAULT NULL,
  KEY `premapped_idx` (`SeqID`,`End`,`Start`,`qvalue`,`pvalue`,`Strand`,`match_seq`,`motif`,`ic`,`fd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `premapped_yu_motifs`
--

DROP TABLE IF EXISTS `premapped_yu_motifs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `premapped_yu_motifs` (
  `SeqID` varchar(15) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Score` float DEFAULT NULL,
  `pvalue` float DEFAULT NULL,
  `qvalue` float DEFAULT NULL,
  `match_seq` varchar(40) DEFAULT NULL,
  `motif` varchar(20) DEFAULT NULL,
  `ic` float DEFAULT NULL,
  `fd` float DEFAULT NULL,
  `Attribute` varchar(50) DEFAULT NULL,
  KEY `premapped_idx` (`SeqID`,`End`,`Start`,`qvalue`,`pvalue`,`Strand`,`match_seq`,`motif`,`ic`,`fd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pssm_consensus`
--

DROP TABLE IF EXISTS `pssm_consensus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pssm_consensus` (
  `id` int NOT NULL,
  `cluster` varchar(40) NOT NULL,
  `pssm` varchar(100) NOT NULL,
  `consensus` varchar(100) NOT NULL,
  `agis` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cistome_legacy`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cistome_legacy` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cistome_legacy`;

--
-- Table structure for table `cluster_agis`
--

DROP TABLE IF EXISTS `cluster_agis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_agis` (
  `id` varchar(4) NOT NULL,
  `cluster` varchar(50) NOT NULL,
  `agis` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data`
--

DROP TABLE IF EXISTS `data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data` (
  `id` int NOT NULL,
  `cluster` varchar(100) NOT NULL,
  `pssm` varchar(300) NOT NULL,
  `consensus` varchar(200) NOT NULL,
  `agis` mediumtext NOT NULL,
  `ref_free_text` varchar(100) DEFAULT NULL,
  `ref_pubmed_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cluster_agis` (`cluster`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pssm_consensus`
--

DROP TABLE IF EXISTS `pssm_consensus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pssm_consensus` (
  `id` int NOT NULL,
  `cluster` varchar(40) NOT NULL,
  `pssm` varchar(100) NOT NULL,
  `consensus` varchar(100) NOT NULL,
  `agis` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cort_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cort_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cort_db`;

--
-- Table structure for table `Metadata`
--

DROP TABLE IF EXISTS `Metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Metadata` (
  `ID` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `BSG_94_percent` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `GenBank_Accession` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Herbarium_Accession` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Collection_Number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Genus` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Species` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `Continent` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Country` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Province/State` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Location` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Habitat` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Source` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Date_of_Collection` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `Collector` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Determiner` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Type_Specimen` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Sequence_Location` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `Publications` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `Sequence` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `current_mappings`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `current_mappings` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `current_mappings`;

--
-- Table structure for table `lookups`
--

DROP TABLE IF EXISTS `lookups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lookups` (
  `organism` varchar(50) NOT NULL,
  `geneid_column_name` varchar(12) NOT NULL,
  `annot_db_name` varchar(40) NOT NULL,
  `lookup_file_name` varchar(100) DEFAULT NULL,
  `lookup_source` varchar(50) DEFAULT NULL,
  `lookup_file_date` date DEFAULT NULL,
  `lookup_version` varchar(30) DEFAULT NULL,
  `lookup_table_name` varchar(50) DEFAULT NULL,
  `annotation_file_name` varchar(100) DEFAULT NULL,
  `annotation_source` varchar(40) DEFAULT NULL,
  `annot_file_date` date NOT NULL,
  `annot_version` varchar(30) DEFAULT NULL,
  `annot_table_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cuscuta`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cuscuta` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cuscuta`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cuscuta_early_haustoriogenesis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cuscuta_early_haustoriogenesis` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cuscuta_early_haustoriogenesis`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `cuscuta_lmd`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cuscuta_lmd` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cuscuta_lmd`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `dna_damage`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dna_damage` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `dna_damage`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(10) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(32) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `docking_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `docking_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `docking_db`;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results` (
  `protein` varchar(20) DEFAULT NULL,
  `ligand` varchar(20) DEFAULT NULL,
  `data` varchar(65480) DEFAULT NULL,
  `predicted` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `durum_wheat_abiotic_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `durum_wheat_abiotic_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `durum_wheat_abiotic_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `durum_wheat_biotic_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `durum_wheat_biotic_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `durum_wheat_biotic_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(42) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `durum_wheat_development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `durum_wheat_development` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `durum_wheat_development`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `efp_seq_browser`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `efp_seq_browser` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `efp_seq_browser`;

--
-- Table structure for table `data`
--

DROP TABLE IF EXISTS `data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `file` varchar(64) NOT NULL,
  `title` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_user_index` (`user_id`),
  CONSTRAINT `data_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `efpexpressiondata`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `efpexpressiondata` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `efpexpressiondata`;

--
-- Table structure for table `Barley_20131203131233`
--

DROP TABLE IF EXISTS `Barley_20131203131233`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Barley_20131203131233` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Barley_20131203131233_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Barley_20131203131234`
--

DROP TABLE IF EXISTS `Barley_20131203131234`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Barley_20131203131234` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Barley_20131203131234_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Barley_20131203131248`
--

DROP TABLE IF EXISTS `Barley_20131203131248`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Barley_20131203131248` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Barley_20131203131248_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Barley_20131203131256`
--

DROP TABLE IF EXISTS `Barley_20131203131256`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Barley_20131203131256` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Barley_20131203131256_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Bigfile_test_20120905130928`
--

DROP TABLE IF EXISTS `Bigfile_test_20120905130928`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bigfile_test_20120905130928` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Bigfile_test_20120905140953`
--

DROP TABLE IF EXISTS `Bigfile_test_20120905140953`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bigfile_test_20120905140953` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_20120829`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_20120829`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_20120829` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120822040812_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_LRI_20120705050723`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_LRI_20120705050723`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_LRI_20120705050723` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_LRI_20120821030854`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_LRI_20120821030854`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_LRI_20120821030854` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120821030854_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_LRI_20120821050803`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_LRI_20120821050803`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_LRI_20120821050803` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120821050803_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_LRI_20120821050842`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_LRI_20120821050842`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_LRI_20120821050842` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120821050842_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_LRI_20120822040812`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_LRI_20120822040812`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_LRI_20120822040812` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120822040812_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_LRI_20120822040829`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_LRI_20120822040829`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_LRI_20120822040829` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120822040829_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_Root_Initiation_LRI_20120822040854`
--

DROP TABLE IF EXISTS `Lateral_Root_Initiation_LRI_20120822040854`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_Root_Initiation_LRI_20120822040854` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120822040854_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lateral_root_initiation_20120711130737`
--

DROP TABLE IF EXISTS `Lateral_root_initiation_20120711130737`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lateral_root_initiation_20120711130737` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_root_initiation_20120711130737_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Medicago_truncatula_20130812080825`
--

DROP TABLE IF EXISTS `Medicago_truncatula_20130812080825`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Medicago_truncatula_20130812080825` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Medicago_truncatula_20130812080825_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Medicago_truncatula_20130812080837`
--

DROP TABLE IF EXISTS `Medicago_truncatula_20130812080837`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Medicago_truncatula_20130812080837` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Medicago_truncatula_20130812080837_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130114100145`
--

DROP TABLE IF EXISTS `My_EucaMap_20130114100145`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130114100145` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130114100145_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130114110101`
--

DROP TABLE IF EXISTS `My_EucaMap_20130114110101`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130114110101` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130114110101_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130130070111`
--

DROP TABLE IF EXISTS `My_EucaMap_20130130070111`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130130070111` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130130070111_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130130070153`
--

DROP TABLE IF EXISTS `My_EucaMap_20130130070153`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130130070153` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130130070153_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130306030303`
--

DROP TABLE IF EXISTS `My_EucaMap_20130306030303`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130306030303` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130306030303_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130306030342`
--

DROP TABLE IF EXISTS `My_EucaMap_20130306030342`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130306030342` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130306030342_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130306030345`
--

DROP TABLE IF EXISTS `My_EucaMap_20130306030345`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130306030345` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130306030345_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_EucaMap_20130605100642`
--

DROP TABLE IF EXISTS `My_EucaMap_20130605100642`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_EucaMap_20130605100642` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_EucaMap_20130605100642_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_eFP_Browser_20120223110201`
--

DROP TABLE IF EXISTS `My_eFP_Browser_20120223110201`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_eFP_Browser_20120223110201` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_eFP_Browser_20120223110201_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_eFP_Test_20120216140211`
--

DROP TABLE IF EXISTS `My_eFP_Test_20120216140211`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_eFP_Test_20120216140211` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `My_eFP_Test_20120216140211_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_eFP_Test_20120221120222`
--

DROP TABLE IF EXISTS `My_eFP_Test_20120221120222`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_eFP_Test_20120221120222` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `My_eFP_Test_20120221120243`
--

DROP TABLE IF EXISTS `My_eFP_Test_20120221120243`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `My_eFP_Test_20120221120243` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Physcomitrella_20140729070741`
--

DROP TABLE IF EXISTS `Physcomitrella_20140729070741`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Physcomitrella_20140729070741` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Physcomitrella_20140729070741_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Physcomitrella_20140730030721`
--

DROP TABLE IF EXISTS `Physcomitrella_20140730030721`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Physcomitrella_20140730030721` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Physcomitrella_20140730030721_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Physcomitrella_20140731050737`
--

DROP TABLE IF EXISTS `Physcomitrella_20140731050737`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Physcomitrella_20140731050737` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Physcomitrella_20140731050737_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Physcomitrella_20140731060719`
--

DROP TABLE IF EXISTS `Physcomitrella_20140731060719`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Physcomitrella_20140731060719` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Physcomitrella_20140731060719_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Physcomitrella_20140731070729`
--

DROP TABLE IF EXISTS `Physcomitrella_20140731070729`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Physcomitrella_20140731070729` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Physcomitrella_20140731070729_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Physcomitrella_20140807100846`
--

DROP TABLE IF EXISTS `Physcomitrella_20140807100846`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Physcomitrella_20140807100846` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Physcomitrella_20140807100846_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TisHormone_test_20120216110205`
--

DROP TABLE IF EXISTS `TisHormone_test_20120216110205`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TisHormone_test_20120216110205` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `TisHormone_test_20120216110205_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209110225`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209110225`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209110225` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209110251`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209110251`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209110251` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209120205`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209120205`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209120205` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209120215`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209120215`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209120215` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209120223`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209120223`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209120223` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209120231`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209120231`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209120231` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209120234`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209120234`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209120234` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209120255`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209120255`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209120255` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209160207`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209160207`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209160207` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120209170227`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120209170227`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120209170227` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Tissue_Hormone_20120209170227_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_Hormone_20120216110253`
--

DROP TABLE IF EXISTS `Tissue_Hormone_20120216110253`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_Hormone_20120216110253` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Tissue_Hormone_20120216110253_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_hormone_20120209170202`
--

DROP TABLE IF EXISTS `Tissue_hormone_20120209170202`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_hormone_20120209170202` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Tissue_hormone_20120209170202_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tissue_hormone_20120209170214`
--

DROP TABLE IF EXISTS `Tissue_hormone_20120209170214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tissue_hormone_20120209170214` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `abc_20130924160934`
--

DROP TABLE IF EXISTS `abc_20130924160934`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abc_20130924160934` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `abc_20130924160934_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eFP_lateral_root_initiation_20120820110854`
--

DROP TABLE IF EXISTS `eFP_lateral_root_initiation_20120820110854`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eFP_lateral_root_initiation_20120820110854` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `eFP_lateral_root_initiation_20120820110854_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `efp_views`
--

DROP TABLE IF EXISTS `efp_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `efp_views` (
  `view_file` varchar(70) NOT NULL,
  `view_name` varchar(50) NOT NULL,
  `species` varchar(50) NOT NULL,
  `publish` tinyint(1) NOT NULL DEFAULT '0',
  `organization` varchar(40) DEFAULT NULL,
  `contact_name` varchar(40) NOT NULL,
  `contact_email` varchar(40) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `released` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`view_file`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gdowns_maize_20141128101112`
--

DROP TABLE IF EXISTS `gdowns_maize_20141128101112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gdowns_maize_20141128101112` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gdowns_maize_20141128101113`
--

DROP TABLE IF EXISTS `gdowns_maize_20141128101113`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gdowns_maize_20141128101113` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gdowns_maize_20141128111137`
--

DROP TABLE IF EXISTS `gdowns_maize_20141128111137`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gdowns_maize_20141128111137` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `gdowns_maize_20141128111137_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gtestsers_20120222130254`
--

DROP TABLE IF EXISTS `gtestsers_20120222130254`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gtestsers_20120222130254` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gtestsers_20120222130258`
--

DROP TABLE IF EXISTS `gtestsers_20120222130258`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gtestsers_20120222130258` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gtestsers_20120222140200`
--

DROP TABLE IF EXISTS `gtestsers_20120222140200`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gtestsers_20120222140200` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `gtestsers_20120222140200_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gtestsers_20120222140231`
--

DROP TABLE IF EXISTS `gtestsers_20120222140231`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gtestsers_20120222140231` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `gtestsers_20120222140231_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_eFP_test_20140325070309`
--

DROP TABLE IF EXISTS `my_eFP_test_20140325070309`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_eFP_test_20140325070309` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `my_eFP_test_20140325070309_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_eFP_test_20140325070323`
--

DROP TABLE IF EXISTS `my_eFP_test_20140325070323`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_eFP_test_20140325070323` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_eFP_test_20140325070340`
--

DROP TABLE IF EXISTS `my_eFP_test_20140325070340`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_eFP_test_20140325070340` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `my_eFP_test_20140325070340_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_eFP_test_20140325070341`
--

DROP TABLE IF EXISTS `my_eFP_test_20140325070341`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_eFP_test_20140325070341` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `my_eFP_test_20140325070341_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_eFP_test_20140325070345`
--

DROP TABLE IF EXISTS `my_eFP_test_20140325070345`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_eFP_test_20140325070345` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `my_eFP_test_20140325070345_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_eFP_test_20140325070353`
--

DROP TABLE IF EXISTS `my_eFP_test_20140325070353`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_eFP_test_20140325070353` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_eFP_test_20140325070357`
--

DROP TABLE IF EXISTS `my_eFP_test_20140325070357`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_eFP_test_20140325070357` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tesrsersr_20120218100207`
--

DROP TABLE IF EXISTS `tesrsersr_20120218100207`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tesrsersr_20120218100207` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tesrsersr_20120218100209`
--

DROP TABLE IF EXISTS `tesrsersr_20120218100209`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tesrsersr_20120218100209` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `tesrsersr_20120218100209_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tesrsfds_20120227140230`
--

DROP TABLE IF EXISTS `tesrsfds_20120227140230`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tesrsfds_20120227140230` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `tesrsfds_20120227140230_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test342_20120215110254`
--

DROP TABLE IF EXISTS `test342_20120215110254`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test342_20120215110254` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test342_20120215110254_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120207150201`
--

DROP TABLE IF EXISTS `test_20120207150201`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120207150201` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120207150224`
--

DROP TABLE IF EXISTS `test_20120207150224`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120207150224` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120209110224`
--

DROP TABLE IF EXISTS `test_20120209110224`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120209110224` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120209110240`
--

DROP TABLE IF EXISTS `test_20120209110240`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120209110240` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120209130209`
--

DROP TABLE IF EXISTS `test_20120209130209`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120209130209` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_20120209130209_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120209130225`
--

DROP TABLE IF EXISTS `test_20120209130225`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120209130225` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_20120209130225_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120209130229`
--

DROP TABLE IF EXISTS `test_20120209130229`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120209130229` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_20120209130229_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20120209130237`
--

DROP TABLE IF EXISTS `test_20120209130237`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20120209130237` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_20120209130237_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_20140729070702`
--

DROP TABLE IF EXISTS `test_20140729070702`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_20140729070702` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_20140729070702_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_23423904wsd_20120501090505`
--

DROP TABLE IF EXISTS `test_23423904wsd_20120501090505`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_23423904wsd_20120501090505` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_23423904wsd_20120501090505_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_23423904wsd_20120501090511`
--

DROP TABLE IF EXISTS `test_23423904wsd_20120501090511`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_23423904wsd_20120501090511` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_23423904wsd_20120501090511_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_23423904wsd_20120501090515`
--

DROP TABLE IF EXISTS `test_23423904wsd_20120501090515`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_23423904wsd_20120501090515` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_23423904wsd_20120501090515_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_23423904wsd_20120501090523`
--

DROP TABLE IF EXISTS `test_23423904wsd_20120501090523`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_23423904wsd_20120501090523` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_23423904wsd_20120501090523_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_23423904wsd_20120501090557`
--

DROP TABLE IF EXISTS `test_23423904wsd_20120501090557`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_23423904wsd_20120501090557` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_23423904wsd_20120501090557_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_eFP_20140325160308`
--

DROP TABLE IF EXISTS `test_eFP_20140325160308`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_eFP_20140325160308` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_eFP_20140325160308_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_eFP_20140325160322`
--

DROP TABLE IF EXISTS `test_eFP_20140325160322`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_eFP_20140325160322` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_eFP_20140325160322_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_eFP_20140325160324`
--

DROP TABLE IF EXISTS `test_eFP_20140325160324`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_eFP_20140325160324` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_eFP_20140325160324_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_eFP_20140325160337`
--

DROP TABLE IF EXISTS `test_eFP_20140325160337`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_eFP_20140325160337` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `test_eFP_20140325160337_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `testser_20120222140246`
--

DROP TABLE IF EXISTS `testser_20120222140246`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testser_20120222140246` (
  `sample_id` int NOT NULL,
  `project_id` int NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `testser_20120222140246_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `thellungiella`
--

DROP TABLE IF EXISTS `thellungiella`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thellungiella` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `Lateral_Root_Initiation_LRI_20120822040812_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tsa_test_20121005151054`
--

DROP TABLE IF EXISTS `tsa_test_20121005151054`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsa_test_20121005151054` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `tsa_test_20121005151054_idx` (`data_probeset_id`,`data_bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zip_upload_20120910150906`
--

DROP TABLE IF EXISTS `zip_upload_20120910150906`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zip_upload_20120910150906` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zip_upload_20120910150949`
--

DROP TABLE IF EXISTS `zip_upload_20120910150949`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zip_upload_20120910150949` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `embryo`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `embryo` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `embryo`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(3) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant2` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant2`;

--
-- Table structure for table `1001_genomes_lookup`
--

DROP TABLE IF EXISTS `1001_genomes_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `1001_genomes_lookup` (
  `id` varchar(8) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `lookup` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`,`lookup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `agi_alias`
--

DROP TABLE IF EXISTS `agi_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_alias` (
  `agi` varchar(30) NOT NULL,
  `alias` varchar(30) NOT NULL,
  PRIMARY KEY (`agi`,`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `agi_names`
--

DROP TABLE IF EXISTS `agi_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_names` (
  `agi` varchar(30) NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`agi`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_uniprot_lookup`
--

DROP TABLE IF EXISTS `agi_uniprot_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_uniprot_lookup` (
  `agi` varchar(30) NOT NULL,
  `uniprot` varchar(30) NOT NULL,
  KEY `idx_agi` (`agi`),
  KEY `idx_uniprot` (`uniprot`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `araport11_gff3`
--

DROP TABLE IF EXISTS `araport11_gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `araport11_gff3` (
  `SeqID` varchar(10) NOT NULL,
  `Source` varchar(12) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `binding`
--

DROP TABLE IF EXISTS `binding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `binding` (
  `id` varchar(25) NOT NULL,
  `residue` varchar(5) NOT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`,`residue`,`position`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `gene_alias`
--

DROP TABLE IF EXISTS `gene_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_alias` (
  `gene` varchar(16) NOT NULL,
  `symbol` varchar(32) NOT NULL,
  `synonyms` varchar(128) DEFAULT NULL,
  KEY `alias_idx` (`gene`,`symbol`,`synonyms`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hmmpred`
--

DROP TABLE IF EXISTS `hmmpred`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hmmpred` (
  `agi` varchar(16) NOT NULL,
  `template` varchar(16) NOT NULL,
  `hmmpred_evalue` float NOT NULL,
  `link` varchar(128) NOT NULL,
  KEY `hmm_index` (`agi`,`template`,`hmmpred_evalue`,`link`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `isoforms`
--

DROP TABLE IF EXISTS `isoforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `isoforms` (
  `gene` varchar(10) NOT NULL,
  `isoform` varchar(12) NOT NULL,
  KEY `idx_gene_isoform` (`gene`,`isoform`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdb_experimental`
--

DROP TABLE IF EXISTS `pdb_experimental`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdb_experimental` (
  `agi` varchar(16) NOT NULL,
  `model` varchar(8) NOT NULL,
  `isoform` varchar(3) DEFAULT NULL,
  KEY `agi_model_isoform` (`agi`,`model`,`isoform`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publications`
--

DROP TABLE IF EXISTS `publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publications` (
  `gene` varchar(12) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `author` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `journal` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `pubmed` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  KEY `gene_idx` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reactome`
--

DROP TABLE IF EXISTS `reactome`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reactome` (
  `gene_id` varchar(12) NOT NULL,
  `pathway_id` varchar(18) NOT NULL,
  KEY `reactome_index` (`gene_id`,`pathway_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reactome_reactions`
--

DROP TABLE IF EXISTS `reactome_reactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reactome_reactions` (
  `gene_id` varchar(12) NOT NULL,
  `reaction_id` varchar(18) NOT NULL,
  KEY `reactome_reactions_index` (`gene_id`,`reaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tair10_gff3`
--

DROP TABLE IF EXISTS `tair10_gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
-- Current Database: `eplant_barley`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_barley` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_barley`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(50) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_barley_legacy`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_barley_legacy` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_barley_legacy`;

--
-- Table structure for table `functional_descriptions`
--

DROP TABLE IF EXISTS `functional_descriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `functional_descriptions` (
  `Model_name` varchar(16) NOT NULL,
  `Type` varchar(32) DEFAULT NULL,
  `Short_description` text,
  `Curator_summary` text,
  `Computational_description` text,
  KEY `Model_name_idx` (`Model_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_camelina`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_camelina` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_camelina`;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(18) NOT NULL,
  `Source` varchar(10) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(28) DEFAULT NULL,
  `Parent` varchar(28) DEFAULT NULL,
  `Attributes` varchar(28) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_cassava`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_cassava` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_cassava`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(50) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_eucalyptus`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_eucalyptus` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_eucalyptus`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(50) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_maize`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_maize` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_maize`;

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
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(20) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3_v3`
--

DROP TABLE IF EXISTS `gff3_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3_v3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3_v4`
--

DROP TABLE IF EXISTS `gff3_v4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3_v4` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maize_lookup_v4`
--

DROP TABLE IF EXISTS `maize_lookup_v4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maize_lookup_v4` (
  `probeset` varchar(24) NOT NULL,
  `gene_id` varchar(24) NOT NULL,
  KEY `gene_probeset` (`gene_id`,`probeset`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publications`
--

DROP TABLE IF EXISTS `publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publications` (
  `gene` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `author` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `journal` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `pubmed` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  KEY `gene_idx` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_medicago`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_medicago` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_medicago`;

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
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(50) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdb_predicted_files`
--

DROP TABLE IF EXISTS `pdb_predicted_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdb_predicted_files` (
  `gene` varchar(24) NOT NULL,
  `template` varchar(6) NOT NULL,
  `confidence` float NOT NULL,
  KEY `pdb_predicted_index` (`gene`,`template`,`confidence`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publications`
--

DROP TABLE IF EXISTS `publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publications` (
  `gene` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `year` varchar(6) NOT NULL,
  `journal` varchar(64) NOT NULL,
  `title` text NOT NULL,
  `pubmed` varchar(16) NOT NULL,
  KEY `gene_idx` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_poplar`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_poplar` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_poplar`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(20) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3_v3`
--

DROP TABLE IF EXISTS `gff3_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3_v3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `isoforms`
--

DROP TABLE IF EXISTS `isoforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `isoforms` (
  `gene` varchar(20) NOT NULL,
  `isoform` varchar(24) NOT NULL,
  KEY `idx_gene_isoform` (`gene`,`isoform`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdb_predicted_files`
--

DROP TABLE IF EXISTS `pdb_predicted_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdb_predicted_files` (
  `gene` varchar(24) NOT NULL,
  `template` varchar(6) NOT NULL,
  `confidence` float NOT NULL,
  KEY `pdb_predicted_index` (`gene`,`template`,`confidence`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_potato`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_potato` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_potato`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(50) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(50) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_rice`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_rice` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_rice`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(20) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3_msu`
--

DROP TABLE IF EXISTS `gff3_msu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3_msu` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_soybean`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_soybean` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_soybean`;

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
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(20) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdb_predicted_files`
--

DROP TABLE IF EXISTS `pdb_predicted_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdb_predicted_files` (
  `gene` varchar(24) NOT NULL,
  `template` varchar(6) NOT NULL,
  `confidence` float NOT NULL,
  KEY `pdb_predicted_index` (`gene`,`template`,`confidence`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publications`
--

DROP TABLE IF EXISTS `publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publications` (
  `gene` varchar(16) NOT NULL,
  `author` varchar(64) NOT NULL,
  `year` varchar(6) NOT NULL,
  `journal` varchar(64) NOT NULL,
  `title` text NOT NULL,
  `pubmed` varchar(16) NOT NULL,
  KEY `gene_idx` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_spruce`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_spruce` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_spruce`;

--
-- Table structure for table `ids`
--

DROP TABLE IF EXISTS `ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ids` (
  `locus` varchar(24) NOT NULL,
  KEY `locus` (`locus`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_sugarcane`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_sugarcane` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_sugarcane`;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(18) NOT NULL,
  `Source` varchar(10) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(28) DEFAULT NULL,
  `Parent` varchar(28) DEFAULT NULL,
  `Attributes` varchar(28) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_sunflower`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_sunflower` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_sunflower`;

--
-- Table structure for table `geneRIFs`
--

DROP TABLE IF EXISTS `geneRIFs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geneRIFs` (
  `gene` varchar(24) NOT NULL,
  `pubmed` varchar(16) NOT NULL,
  `RIF` text NOT NULL,
  KEY `rifs` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(32) NOT NULL,
  `annotation` text NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_mapping`
--

DROP TABLE IF EXISTS `gene_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_mapping` (
  `ha412` varchar(24) NOT NULL,
  `haxrq` varchar(32) NOT NULL,
  KEY `eplant` (`haxrq`,`ha412`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(24) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(20) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(64) DEFAULT NULL,
  `geneId` varchar(64) DEFAULT NULL,
  `Parent` varchar(64) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publications`
--

DROP TABLE IF EXISTS `publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publications` (
  `gene` varchar(24) NOT NULL,
  `author` varchar(64) NOT NULL,
  `year` varchar(6) NOT NULL,
  `journal` varchar(64) NOT NULL,
  `title` text NOT NULL,
  `pubmed` varchar(16) NOT NULL,
  KEY `gene_idx` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_tomato`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_tomato` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_tomato`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(20) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(30) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(50) DEFAULT NULL,
  `geneId` varchar(50) DEFAULT NULL,
  `Parent` varchar(50) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `isoforms`
--

DROP TABLE IF EXISTS `isoforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `isoforms` (
  `gene` varchar(20) NOT NULL,
  `isoform` varchar(24) NOT NULL,
  KEY `idx_gene_isoform` (`gene`,`isoform`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdb_predicted_files`
--

DROP TABLE IF EXISTS `pdb_predicted_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdb_predicted_files` (
  `gene` varchar(24) NOT NULL,
  `template` varchar(6) NOT NULL,
  `confidence` float NOT NULL,
  KEY `pdb_predicted_index` (`gene`,`template`,`confidence`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_wheat`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_wheat` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_wheat`;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(3) NOT NULL,
  `Source` varchar(6) NOT NULL,
  `Type` varchar(16) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(27) DEFAULT NULL,
  `geneId` varchar(27) DEFAULT NULL,
  `Parent` varchar(27) DEFAULT NULL,
  `Attributes` varchar(27) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eplant_willow`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eplant_willow` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eplant_willow`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(32) NOT NULL,
  `annotation` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_lookup`
--

DROP TABLE IF EXISTS `gene_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_lookup` (
  `subject_id` varchar(24) NOT NULL,
  `query_id` varchar(24) NOT NULL,
  KEY `subject_idx` (`subject_id`,`query_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gff3`
--

DROP TABLE IF EXISTS `gff3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gff3` (
  `SeqID` varchar(10) NOT NULL,
  `Source` varchar(20) NOT NULL,
  `Type` varchar(20) NOT NULL,
  `Start` int NOT NULL,
  `End` int NOT NULL,
  `Score` float DEFAULT NULL,
  `Strand` char(1) DEFAULT NULL,
  `Phase` char(1) DEFAULT NULL,
  `Id` varchar(32) DEFAULT NULL,
  `geneId` varchar(128) DEFAULT NULL,
  `Parent` varchar(64) DEFAULT NULL,
  `Attributes` varchar(50) DEFAULT NULL,
  KEY `geneId_idx` (`geneId`),
  KEY `Start_idx` (`Start`),
  KEY `End_idx` (`End`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `eucalyptus`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eucalyptus` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `eucalyptus`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(42) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `euphorbia`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `euphorbia` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `euphorbia`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `expression_max_test`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `expression_max_test` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `expression_max_test`;

--
-- Table structure for table `max_average_microarray`
--

DROP TABLE IF EXISTS `max_average_microarray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_average_microarray` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(13,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `sample` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `sample` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_average_rnaseq`
--

DROP TABLE IF EXISTS `max_average_rnaseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_average_rnaseq` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(13,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `sample0` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `sample0` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_induction_microarray`
--

DROP TABLE IF EXISTS `max_induction_microarray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_induction_microarray` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `induction_value` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample0` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample0` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_induction_ratio_microarray`
--

DROP TABLE IF EXISTS `max_induction_ratio_microarray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_induction_ratio_microarray` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `expression_ratio` decimal(9,5) DEFAULT NULL,
  `induction_value` decimal(13,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample10` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample10` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_induction_ratio_rnaseq`
--

DROP TABLE IF EXISTS `max_induction_ratio_rnaseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_induction_ratio_rnaseq` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `expression_ratio` decimal(9,5) DEFAULT NULL,
  `induction_value` decimal(13,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample100` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample100` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_induction_rnaseq`
--

DROP TABLE IF EXISTS `max_induction_rnaseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_induction_rnaseq` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `induction_value` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample00` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample00` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_reduction_microarray`
--

DROP TABLE IF EXISTS `max_reduction_microarray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_reduction_microarray` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `reduction_value` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_reduction_ratio_microarray`
--

DROP TABLE IF EXISTS `max_reduction_ratio_microarray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_reduction_ratio_microarray` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `expression_ratio` decimal(9,5) DEFAULT NULL,
  `reduction_value` decimal(13,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample1` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample1` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_reduction_ratio_rnaseq`
--

DROP TABLE IF EXISTS `max_reduction_ratio_rnaseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_reduction_ratio_rnaseq` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `expression_ratio` decimal(9,5) DEFAULT NULL,
  `reduction_value` decimal(13,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample11` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample11` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `max_reduction_rnaseq`
--

DROP TABLE IF EXISTS `max_reduction_rnaseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `max_reduction_rnaseq` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `reduction_value` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_reduction_sample2` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_reduction_sample2` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `min_average_microarray`
--

DROP TABLE IF EXISTS `min_average_microarray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `min_average_microarray` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_average_sample0` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_average_sample0` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `min_average_rnaseq`
--

DROP TABLE IF EXISTS `min_average_rnaseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `min_average_rnaseq` (
  `locus` varchar(10) DEFAULT NULL,
  `average` decimal(13,5) DEFAULT NULL,
  `standard_deviation` decimal(10,5) DEFAULT NULL,
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  KEY `max_average_sample00` (`sample`,`compendium`),
  KEY `locus_index` (`locus`),
  CONSTRAINT `max_average_sample00` FOREIGN KEY (`sample`, `compendium`) REFERENCES `sample` (`sample`, `compendium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `provenance`
--

DROP TABLE IF EXISTS `provenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provenance` (
  `provenance_id` int NOT NULL AUTO_INCREMENT,
  `url` varchar(100) DEFAULT NULL,
  `methods` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`provenance_id`),
  UNIQUE KEY `idProvenance_UNIQUE` (`provenance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample` (
  `sample` varchar(200) NOT NULL,
  `compendium` varchar(180) NOT NULL,
  `provenance_id` int DEFAULT NULL,
  PRIMARY KEY (`sample`,`compendium`),
  KEY `provenance_id_idx` (`provenance_id`),
  CONSTRAINT `provenance_id` FOREIGN KEY (`provenance_id`) REFERENCES `provenance` (`provenance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `fastpheno`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fastpheno` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fastpheno`;

--
-- Table structure for table `band`
--

DROP TABLE IF EXISTS `band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `band` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `band` varchar(100) NOT NULL,
  `value` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`,`band`),
  KEY `trees_fk_idx` (`trees_pk`),
  CONSTRAINT `trees_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `height`
--

DROP TABLE IF EXISTS `height`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `height` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `tree_height_proxy` decimal(20,15) NOT NULL,
  `ground_height_proxy` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`),
  KEY `tree_fk_idx` (`trees_pk`),
  CONSTRAINT `tree_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `sites_pk` int NOT NULL AUTO_INCREMENT,
  `site_name` varchar(45) NOT NULL,
  `site_desc` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`sites_pk`),
  UNIQUE KEY `site_name` (`site_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trees`
--

DROP TABLE IF EXISTS `trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trees` (
  `trees_pk` int NOT NULL AUTO_INCREMENT,
  `sites_pk` int NOT NULL,
  `longitude` decimal(25,15) DEFAULT NULL,
  `latitude` decimal(25,15) DEFAULT NULL,
  `genotype_id` varchar(5) DEFAULT NULL,
  `external_link` varchar(200) DEFAULT NULL,
  `tree_given_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`trees_pk`),
  KEY `sites_fk_idx` (`sites_pk`),
  CONSTRAINT `sites_fk` FOREIGN KEY (`sites_pk`) REFERENCES `sites` (`sites_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6309 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `fastpheno2_draft`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fastpheno2_draft` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fastpheno2_draft`;

--
-- Table structure for table `band`
--

DROP TABLE IF EXISTS `band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `band` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `band` varchar(100) NOT NULL,
  `value` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`,`band`),
  KEY `trees_fk_idx` (`trees_pk`),
  CONSTRAINT `trees_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `height`
--

DROP TABLE IF EXISTS `height`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `height` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `tree_height_proxy` decimal(20,15) NOT NULL,
  `ground_height_proxy` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`),
  KEY `tree_fk_idx` (`trees_pk`),
  CONSTRAINT `tree_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `sites_pk` int NOT NULL AUTO_INCREMENT,
  `site_name` varchar(45) NOT NULL,
  `site_desc` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`sites_pk`),
  UNIQUE KEY `site_name` (`site_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trees`
--

DROP TABLE IF EXISTS `trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trees` (
  `trees_pk` int NOT NULL AUTO_INCREMENT,
  `sites_pk` int NOT NULL,
  `longitude` decimal(25,15) DEFAULT NULL,
  `latitude` decimal(25,15) DEFAULT NULL,
  `genotype_id` varchar(5) DEFAULT NULL,
  `external_link` varchar(200) DEFAULT NULL,
  `tree_given_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`trees_pk`),
  KEY `sites_fk_idx` (`sites_pk`),
  CONSTRAINT `sites_fk` FOREIGN KEY (`sites_pk`) REFERENCES `sites` (`sites_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6309 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `fastpheno_draft`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fastpheno_draft` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fastpheno_draft`;

--
-- Table structure for table `band`
--

DROP TABLE IF EXISTS `band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `band` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `band` varchar(100) NOT NULL,
  `value` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`,`band`),
  KEY `trees_fk_idx` (`trees_pk`),
  CONSTRAINT `trees_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `height`
--

DROP TABLE IF EXISTS `height`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `height` (
  `trees_pk` int NOT NULL,
  `month` enum('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec') NOT NULL,
  `tree_height_proxy` decimal(20,15) NOT NULL,
  `ground_height_proxy` decimal(20,15) NOT NULL,
  PRIMARY KEY (`trees_pk`,`month`),
  KEY `tree_fk_idx` (`trees_pk`),
  CONSTRAINT `tree_fk` FOREIGN KEY (`trees_pk`) REFERENCES `trees` (`trees_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `sites_pk` int NOT NULL AUTO_INCREMENT,
  `site_name` varchar(45) NOT NULL,
  `site_desc` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`sites_pk`),
  UNIQUE KEY `site_name` (`site_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trees`
--

DROP TABLE IF EXISTS `trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trees` (
  `trees_pk` int NOT NULL AUTO_INCREMENT,
  `sites_pk` int NOT NULL,
  `longitude` decimal(25,15) DEFAULT NULL,
  `latitude` decimal(25,15) DEFAULT NULL,
  `genotype_id` varchar(5) DEFAULT NULL,
  `external_link` varchar(200) DEFAULT NULL,
  `tree_given_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`trees_pk`),
  KEY `sites_fk_idx` (`sites_pk`),
  CONSTRAINT `sites_fk` FOREIGN KEY (`sites_pk`) REFERENCES `sites` (`sites_pk`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6309 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `gAccounts`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `gAccounts` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `gAccounts`;

--
-- Current Database: `gaia`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `gaia` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `gaia`;

--
-- Table structure for table `aliases`
--

DROP TABLE IF EXISTS `aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aliases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `genes_id` int NOT NULL,
  `alias` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_genes` (`genes_id`),
  KEY `idx_aliases` (`alias`,`genes_id`),
  CONSTRAINT `aliases_ibfk_1` FOREIGN KEY (`genes_id`) REFERENCES `genes` (`id`),
  CONSTRAINT `FK_genes` FOREIGN KEY (`genes_id`) REFERENCES `genes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2124845 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `author_list`
--

DROP TABLE IF EXISTS `author_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author_list` (
  `id` int NOT NULL AUTO_INCREMENT,
  `publication_figures_id` int NOT NULL,
  `author` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_publication_figures_author_list` (`publication_figures_id`),
  CONSTRAINT `author_list_ibfk_1` FOREIGN KEY (`publication_figures_id`) REFERENCES `publication_figures` (`id`),
  CONSTRAINT `FK_publication_figures_author_list` FOREIGN KEY (`publication_figures_id`) REFERENCES `publication_figures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38184 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `figure_models`
--

DROP TABLE IF EXISTS `figure_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `figure_models` (
  `id` int NOT NULL AUTO_INCREMENT,
  `data` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93239 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `figures`
--

DROP TABLE IF EXISTS `figures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `figures` (
  `id` int NOT NULL AUTO_INCREMENT,
  `publication_figures_id` int NOT NULL,
  `img_name` varchar(64) NOT NULL,
  `caption` text,
  `img_url` varchar(265) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_publication_figures_figures` (`publication_figures_id`),
  CONSTRAINT `figures_ibfk_1` FOREIGN KEY (`publication_figures_id`) REFERENCES `publication_figures` (`id`),
  CONSTRAINT `FK_publication_figures_figures` FOREIGN KEY (`publication_figures_id`) REFERENCES `publication_figures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31955 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `genes`
--

DROP TABLE IF EXISTS `genes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `species` varchar(64) NOT NULL,
  `locus` varchar(64) DEFAULT NULL,
  `geneid` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_locus` (`locus`),
  KEY `idx_geneid` (`geneid`)
) ENGINE=InnoDB AUTO_INCREMENT=2358285 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pub_ids`
--

DROP TABLE IF EXISTS `pub_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pub_ids` (
  `id` int NOT NULL AUTO_INCREMENT,
  `publication_figures_id` int NOT NULL,
  `pubmed` varchar(16) DEFAULT NULL,
  `pmc` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_publication_figures_pub_ids` (`publication_figures_id`),
  CONSTRAINT `FK_publication_figures_pub_ids` FOREIGN KEY (`publication_figures_id`) REFERENCES `publication_figures` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pub_ids_ibfk_1` FOREIGN KEY (`publication_figures_id`) REFERENCES `publication_figures` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6655 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publication_figures`
--

DROP TABLE IF EXISTS `publication_figures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publication_figures` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(512) DEFAULT NULL,
  `abstract` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6655 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `gc_drought`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `gc_drought` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `gc_drought`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `geneslider`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `geneslider` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `geneslider`;

--
-- Table structure for table `data`
--

DROP TABLE IF EXISTS `data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data` (
  `id` int NOT NULL,
  `chr` varchar(2) DEFAULT NULL,
  `start` int NOT NULL,
  `end` int NOT NULL,
  `strand` varchar(1) NOT NULL,
  `file_name` varchar(80) NOT NULL,
  `url` tinytext,
  PRIMARY KEY (`id`),
  KEY `chr` (`chr`),
  KEY `start_end` (`start`,`end`),
  KEY `end_start` (`end`,`start`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tair10_gff3_pssm`
--

DROP TABLE IF EXISTS `tair10_gff3_pssm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tair10_gff3_pssm` (
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
  `FD` float DEFAULT NULL,
  `Attributes` varchar(256) DEFAULT NULL,
  KEY `Start` (`Start`),
  KEY `End` (`End`),
  KEY `geneId` (`geneId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `germination`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `germination` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `germination`;

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
-- Current Database: `grape_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `grape_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `grape_annotations_lookup`;

--
-- Table structure for table `grape_annotations`
--

DROP TABLE IF EXISTS `grape_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grape_annotations` (
  `gene` varchar(60) NOT NULL,
  `annotation` varchar(128) DEFAULT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`date`),
  KEY `date_annotation` (`date`,`gene`,`annotation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grape_probeset_lookup`
--

DROP TABLE IF EXISTS `grape_probeset_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grape_probeset_lookup` (
  `gene` varchar(100) NOT NULL,
  `probeset` varchar(100) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`probeset`,`date`),
  KEY `probeset` (`probeset`,`gene`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `grape_developmental`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `grape_developmental` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `grape_developmental`;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int NOT NULL,
  `proj_id` int NOT NULL,
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL,
  `data_bot_id` varchar(50) NOT NULL,
  `sample_tissue` text NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `guard_cell`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `guard_cell` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `guard_cell`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `gynoecium`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `gynoecium` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `gynoecium`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `heterodera_schachtii`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `heterodera_schachtii` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `heterodera_schachtii`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `hnahal`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hnahal` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hnahal`;

--
-- Table structure for table `agi_annotation`
--

DROP TABLE IF EXISTS `agi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_annotation` (
  `agi` varchar(11) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`agi`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_pgi_lookup`
--

DROP TABLE IF EXISTS `at_pgi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_pgi_lookup` (
  `probeset` varchar(60) NOT NULL,
  `pgi` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`pgi`,`date`),
  KEY `probeset` (`probeset`),
  KEY `pgi` (`pgi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation`
--

DROP TABLE IF EXISTS `chr_seq_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation` (
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
  KEY `cistome_id` (`Id`),
  KEY `cistome_parent` (`Parent`),
  KEY `cistome_annotation` (`Source`,`SeqID`,`Type`,`Strand`,`Start`,`End`),
  KEY `ngm_index` (`Source`,`SeqID`,`Type`,`geneId`,`Start`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation_c24`
--

DROP TABLE IF EXISTS `chr_seq_annotation_c24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation_c24` (
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
  `Attributes` mediumtext,
  KEY `range` (`Source`,`SeqID`,`Start`,`End`),
  KEY `seqend` (`Source`,`SeqID`,`End`),
  KEY `typeid` (`SeqID`,`Source`,`Type`,`Parent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation_patens`
--

DROP TABLE IF EXISTS `chr_seq_annotation_patens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation_patens` (
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
  `Attributes` mediumtext,
  KEY `myIndex` (`SeqID`,`Source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_annotations`
--

DROP TABLE IF EXISTS `gene_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotations` (
  `agi` varchar(12) NOT NULL,
  `annotation` longtext NOT NULL,
  `source` varchar(10) NOT NULL,
  PRIMARY KEY (`agi`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go`
--

DROP TABLE IF EXISTS `go`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go` (
  `agi` varchar(10) NOT NULL DEFAULT '',
  `tair_accession` mediumint unsigned NOT NULL DEFAULT '0',
  `object_name` varchar(12) NOT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL DEFAULT '',
  `tair_keyword` smallint unsigned NOT NULL DEFAULT '0',
  `aspect` varchar(5) NOT NULL DEFAULT '',
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) NOT NULL DEFAULT '',
  `reference` tinytext NOT NULL,
  `annotating_db` varchar(5) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  KEY `agi` (`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(9) NOT NULL DEFAULT '',
  `Protein2` varchar(9) NOT NULL DEFAULT '',
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` smallint NOT NULL DEFAULT '0',
  `Index` tinyint NOT NULL DEFAULT '0',
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  UNIQUE KEY `Protein1` (`Protein1`,`Protein2`,`Bind_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pgi_annotation`
--

DROP TABLE IF EXISTS `pgi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pgi_annotation` (
  `pgi` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`pgi`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) DEFAULT NULL,
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `channel` varchar(5) DEFAULT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) DEFAULT NULL,
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_name` tinytext,
  `sample_desc` longtext,
  `sample_od` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_mass` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_vol` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `hnahal_temp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hnahal_temp` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hnahal_temp`;

--
-- Table structure for table `agi_annotation`
--

DROP TABLE IF EXISTS `agi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_annotation` (
  `agi` varchar(11) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`agi`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_pgi_lookup`
--

DROP TABLE IF EXISTS `at_pgi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_pgi_lookup` (
  `probeset` varchar(60) NOT NULL,
  `pgi` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`pgi`,`date`),
  KEY `probeset` (`probeset`),
  KEY `pgi` (`pgi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation`
--

DROP TABLE IF EXISTS `chr_seq_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation` (
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
  KEY `range` (`Source`,`SeqID`,`Start`,`End`),
  KEY `seqend` (`Source`,`SeqID`,`End`),
  KEY `typeid` (`SeqID`,`Source`,`Type`,`Parent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation_c24`
--

DROP TABLE IF EXISTS `chr_seq_annotation_c24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation_c24` (
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
  `Attributes` mediumtext,
  KEY `range` (`Source`,`SeqID`,`Start`,`End`),
  KEY `seqend` (`Source`,`SeqID`,`End`),
  KEY `typeid` (`SeqID`,`Source`,`Type`,`Parent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation_patens`
--

DROP TABLE IF EXISTS `chr_seq_annotation_patens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation_patens` (
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
  `Attributes` mediumtext,
  KEY `myIndex` (`SeqID`,`Source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_annotations`
--

DROP TABLE IF EXISTS `gene_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotations` (
  `agi` varchar(12) NOT NULL,
  `annotation` longtext NOT NULL,
  `source` varchar(10) NOT NULL,
  PRIMARY KEY (`agi`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go`
--

DROP TABLE IF EXISTS `go`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go` (
  `agi` varchar(10) NOT NULL DEFAULT '',
  `tair_accession` mediumint unsigned NOT NULL DEFAULT '0',
  `object_name` varchar(12) NOT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL DEFAULT '',
  `tair_keyword` smallint unsigned NOT NULL DEFAULT '0',
  `aspect` varchar(5) NOT NULL DEFAULT '',
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) NOT NULL DEFAULT '',
  `reference` tinytext NOT NULL,
  `annotating_db` varchar(5) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  KEY `agi` (`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(9) NOT NULL DEFAULT '',
  `Protein2` varchar(9) NOT NULL DEFAULT '',
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` smallint NOT NULL DEFAULT '0',
  `Index` tinyint NOT NULL DEFAULT '0',
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  UNIQUE KEY `Protein1` (`Protein1`,`Protein2`,`Bind_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pgi_annotation`
--

DROP TABLE IF EXISTS `pgi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pgi_annotation` (
  `pgi` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`pgi`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `homologs_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `homologs_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `homologs_db`;

--
-- Table structure for table `homologs`
--

DROP TABLE IF EXISTS `homologs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homologs` (
  `homologs_id` int NOT NULL AUTO_INCREMENT,
  `search_protein_name` varchar(45) NOT NULL,
  `result_protein_name` varchar(45) NOT NULL,
  `search_species_name` varchar(45) NOT NULL,
  `result_species_name` varchar(45) NOT NULL,
  `Percent_id` decimal(10,5) NOT NULL,
  `e_score` varchar(10) NOT NULL,
  PRIMARY KEY (`homologs_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1459145 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `human_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `human_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `human_annotations_lookup`;

--
-- Table structure for table `gene_probeset_lookup`
--

DROP TABLE IF EXISTS `gene_probeset_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_probeset_lookup` (
  `gene` varchar(30) NOT NULL DEFAULT '',
  `probeset` varchar(30) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`probeset`,`date`),
  KEY `probeset_date_gene` (`probeset`,`date`,`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `human_annotation`
--

DROP TABLE IF EXISTS `human_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `human_annotation` (
  `probeset` varchar(30) NOT NULL,
  `annotation` longtext,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `human_body_map_2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `human_body_map_2` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `human_body_map_2`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(28) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(20) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `human_developmental`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `human_developmental` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `human_developmental`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(32) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(24) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Current Database: `human_developmental_SpongeLab`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `human_developmental_SpongeLab` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `human_developmental_SpongeLab`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(30)),
  KEY `data_probeset_id` (`data_probeset_id`(30),`data_bot_id`(30)),
  KEY `data_bot_id` (`data_bot_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Current Database: `human_diseased`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `human_diseased` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `human_diseased`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(30)),
  KEY `data_probeset_id` (`data_probeset_id`(30),`data_bot_id`(30)),
  KEY `data_bot_id` (`data_bot_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
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
-- Current Database: `interactions`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `interactions` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `interactions`;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(25) DEFAULT NULL,
  `Protein2` varchar(25) DEFAULT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` float NOT NULL,
  `aiv_index` tinyint DEFAULT NULL,
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  `Interactions_detection_mi` varchar(35) DEFAULT NULL,
  `Interactions_detection` varchar(125) DEFAULT NULL,
  `Interactions_type_mi` varchar(10) DEFAULT NULL,
  `Interactions_type` varchar(30) DEFAULT NULL,
  UNIQUE KEY `Protein1` (`Protein1`,`Protein2`,`Bind_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_eplant`
--

DROP TABLE IF EXISTS `interactions_eplant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_eplant` (
  `Protein1` varchar(25) DEFAULT NULL,
  `Protein2` varchar(25) DEFAULT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` float NOT NULL,
  `aiv_index` tinyint DEFAULT NULL,
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  `Interactions_detection_mi` varchar(35) DEFAULT NULL,
  `Interactions_detection` varchar(125) DEFAULT NULL,
  `Interactions_type_mi` varchar(10) DEFAULT NULL,
  `Interactions_type` varchar(30) DEFAULT NULL,
  UNIQUE KEY `interaction` (`Protein1`,`Protein2`,`aiv_index`,`Bind_id`(30)),
  KEY `aiv_index` (`aiv_index`),
  KEY `protein2` (`Protein2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_eplant_v2`
--

DROP TABLE IF EXISTS `interactions_eplant_v2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_eplant_v2` (
  `Protein1` varchar(25) DEFAULT NULL,
  `Protein2` varchar(25) DEFAULT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` float NOT NULL,
  `aiv_index` tinyint DEFAULT NULL,
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  `Interactions_detection_mi` varchar(35) DEFAULT NULL,
  `Interactions_detection` varchar(125) DEFAULT NULL,
  `Interactions_type_mi` varchar(10) DEFAULT NULL,
  `Interactions_type` varchar(30) DEFAULT NULL,
  UNIQUE KEY `interaction` (`Protein1`,`Protein2`,`aiv_index`,`Bind_id`(30)),
  KEY `aiv_index` (`aiv_index`),
  KEY `protein2` (`Protein2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_eplant_v3`
--

DROP TABLE IF EXISTS `interactions_eplant_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_eplant_v3` (
  `Protein1` varchar(25) DEFAULT NULL,
  `Protein2` varchar(25) DEFAULT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` float NOT NULL,
  `aiv_index` tinyint DEFAULT NULL,
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  `Interactions_detection_mi` varchar(35) DEFAULT NULL,
  `Interactions_detection` varchar(125) DEFAULT NULL,
  `Interactions_type_mi` varchar(10) DEFAULT NULL,
  `Interactions_type` varchar(30) DEFAULT NULL,
  KEY `aiv_index` (`aiv_index`),
  KEY `protein2` (`Protein2`),
  KEY `interaction` (`Protein1`,`Protein2`,`aiv_index`,`Bind_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_eplant_v4`
--

DROP TABLE IF EXISTS `interactions_eplant_v4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_eplant_v4` (
  `Protein1` varchar(25) DEFAULT NULL,
  `Protein2` varchar(25) DEFAULT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` float NOT NULL,
  `aiv_index` tinyint DEFAULT NULL,
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  `Interactions_detection_mi` varchar(64) DEFAULT NULL,
  `Interactions_detection` varchar(256) DEFAULT NULL,
  `Interactions_type_mi` varchar(64) DEFAULT NULL,
  `Interactions_type` varchar(256) DEFAULT NULL,
  KEY `aiv_index` (`aiv_index`),
  KEY `protein2` (`Protein2`),
  KEY `interaction` (`Protein1`,`Protein2`,`aiv_index`,`Bind_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `interactions_dapseq`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `interactions_dapseq` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `interactions_dapseq`;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(25) DEFAULT NULL,
  `Protein2` varchar(25) DEFAULT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` float NOT NULL,
  `aiv_index` tinyint DEFAULT NULL,
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  `Interactions_detection_mi` varchar(35) DEFAULT NULL,
  `Interactions_detection` varchar(125) DEFAULT NULL,
  `Interactions_type_mi` varchar(10) DEFAULT NULL,
  `Interactions_type` varchar(30) DEFAULT NULL,
  UNIQUE KEY `Protein1` (`Protein1`,`Protein2`,`Bind_id`(30))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `new_interactions`
--

DROP TABLE IF EXISTS `new_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `new_interactions` (
  `name` varchar(35) NOT NULL DEFAULT '',
  `email` varchar(35) NOT NULL DEFAULT '',
  `agi1` varchar(12) NOT NULL DEFAULT '',
  `agi2` varchar(12) NOT NULL DEFAULT '',
  `pubmed` varchar(20) DEFAULT NULL,
  `description` mediumtext,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `interactions_eddi`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `interactions_eddi` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `interactions_eddi`;

--
-- Table structure for table `algorithms_lookup_table`
--

DROP TABLE IF EXISTS `algorithms_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `algorithms_lookup_table` (
  `algo_name` varchar(100) NOT NULL,
  `algo_desc` varchar(500) NOT NULL,
  `algo_ranges` varchar(200) NOT NULL,
  PRIMARY KEY (`algo_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `detections_mi_lookup_table`
--

DROP TABLE IF EXISTS `detections_mi_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detections_mi_lookup_table` (
  `detections_mi_id` varchar(200) NOT NULL,
  `interactions_detection` varchar(200) DEFAULT NULL,
  `interactions_type_mi` varchar(200) DEFAULT NULL,
  `interactions_type` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`detections_mi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `external_db_lookup_table`
--

DROP TABLE IF EXISTS `external_db_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `external_db_lookup_table` (
  `ext_db_id` int NOT NULL,
  `name_of_db` varchar(100) NOT NULL,
  PRIMARY KEY (`ext_db_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `external_source`
--

DROP TABLE IF EXISTS `external_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `external_source` (
  `source_id` int NOT NULL AUTO_INCREMENT,
  `source_name` varchar(500) NOT NULL,
  `comments` text,
  `date_uploaded` date DEFAULT NULL,
  `url` varchar(350) DEFAULT NULL,
  `source_type_id` int NOT NULL,
  `is_GRN` tinyint(1) NOT NULL,
  `tags` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `source_name_UNIQUE` (`source_name`),
  KEY `ext_src_type_FK_idx` (`source_type_id`),
  CONSTRAINT `ext_src_type_FK` FOREIGN KEY (`source_type_id`) REFERENCES `source_type_lookup_table` (`source_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2088 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interaction_lookup_table`
--

DROP TABLE IF EXISTS `interaction_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interaction_lookup_table` (
  `interaction_type_id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `entity_1_alias` varchar(50) NOT NULL,
  `entity_2_alias` varchar(50) NOT NULL,
  PRIMARY KEY (`interaction_type_id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `interaction_id` int NOT NULL AUTO_INCREMENT,
  `pearson_correlation_coeff` decimal(6,5) DEFAULT NULL,
  `entity_1` varchar(50) NOT NULL,
  `entity_2` varchar(50) NOT NULL,
  `interaction_type_id` int NOT NULL,
  PRIMARY KEY (`interaction_id`),
  UNIQUE KEY `unique_interaction_index` (`entity_1`,`entity_2`,`interaction_type_id`),
  KEY `interaction_type_id_idx` (`interaction_type_id`),
  CONSTRAINT `interaction_type_id` FOREIGN KEY (`interaction_type_id`) REFERENCES `interaction_lookup_table` (`interaction_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3240894 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_source_mi_join_table`
--

DROP TABLE IF EXISTS `interactions_source_mi_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_source_mi_join_table` (
  `interaction_id` int NOT NULL,
  `detections_mi_id` varchar(100) DEFAULT NULL,
  `source_id` int NOT NULL,
  `external_db_lookup` int DEFAULT NULL,
  `external_db_id` varchar(30) DEFAULT NULL,
  `mode_of_action` tinyint(1) NOT NULL,
  PRIMARY KEY (`interaction_id`,`source_id`),
  KEY `detection_mi_idx` (`detections_mi_id`),
  KEY `source_id_idx` (`source_id`),
  KEY `external_db_FK_idx` (`external_db_lookup`),
  KEY `m_o_a_db_FK_idx` (`mode_of_action`),
  CONSTRAINT `detection_mi_FK` FOREIGN KEY (`detections_mi_id`) REFERENCES `detections_mi_lookup_table` (`detections_mi_id`),
  CONSTRAINT `external_db_FK` FOREIGN KEY (`external_db_lookup`) REFERENCES `external_db_lookup_table` (`ext_db_id`),
  CONSTRAINT `int_id_FK_on_mi_int_src` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`),
  CONSTRAINT `m_o_a_db_FK` FOREIGN KEY (`mode_of_action`) REFERENCES `modes_of_action_lookup_table` (`m_of_a_pk`),
  CONSTRAINT `source_id_FK` FOREIGN KEY (`source_id`) REFERENCES `external_source` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interolog_confidence_subset_table`
--

DROP TABLE IF EXISTS `interolog_confidence_subset_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interolog_confidence_subset_table` (
  `interaction_id` int NOT NULL,
  `s_cerevisiae` tinyint NOT NULL,
  `s_pombe` tinyint NOT NULL,
  `worm` tinyint NOT NULL,
  `fly` tinyint NOT NULL,
  `human` tinyint NOT NULL,
  `mouse` tinyint NOT NULL,
  `e_coli` tinyint NOT NULL,
  `total_hits` smallint NOT NULL,
  `num_species` tinyint NOT NULL,
  PRIMARY KEY (`interaction_id`),
  KEY `pdi_interaction_id_idx` (`interaction_id`),
  CONSTRAINT `interolog_int_id_FK` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modes_of_action_lookup_table`
--

DROP TABLE IF EXISTS `modes_of_action_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modes_of_action_lookup_table` (
  `m_of_a_pk` tinyint(1) NOT NULL,
  `description` varchar(20) NOT NULL,
  PRIMARY KEY (`m_of_a_pk`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `source_type_lookup_table`
--

DROP TABLE IF EXISTS `source_type_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `source_type_lookup_table` (
  `source_type_id` int NOT NULL AUTO_INCREMENT,
  `source_type_desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`source_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `interactions_grn_dev_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `interactions_grn_dev_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `interactions_grn_dev_db`;

--
-- Table structure for table `algorithms_lookup_table`
--

DROP TABLE IF EXISTS `algorithms_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `algorithms_lookup_table` (
  `algo_name` varchar(100) NOT NULL COMMENT 'Algorithm name to be used in place of a surrogate key, assume they’re going to be unique. Like “FIMO”.',
  `algo_desc` varchar(500) NOT NULL COMMENT 'Describe the named algorithm in algo_name.',
  `algo_ranges` varchar(200) NOT NULL COMMENT 'Briefly describe the range of values',
  PRIMARY KEY (`algo_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `external_source`
--

DROP TABLE IF EXISTS `external_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `external_source` (
  `source_id` int NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `source_name` varchar(500) NOT NULL COMMENT 'name of the source, can be a pubmed identifier like “PMIDXXXXXXX” or “Asher’s sql dump”',
  `comments` text NOT NULL COMMENT 'Comments regarding the source',
  `date_uploaded` date NOT NULL COMMENT 'When it was uploaded to database',
  `url` varchar(350) DEFAULT NULL COMMENT 'URL if available to paper/source (does not have to be a DOI, can be a link to a databases’ source)',
  `image_url` varchar(300) DEFAULT NULL,
  `grn_title` varchar(200) DEFAULT NULL,
  `cyjs_layout` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `source_name_UNIQUE` (`source_name`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interaction_lookup_table`
--

DROP TABLE IF EXISTS `interaction_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interaction_lookup_table` (
  `interaction_type_id` int NOT NULL AUTO_INCREMENT COMMENT 'Surrogate key',
  `description` varchar(100) NOT NULL COMMENT 'Describe the binary interaction of the entities. For example ‘ppi - protein interaction where entity_1_alias and entity_2_alias represent proteins’',
  `entity_1_alias` varchar(50) NOT NULL COMMENT 'Can be a protein, miRNA, etc.',
  `entity_2_alias` varchar(50) NOT NULL COMMENT 'Can be a protein, miRNA, etc.',
  PRIMARY KEY (`interaction_type_id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `interaction_id` int NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `pearson_correlation_coeff` decimal(6,5) DEFAULT NULL COMMENT 'PCC score imported from interactions table',
  `entity_1` varchar(50) NOT NULL COMMENT 'Following the interaction_type_id (referencing the lookup table), define the first entity. For example if it is a PPI relationship than the entity 1 shall be a protein with an AGI (ex AT5G01010).',
  `entity_2` varchar(50) NOT NULL COMMENT 'Following the interaction_type_id (referencing the lookup table), define the first entity. For example if it is a PPI relationship than the entity 2 shall be a protein with an AGI (ex AT5G01010).',
  `interaction_type_id` int NOT NULL COMMENT 'Reference to the lookup of a interactions_lookup_table. Define what type of interaction these two genes are. For example if the value were ‘3’ and it looksup to a PPI, then both members are proteins.',
  PRIMARY KEY (`interaction_id`),
  UNIQUE KEY `unique_interaction_index` (`entity_1`,`entity_2`,`interaction_type_id`),
  KEY `interaction_type_id_idx` (`interaction_type_id`),
  CONSTRAINT `interaction_type_id` FOREIGN KEY (`interaction_type_id`) REFERENCES `interaction_lookup_table` (`interaction_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10835 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_algo_score_join_table`
--

DROP TABLE IF EXISTS `interactions_algo_score_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_algo_score_join_table` (
  `algo_score` varchar(30) NOT NULL COMMENT 'Score for that specific algorithm referenced in ‘algo_name’ for a particular binary interaction',
  `interaction_id` int NOT NULL COMMENT 'The interaction we are looking at when we are referring to an algorithm score',
  `algo_name` varchar(100) NOT NULL COMMENT 'algo_name which will reference the lookup table',
  PRIMARY KEY (`algo_name`,`interaction_id`,`algo_score`),
  KEY `interaction_id_idx` (`interaction_id`),
  CONSTRAINT `algo_name` FOREIGN KEY (`algo_name`) REFERENCES `algorithms_lookup_table` (`algo_name`),
  CONSTRAINT `interaction_id` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_source_mi_join_table`
--

DROP TABLE IF EXISTS `interactions_source_mi_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_source_mi_join_table` (
  `interaction_id` int NOT NULL COMMENT 'reference the interaction pair via id',
  `source_id` int NOT NULL COMMENT 'reference the paper/source where this interaction came from',
  `external_db_id` varchar(30) NOT NULL COMMENT 'For the given external_database, like BIOGRID; what is it’s ID?',
  `mode_of_action` tinyint(1) NOT NULL COMMENT 'Repression or activation? Reference it here to the lookup.',
  `mi_detection_method` varchar(10) NOT NULL,
  `mi_detection_type` varchar(10) NOT NULL,
  PRIMARY KEY (`mi_detection_method`,`mi_detection_type`,`external_db_id`,`interaction_id`,`source_id`),
  KEY `source_id_idx` (`source_id`),
  KEY `m_o_a_db_FK_idx` (`mode_of_action`),
  KEY `int_id_FK_on_mi_int_src` (`interaction_id`),
  CONSTRAINT `int_id_FK_on_mi_int_src` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`),
  CONSTRAINT `m_o_a_db_FK` FOREIGN KEY (`mode_of_action`) REFERENCES `modes_of_action_lookup_table` (`m_of_a_pk`),
  CONSTRAINT `source_id_FK` FOREIGN KEY (`source_id`) REFERENCES `external_source` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interolog_confidence_subset_table`
--

DROP TABLE IF EXISTS `interolog_confidence_subset_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interolog_confidence_subset_table` (
  `interaction_id` int NOT NULL COMMENT 'surrogate key',
  `s_cerevisiae` tinyint NOT NULL COMMENT 'species score… repeat for all other species',
  `s_pombe` tinyint NOT NULL,
  `worm` tinyint NOT NULL,
  `fly` tinyint NOT NULL,
  `human` tinyint NOT NULL,
  `mouse` tinyint NOT NULL,
  `e_coli` tinyint NOT NULL,
  `total_hits` smallint NOT NULL,
  `num_species` tinyint NOT NULL,
  PRIMARY KEY (`interaction_id`),
  KEY `pdi_interaction_id_idx` (`interaction_id`),
  CONSTRAINT `interolog_int_id_FK` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modes_of_action_lookup_table`
--

DROP TABLE IF EXISTS `modes_of_action_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modes_of_action_lookup_table` (
  `m_of_a_pk` tinyint(1) NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `description` varchar(20) NOT NULL COMMENT 'Describe the mode of action of the interaction, is it repression or activation for example?',
  PRIMARY KEY (`m_of_a_pk`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `source_tag_join_table`
--

DROP TABLE IF EXISTS `source_tag_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `source_tag_join_table` (
  `source_id` int NOT NULL,
  `tag_name` varchar(45) NOT NULL,
  PRIMARY KEY (`source_id`,`tag_name`),
  KEY `tag_join_tag_names_FK_idx` (`tag_name`),
  CONSTRAINT `tag_join_source_id_FK` FOREIGN KEY (`source_id`) REFERENCES `external_source` (`source_id`),
  CONSTRAINT `tag_join_tag_names_FK` FOREIGN KEY (`tag_name`) REFERENCES `tag_lookup_table` (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_lookup_table`
--

DROP TABLE IF EXISTS `tag_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_lookup_table` (
  `tag_name` varchar(45) NOT NULL,
  `tag_group` enum('Gene','Experiment','Condition','Misc') NOT NULL,
  PRIMARY KEY (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `interactions_vincent`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `interactions_vincent` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `interactions_vincent`;

--
-- Table structure for table `algorithms_lookup_table`
--

DROP TABLE IF EXISTS `algorithms_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `algorithms_lookup_table` (
  `algo_name` varchar(100) NOT NULL COMMENT 'Algorithm name to be used in place of a surrogate key, assume they’re going to be unique. Like “FIMO”.',
  `algo_desc` varchar(500) NOT NULL COMMENT 'Describe the named algorithm in algo_name.',
  `algo_ranges` varchar(200) NOT NULL COMMENT 'Briefly describe the range of values',
  PRIMARY KEY (`algo_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `external_source`
--

DROP TABLE IF EXISTS `external_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `external_source` (
  `source_id` int NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `source_name` varchar(500) NOT NULL COMMENT 'name of the source, can be a pubmed identifier like “PMIDXXXXXXX” or “Asher’s sql dump”',
  `comments` text NOT NULL COMMENT 'Comments regarding the source',
  `date_uploaded` date NOT NULL,
  `url` varchar(350) DEFAULT NULL COMMENT 'URL if available to paper/source (does not have to be a DOI, can be a link to a databases’ source)',
  `tags` varchar(300) DEFAULT NULL COMMENT 'Specific to GRN project, have tags which describe features of a GRN which are relevant. For example, the condition or tissue of Arabidopsis when GRN was constructed, master regulators, what technique used',
  `image_url` varchar(300) DEFAULT NULL,
  `grn_title` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `source_name_UNIQUE` (`source_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2286 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interaction_lookup_table`
--

DROP TABLE IF EXISTS `interaction_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interaction_lookup_table` (
  `interaction_type_id` int NOT NULL AUTO_INCREMENT COMMENT 'Surrogate key',
  `description` varchar(100) NOT NULL COMMENT 'Describe the binary interaction of the entities. For example ‘ppi - protein interaction where entity_1_alias and entity_2_alias represent proteins’',
  `entity_1_alias` varchar(50) NOT NULL COMMENT 'Can be a protein, miRNA, etc.',
  `entity_2_alias` varchar(50) NOT NULL COMMENT 'Can be a protein, miRNA, etc.',
  PRIMARY KEY (`interaction_type_id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `interaction_id` int NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `pearson_correlation_coeff` decimal(6,5) DEFAULT NULL COMMENT 'PCC score imported from interactions table',
  `entity_1` varchar(50) NOT NULL COMMENT 'Following the interaction_type_id (referencing the lookup table), define the first entity. For example if it is a PPI relationship than the entity 1 shall be a protein with an AGI (ex AT5G01010).',
  `entity_2` varchar(50) NOT NULL COMMENT 'Following the interaction_type_id (referencing the lookup table), define the first entity. For example if it is a PPI relationship than the entity 2 shall be a protein with an AGI (ex AT5G01010).',
  `interaction_type_id` int NOT NULL COMMENT 'Reference to the lookup of a interactions_lookup_table. Define what type of interaction these two genes are. For example if the value were ‘3’ and it looksup to a PPI, then both members are proteins.',
  PRIMARY KEY (`interaction_id`),
  UNIQUE KEY `unique_interaction_index` (`entity_1`,`entity_2`,`interaction_type_id`),
  KEY `interaction_type_id_idx` (`interaction_type_id`),
  KEY `e_1_idx` (`entity_1`),
  KEY `e_2_idx` (`entity_2`),
  CONSTRAINT `interaction_type_id` FOREIGN KEY (`interaction_type_id`) REFERENCES `interaction_lookup_table` (`interaction_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3191448 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_algo_score_join_table`
--

DROP TABLE IF EXISTS `interactions_algo_score_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_algo_score_join_table` (
  `algo_score` varchar(30) NOT NULL COMMENT 'Score for that specific algorithm referenced in ‘algo_name’ for a particular binary interaction',
  `interaction_id` int NOT NULL COMMENT 'The interaction we are looking at when we are referring to an algorithm score',
  `algo_name` varchar(100) NOT NULL COMMENT 'algo_name which will reference the lookup table',
  PRIMARY KEY (`algo_name`,`interaction_id`,`algo_score`),
  KEY `interaction_id_idx` (`interaction_id`),
  CONSTRAINT `algo_name` FOREIGN KEY (`algo_name`) REFERENCES `algorithms_lookup_table` (`algo_name`),
  CONSTRAINT `interaction_id` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_source_mi_join_table`
--

DROP TABLE IF EXISTS `interactions_source_mi_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_source_mi_join_table` (
  `interaction_id` int NOT NULL COMMENT 'reference the interaction pair via id',
  `source_id` int NOT NULL COMMENT 'reference the paper/source where this interaction came from',
  `external_db_id` varchar(30) NOT NULL COMMENT 'For the given external_database, like BIOGRID; what is it’s ID?',
  `mode_of_action` tinyint(1) NOT NULL COMMENT 'Repression or activation? Reference it here to the lookup.',
  `mi_detection_method` varchar(10) NOT NULL,
  `mi_detection_type` varchar(10) NOT NULL,
  PRIMARY KEY (`mi_detection_method`,`mi_detection_type`,`external_db_id`,`interaction_id`,`source_id`),
  KEY `source_id_idx` (`source_id`),
  KEY `m_o_a_db_FK_idx` (`mode_of_action`),
  KEY `int_id_FK_on_mi_int_src` (`interaction_id`),
  CONSTRAINT `int_id_FK_on_mi_int_src` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`),
  CONSTRAINT `m_o_a_db_FK` FOREIGN KEY (`mode_of_action`) REFERENCES `modes_of_action_lookup_table` (`m_of_a_pk`),
  CONSTRAINT `source_id_FK` FOREIGN KEY (`source_id`) REFERENCES `external_source` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interolog_confidence_subset_table`
--

DROP TABLE IF EXISTS `interolog_confidence_subset_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interolog_confidence_subset_table` (
  `interaction_id` int NOT NULL COMMENT 'surrogate key',
  `s_cerevisiae` tinyint NOT NULL COMMENT 'species score… repeat for all other species',
  `s_pombe` tinyint NOT NULL,
  `worm` tinyint NOT NULL,
  `fly` tinyint NOT NULL,
  `human` tinyint NOT NULL,
  `mouse` tinyint NOT NULL,
  `e_coli` tinyint NOT NULL,
  `total_hits` smallint NOT NULL,
  `num_species` tinyint NOT NULL,
  PRIMARY KEY (`interaction_id`),
  KEY `pdi_interaction_id_idx` (`interaction_id`),
  CONSTRAINT `interolog_int_id_FK` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modes_of_action_lookup_table`
--

DROP TABLE IF EXISTS `modes_of_action_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modes_of_action_lookup_table` (
  `m_of_a_pk` tinyint(1) NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `description` varchar(20) NOT NULL COMMENT 'Describe the mode of action of the interaction, is it repression or activation for example?',
  PRIMARY KEY (`m_of_a_pk`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `interactions_vincent_v2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `interactions_vincent_v2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `interactions_vincent_v2`;

--
-- Table structure for table `algorithms_lookup_table`
--

DROP TABLE IF EXISTS `algorithms_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `algorithms_lookup_table` (
  `algo_name` varchar(100) NOT NULL COMMENT 'Algorithm name to be used in place of a surrogate key, assume they’re going to be unique. Like “FIMO”.',
  `algo_desc` varchar(500) NOT NULL COMMENT 'Describe the named algorithm in algo_name.',
  `algo_ranges` varchar(200) NOT NULL COMMENT 'Briefly describe the range of values',
  PRIMARY KEY (`algo_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `external_source`
--

DROP TABLE IF EXISTS `external_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `external_source` (
  `source_id` int NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `source_name` varchar(500) NOT NULL COMMENT 'name of the source, can be a pubmed identifier like “PMIDXXXXXXX” or “Asher’s sql dump”',
  `comments` text NOT NULL COMMENT 'Comments regarding the source',
  `date_uploaded` date NOT NULL COMMENT 'When it was uploaded to database',
  `url` varchar(350) DEFAULT NULL COMMENT 'URL if available to paper/source (does not have to be a DOI, can be a link to a databases’ source)',
  `image_url` varchar(300) DEFAULT NULL,
  `grn_title` varchar(200) DEFAULT NULL,
  `cyjs_layout` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `source_name_UNIQUE` (`source_name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interaction_lookup_table`
--

DROP TABLE IF EXISTS `interaction_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interaction_lookup_table` (
  `interaction_type_id` int NOT NULL AUTO_INCREMENT COMMENT 'Surrogate key',
  `description` varchar(100) NOT NULL COMMENT 'Describe the binary interaction of the entities. For example ‘ppi - protein interaction where entity_1_alias and entity_2_alias represent proteins’',
  `entity_1_alias` varchar(50) NOT NULL COMMENT 'Can be a protein, miRNA, etc.',
  `entity_2_alias` varchar(50) NOT NULL COMMENT 'Can be a protein, miRNA, etc.',
  PRIMARY KEY (`interaction_type_id`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `interaction_id` int NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `pearson_correlation_coeff` decimal(6,5) DEFAULT NULL COMMENT 'PCC score imported from interactions table',
  `entity_1` varchar(50) NOT NULL COMMENT 'Following the interaction_type_id (referencing the lookup table), define the first entity. For example if it is a PPI relationship than the entity 1 shall be a protein with an AGI (ex AT5G01010).',
  `entity_2` varchar(50) NOT NULL COMMENT 'Following the interaction_type_id (referencing the lookup table), define the first entity. For example if it is a PPI relationship than the entity 2 shall be a protein with an AGI (ex AT5G01010).',
  `interaction_type_id` int NOT NULL COMMENT 'Reference to the lookup of a interactions_lookup_table. Define what type of interaction these two genes are. For example if the value were ‘3’ and it looksup to a PPI, then both members are proteins.',
  PRIMARY KEY (`interaction_id`),
  UNIQUE KEY `unique_interaction_index` (`entity_1`,`entity_2`,`interaction_type_id`),
  KEY `interaction_type_id_idx` (`interaction_type_id`),
  CONSTRAINT `interaction_type_id` FOREIGN KEY (`interaction_type_id`) REFERENCES `interaction_lookup_table` (`interaction_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9069 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_algo_score_join_table`
--

DROP TABLE IF EXISTS `interactions_algo_score_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_algo_score_join_table` (
  `algo_score` varchar(30) NOT NULL COMMENT 'Score for that specific algorithm referenced in ‘algo_name’ for a particular binary interaction',
  `interaction_id` int NOT NULL COMMENT 'The interaction we are looking at when we are referring to an algorithm score',
  `algo_name` varchar(100) NOT NULL COMMENT 'algo_name which will reference the lookup table',
  PRIMARY KEY (`algo_name`,`interaction_id`,`algo_score`),
  KEY `interaction_id_idx` (`interaction_id`),
  CONSTRAINT `algo_name` FOREIGN KEY (`algo_name`) REFERENCES `algorithms_lookup_table` (`algo_name`),
  CONSTRAINT `interaction_id` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions_source_mi_join_table`
--

DROP TABLE IF EXISTS `interactions_source_mi_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions_source_mi_join_table` (
  `interaction_id` int NOT NULL COMMENT 'reference the interaction pair via id',
  `source_id` int NOT NULL COMMENT 'reference the paper/source where this interaction came from',
  `external_db_id` varchar(30) NOT NULL COMMENT 'For the given external_database, like BIOGRID; what is it’s ID?',
  `mode_of_action` tinyint(1) NOT NULL COMMENT 'Repression or activation? Reference it here to the lookup.',
  `mi_detection_method` varchar(10) NOT NULL,
  `mi_detection_type` varchar(10) NOT NULL,
  PRIMARY KEY (`mi_detection_method`,`mi_detection_type`,`external_db_id`,`interaction_id`,`source_id`),
  KEY `source_id_idx` (`source_id`),
  KEY `m_o_a_db_FK_idx` (`mode_of_action`),
  KEY `int_id_FK_on_mi_int_src` (`interaction_id`),
  CONSTRAINT `int_id_FK_on_mi_int_src` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`),
  CONSTRAINT `m_o_a_db_FK` FOREIGN KEY (`mode_of_action`) REFERENCES `modes_of_action_lookup_table` (`m_of_a_pk`),
  CONSTRAINT `source_id_FK` FOREIGN KEY (`source_id`) REFERENCES `external_source` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interolog_confidence_subset_table`
--

DROP TABLE IF EXISTS `interolog_confidence_subset_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interolog_confidence_subset_table` (
  `interaction_id` int NOT NULL COMMENT 'surrogate key',
  `s_cerevisiae` tinyint NOT NULL COMMENT 'species score… repeat for all other species',
  `s_pombe` tinyint NOT NULL,
  `worm` tinyint NOT NULL,
  `fly` tinyint NOT NULL,
  `human` tinyint NOT NULL,
  `mouse` tinyint NOT NULL,
  `e_coli` tinyint NOT NULL,
  `total_hits` smallint NOT NULL,
  `num_species` tinyint NOT NULL,
  PRIMARY KEY (`interaction_id`),
  KEY `pdi_interaction_id_idx` (`interaction_id`),
  CONSTRAINT `interolog_int_id_FK` FOREIGN KEY (`interaction_id`) REFERENCES `interactions` (`interaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modes_of_action_lookup_table`
--

DROP TABLE IF EXISTS `modes_of_action_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modes_of_action_lookup_table` (
  `m_of_a_pk` tinyint(1) NOT NULL AUTO_INCREMENT COMMENT 'surrogate key',
  `description` varchar(20) NOT NULL COMMENT 'Describe the mode of action of the interaction, is it repression or activation for example?',
  PRIMARY KEY (`m_of_a_pk`),
  UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `source_tag_join_table`
--

DROP TABLE IF EXISTS `source_tag_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `source_tag_join_table` (
  `source_id` int NOT NULL,
  `tag_name` varchar(20) NOT NULL,
  PRIMARY KEY (`source_id`,`tag_name`),
  KEY `tag_join_tag_names_FK_idx` (`tag_name`),
  CONSTRAINT `tag_join_source_id_FK` FOREIGN KEY (`source_id`) REFERENCES `external_source` (`source_id`),
  CONSTRAINT `tag_join_tag_names_FK` FOREIGN KEY (`tag_name`) REFERENCES `tag_lookup_table` (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_lookup_table`
--

DROP TABLE IF EXISTS `tag_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_lookup_table` (
  `tag_name` varchar(20) NOT NULL,
  `tag_group` enum('Gene','Experiment','Condition','Misc') NOT NULL,
  PRIMARY KEY (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `kalanchoe`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `kalanchoe` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `kalanchoe`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `kalanchoe_time_course_analysis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `kalanchoe_time_course_analysis` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `kalanchoe_time_course_analysis`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Current Database: `lateral_root_initiation`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lateral_root_initiation` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `lateral_root_initiation`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(30) NOT NULL,
  `project_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`sample_id`,`project_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `light_series`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `light_series` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `light_series`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(30) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Current Database: `lipid_map`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lipid_map` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `lipid_map`;

--
-- Table structure for table `lipids`
--

DROP TABLE IF EXISTS `lipids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lipids` (
  `lipid_class` varchar(64) NOT NULL,
  `lipid` varchar(64) NOT NULL,
  KEY `lipids_key` (`lipid_class`,`lipid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(64) NOT NULL,
  `data_signal` float DEFAULT NULL,
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `little_millet`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `little_millet` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `little_millet`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `llama3`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `llama3` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `llama3`;

--
-- Table structure for table `summaries`
--

DROP TABLE IF EXISTS `summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `summaries` (
  `gene_id` varchar(13) DEFAULT NULL,
  `summary` longtext,
  `bert_score` decimal(8,7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `localisations`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `localisations` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `localisations`;

--
-- Table structure for table `BAR_suba3`
--

DROP TABLE IF EXISTS `BAR_suba3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BAR_suba3` (
  `gene_id` varchar(20) NOT NULL,
  `alias` mediumtext,
  `lab_description` mediumtext,
  `gfp` mediumtext,
  `mass_spec` mediumtext,
  `swissprot` mediumtext,
  `amigo` mediumtext,
  `tair` mediumtext,
  `gs` mediumtext,
  `pred_ipsort` mediumtext,
  `pred_mitopred` mediumtext,
  `pred_mitoprot2` mediumtext,
  `pred_predotar` mediumtext,
  `pred_subloc` mediumtext,
  `pred_targetp` mediumtext,
  `pred_wolfpsort` mediumtext,
  `pred_multiloc2` mediumtext,
  `pred_adaboost` mediumtext,
  `pred_atp` mediumtext,
  `pred_bacello` mediumtext,
  `pred_chlorop` mediumtext,
  `pred_epiloc` mediumtext,
  `pred_nucleo` mediumtext,
  `pred_plantmploc` mediumtext,
  `pred_pclr` mediumtext,
  `pred_predsl` mediumtext,
  `pred_pprowler` mediumtext,
  `pred_pts1` mediumtext,
  `pred_slpfa` mediumtext,
  `pred_slplocal` mediumtext,
  `pred_yloc` mediumtext,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `BAR_suba4`
--

DROP TABLE IF EXISTS `BAR_suba4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BAR_suba4` (
  `gene_id` varchar(20) NOT NULL,
  `alias` mediumtext,
  `lab_description` mediumtext,
  `gfp` mediumtext,
  `mass_spec` mediumtext,
  `swissprot` mediumtext,
  `amigo` mediumtext,
  `tair` mediumtext,
  `gs` mediumtext,
  `pred_ipsort` mediumtext,
  `pred_mitopred` mediumtext,
  `pred_mitoprot2` mediumtext,
  `pred_predotar` mediumtext,
  `pred_subloc` mediumtext,
  `pred_targetp` mediumtext,
  `pred_wolfpsort` mediumtext,
  `pred_multiloc2` mediumtext,
  `pred_adaboost` mediumtext,
  `pred_atp` mediumtext,
  `pred_bacello` mediumtext,
  `pred_chlorop` mediumtext,
  `pred_epiloc` mediumtext,
  `pred_nucleo` mediumtext,
  `pred_plantmploc` mediumtext,
  `pred_pclr` mediumtext,
  `pred_predsl` mediumtext,
  `pred_pprowler` mediumtext,
  `pred_pts1` mediumtext,
  `pred_slpfa` mediumtext,
  `pred_slplocal` mediumtext,
  `pred_yloc` mediumtext,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Rice_mPLoc`
--

DROP TABLE IF EXISTS `Rice_mPLoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rice_mPLoc` (
  `gene_id` varchar(20) NOT NULL DEFAULT '',
  `alias` text,
  `lab_description` text,
  `gfp` text,
  `mass_spec` text,
  `swissprot` text,
  `amigo` text,
  `annotation` text,
  `pred_ipsort` text,
  `pred_mitopred` text,
  `pred_mitopred2` text,
  `pred_predator` text,
  `pred_peroxp` text,
  `pred_subloc` text,
  `pred_targetp` text,
  `pred_wolfpsort` text,
  `pred_multiloc` text,
  `pred_loctree` text,
  `pred_mPLoc` text,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cropPAL2_eplant`
--

DROP TABLE IF EXISTS `cropPAL2_eplant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cropPAL2_eplant` (
  `locus` varchar(64) NOT NULL,
  `location_consensus` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  KEY `locus_location` (`locus`,`location_consensus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `src_species_exp_34`
--

DROP TABLE IF EXISTS `src_species_exp_34`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `src_species_exp_34` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `source` enum('gfp','msms') NOT NULL,
  `locus` varchar(255) DEFAULT NULL,
  `taxaid` int DEFAULT NULL,
  `paper` varchar(32) DEFAULT NULL,
  `location` enum('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `match_type` mediumtext,
  PRIMARY KEY (`id`),
  KEY `ix_src_species_exp_34_source` (`source`),
  KEY `locus` (`locus`),
  KEY `taxaid` (`taxaid`)
) ENGINE=InnoDB AUTO_INCREMENT=38257 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suba`
--

DROP TABLE IF EXISTS `suba`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suba` (
  `gene_id` varchar(20) NOT NULL DEFAULT '',
  `alias` text,
  `lab_description` text,
  `gfp` text,
  `mass_spec` text,
  `swissprot` text,
  `amigo` text,
  `annotation` text,
  `pred_ipsort` text,
  `pred_mitopred` text,
  `pred_mitopred2` text,
  `pred_predator` text,
  `pred_peroxp` text,
  `pred_subloc` text,
  `pred_targetp` text,
  `pred_wolfpsort` text,
  `pred_multiloc` text,
  `pred_loctree` text,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suba3`
--

DROP TABLE IF EXISTS `suba3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suba3` (
  `id` int NOT NULL AUTO_INCREMENT,
  `locus` varchar(13) DEFAULT NULL,
  `chr` enum('1','2','3','4','5','C','M') DEFAULT NULL,
  `description` text,
  `ests` int DEFAULT '0',
  `flcdnas` int DEFAULT '0',
  `residues` int DEFAULT '0',
  `mwt` float DEFAULT '0',
  `pi` float DEFAULT '0',
  `gravy` float DEFAULT '0',
  `gfp_image` tinyint NOT NULL DEFAULT '0',
  `location_all_predictors` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_adaboost` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_atp` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_bacello` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_chlorop` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_epiloc` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_ipsort` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_mitopred` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_mitoprot2` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_multiloc2` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_nucleo` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_plantmploc` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_pclr` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_predotar` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_predsl` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_pprowler` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_pts1` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_slpfa` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_slplocal` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_subloc` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_targetp` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_wolfpsort` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_yloc` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_amigo` text NOT NULL,
  `location_tair` text NOT NULL,
  `location_swissprot` text NOT NULL,
  `spid` varchar(8) DEFAULT NULL,
  `location_ms` text NOT NULL,
  `location_gfp` text NOT NULL,
  `location_consensus` set('cell plate','cytoskeleton','cytosol','endoplasmic reticulum','extracellular','golgi','mitochondrion','nucleus','peroxisome','plasma membrane','plastid','unclear','vacuole','endosome') DEFAULT NULL,
  `location_gs` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_suba3_locus` (`locus`),
  FULLTEXT KEY `ft_index` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=35451 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `lupin_lcm_leaf`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lupin_lcm_leaf` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `lupin_lcm_leaf`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `lupin_lcm_pod`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lupin_lcm_pod` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `lupin_lcm_pod`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `lupin_lcm_stem`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lupin_lcm_stem` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `lupin_lcm_stem`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `lupin_pod_seed`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lupin_pod_seed` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `lupin_pod_seed`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `lupin_whole_plant`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lupin_whole_plant` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `lupin_whole_plant`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_RMA_linear`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_RMA_linear` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_RMA_linear`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(20) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(30) NOT NULL,
  `sample_tissue` text NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Current Database: `maize_RMA_log`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_RMA_log` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_RMA_log`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(20) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(30) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_annotations`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_annotations` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_annotations`;

--
-- Table structure for table `enzyme_gene_lookup`
--

DROP TABLE IF EXISTS `enzyme_gene_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enzyme_gene_lookup` (
  `data_probeset_id` varchar(60) NOT NULL,
  `gene` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`data_probeset_id`,`gene`,`date`),
  KEY `gene_probeset` (`gene`,`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enzyme_information`
--

DROP TABLE IF EXISTS `enzyme_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enzyme_information` (
  `data_probeset_id` varchar(40) NOT NULL,
  `unit` text NOT NULL,
  `type` text NOT NULL,
  `enzyme_class` text,
  `pathway` text,
  `compound_id` text,
  `pathway_name` text NOT NULL,
  KEY `probeset` (`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_annotations`
--

DROP TABLE IF EXISTS `gene_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotations` (
  `gene` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`date`),
  KEY `date_gene` (`date`,`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maize_rice_lookup`
--

DROP TABLE IF EXISTS `maize_rice_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maize_rice_lookup` (
  `maize_id` varchar(60) NOT NULL,
  `rice_id` varchar(60) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maize_v3_v4_lookup`
--

DROP TABLE IF EXISTS `maize_v3_v4_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maize_v3_v4_lookup` (
  `v4` varchar(24) NOT NULL,
  `v3` varchar(24) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`v4`,`v3`),
  KEY `v3_v4` (`v3`,`v4`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maize_v3_v5_lookup`
--

DROP TABLE IF EXISTS `maize_v3_v5_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maize_v3_v5_lookup` (
  `v3` varchar(24) NOT NULL,
  `v5` varchar(24) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`v5`,`v3`),
  KEY `v3_v5` (`v3`,`v5`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `metabolite_gene_lookup`
--

DROP TABLE IF EXISTS `metabolite_gene_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metabolite_gene_lookup` (
  `data_probeset_id` varchar(60) NOT NULL,
  `gene` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`data_probeset_id`,`gene`,`date`),
  KEY `gene_probeset` (`gene`,`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `metabolite_information`
--

DROP TABLE IF EXISTS `metabolite_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metabolite_information` (
  `data_probeset_id` varchar(42) NOT NULL,
  `unit` text NOT NULL,
  `type` text NOT NULL,
  `enzyme_class` text,
  `pathway` text,
  `compound_id` text,
  `pathway_name` text NOT NULL,
  KEY `probeset` (`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_atlas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_atlas` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_atlas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(5) NOT NULL,
  `proj_id` varchar(5) NOT NULL,
  `data_probeset_id` varchar(25) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_atlas_v5`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_atlas_v5` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_atlas_v5`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(25) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(40) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_buell_lab`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_buell_lab` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_buell_lab`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(50) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_early_seed`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_early_seed` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_early_seed`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(50) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_ears`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_ears` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_ears`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(20) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_embryonic_leaf_development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_embryonic_leaf_development` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_embryonic_leaf_development`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_enzyme`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_enzyme` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_enzyme`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_gdowns`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_gdowns` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_gdowns`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(30) NOT NULL,
  `proj_id` varchar(30) NOT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_gdowns_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_gdowns_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_gdowns_annotations_lookup`;

--
-- Table structure for table `maize_gdowns_lookup`
--

DROP TABLE IF EXISTS `maize_gdowns_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maize_gdowns_lookup` (
  `probeset` varchar(60) NOT NULL,
  `gene` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`gene`),
  KEY `date_gene` (`date`,`gene`,`probeset`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_interactions`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_interactions` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_interactions`;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(25) NOT NULL,
  `Protein2` varchar(25) NOT NULL,
  `Quality` float DEFAULT '0',
  `aiv_index` tinyint NOT NULL,
  `Pcc` float DEFAULT NULL,
  `bind_id` text,
  UNIQUE KEY `interactions_eplant` (`Protein1`,`Protein2`,`aiv_index`,`bind_id`(30)),
  KEY `aiv_index` (`aiv_index`),
  KEY `protein2` (`Protein2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_interactions_v5`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_interactions_v5` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_interactions_v5`;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(25) NOT NULL,
  `Protein2` varchar(25) NOT NULL,
  `Quality` float DEFAULT '0',
  `aiv_index` tinyint NOT NULL,
  `Pcc` float DEFAULT NULL,
  `bind_id` text,
  UNIQUE KEY `interactions_eplant` (`Protein1`,`Protein2`,`aiv_index`,`bind_id`(30)),
  KEY `aiv_index` (`aiv_index`),
  KEY `protein2` (`Protein2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_iplant`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_iplant` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_iplant`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(20) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_kernel_v5`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_kernel_v5` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_kernel_v5`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(25) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_leaf_gradient`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_leaf_gradient` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_leaf_gradient`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(20) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_lipid_map`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_lipid_map` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_lipid_map`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT NULL,
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_metabolite`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_metabolite` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_metabolite`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(64) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(5) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(50)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_nitrogen_use_efficiency`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_nitrogen_use_efficiency` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_nitrogen_use_efficiency`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_rice_comparison`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_rice_comparison` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_rice_comparison`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_root`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_root` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_root`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(255) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `maize_stress_v5`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `maize_stress_v5` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `maize_stress_v5`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(25) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(20) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_annotations_lookup` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_annotations_lookup`;

--
-- Table structure for table `mangosteen_annotation`
--

DROP TABLE IF EXISTS `mangosteen_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mangosteen_annotation` (
  `gene` varchar(12) NOT NULL,
  `annotation` text,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_aril_vs_rind`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_aril_vs_rind` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_aril_vs_rind`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(8) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_callus`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_callus` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_callus`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(8) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_diseased_vs_normal`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_diseased_vs_normal` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_diseased_vs_normal`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(8) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_fruit_ripening`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_fruit_ripening` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_fruit_ripening`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(8) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_seed_development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_seed_development` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_seed_development`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(8) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_seed_development_germination`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_seed_development_germination` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_seed_development_germination`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(8) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mangosteen_seed_germination`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mangosteen_seed_germination` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mangosteen_seed_germination`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(8) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `marchantia_organ_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `marchantia_organ_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `marchantia_organ_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `markergen`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `markergen` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `markergen`;

--
-- Table structure for table `accession`
--

DROP TABLE IF EXISTS `accession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accession` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capsfeedback`
--

DROP TABLE IF EXISTS `capsfeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capsfeedback` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `researcher_id` int unsigned NOT NULL DEFAULT '0',
  `capsinstance_id` int unsigned NOT NULL DEFAULT '0',
  `observed_fragment_list` varchar(100) NOT NULL DEFAULT '',
  `comment_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=232 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capsinstance`
--

DROP TABLE IF EXISTS `capsinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capsinstance` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `capsmarker_id` int unsigned NOT NULL DEFAULT '0',
  `fragment_list` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `capsmarker_id` (`capsmarker_id`),
  KEY `accession_id` (`accession_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1342063 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capsmarker`
--

DROP TABLE IF EXISTS `capsmarker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capsmarker` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `enzyme_id` int unsigned NOT NULL DEFAULT '0',
  `pcr_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `enzyme_id` (`enzyme_id`),
  KEY `pcr_id` (`pcr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=254982 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `researcher_id` int unsigned NOT NULL DEFAULT '0',
  `details` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset`
--

DROP TABLE IF EXISTS `dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dataset` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL DEFAULT '',
  `target_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `difference`
--

DROP TABLE IF EXISTS `difference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `difference` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `pattern` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61342 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enzyme`
--

DROP TABLE IF EXISTS `enzyme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enzyme` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene`
--

DROP TABLE IF EXISTS `gene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11079 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pcr`
--

DROP TABLE IF EXISTS `pcr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcr` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `dataset_id` int unsigned NOT NULL DEFAULT '0',
  `gene_id` int unsigned NOT NULL DEFAULT '0',
  `forward_id` int unsigned NOT NULL DEFAULT '0',
  `reverse_id` int unsigned NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL DEFAULT '0',
  `chromosome` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `forward_id` (`forward_id`),
  UNIQUE KEY `reverse_id` (`reverse_id`),
  UNIQUE KEY `product_id` (`product_id`),
  KEY `gene_id` (`gene_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23544 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pcrfeedback`
--

DROP TABLE IF EXISTS `pcrfeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcrfeedback` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `researcher_id` int unsigned NOT NULL DEFAULT '0',
  `pcr_id` int unsigned NOT NULL DEFAULT '0',
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `comment_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pickled_search`
--

DROP TABLE IF EXISTS `pickled_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pickled_search` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `researcher_id` int unsigned NOT NULL DEFAULT '0',
  `saved` date NOT NULL DEFAULT '0000-00-00',
  `reminder` date DEFAULT NULL,
  `pickle` text NOT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `polymorphism`
--

DROP TABLE IF EXISTS `polymorphism`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `polymorphism` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL DEFAULT '0',
  `difference_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `difference_id` (`difference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=133293 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primer`
--

DROP TABLE IF EXISTS `primer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `primer` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `seq` varchar(100) NOT NULL DEFAULT '',
  `start` int unsigned NOT NULL DEFAULT '0',
  `tm` float NOT NULL DEFAULT '0',
  `gc` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `start` (`start`)
) ENGINE=InnoDB AUTO_INCREMENT=47088 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primerfeedback`
--

DROP TABLE IF EXISTS `primerfeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `primerfeedback` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `researcher_id` int unsigned NOT NULL DEFAULT '0',
  `primer_id` int unsigned NOT NULL DEFAULT '0',
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `comment_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `target_seq` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23545 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `researcher`
--

DROP TABLE IF EXISTS `researcher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `researcher` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) NOT NULL DEFAULT '',
  `last_name` varchar(20) NOT NULL DEFAULT '',
  `user_name` varchar(20) NOT NULL DEFAULT '',
  `passwd` varchar(20) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sslpfeedback`
--

DROP TABLE IF EXISTS `sslpfeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sslpfeedback` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `researcher_id` int unsigned NOT NULL DEFAULT '0',
  `sslpinstance_id` int unsigned NOT NULL DEFAULT '0',
  `observed_product_size` varchar(100) NOT NULL DEFAULT '',
  `comment_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sslpinstance`
--

DROP TABLE IF EXISTS `sslpinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sslpinstance` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `pcr_id` int unsigned NOT NULL DEFAULT '0',
  `product_size` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `test`
--

DROP TABLE IF EXISTS `test`;
/*!50001 DROP VIEW IF EXISTS `test`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `test` AS SELECT 
 1 AS `name`,
 1 AS `product_id`,
 1 AS `count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vie_cvi`
--

DROP TABLE IF EXISTS `vie_cvi`;
/*!50001 DROP VIEW IF EXISTS `vie_cvi`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vie_cvi` AS SELECT 
 1 AS `agi`,
 1 AS `accesion_name`,
 1 AS `difference_id`,
 1 AS `difference_pattern`,
 1 AS `product_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vie_cvi1`
--

DROP TABLE IF EXISTS `vie_cvi1`;
/*!50001 DROP VIEW IF EXISTS `vie_cvi1`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vie_cvi1` AS SELECT 
 1 AS `agi`,
 1 AS `accesion_name`,
 1 AS `difference_id`,
 1 AS `difference_pattern`,
 1 AS `product_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vie_cvi2`
--

DROP TABLE IF EXISTS `vie_cvi2`;
/*!50001 DROP VIEW IF EXISTS `vie_cvi2`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vie_cvi2` AS SELECT 
 1 AS `agi`,
 1 AS `accesion_name`,
 1 AS `difference_id`,
 1 AS `difference_pattern`,
 1 AS `product_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vie_cvi3`
--

DROP TABLE IF EXISTS `vie_cvi3`;
/*!50001 DROP VIEW IF EXISTS `vie_cvi3`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vie_cvi3` AS SELECT 
 1 AS `agi`,
 1 AS `accesion_name`,
 1 AS `difference_id`,
 1 AS `difference_pattern`,
 1 AS `product_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vie_poly`
--

DROP TABLE IF EXISTS `vie_poly`;
/*!50001 DROP VIEW IF EXISTS `vie_poly`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vie_poly` AS SELECT 
 1 AS `name`,
 1 AS `forward_id`,
 1 AS `forward_seq`,
 1 AS `reverse_id`,
 1 AS `reverse_seq`,
 1 AS `product_id`,
 1 AS `target_seq`,
 1 AS `accesion_id`,
 1 AS `accesion_name`,
 1 AS `difference_id`,
 1 AS `difference_pattern`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vie_poly1`
--

DROP TABLE IF EXISTS `vie_poly1`;
/*!50001 DROP VIEW IF EXISTS `vie_poly1`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vie_poly1` AS SELECT 
 1 AS `name`,
 1 AS `forward_id`,
 1 AS `forward_seq`,
 1 AS `reverse_id`,
 1 AS `reverse_seq`,
 1 AS `product_id`,
 1 AS `target_seq`,
 1 AS `accesion_id`,
 1 AS `accesion_name`,
 1 AS `difference_id`,
 1 AS `difference_pattern`*/;
SET character_set_client = @saved_cs_client;

--
-- Current Database: `markergen_pop`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `markergen_pop` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `markergen_pop`;

--
-- Table structure for table `accession`
--

DROP TABLE IF EXISTS `accession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accession` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capsinstance`
--

DROP TABLE IF EXISTS `capsinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capsinstance` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `capsmarker_id` int unsigned NOT NULL DEFAULT '0',
  `fragment_list` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `capsmarker_id` (`capsmarker_id`),
  KEY `accession_id` (`accession_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1467292 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capsmarker`
--

DROP TABLE IF EXISTS `capsmarker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capsmarker` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `enzyme_id` int unsigned NOT NULL DEFAULT '0',
  `pcr_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `enzyme_id` (`enzyme_id`),
  KEY `pcr_id` (`pcr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=437018 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset`
--

DROP TABLE IF EXISTS `dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dataset` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL DEFAULT '',
  `target_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `difference`
--

DROP TABLE IF EXISTS `difference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `difference` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `pattern` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106993 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enzyme`
--

DROP TABLE IF EXISTS `enzyme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enzyme` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene`
--

DROP TABLE IF EXISTS `gene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=33604 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pcr`
--

DROP TABLE IF EXISTS `pcr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcr` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `dataset_id` int unsigned NOT NULL DEFAULT '0',
  `gene_id` int unsigned NOT NULL DEFAULT '0',
  `forward_id` int unsigned NOT NULL DEFAULT '0',
  `reverse_id` int unsigned NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL DEFAULT '0',
  `chromosome` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `forward_id` (`forward_id`),
  UNIQUE KEY `reverse_id` (`reverse_id`),
  UNIQUE KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48579 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `polymorphism`
--

DROP TABLE IF EXISTS `polymorphism`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `polymorphism` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL DEFAULT '0',
  `difference_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154252 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primer`
--

DROP TABLE IF EXISTS `primer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `primer` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `seq` varchar(100) NOT NULL DEFAULT '',
  `start` int unsigned NOT NULL DEFAULT '0',
  `tm` float NOT NULL DEFAULT '0',
  `gc` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `start` (`start`)
) ENGINE=InnoDB AUTO_INCREMENT=97157 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `target_seq` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48579 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `markergen_test`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `markergen_test` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `markergen_test`;

--
-- Table structure for table `accession`
--

DROP TABLE IF EXISTS `accession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accession` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capsinstance`
--

DROP TABLE IF EXISTS `capsinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capsinstance` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `capsmarker_id` int unsigned NOT NULL DEFAULT '0',
  `fragment_list` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `capsmarker_id` (`capsmarker_id`),
  KEY `accession_id` (`accession_id`)
) ENGINE=InnoDB AUTO_INCREMENT=607552 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capsmarker`
--

DROP TABLE IF EXISTS `capsmarker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capsmarker` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `enzyme_id` int unsigned NOT NULL DEFAULT '0',
  `pcr_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `enzyme_id` (`enzyme_id`),
  KEY `pcr_id` (`pcr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7148 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset`
--

DROP TABLE IF EXISTS `dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dataset` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL DEFAULT '',
  `target_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `difference`
--

DROP TABLE IF EXISTS `difference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `difference` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `pattern` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11039 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enzyme`
--

DROP TABLE IF EXISTS `enzyme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enzyme` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene`
--

DROP TABLE IF EXISTS `gene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=33604 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pcr`
--

DROP TABLE IF EXISTS `pcr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcr` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `dataset_id` int unsigned NOT NULL DEFAULT '0',
  `gene_id` int unsigned NOT NULL DEFAULT '0',
  `forward_id` int unsigned NOT NULL DEFAULT '0',
  `reverse_id` int unsigned NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL DEFAULT '0',
  `chromosome` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `forward_id` (`forward_id`),
  UNIQUE KEY `reverse_id` (`reverse_id`),
  UNIQUE KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=602 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `polymorphism`
--

DROP TABLE IF EXISTS `polymorphism`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `polymorphism` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `accession_id` int unsigned NOT NULL DEFAULT '0',
  `product_id` int unsigned NOT NULL DEFAULT '0',
  `difference_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58298 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primer`
--

DROP TABLE IF EXISTS `primer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `primer` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `seq` varchar(100) NOT NULL DEFAULT '',
  `start` int unsigned NOT NULL DEFAULT '0',
  `tm` float NOT NULL DEFAULT '0',
  `gc` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `start` (`start`)
) ENGINE=InnoDB AUTO_INCREMENT=1203 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `target_seq` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=602 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `medicago_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `medicago_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `medicago_annotations_lookup`;

--
-- Table structure for table `at_mtgi_lookup`
--

DROP TABLE IF EXISTS `at_mtgi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_mtgi_lookup` (
  `mtgi` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL,
  KEY `mtgi` (`mtgi`),
  KEY `probeset` (`probeset`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_mtgi_lookup_merged`
--

DROP TABLE IF EXISTS `at_mtgi_lookup_merged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_mtgi_lookup_merged` (
  `mtgi` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL,
  KEY `date` (`date`),
  KEY `mtgi_probeset` (`mtgi`,`probeset`),
  KEY `probeset_mtgi` (`probeset`,`mtgi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_mtgi_v3_5_lookup`
--

DROP TABLE IF EXISTS `at_mtgi_v3_5_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_mtgi_v3_5_lookup` (
  `mtgi` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_mtgi_v4_lookup`
--

DROP TABLE IF EXISTS `at_mtgi_v4_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_mtgi_v4_lookup` (
  `mtgi` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL,
  KEY `mtgi` (`mtgi`),
  KEY `probeset` (`probeset`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicago_seed_lookup`
--

DROP TABLE IF EXISTS `medicago_seed_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicago_seed_lookup` (
  `mtgi` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL,
  KEY `date` (`date`),
  KEY `gi_probe` (`mtgi`,`probeset`),
  KEY `probe_gi` (`probeset`,`mtgi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mtgi_annotation`
--

DROP TABLE IF EXISTS `mtgi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mtgi_annotation` (
  `mtgi` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`mtgi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mtgi_annotation_merged`
--

DROP TABLE IF EXISTS `mtgi_annotation_merged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mtgi_annotation_merged` (
  `mtgi` varchar(60) NOT NULL,
  `annotation` varchar(170) DEFAULT NULL,
  `date` date NOT NULL,
  KEY `date_gene` (`date`,`mtgi`,`annotation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mtgi_v3_5_annotation`
--

DROP TABLE IF EXISTS `mtgi_v3_5_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mtgi_v3_5_annotation` (
  `mtgi` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mtgi_v4_1_annotation`
--

DROP TABLE IF EXISTS `mtgi_v4_1_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mtgi_v4_1_annotation` (
  `mtgi` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `new_mtgi_lookup`
--

DROP TABLE IF EXISTS `new_mtgi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `new_mtgi_lookup` (
  `mtgi` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `medicago_mas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `medicago_mas` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `medicago_mas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(28) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(22) NOT NULL,
  `sample_tissue` text NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `medicago_rma`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `medicago_rma` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `medicago_rma`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(28) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(22) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `medicago_root`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `medicago_root` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `medicago_root`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL,
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_p_value` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `medicago_root_v5`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `medicago_root_v5` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `medicago_root_v5`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL,
  `data_probeset_id` varchar(64) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `medicago_seed`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `medicago_seed` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `medicago_seed`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL,
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_p_value` float DEFAULT '0',
  `data_bot_id` varchar(15) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `meristem_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `meristem_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `meristem_db`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(18) NOT NULL,
  `channel` varchar(5) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `meristem_db_new`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `meristem_db_new` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `meristem_db_new`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `channel` varchar(5) DEFAULT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12),`data_bot_id`(12)),
  KEY `data_bot_id` (`data_bot_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `mouse_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mouse_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mouse_db`;

--
-- Table structure for table `id_lookup`
--

DROP TABLE IF EXISTS `id_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `id_lookup` (
  `lookup` varchar(20) NOT NULL,
  `probe_id` varchar(15) NOT NULL,
  KEY `lookup_id` (`lookup`,`probe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `data_probeset_id` varchar(15) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(18) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `ngm_nina`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ngm_nina` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ngm_nina`;

--
-- Table structure for table `agi_annotation`
--

DROP TABLE IF EXISTS `agi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_annotation` (
  `agi` varchar(11) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`agi`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chr_seq_annotation`
--

DROP TABLE IF EXISTS `chr_seq_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chr_seq_annotation` (
  `SeqID` varchar(20) NOT NULL,
  `Source` varchar(15) NOT NULL,
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
  KEY `range` (`Source`,`SeqID`,`Start`,`End`),
  KEY `seqend` (`Source`,`SeqID`,`End`),
  KEY `typeid` (`SeqID`,`Source`,`Type`,`Parent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `oat`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `oat` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `oat`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `genome` varchar(16) NOT NULL,
  `version` varchar(2) NOT NULL,
  `genome_id` varchar(16) NOT NULL,
  `orthogroup` varchar(16) NOT NULL,
  `data_probeset_id` varchar(36) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `orthogroup_idx` (`orthogroup`,`data_bot_id`,`data_probeset_id`,`data_signal`),
  KEY `data_probeset_id_idx` (`data_probeset_id`,`orthogroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `ontologies`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ontologies` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ontologies`;

--
-- Table structure for table `go`
--

DROP TABLE IF EXISTS `go`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go` (
  `agi` varchar(16) NOT NULL,
  `tair_accession` mediumint unsigned NOT NULL DEFAULT '0',
  `object_name` varchar(16) NOT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL DEFAULT '',
  `tair_keyword` smallint unsigned NOT NULL DEFAULT '0',
  `aspect` varchar(5) NOT NULL DEFAULT '',
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) NOT NULL DEFAULT '',
  `reference` tinytext NOT NULL,
  `annotating_db` varchar(64) DEFAULT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  KEY `agi` (`agi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go_medicago`
--

DROP TABLE IF EXISTS `go_medicago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go_medicago` (
  `geneID` varchar(20) NOT NULL,
  `tair_accession` mediumint unsigned DEFAULT NULL,
  `object_name` varchar(20) DEFAULT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL,
  `tair_keyword` smallint unsigned DEFAULT NULL,
  `aspect` varchar(5) NOT NULL,
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) DEFAULT NULL,
  `reference` tinytext,
  `annotating_db` varchar(5) DEFAULT NULL,
  `date` date DEFAULT NULL,
  KEY `geneID` (`geneID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go_medicago_agrigo`
--

DROP TABLE IF EXISTS `go_medicago_agrigo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go_medicago_agrigo` (
  `geneID` varchar(20) NOT NULL,
  `tair_accession` mediumint unsigned DEFAULT NULL,
  `object_name` varchar(20) DEFAULT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL,
  `tair_keyword` smallint unsigned DEFAULT NULL,
  `aspect` varchar(5) NOT NULL,
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) DEFAULT NULL,
  `reference` tinytext,
  `annotating_db` varchar(5) DEFAULT NULL,
  `date` date DEFAULT NULL,
  KEY `geneID` (`geneID`),
  KEY `medindex` (`geneID`,`aspect`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go_medicago_agrigo_latest`
--

DROP TABLE IF EXISTS `go_medicago_agrigo_latest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go_medicago_agrigo_latest` (
  `geneID` varchar(20) NOT NULL,
  `tair_accession` mediumint unsigned DEFAULT NULL,
  `object_name` varchar(20) DEFAULT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL,
  `tair_keyword` smallint unsigned DEFAULT NULL,
  `aspect` varchar(5) NOT NULL,
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) DEFAULT NULL,
  `reference` tinytext,
  `annotating_db` varchar(5) DEFAULT NULL,
  `date` date DEFAULT NULL,
  KEY `geneID` (`geneID`),
  KEY `medindex` (`geneID`,`aspect`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go_medicago_uniprot`
--

DROP TABLE IF EXISTS `go_medicago_uniprot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go_medicago_uniprot` (
  `geneID` varchar(20) NOT NULL,
  `tair_accession` mediumint unsigned DEFAULT NULL,
  `object_name` varchar(20) DEFAULT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL,
  `tair_keyword` smallint unsigned DEFAULT NULL,
  `aspect` varchar(5) NOT NULL,
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) DEFAULT NULL,
  `reference` tinytext,
  `annotating_db` varchar(16) DEFAULT NULL,
  `date` date DEFAULT NULL,
  KEY `geneID` (`geneID`),
  KEY `medindex` (`geneID`,`aspect`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go_medicago_uniprot_latest`
--

DROP TABLE IF EXISTS `go_medicago_uniprot_latest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `go_medicago_uniprot_latest` (
  `geneID` varchar(20) NOT NULL,
  `tair_accession` mediumint unsigned DEFAULT NULL,
  `object_name` varchar(20) DEFAULT NULL,
  `go_term` tinytext NOT NULL,
  `go_id` varchar(11) NOT NULL,
  `tair_keyword` smallint unsigned DEFAULT NULL,
  `aspect` varchar(5) NOT NULL,
  `goslim_term` tinytext NOT NULL,
  `evidence_code` varchar(4) DEFAULT NULL,
  `reference` tinytext,
  `annotating_db` varchar(16) DEFAULT NULL,
  `date` date DEFAULT NULL,
  KEY `geneID` (`geneID`),
  KEY `medindex` (`geneID`,`aspect`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mapman`
--

DROP TABLE IF EXISTS `mapman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapman` (
  `maincode` varchar(4) NOT NULL,
  `bincode` varchar(15) NOT NULL,
  `name` varchar(150) NOT NULL,
  `identifier` varchar(20) NOT NULL,
  `description` text,
  `type` char(1) DEFAULT NULL,
  PRIMARY KEY (`bincode`,`identifier`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mapman2012`
--

DROP TABLE IF EXISTS `mapman2012`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapman2012` (
  `maincode` varchar(4) NOT NULL,
  `bincode` varchar(15) NOT NULL,
  `name` varchar(150) NOT NULL,
  `identifier` varchar(20) NOT NULL,
  `description` text,
  `type` char(1) DEFAULT NULL,
  PRIMARY KEY (`bincode`,`identifier`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Jan2010';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mapman_old`
--

DROP TABLE IF EXISTS `mapman_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapman_old` (
  `maincode` varchar(4) NOT NULL,
  `bincode` varchar(15) NOT NULL,
  `name` varchar(150) NOT NULL,
  `identifier` varchar(20) NOT NULL,
  `description` text,
  `type` char(1) DEFAULT NULL,
  PRIMARY KEY (`bincode`,`identifier`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Dec2008';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taggit`
--

DROP TABLE IF EXISTS `taggit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taggit` (
  `agi` varchar(10) NOT NULL DEFAULT '',
  `category` tinytext NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `ortholog_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ortholog_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ortholog_db`;

--
-- Table structure for table `arabidopsis`
--

DROP TABLE IF EXISTS `arabidopsis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_poplar_mcl`
--

DROP TABLE IF EXISTS `arabidopsis_poplar_mcl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_poplar_mcl` (
  `cluster` int NOT NULL,
  `gene` varchar(60) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `genome` varchar(6) NOT NULL,
  `date` date NOT NULL,
  `method` varchar(15) NOT NULL,
  PRIMARY KEY (`cluster`,`gene`),
  KEY `genecluster` (`cluster`,`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_poplar_scc`
--

DROP TABLE IF EXISTS `arabidopsis_poplar_scc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_poplar_scc` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(30) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `barley`
--

DROP TABLE IF EXISTS `barley`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barley` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicago`
--

DROP TABLE IF EXISTS `medicago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicago` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orthologs`
--

DROP TABLE IF EXISTS `orthologs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orthologs` (
  `cluster` int NOT NULL,
  `gene` varchar(100) NOT NULL,
  `genome` varchar(10) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  `method` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orthologs_scc`
--

DROP TABLE IF EXISTS `orthologs_scc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orthologs_scc` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(60) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Cluster` (`Genome_B`,`Probeset_B`,`Genome_A`),
  KEY `Genome_A` (`Genome_A`,`Probeset_A`,`Genome_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poplar`
--

DROP TABLE IF EXISTS `poplar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poplar` (
  `gene` varchar(60) NOT NULL,
  `sequence` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rice`
--

DROP TABLE IF EXISTS `rice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rice` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sequences`
--

DROP TABLE IF EXISTS `sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sequences` (
  `gene` varchar(40) NOT NULL,
  `sequence` tinytext NOT NULL,
  PRIMARY KEY (`gene`),
  KEY `gene_name` (`gene`(20))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `cluster` int NOT NULL,
  `gene` varchar(40) NOT NULL,
  `genome` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `phelipanche`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `phelipanche` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `phelipanche`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `phelipanche_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `phelipanche_annotations_lookup` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `phelipanche_annotations_lookup`;

--
-- Table structure for table `phelipanche_lookup`
--

DROP TABLE IF EXISTS `phelipanche_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phelipanche_lookup` (
  `phelipanche` varchar(16) NOT NULL,
  `arabidopsis` varchar(16) NOT NULL,
  `date` date NOT NULL,
  KEY `phelipanche` (`phelipanche`),
  KEY `arabidopsis` (`arabidopsis`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `phpmyadmin`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `phpmyadmin` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `phpmyadmin`;

--
-- Table structure for table `pma__bookmark`
--

DROP TABLE IF EXISTS `pma__bookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__bookmark` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `dbase` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `user` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `query` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Bookmarks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__central_columns`
--

DROP TABLE IF EXISTS `pma__central_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_type` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_length` text COLLATE utf8mb3_bin,
  `col_collation` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) COLLATE utf8mb3_bin DEFAULT '',
  `col_default` text COLLATE utf8mb3_bin,
  PRIMARY KEY (`db_name`,`col_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Central list of columns';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__column_info`
--

DROP TABLE IF EXISTS `pma__column_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__column_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `column_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `transformation_options` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `input_transformation` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Column information for phpMyAdmin';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__designer_settings`
--

DROP TABLE IF EXISTS `pma__designer_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `settings_data` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Settings related to Designer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__export_templates`
--

DROP TABLE IF EXISTS `pma__export_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__export_templates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `export_type` varchar(10) COLLATE utf8mb3_bin NOT NULL,
  `template_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `template_data` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Saved export templates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__favorite`
--

DROP TABLE IF EXISTS `pma__favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__favorite` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `tables` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Favorite tables';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__history`
--

DROP TABLE IF EXISTS `pma__history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `db` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sqlquery` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`,`db`,`table`,`timevalue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='SQL history for phpMyAdmin';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__navigationhiding`
--

DROP TABLE IF EXISTS `pma__navigationhiding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `item_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `item_type` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Hidden items of navigation tree';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__pdf_pages`
--

DROP TABLE IF EXISTS `pma__pdf_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `page_nr` int unsigned NOT NULL AUTO_INCREMENT,
  `page_descr` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`page_nr`),
  KEY `db_name` (`db_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='PDF relation pages for phpMyAdmin';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__recent`
--

DROP TABLE IF EXISTS `pma__recent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__recent` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `tables` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Recently accessed tables';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__relation`
--

DROP TABLE IF EXISTS `pma__relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__relation` (
  `master_db` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `master_table` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `master_field` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `foreign_db` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `foreign_table` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `foreign_field` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  KEY `foreign_field` (`foreign_db`,`foreign_table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Relation table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__savedsearches`
--

DROP TABLE IF EXISTS `pma__savedsearches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__savedsearches` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `search_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `search_data` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Saved searches';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__table_coords`
--

DROP TABLE IF EXISTS `pma__table_coords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `pdf_page_number` int NOT NULL DEFAULT '0',
  `x` float unsigned NOT NULL DEFAULT '0',
  `y` float unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Table coordinates for phpMyAdmin PDF output';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__table_info`
--

DROP TABLE IF EXISTS `pma__table_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `display_field` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`db_name`,`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Table information for phpMyAdmin';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__table_uiprefs`
--

DROP TABLE IF EXISTS `pma__table_uiprefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `prefs` text COLLATE utf8mb3_bin NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`,`db_name`,`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Tables'' UI preferences';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__tracking`
--

DROP TABLE IF EXISTS `pma__tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `version` int unsigned NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text COLLATE utf8mb3_bin NOT NULL,
  `schema_sql` text COLLATE utf8mb3_bin,
  `data_sql` longtext COLLATE utf8mb3_bin,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') COLLATE utf8mb3_bin DEFAULT NULL,
  `tracking_active` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`db_name`,`table_name`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Database changes tracking for phpMyAdmin';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__userconfig`
--

DROP TABLE IF EXISTS `pma__userconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__userconfig` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `config_data` text COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='User preferences storage for phpMyAdmin';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__usergroups`
--

DROP TABLE IF EXISTS `pma__usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `tab` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `allowed` enum('Y','N') COLLATE utf8mb3_bin NOT NULL DEFAULT 'N',
  PRIMARY KEY (`usergroup`,`tab`,`allowed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='User groups with configured menu items';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pma__users`
--

DROP TABLE IF EXISTS `pma__users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pma__users` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `usergroup` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`username`,`usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Users and their assignments to user groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `physcomitrella_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `physcomitrella_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `physcomitrella_annotations_lookup`;

--
-- Table structure for table `physcomitrella_annotation`
--

DROP TABLE IF EXISTS `physcomitrella_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `physcomitrella_annotation` (
  `probeset` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`),
  KEY `date_probeset` (`date`,`probeset`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `physcomitrella_lookup`
--

DROP TABLE IF EXISTS `physcomitrella_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `physcomitrella_lookup` (
  `probeset` varchar(60) NOT NULL,
  `gene` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`gene`),
  KEY `gene_probeset` (`gene`,`probeset`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `physcomitrella_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `physcomitrella_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `physcomitrella_db`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(30) NOT NULL DEFAULT '',
  `proj_id` varchar(30) NOT NULL DEFAULT '',
  `data_probeset_id` varchar(40) NOT NULL DEFAULT '',
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `proj_date_submit` date NOT NULL DEFAULT '0000-00-00',
  `proj_date_ready` date NOT NULL DEFAULT '0000-00-00',
  `proj_date_complete` date NOT NULL DEFAULT '0000-00-00',
  `proj_paid_date` date NOT NULL DEFAULT '0000-00-00',
  `proj_paid_amount` decimal(6,2) NOT NULL DEFAULT '0.00',
  `proj_title` tinytext,
  `proj_pi` tinytext,
  `proj_pi_title` tinytext,
  `proj_pi_inst` tinytext,
  `proj_pi_addr` tinytext,
  `proj_pi_tel` tinytext,
  `proj_pi_fax` tinytext,
  `proj_pi_email` tinytext,
  `proj_keyw1` tinytext,
  `proj_keyw2` tinytext,
  `proj_keyw3` tinytext,
  `proj_keyw4` tinytext,
  `proj_keyw5` tinytext,
  `proj_res_area` tinytext,
  `proj_abstr` text,
  `proj_prop` text,
  `proj_fund_src` text,
  `proj_num_samps` tinyint unsigned NOT NULL DEFAULT '0',
  `proj_num_arrays` tinyint unsigned NOT NULL DEFAULT '0',
  `proj_ht3_array` tinytext,
  PRIMARY KEY (`proj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proj_res_area`
--

DROP TABLE IF EXISTS `proj_res_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_res_area` (
  `proj_res_index` text,
  `proj_res_area` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) DEFAULT NULL,
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` varchar(40) NOT NULL,
  `data_num` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(70) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_call` varchar(12) NOT NULL,
  `data_p_val` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(40) DEFAULT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_ext_param`
--

DROP TABLE IF EXISTS `sample_ext_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_ext_param` (
  `sample_param_type` tinytext,
  `sample_param_index` tinytext NOT NULL,
  `sample_param_data` tinytext NOT NULL,
  `sample_param_ontology` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_extraction_info`
--

DROP TABLE IF EXISTS `sample_extraction_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_extraction_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_protocol_name` tinytext NOT NULL,
  `sample_protocol_method` tinytext,
  `sample_amplification` tinytext,
  `sample_other_info` tinytext,
  `sample_type` tinytext,
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) DEFAULT NULL,
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_name` tinytext,
  `sample_desc` longtext,
  `sample_od` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_mass` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_vol` decimal(10,3) unsigned NOT NULL DEFAULT '0.000',
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext,
  PRIMARY KEY (`sample_id`),
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybrid_blocking_agent`
--

DROP TABLE IF EXISTS `sample_hybrid_blocking_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybrid_blocking_agent` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `blocking_agent` tinytext,
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybrid_solution`
--

DROP TABLE IF EXISTS `sample_hybrid_solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybrid_solution` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `solution` tinytext,
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybrid_wash`
--

DROP TABLE IF EXISTS `sample_hybrid_wash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybrid_wash` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `step_num` int DEFAULT NULL,
  `wash_step` tinytext,
  KEY `sample_id` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_hybridization_info`
--

DROP TABLE IF EXISTS `sample_hybridization_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_hybridization_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) DEFAULT NULL,
  `sample_protocol_name` tinytext,
  `sample_amount` tinytext,
  `sample_time` int DEFAULT NULL,
  `sample_concentration` int DEFAULT NULL,
  `sample_volume` int DEFAULT NULL,
  `sample_temperature` int DEFAULT NULL,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_image_analysis_info`
--

DROP TABLE IF EXISTS `sample_image_analysis_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_image_analysis_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_image_name` tinytext,
  `sample_scaling_factor` float DEFAULT NULL,
  `sample_software_name` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_label_info`
--

DROP TABLE IF EXISTS `sample_label_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_label_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_protocol_name` tinytext,
  `sample_label_amount` int unsigned DEFAULT NULL,
  `sample_label_name` tinytext,
  `sample_label_method` tinytext,
  `sample_other_info` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_norm_info`
--

DROP TABLE IF EXISTS `sample_norm_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_norm_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_strategy` tinytext,
  `sample_algorithm` tinytext,
  `sample_ctrl_elem` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_scan_info`
--

DROP TABLE IF EXISTS `sample_scan_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_scan_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_protocol_name` tinytext,
  `sample_image_width` int unsigned DEFAULT NULL,
  `sample_image_height` int unsigned DEFAULT NULL,
  `sample_x_res` int unsigned DEFAULT NULL,
  `sample_y_res` int unsigned DEFAULT NULL,
  `sample_scanner_name` tinytext,
  `sample_software_name` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_slide_info`
--

DROP TABLE IF EXISTS `sample_slide_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_slide_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned DEFAULT NULL,
  `sample_date_hybridized` tinytext,
  `sample_slide_design_name` tinytext,
  `sample_array_source` tinytext,
  `sample_array_type` tinytext,
  `sample_num_array_spots` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_temp_data`
--

DROP TABLE IF EXISTS `sample_temp_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_temp_data` (
  `data_probeset_id` tinytext,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `data_signal` float NOT NULL DEFAULT '0',
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL DEFAULT '0',
  `data_bot_id` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar_annotations_lookup`;

--
-- Table structure for table `at_pgi_lookup`
--

DROP TABLE IF EXISTS `at_pgi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_pgi_lookup` (
  `probeset` varchar(60) NOT NULL,
  `pgi` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`pgi`,`date`),
  KEY `probeset` (`probeset`),
  KEY `pgi` (`pgi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pgi_annotation`
--

DROP TABLE IF EXISTS `pgi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pgi_annotation` (
  `pgi` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`pgi`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar_hormone`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar_hormone` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar_hormone`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar_interactions`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar_interactions` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar_interactions`;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(25) NOT NULL,
  `Protein2` varchar(25) NOT NULL,
  `aiv_index` tinyint NOT NULL,
  `cv` int DEFAULT NULL,
  UNIQUE KEY `interactions_eplant` (`Protein1`,`Protein2`,`aiv_index`,`cv`),
  KEY `aiv_index` (`aiv_index`),
  KEY `protein2` (`Protein2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar_leaf`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar_leaf` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar_leaf`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(70) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(40) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar_new_annotations`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar_new_annotations` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar_new_annotations`;

--
-- Table structure for table `at_pgi_lookup`
--

DROP TABLE IF EXISTS `at_pgi_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_pgi_lookup` (
  `probeset` varchar(60) NOT NULL,
  `pgi` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`probeset`,`pgi`,`date`),
  KEY `date` (`date`),
  KEY `pgi_probese` (`pgi`,`probeset`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pgi_annotation`
--

DROP TABLE IF EXISTS `pgi_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pgi_annotation` (
  `pgi` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`pgi`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar_nssnp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar_nssnp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar_nssnp`;

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
) ENGINE=InnoDB AUTO_INCREMENT=55981 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  UNIQUE KEY `preventdupe` (`chromosome`,`chromosomal_loci`,`ref_allele`,`alt_allele`,`sample_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25980390 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `poplar_xylem`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `poplar_xylem` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poplar_xylem`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(70) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(40) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `potato_annotations`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `potato_annotations` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `potato_annotations`;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene` varchar(25) NOT NULL,
  `annotation` tinytext NOT NULL,
  `date` date NOT NULL,
  KEY `gene_date` (`gene`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_protein_lookup`
--

DROP TABLE IF EXISTS `gene_protein_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_protein_lookup` (
  `probeset` varchar(25) NOT NULL,
  `gene` varchar(25) NOT NULL,
  `date` date NOT NULL,
  KEY `probeset_gene` (`probeset`,`gene`),
  KEY `gene_probeset` (`gene`,`probeset`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `potato_dev`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `potato_dev` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `potato_dev`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(15) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `potato_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `potato_stress` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `potato_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `potato_wounding`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `potato_wounding` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `potato_wounding`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `prot_model_data`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `prot_model_data` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `prot_model_data`;

--
-- Table structure for table `AGI_fasta`
--

DROP TABLE IF EXISTS `AGI_fasta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AGI_fasta` (
  `auto_inc` int NOT NULL AUTO_INCREMENT,
  `AGI_id` varchar(30) NOT NULL,
  `AGI_fasta` mediumtext NOT NULL,
  PRIMARY KEY (`auto_inc`),
  KEY `AGI_id` (`AGI_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33412 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CDD_annotations`
--

DROP TABLE IF EXISTS `CDD_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CDD_annotations` (
  `auto_inc` int NOT NULL AUTO_INCREMENT,
  `CDD_id` varchar(30) NOT NULL,
  `CDD_annot` mediumtext NOT NULL,
  PRIMARY KEY (`auto_inc`),
  KEY `CDD_id` (`CDD_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27049 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CDD_fasta`
--

DROP TABLE IF EXISTS `CDD_fasta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CDD_fasta` (
  `auto_inc` int NOT NULL AUTO_INCREMENT,
  `CDD_id` varchar(30) NOT NULL,
  `CDD_fasta` mediumtext NOT NULL,
  PRIMARY KEY (`auto_inc`),
  KEY `CDD_id` (`CDD_id`)
) ENGINE=InnoDB AUTO_INCREMENT=979 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CDD_model_mapping`
--

DROP TABLE IF EXISTS `CDD_model_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CDD_model_mapping` (
  `auto_inc` int NOT NULL AUTO_INCREMENT,
  `model_id` varchar(30) NOT NULL,
  `CDD_id` varchar(30) NOT NULL,
  PRIMARY KEY (`auto_inc`),
  KEY `model_id` (`model_id`,`CDD_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agi_annotations`
--

DROP TABLE IF EXISTS `agi_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agi_annotations` (
  `auto_inc` int NOT NULL AUTO_INCREMENT,
  `agi_id` varchar(11) NOT NULL,
  `agi_nosplice` varchar(9) NOT NULL,
  `blast_annotation` mediumtext,
  PRIMARY KEY (`auto_inc`),
  KEY `agi_id` (`agi_id`),
  KEY `agi_nosplice` (`agi_nosplice`)
) ENGINE=InnoDB AUTO_INCREMENT=3942670 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `model_data`
--

DROP TABLE IF EXISTS `model_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_data` (
  `model_id` varchar(30) NOT NULL,
  `model_path` mediumtext NOT NULL,
  `implicit_fasta` mediumtext NOT NULL,
  `html_alignments_path` mediumtext,
  `jmol_scripts_path` mediumtext,
  PRIMARY KEY (`model_id`),
  KEY `model_id` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdb_agi_mapping`
--

DROP TABLE IF EXISTS `pdb_agi_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdb_agi_mapping` (
  `auto_inc` int NOT NULL AUTO_INCREMENT,
  `model_id` varchar(30) NOT NULL,
  `agi_id` varchar(11) NOT NULL,
  `evalue` varchar(99) NOT NULL,
  PRIMARY KEY (`auto_inc`),
  KEY `model_id` (`model_id`),
  KEY `agi_id` (`agi_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3942670 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdb_cdd_mapping`
--

DROP TABLE IF EXISTS `pdb_cdd_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pdb_cdd_mapping` (
  `auto_inc` int NOT NULL AUTO_INCREMENT,
  `model_id` varchar(30) NOT NULL,
  `cdd_id` varchar(200) NOT NULL,
  PRIMARY KEY (`auto_inc`),
  KEY `model_id` (`model_id`,`cdd_id`)
) ENGINE=InnoDB AUTO_INCREMENT=472999 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_abiotic_stress_sc_pseudobulk`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_abiotic_stress_sc_pseudobulk` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_abiotic_stress_sc_pseudobulk`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(64) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_annotations_lookup`;

--
-- Table structure for table `at_loc_lookup`
--

DROP TABLE IF EXISTS `at_loc_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_loc_lookup` (
  `probeset` varchar(60) NOT NULL,
  `loc` varchar(30) NOT NULL,
  `date` date NOT NULL,
  KEY `date` (`date`),
  KEY `loc_probeset` (`loc`,`probeset`),
  KEY `probeset_loc` (`probeset`,`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_loc_lookup_merged`
--

DROP TABLE IF EXISTS `at_loc_lookup_merged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_loc_lookup_merged` (
  `probeset` varchar(60) NOT NULL,
  `loc` varchar(30) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enzyme_gene_lookup`
--

DROP TABLE IF EXISTS `enzyme_gene_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enzyme_gene_lookup` (
  `data_probeset_id` varchar(60) NOT NULL,
  `gene` varchar(60) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enzyme_information`
--

DROP TABLE IF EXISTS `enzyme_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enzyme_information` (
  `data_probeset_id` text NOT NULL,
  `unit` text NOT NULL,
  `type` text NOT NULL,
  `enzyme_class` text,
  `pathway` text,
  `compound_id` text,
  `pathway_name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loc_annotation`
--

DROP TABLE IF EXISTS `loc_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loc_annotation` (
  `loc` varchar(30) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`loc`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loc_annotation_merged`
--

DROP TABLE IF EXISTS `loc_annotation_merged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loc_annotation_merged` (
  `loc` varchar(30) NOT NULL,
  `annotation` longtext,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `metabolite_gene_lookup`
--

DROP TABLE IF EXISTS `metabolite_gene_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metabolite_gene_lookup` (
  `data_probeset_id` varchar(60) NOT NULL,
  `gene` varchar(60) NOT NULL,
  `date` date NOT NULL,
  KEY `probeset_gene` (`data_probeset_id`,`gene`),
  KEY `gene_probeset` (`gene`,`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `metabolite_information`
--

DROP TABLE IF EXISTS `metabolite_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metabolite_information` (
  `data_probeset_id` varchar(30) NOT NULL,
  `unit` text NOT NULL,
  `type` text NOT NULL,
  `enzyme_class` text,
  `pathway` text,
  `compound_id` text,
  `pathway_name` text NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `msu_rap`
--

DROP TABLE IF EXISTS `msu_rap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msu_rap` (
  `msu` varchar(16) DEFAULT NULL,
  `rap` varchar(16) DEFAULT NULL,
  KEY `msu_rap` (`msu`,`rap`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `new_loc_annotation`
--

DROP TABLE IF EXISTS `new_loc_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `new_loc_annotation` (
  `loc` varchar(30) NOT NULL,
  `annotation` longtext,
  `date` date NOT NULL,
  KEY `date_loc` (`date`,`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `new_loc_lookup`
--

DROP TABLE IF EXISTS `new_loc_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `new_loc_lookup` (
  `probeset` varchar(60) NOT NULL,
  `loc` varchar(30) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rice_maize_lookup`
--

DROP TABLE IF EXISTS `rice_maize_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rice_maize_lookup` (
  `rice_ID` varchar(60) NOT NULL,
  `maize_ID` varchar(60) NOT NULL,
  `date` date NOT NULL,
  KEY `date_gene` (`date`,`rice_ID`,`maize_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_drought_heat_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_drought_heat_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_drought_heat_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_interactions`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_interactions` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_interactions`;

--
-- Table structure for table `RGI_annotation`
--

DROP TABLE IF EXISTS `RGI_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RGI_annotation` (
  `loc` varchar(14) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`loc`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Rice_mPLoc`
--

DROP TABLE IF EXISTS `Rice_mPLoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rice_mPLoc` (
  `gene_id` varchar(20) NOT NULL DEFAULT '',
  `alias` text,
  `lab_description` text,
  `gfp` text,
  `mass_spec` text,
  `swissprot` text,
  `amigo` text,
  `annotation` text,
  `pred_ipsort` text,
  `pred_mitopred` text,
  `pred_mitopred2` text,
  `pred_predator` text,
  `pred_peroxp` text,
  `pred_subloc` text,
  `pred_targetp` text,
  `pred_wolfpsort` text,
  `pred_multiloc` text,
  `pred_loctree` text,
  `pred_mPLoc` text,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `interactions`
--

DROP TABLE IF EXISTS `interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interactions` (
  `Protein1` varchar(14) NOT NULL,
  `Protein2` varchar(14) NOT NULL,
  `S_cerevisiae` tinyint NOT NULL DEFAULT '0',
  `S_pombe` tinyint NOT NULL DEFAULT '0',
  `Worm` tinyint NOT NULL DEFAULT '0',
  `Fly` tinyint NOT NULL DEFAULT '0',
  `Human` tinyint NOT NULL DEFAULT '0',
  `Mouse` tinyint NOT NULL DEFAULT '0',
  `E_coli` tinyint NOT NULL DEFAULT '0',
  `Total_hits` smallint NOT NULL DEFAULT '0',
  `Num_species` tinyint NOT NULL DEFAULT '0',
  `Quality` smallint NOT NULL DEFAULT '0',
  `Index` tinyint NOT NULL DEFAULT '0',
  `Pcc` float DEFAULT NULL,
  `Bind_id` tinytext,
  UNIQUE KEY `Protein1` (`Protein1`,`Protein2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suba`
--

DROP TABLE IF EXISTS `suba`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suba` (
  `gene_id` varchar(20) NOT NULL DEFAULT '',
  `alias` text,
  `lab_description` text,
  `gfp` text,
  `mass_spec` text,
  `swissprot` text,
  `amigo` text,
  `annotation` text,
  `pred_ipsort` text,
  `pred_mitopred` text,
  `pred_mitopred2` text,
  `pred_predator` text,
  `pred_peroxp` text,
  `pred_subloc` text,
  `pred_targetp` text,
  `pred_wolfpsort` text,
  `pred_multiloc` text,
  `pred_loctree` text,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_leaf_gradient`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_leaf_gradient` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_leaf_gradient`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_maize_comparison`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_maize_comparison` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_maize_comparison`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_mas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_mas` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_mas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(28) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(26) NOT NULL,
  `sample_tissue` text NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_metabolite`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_metabolite` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_metabolite`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(25) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(6) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_rma`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_rma` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_rma`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(28) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(26) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rice_root`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rice_root` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rice_root`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rohan`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rohan` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rohan`;

--
-- Table structure for table `arab_soy_check`
--

DROP TABLE IF EXISTS `arab_soy_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arab_soy_check` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arab_stress_wilkins`
--

DROP TABLE IF EXISTS `arab_stress_wilkins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arab_stress_wilkins` (
  `sample_id` int NOT NULL,
  `proj_id` varchar(15) NOT NULL,
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL,
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  `sample_repl` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis`
--

DROP TABLE IF EXISTS `arabidopsis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_pop_stress`
--

DROP TABLE IF EXISTS `arabidopsis_pop_stress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_pop_stress` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(60) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_pop_stress_seq`
--

DROP TABLE IF EXISTS `arabidopsis_pop_stress_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_pop_stress_seq` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_rice_stress`
--

DROP TABLE IF EXISTS `arabidopsis_rice_stress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_rice_stress` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(60) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL,
  `Seq_similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_scc_seq`
--

DROP TABLE IF EXISTS `arabidopsis_scc_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_scc_seq` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_B` (`Gene_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_scc_test`
--

DROP TABLE IF EXISTS `arabidopsis_scc_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_scc_test` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(60) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Cluster` (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_tair10`
--

DROP TABLE IF EXISTS `arabidopsis_tair10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_tair10` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_bar_lookup`
--

DROP TABLE IF EXISTS `at_bar_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_bar_lookup` (
  `bar` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `barley`
--

DROP TABLE IF EXISTS `barley`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barley` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  KEY `date` (`date`),
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `barley_data`
--

DROP TABLE IF EXISTS `barley_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barley_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  `sample_repl` varchar(5) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabpop_stress_sccseq`
--

DROP TABLE IF EXISTS `expressolog_arabpop_stress_sccseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabpop_stress_sccseq` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabpop_stress_sccseq_nonulls`
--

DROP TABLE IF EXISTS `expressolog_arabpop_stress_sccseq_nonulls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabpop_stress_sccseq_nonulls` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabpop_stress_sccseq_v2`
--

DROP TABLE IF EXISTS `expressolog_arabpop_stress_sccseq_v2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabpop_stress_sccseq_v2` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabpop_stress_sccseq_v3`
--

DROP TABLE IF EXISTS `expressolog_arabpop_stress_sccseq_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabpop_stress_sccseq_v3` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabpop_stress_sccseq_v4`
--

DROP TABLE IF EXISTS `expressolog_arabpop_stress_sccseq_v4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabpop_stress_sccseq_v4` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabrice_stress_sccseq`
--

DROP TABLE IF EXISTS `expressolog_arabrice_stress_sccseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabrice_stress_sccseq` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabrice_stress_sccseq_nonulls`
--

DROP TABLE IF EXISTS `expressolog_arabrice_stress_sccseq_nonulls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabrice_stress_sccseq_nonulls` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabrice_stress_sccseq_v2`
--

DROP TABLE IF EXISTS `expressolog_arabrice_stress_sccseq_v2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabrice_stress_sccseq_v2` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabrice_stress_sccseq_v3`
--

DROP TABLE IF EXISTS `expressolog_arabrice_stress_sccseq_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabrice_stress_sccseq_v3` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_arabrice_stress_sccseq_v4`
--

DROP TABLE IF EXISTS `expressolog_arabrice_stress_sccseq_v4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_arabrice_stress_sccseq_v4` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_scc_seq`
--

DROP TABLE IF EXISTS `expressolog_scc_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_scc_seq` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_scc_seq_nonulls`
--

DROP TABLE IF EXISTS `expressolog_scc_seq_nonulls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_scc_seq_nonulls` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_scc_seq_v2`
--

DROP TABLE IF EXISTS `expressolog_scc_seq_v2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_scc_seq_v2` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_scc_seq_v3`
--

DROP TABLE IF EXISTS `expressolog_scc_seq_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_scc_seq_v3` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_scc_seq_v3_1`
--

DROP TABLE IF EXISTS `expressolog_scc_seq_v3_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_scc_seq_v3_1` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expressolog_scc_seq_v4`
--

DROP TABLE IF EXISTS `expressolog_scc_seq_v4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expressolog_scc_seq_v4` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grape`
--

DROP TABLE IF EXISTS `grape`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grape` (
  `gene` varchar(60) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loc_annotation`
--

DROP TABLE IF EXISTS `loc_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loc_annotation` (
  `loc` varchar(30) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maize`
--

DROP TABLE IF EXISTS `maize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maize` (
  `gene` varchar(60) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maize_rice_check`
--

DROP TABLE IF EXISTS `maize_rice_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maize_rice_check` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `med_data`
--

DROP TABLE IF EXISTS `med_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `med_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_repl` varchar(50) NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicago`
--

DROP TABLE IF EXISTS `medicago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicago` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicago_v3_5`
--

DROP TABLE IF EXISTS `medicago_v3_5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicago_v3_5` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicago_v4_1`
--

DROP TABLE IF EXISTS `medicago_v4_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicago_v4_1` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orthologs`
--

DROP TABLE IF EXISTS `orthologs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orthologs` (
  `cluster` int NOT NULL,
  `gene` varchar(100) NOT NULL,
  `genome` varchar(10) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  `method` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pop_stress_wilkins`
--

DROP TABLE IF EXISTS `pop_stress_wilkins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pop_stress_wilkins` (
  `sample_id` int NOT NULL,
  `data_probeset_id` varchar(70) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  `timepoint` varchar(50) NOT NULL,
  PRIMARY KEY (`sample_id`,`data_probeset_id`,`timepoint`),
  KEY `sample_id` (`sample_id`,`data_bot_id`,`timepoint`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poplar`
--

DROP TABLE IF EXISTS `poplar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poplar` (
  `gene` varchar(60) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `potato`
--

DROP TABLE IF EXISTS `potato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `potato` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  KEY `date` (`date`),
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `rice`
--

DROP TABLE IF EXISTS `rice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rice` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rice_data`
--

DROP TABLE IF EXISTS `rice_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rice_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  `sample_repl` varchar(10) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rice_new`
--

DROP TABLE IF EXISTS `rice_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rice_new` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sheezy`
--

DROP TABLE IF EXISTS `sheezy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sheezy` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Gene_A` (`Gene_A`,`Gene_B`),
  KEY `Gene_B` (`Gene_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `soybean`
--

DROP TABLE IF EXISTS `soybean`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soybean` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `soybean_merged`
--

DROP TABLE IF EXISTS `soybean_merged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soybean_merged` (
  `sample_id` int NOT NULL,
  `proj_id` varchar(15) NOT NULL,
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL,
  `data_bot_id` tinytext NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`(15)),
  KEY `data_probeset_id` (`data_probeset_id`(15),`data_bot_id`(20))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_expressolog`
--

DROP TABLE IF EXISTS `test_expressolog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_expressolog` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tissue_equivalency`
--

DROP TABLE IF EXISTS `tissue_equivalency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tissue_equivalency` (
  `Tissue_A` varchar(100) DEFAULT NULL,
  `Species_A` varchar(100) DEFAULT NULL,
  `Tissue_B` varchar(100) DEFAULT NULL,
  `Species_B` varchar(100) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Accession_A` varchar(100) DEFAULT NULL,
  `Accession_B` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tissue_equivalency_v2`
--

DROP TABLE IF EXISTS `tissue_equivalency_v2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tissue_equivalency_v2` (
  `Tissue_A` varchar(100) DEFAULT NULL,
  `Species_A` varchar(100) DEFAULT NULL,
  `Tissue_B` varchar(100) DEFAULT NULL,
  `Species_B` varchar(100) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Accession_A` varchar(100) DEFAULT NULL,
  `Accession_B` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tissue_equivalency_v3`
--

DROP TABLE IF EXISTS `tissue_equivalency_v3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tissue_equivalency_v3` (
  `Tissue_A` varchar(100) DEFAULT NULL,
  `Species_A` varchar(100) DEFAULT NULL,
  `Tissue_B` varchar(100) DEFAULT NULL,
  `Species_B` varchar(100) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Accession_A` varchar(100) DEFAULT NULL,
  `Accession_B` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tissue_equivalency_v4`
--

DROP TABLE IF EXISTS `tissue_equivalency_v4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tissue_equivalency_v4` (
  `Tissue_A` varchar(100) DEFAULT NULL,
  `Species_A` varchar(100) DEFAULT NULL,
  `Tissue_B` varchar(100) DEFAULT NULL,
  `Species_B` varchar(100) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Accession_A` varchar(100) DEFAULT NULL,
  `Accession_B` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tomato`
--

DROP TABLE IF EXISTS `tomato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tomato` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  KEY `date` (`date`),
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `root`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `root` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `root`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Current Database: `root_Schaefer_lab`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `root_Schaefer_lab` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `root_Schaefer_lab`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(20) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rpatel`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rpatel` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rpatel`;

--
-- Table structure for table `arab_stress_wilkins`
--

DROP TABLE IF EXISTS `arab_stress_wilkins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arab_stress_wilkins` (
  `sample_id` int NOT NULL,
  `proj_id` varchar(15) NOT NULL,
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL,
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  `sample_repl` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis`
--

DROP TABLE IF EXISTS `arabidopsis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_pop_stress`
--

DROP TABLE IF EXISTS `arabidopsis_pop_stress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_pop_stress` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(60) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_pop_stress_seq`
--

DROP TABLE IF EXISTS `arabidopsis_pop_stress_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_pop_stress_seq` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_rice_stress`
--

DROP TABLE IF EXISTS `arabidopsis_rice_stress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_rice_stress` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(60) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL,
  `Seq_similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_scc_seq`
--

DROP TABLE IF EXISTS `arabidopsis_scc_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_scc_seq` (
  `Cluster` int NOT NULL DEFAULT '0',
  `Gene_A` varchar(60) NOT NULL DEFAULT '',
  `Probeset_A` varchar(60) NOT NULL DEFAULT '',
  `Genome_A` varchar(30) DEFAULT NULL,
  `Gene_B` varchar(60) NOT NULL DEFAULT '',
  `Probeset_B` varchar(60) NOT NULL DEFAULT '',
  `Genome_B` varchar(30) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Seq_Similarity` int DEFAULT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `geneA_cluster` (`Gene_A`,`Cluster`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arabidopsis_scc_test`
--

DROP TABLE IF EXISTS `arabidopsis_scc_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arabidopsis_scc_test` (
  `Cluster` int NOT NULL,
  `Gene_A` varchar(60) NOT NULL,
  `Probeset_A` varchar(60) NOT NULL,
  `Genome_A` varchar(30) NOT NULL,
  `Gene_B` varchar(60) NOT NULL,
  `Probeset_B` varchar(60) NOT NULL,
  `Genome_B` varchar(30) NOT NULL,
  `SCC_Value` float NOT NULL,
  PRIMARY KEY (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`),
  KEY `Cluster` (`Cluster`,`Gene_A`,`Probeset_A`,`Gene_B`,`Probeset_B`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `at_bar_lookup`
--

DROP TABLE IF EXISTS `at_bar_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `at_bar_lookup` (
  `bar` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `barley`
--

DROP TABLE IF EXISTS `barley`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barley` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `barley_data`
--

DROP TABLE IF EXISTS `barley_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barley_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  `sample_repl` varchar(5) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loc_annotation`
--

DROP TABLE IF EXISTS `loc_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loc_annotation` (
  `loc` varchar(30) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `med_data`
--

DROP TABLE IF EXISTS `med_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `med_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_repl` varchar(50) NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicago`
--

DROP TABLE IF EXISTS `medicago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicago` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orthologs`
--

DROP TABLE IF EXISTS `orthologs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orthologs` (
  `cluster` int NOT NULL,
  `gene` varchar(100) NOT NULL,
  `genome` varchar(10) NOT NULL,
  `sequence` mediumtext NOT NULL,
  `date` date NOT NULL,
  `method` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pop_stress_wilkins`
--

DROP TABLE IF EXISTS `pop_stress_wilkins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pop_stress_wilkins` (
  `sample_id` int NOT NULL,
  `data_probeset_id` varchar(70) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  `timepoint` varchar(50) NOT NULL,
  PRIMARY KEY (`sample_id`,`data_probeset_id`,`timepoint`),
  KEY `sample_id` (`sample_id`,`data_bot_id`,`timepoint`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poplar`
--

DROP TABLE IF EXISTS `poplar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poplar` (
  `gene` varchar(60) NOT NULL,
  `sequence` mediumtext NOT NULL,
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `rice`
--

DROP TABLE IF EXISTS `rice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rice` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rice_data`
--

DROP TABLE IF EXISTS `rice_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rice_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `sample_tissue` varchar(50) NOT NULL,
  `sample_repl` varchar(10) NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  KEY `datapoint_id` (`sample_id`,`proj_id`,`data_probeset_id`(12)),
  KEY `data_probeset_id` (`data_probeset_id`(12))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `soybean`
--

DROP TABLE IF EXISTS `soybean`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soybean` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL,
  KEY `gene` (`gene`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `soybean_merged`
--

DROP TABLE IF EXISTS `soybean_merged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soybean_merged` (
  `sample_id` int NOT NULL,
  `proj_id` varchar(15) NOT NULL,
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL,
  `data_bot_id` tinytext NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`(15)),
  KEY `data_probeset_id` (`data_probeset_id`(15),`data_bot_id`(20))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `gene` varchar(30) NOT NULL,
  `sequence` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tissue_equivalency`
--

DROP TABLE IF EXISTS `tissue_equivalency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tissue_equivalency` (
  `Tissue_A` varchar(100) DEFAULT NULL,
  `Species_A` varchar(100) DEFAULT NULL,
  `Tissue_B` varchar(100) DEFAULT NULL,
  `Species_B` varchar(100) DEFAULT NULL,
  `SCC_Value` float DEFAULT NULL,
  `Accession_A` varchar(100) DEFAULT NULL,
  `Accession_B` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `rsvp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rsvp` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rsvp`;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `subjectId` int unsigned DEFAULT NULL,
  `testId` tinyint unsigned DEFAULT NULL,
  `question` int unsigned DEFAULT NULL,
  `time_taken` int unsigned DEFAULT NULL,
  `status` tinyint DEFAULT NULL,
  `step` int DEFAULT NULL,
  `image` int DEFAULT NULL,
  `response` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_info`
--

DROP TABLE IF EXISTS `subject_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `testID` tinyint unsigned DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `age` int unsigned DEFAULT NULL,
  `gender` varchar(8) DEFAULT NULL,
  `pointer` varchar(16) DEFAULT NULL,
  `red` varchar(16) DEFAULT NULL,
  `start` varchar(64) DEFAULT NULL,
  `end` varchar(64) DEFAULT NULL,
  `total_time` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `seed_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `seed_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `seed_db`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(20) NOT NULL DEFAULT '0',
  `sample_file_name` varchar(100) DEFAULT NULL,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` varchar(40) DEFAULT NULL,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(64) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data_test`
--

DROP TABLE IF EXISTS `sample_data_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data_test` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` int unsigned NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` tinytext NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
-- Current Database: `seedcoat`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `seedcoat` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `seedcoat`;

--
-- Table structure for table `proj_info`
--

DROP TABLE IF EXISTS `proj_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proj_info` (
  `proj_id` varchar(15) NOT NULL,
  `proj_title` tinytext,
  `proj_pi` tinytext,
  `proj_pi_title` tinytext,
  `proj_pi_inst` tinytext,
  `proj_keyw1` tinytext,
  `proj_keyw2` tinytext,
  `proj_keyw3` tinytext,
  `proj_keyw4` tinytext,
  `proj_keyw5` tinytext,
  `proj_res_area` tinytext,
  `proj_num_samps` tinyint unsigned NOT NULL,
  PRIMARY KEY (`proj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_biosource_info`
--

DROP TABLE IF EXISTS `sample_biosource_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_biosource_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
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
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(22) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_general_info`
--

DROP TABLE IF EXISTS `sample_general_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_general_info` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_repl` tinytext,
  `sample_ctrl` tinytext,
  `sample_desc` tinytext,
  `sample_file_name` tinytext,
  `sample_bot_id` tinytext NOT NULL,
  `sample_name` tinytext,
  PRIMARY KEY (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `selaginella`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `selaginella` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `selaginella`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(36) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `shoot_apex`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `shoot_apex` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `shoot_apex`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(2) DEFAULT NULL,
  `sample_file_name` varchar(16) DEFAULT NULL,
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` varchar(2) DEFAULT NULL,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `silique`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `silique` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `silique`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(12) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(64) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `single_cell`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `single_cell` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `single_cell`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_atlas_w_BS_cells`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_atlas_w_BS_cells` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_atlas_w_BS_cells`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_bundle_sheath`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_bundle_sheath` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_bundle_sheath`;

--
-- Current Database: `sorghum_comparative_transcriptomics`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_comparative_transcriptomics` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_comparative_transcriptomics`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(40) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_developmental`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_developmental` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_developmental`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_developmental_2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_developmental_2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_developmental_2`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_flowering_activation`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_flowering_activation` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_flowering_activation`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_low_phosphorus`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_low_phosphorus` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_low_phosphorus`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_nitrogen_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_nitrogen_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_nitrogen_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_nitrogen_use_efficiency`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_nitrogen_use_efficiency` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_nitrogen_use_efficiency`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_phosphate_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_phosphate_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_phosphate_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_plasma`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_plasma` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_plasma`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_saline_alkali_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_saline_alkali_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_saline_alkali_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_strigolactone_variation`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_strigolactone_variation` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_strigolactone_variation`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_sulfur_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_sulfur_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_sulfur_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_temperature_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_temperature_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_temperature_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sorghum_vascularization_and_internode`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sorghum_vascularization_and_internode` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sorghum_vascularization_and_internode`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `soybean`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `soybean` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `soybean`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int NOT NULL,
  `proj_id` varchar(15) NOT NULL,
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` varchar(36) NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL,
  `data_bot_id` varchar(22) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`(15)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `soybean_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `soybean_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `soybean_annotations_lookup`;

--
-- Table structure for table `gene_probeset_lookup`
--

DROP TABLE IF EXISTS `gene_probeset_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_probeset_lookup` (
  `gene` varchar(100) NOT NULL,
  `probeset` varchar(100) NOT NULL,
  `date` date NOT NULL,
  KEY `gene_probeset` (`gene`,`probeset`),
  KEY `probeset_gene` (`probeset`,`gene`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gmax_annotation`
--

DROP TABLE IF EXISTS `gmax_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gmax_annotation` (
  `gmax` varchar(30) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gmax`,`date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `soybean_embryonic_development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `soybean_embryonic_development` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `soybean_embryonic_development`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(42) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `soybean_heart_cotyledon_globular`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `soybean_heart_cotyledon_globular` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `soybean_heart_cotyledon_globular`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(42) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `soybean_nssnp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `soybean_nssnp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `soybean_nssnp`;

--
-- Table structure for table `protein_reference`
--

DROP TABLE IF EXISTS `protein_reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `protein_reference` (
  `protein_reference_id` int NOT NULL AUTO_INCREMENT,
  `gene_name` varchar(45) DEFAULT NULL,
  `gene_identifier` varchar(45) NOT NULL,
  PRIMARY KEY (`protein_reference_id`),
  KEY `protein_gene_id_idx` (`gene_identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=88178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_lookup`
--

DROP TABLE IF EXISTS `sample_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_lookup` (
  `sample_id` varchar(45) NOT NULL,
  `dataset` varchar(45) DEFAULT NULL,
  `dataset_sample` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`sample_id`),
  CONSTRAINT `sample_id` FOREIGN KEY (`sample_id`) REFERENCES `snps_reference` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `soybean_senescence`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `soybean_senescence` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `soybean_senescence`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(8) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `soybean_severin`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `soybean_severin` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `soybean_severin`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int NOT NULL,
  `proj_id` varchar(15) NOT NULL,
  `sample_file_name` tinytext NOT NULL,
  `data_probeset_id` varchar(18) NOT NULL,
  `data_signal` float NOT NULL,
  `data_call` tinytext NOT NULL,
  `data_p_val` float NOT NULL,
  `data_bot_id` varchar(18) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`(15)),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `spruce`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `spruce` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `spruce`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `strawberry`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `strawberry` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `strawberry`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `strawberry_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `strawberry_annotations_lookup` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `strawberry_annotations_lookup`;

--
-- Table structure for table `strawberry_lookup`
--

DROP TABLE IF EXISTS `strawberry_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `strawberry_lookup` (
  `v4_0_a1` varchar(24) NOT NULL,
  `v2_0_a2` varchar(24) NOT NULL,
  `date` date NOT NULL,
  KEY `v4` (`v4_0_a1`),
  KEY `v2` (`v2_0_a2`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `striga`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `striga` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `striga`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(42) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `striga_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `striga_annotations_lookup` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `striga_annotations_lookup`;

--
-- Table structure for table `striga_lookup`
--

DROP TABLE IF EXISTS `striga_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `striga_lookup` (
  `striga` varchar(24) NOT NULL,
  `arabidopsis` varchar(16) NOT NULL,
  `date` date NOT NULL,
  KEY `striga` (`striga`),
  KEY `arabidopsis` (`arabidopsis`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `string`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `string` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `string`;

--
-- Table structure for table `actions_sets`
--

DROP TABLE IF EXISTS `actions_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions_sets` (
  `item_id_a` int NOT NULL,
  `item_id_b` int NOT NULL,
  `mode` varchar(16) NOT NULL,
  `source` varchar(1024) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fusion_evidence`
--

DROP TABLE IF EXISTS `fusion_evidence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fusion_evidence` (
  `target_protein_id_a` int NOT NULL,
  `target_protein_id_b` int NOT NULL,
  `source_protein` int NOT NULL,
  `source_species` int NOT NULL,
  `transfer_score_c1` int NOT NULL,
  `transfer_score_c2` int NOT NULL,
  `fusion_score` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sets`
--

DROP TABLE IF EXISTS `sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sets` (
  `set_id` varchar(32) NOT NULL,
  `collection_id` varchar(16) NOT NULL,
  `title` varchar(256) NOT NULL,
  `comment` varchar(512) NOT NULL,
  `url` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sets_items`
--

DROP TABLE IF EXISTS `sets_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sets_items` (
  `set_id` varchar(32) NOT NULL,
  `item_id` int NOT NULL,
  `species_id` int NOT NULL,
  `preferred_name` varchar(16) NOT NULL,
  `set_type` varchar(8) NOT NULL,
  KEY `mike_idx` (`item_id`,`preferred_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sets_pubmedrefs`
--

DROP TABLE IF EXISTS `sets_pubmedrefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sets_pubmedrefs` (
  `set_id` varchar(32) NOT NULL,
  `pubmed_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sugarcane_culms`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sugarcane_culms` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sugarcane_culms`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sugarcane_leaf`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sugarcane_leaf` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sugarcane_leaf`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(12) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(32) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `summarization`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `summarization` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `summarization`;

--
-- Table structure for table `00efbabb92f34e97a082f2d831bf4ca7`
--

DROP TABLE IF EXISTS `00efbabb92f34e97a082f2d831bf4ca7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `00efbabb92f34e97a082f2d831bf4ca7` (
  `index` bigint DEFAULT NULL,
  `data_probeset_id` text,
  `data_bot_id` text,
  `data_signal` double DEFAULT NULL,
  KEY `ix_00efbabb92f34e97a082f2d831bf4ca7_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `3048d74091294927a11bee8cd6bd458d`
--

DROP TABLE IF EXISTS `3048d74091294927a11bee8cd6bd458d`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `3048d74091294927a11bee8cd6bd458d` (
  `index` bigint DEFAULT NULL,
  `Gene` text,
  `Sample` text,
  `Value` double DEFAULT NULL,
  KEY `ix_3048d74091294927a11bee8cd6bd458d_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `3430dfa7e07c4f51abae06e37fc6ba44`
--

DROP TABLE IF EXISTS `3430dfa7e07c4f51abae06e37fc6ba44`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `3430dfa7e07c4f51abae06e37fc6ba44` (
  `index` bigint DEFAULT NULL,
  `data_probeset_id` text,
  `data_bot_id` text,
  `data_signal` double DEFAULT NULL,
  KEY `ix_3430dfa7e07c4f51abae06e37fc6ba44_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `389da49401ae4eb9a9e305a885332625`
--

DROP TABLE IF EXISTS `389da49401ae4eb9a9e305a885332625`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `389da49401ae4eb9a9e305a885332625` (
  `index` varchar(42) DEFAULT NULL,
  `Gene` varchar(32) DEFAULT NULL,
  `Sample` varchar(32) DEFAULT NULL,
  `Value` float DEFAULT NULL,
  KEY `ix_389da49401ae4eb9a9e305a885332625_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `491e05d84cf542e8a7dbc5b7c597a501`
--

DROP TABLE IF EXISTS `491e05d84cf542e8a7dbc5b7c597a501`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `491e05d84cf542e8a7dbc5b7c597a501` (
  `index` bigint DEFAULT NULL,
  `data_probeset_id` text,
  `data_bot_id` text,
  `data_signal` double DEFAULT NULL,
  KEY `ix_491e05d84cf542e8a7dbc5b7c597a501_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `6212aacf65444c57bf5d42746a618eb7`
--

DROP TABLE IF EXISTS `6212aacf65444c57bf5d42746a618eb7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `6212aacf65444c57bf5d42746a618eb7` (
  `index` bigint DEFAULT NULL,
  `data_probeset_id` text,
  `data_bot_id` text,
  `data_signal` double DEFAULT NULL,
  KEY `ix_6212aacf65444c57bf5d42746a618eb7_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `64c1e4e3db06405abe9a8771865ff40a`
--

DROP TABLE IF EXISTS `64c1e4e3db06405abe9a8771865ff40a`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `64c1e4e3db06405abe9a8771865ff40a` (
  `index` varchar(42) DEFAULT NULL,
  `Gene` varchar(32) DEFAULT NULL,
  `Sample` varchar(32) DEFAULT NULL,
  `Value` float DEFAULT NULL,
  KEY `ix_64c1e4e3db06405abe9a8771865ff40a_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `6a45ae413bcc4da59157a132125b2b0a`
--

DROP TABLE IF EXISTS `6a45ae413bcc4da59157a132125b2b0a`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `6a45ae413bcc4da59157a132125b2b0a` (
  `index` bigint DEFAULT NULL,
  `Gene` text,
  `Sample` text,
  `Value` float DEFAULT NULL,
  KEY `ix_sample_data_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `9344a03ddc7646bea3f6a8426073cc10`
--

DROP TABLE IF EXISTS `9344a03ddc7646bea3f6a8426073cc10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `9344a03ddc7646bea3f6a8426073cc10` (
  `index` bigint DEFAULT NULL,
  `data_probeset_id` text,
  `data_bot_id` text,
  `data_signal` double DEFAULT NULL,
  KEY `ix_9344a03ddc7646bea3f6a8426073cc10_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `9f50dc7a83754f05ac66e958a610e619`
--

DROP TABLE IF EXISTS `9f50dc7a83754f05ac66e958a610e619`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `9f50dc7a83754f05ac66e958a610e619` (
  `index` bigint DEFAULT NULL,
  `Gene` text,
  `Sample` text,
  `Value` double DEFAULT NULL,
  KEY `ix_9f50dc7a83754f05ac66e958a610e619_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `adksdamkkm2132123azdlaso`
--

DROP TABLE IF EXISTS `adksdamkkm2132123azdlaso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adksdamkkm2132123azdlaso` (
  `index` bigint DEFAULT NULL,
  `data_probeset_id` text,
  `data_bot_id` text,
  `data_signal` double DEFAULT NULL,
  KEY `ix_adksdamkkm2132123azdlaso_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cc36786116eb4f83a5c3cb69adfcfcd2`
--

DROP TABLE IF EXISTS `cc36786116eb4f83a5c3cb69adfcfcd2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cc36786116eb4f83a5c3cb69adfcfcd2` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int NOT NULL,
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(32) NOT NULL,
  PRIMARY KEY (`data_probeset_id`,`data_signal`,`data_bot_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `e033b2ad89464e21aec70d4817b72d09`
--

DROP TABLE IF EXISTS `e033b2ad89464e21aec70d4817b72d09`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `e033b2ad89464e21aec70d4817b72d09` (
  `index` varchar(42) DEFAULT NULL,
  `Gene` varchar(32) DEFAULT NULL,
  `Sample` varchar(32) DEFAULT NULL,
  `Value` float DEFAULT NULL,
  KEY `ix_e033b2ad89464e21aec70d4817b72d09_index` (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requests` (
  `first_name` text,
  `last_name` text,
  `email` text,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `first_name` varchar(32) DEFAULT NULL,
  `last_name` varchar(32) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `telephone` varchar(12) DEFAULT NULL,
  `contact_type` varchar(5) DEFAULT NULL,
  `api_key` varchar(120) NOT NULL,
  `status` varchar(32) DEFAULT NULL,
  `date_added` date NOT NULL,
  `uses_left` int DEFAULT NULL,
  PRIMARY KEY (`api_key`),
  UNIQUE KEY `ix_users_email` (`email`),
  KEY `ix_users_status` (`status`),
  KEY `ix_users_last_name` (`last_name`),
  KEY `ix_users_uses_left` (`uses_left`),
  KEY `ix_users_first_name` (`first_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sunflower`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sunflower` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sunflower`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `thellungiella_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `thellungiella_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `thellungiella_annotations_lookup`;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `thellungiella_gene` varchar(40) NOT NULL,
  `arabidopsis_gene` varchar(30) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tsa_arabidopsis_lookup`
--

DROP TABLE IF EXISTS `tsa_arabidopsis_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsa_arabidopsis_lookup` (
  `thellungiella_gene` varchar(40) NOT NULL,
  `arabidopsis_gene` varchar(30) NOT NULL,
  `date` date NOT NULL,
  KEY `date` (`date`),
  KEY `at_gene` (`thellungiella_gene`,`arabidopsis_gene`,`date`),
  KEY `gene_at` (`arabidopsis_gene`,`thellungiella_gene`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `thellungiella_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `thellungiella_db` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `thellungiella_db`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` varchar(30) NOT NULL,
  `proj_id` varchar(30) NOT NULL,
  `sample_file_name` varchar(80) DEFAULT NULL,
  `data_probeset_id` varchar(40) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(40) NOT NULL,
  PRIMARY KEY (`sample_id`,`proj_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(18) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(18) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_annotations_lookup`;

--
-- Table structure for table `454_Illumina_lookup`
--

DROP TABLE IF EXISTS `454_Illumina_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `454_Illumina_lookup` (
  `454_id` varchar(60) NOT NULL,
  `Illumina_id` varchar(60) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`454_id`,`Illumina_id`,`date`),
  KEY `data` (`date`),
  KEY `illumina` (`Illumina_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tomato_annotations`
--

DROP TABLE IF EXISTS `tomato_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tomato_annotations` (
  `gene` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  KEY `data` (`date`),
  KEY `gene_date` (`gene`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trait_gene_lookup`
--

DROP TABLE IF EXISTS `trait_gene_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trait_gene_lookup` (
  `data_probeset_id` varchar(100) NOT NULL,
  `gene` varchar(50) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trait_info`
--

DROP TABLE IF EXISTS `trait_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trait_info` (
  `exper` varchar(40) NOT NULL,
  `trait` varchar(30) NOT NULL,
  `desc` varchar(100) NOT NULL,
  `units` varchar(40) NOT NULL,
  KEY `desc` (`desc`,`units`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_ils`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_ils` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_ils`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(20) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_p_value` float DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_ils2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_ils2` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_ils2`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(20) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_p_value` float DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  `log` float NOT NULL,
  `p_val` float NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_ils3`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_ils3` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_ils3`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(20) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_p_value` float DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_meristem`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_meristem` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_meristem`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_nssnp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_nssnp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_nssnp`;

--
-- Table structure for table `lines_lookup`
--

DROP TABLE IF EXISTS `lines_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lines_lookup` (
  `lines_id` varchar(45) NOT NULL,
  `species` varchar(35) DEFAULT NULL,
  `alias` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`lines_id`),
  CONSTRAINT `lines_id` FOREIGN KEY (`lines_id`) REFERENCES `snps_reference` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=91149 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_renormalized`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_renormalized` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_renormalized`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(18) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(18) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_root`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_root` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_root`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_root_field_pot`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_root_field_pot` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_root_field_pot`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(18) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(12) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_s_pennellii`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_s_pennellii` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_s_pennellii`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(20) DEFAULT NULL,
  `data_signal` float DEFAULT '0',
  `data_p_value` float DEFAULT '0',
  `data_bot_id` varchar(24) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_seed`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_seed` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_seed`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(24) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_sequence`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_sequence` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_sequence`;

--
-- Table structure for table `tomato_3_2_sequence_info`
--

DROP TABLE IF EXISTS `tomato_3_2_sequence_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tomato_3_2_sequence_info` (
  `gene_id` varchar(20) NOT NULL,
  `full_seq` varchar(9999) DEFAULT NULL,
  `full_seq_len` int DEFAULT NULL,
  `phyre2_seq` varchar(9999) DEFAULT NULL,
  `phyre2_seq_start` int DEFAULT NULL,
  `phyre2_seq_end` int DEFAULT NULL,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_shade_mutants`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_shade_mutants` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_shade_mutants`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(20) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_shade_timecourse`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_shade_timecourse` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_shade_timecourse`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tomato_trait`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tomato_trait` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tomato_trait`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(30) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(100) NOT NULL,
  `data_signal` float DEFAULT NULL,
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` tinytext NOT NULL,
  `qvalue` float DEFAULT NULL,
  KEY `sample_id` (`sample_id`,`proj_id`,`data_probeset_id`),
  KEY `data_probeset_id` (`data_probeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `triphysaria`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `triphysaria` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `triphysaria`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(5) NOT NULL,
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(32) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `triphysaria_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `triphysaria_annotations_lookup` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `triphysaria_annotations_lookup`;

--
-- Table structure for table `triphysaria_lookup`
--

DROP TABLE IF EXISTS `triphysaria_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triphysaria_lookup` (
  `triphysaria` varchar(24) NOT NULL,
  `arabidopsis` varchar(16) NOT NULL,
  `date` date NOT NULL,
  KEY `triphysaria` (`triphysaria`),
  KEY `arabidopsis` (`arabidopsis`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `triticale`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `triticale` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `triticale`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(18) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `triticale_annotations_lookup`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `triticale_annotations_lookup` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `triticale_annotations_lookup`;

--
-- Table structure for table `triticale_annotation`
--

DROP TABLE IF EXISTS `triticale_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triticale_annotation` (
  `gene` varchar(60) NOT NULL,
  `annotation` longtext NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`gene`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `triticale_lookup`
--

DROP TABLE IF EXISTS `triticale_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triticale_lookup` (
  `gene` varchar(60) NOT NULL,
  `probeset` varchar(60) NOT NULL,
  `date` date NOT NULL,
  KEY `gene` (`gene`),
  KEY `probeset` (`probeset`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `triticale_mas`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `triticale_mas` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `triticale_mas`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_file_name` tinytext,
  `data_probeset_id` varchar(30) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_call` tinytext,
  `data_p_val` float DEFAULT '0',
  `data_bot_id` varchar(30) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `tung_tree`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tung_tree` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tung_tree`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `proj_id` varchar(5) NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(16) NOT NULL,
  `data_signal` float NOT NULL DEFAULT '0',
  `data_bot_id` varchar(16) DEFAULT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `wheat`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wheat` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `wheat`;

--
-- Table structure for table `homeologs`
--

DROP TABLE IF EXISTS `homeologs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homeologs` (
  `group_id` int unsigned NOT NULL,
  `cardinality_abs` varchar(8) NOT NULL,
  `A` varchar(1280) DEFAULT NULL,
  `B` varchar(1024) DEFAULT NULL,
  `D` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `homeologues_lookup`
--

DROP TABLE IF EXISTS `homeologues_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homeologues_lookup` (
  `gene_id` varchar(24) NOT NULL,
  `homeologues` varchar(2400) NOT NULL,
  KEY `gene_idx` (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `wheat_abiotic_stress`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wheat_abiotic_stress` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `wheat_abiotic_stress`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `wheat_embryogenesis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wheat_embryogenesis` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `wheat_embryogenesis`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(50) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `wheat_meiosis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wheat_meiosis` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `wheat_meiosis`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(24) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `wheat_root`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wheat_root` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `wheat_root`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(15) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float DEFAULT '0',
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `willow`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `willow` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `willow`;

--
-- Table structure for table `sample_data`
--

DROP TABLE IF EXISTS `sample_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_data` (
  `proj_id` varchar(2) NOT NULL DEFAULT '0',
  `sample_id` int unsigned NOT NULL DEFAULT '0',
  `data_probeset_id` varchar(32) NOT NULL,
  `data_signal` float NOT NULL,
  `data_bot_id` varchar(16) NOT NULL,
  KEY `data_probeset_id` (`data_probeset_id`,`data_bot_id`,`data_signal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `3ddi_wiki`
--

USE `3ddi_wiki`;

--
-- Current Database: `AnnoJ`
--

USE `AnnoJ`;

--
-- Current Database: `BAR_Search`
--

USE `BAR_Search`;

--
-- Current Database: `CDD3D`
--

USE `CDD3D`;

--
-- Current Database: `NASCArrays`
--

USE `NASCArrays`;

--
-- Current Database: `NGM`
--

USE `NGM`;

--
-- Current Database: `TRTCFungarium`
--

USE `TRTCFungarium`;

--
-- Current Database: `actinidia_bud_development`
--

USE `actinidia_bud_development`;

--
-- Current Database: `actinidia_flower_fruit_development`
--

USE `actinidia_flower_fruit_development`;

--
-- Current Database: `actinidia_postharvest`
--

USE `actinidia_postharvest`;

--
-- Current Database: `actinidia_vegetative_growth`
--

USE `actinidia_vegetative_growth`;

--
-- Current Database: `affydb`
--

USE `affydb`;

--
-- Current Database: `annotations_lookup`
--

USE `annotations_lookup`;

--
-- Current Database: `apple`
--

USE `apple`;

--
-- Current Database: `arabidopsis_ecotypes`
--

USE `arabidopsis_ecotypes`;

--
-- Current Database: `arabidopsis_proteomics`
--

USE `arabidopsis_proteomics`;

--
-- Current Database: `arabidopsis_transcriptomics`
--

USE `arabidopsis_transcriptomics`;

--
-- Current Database: `arachis`
--

USE `arachis`;

--
-- Current Database: `atgenexp`
--

USE `atgenexp`;

--
-- Current Database: `atgenexp_hormone`
--

USE `atgenexp_hormone`;

--
-- Current Database: `atgenexp_pathogen`
--

USE `atgenexp_pathogen`;

--
-- Current Database: `atgenexp_plus`
--

USE `atgenexp_plus`;

--
-- Current Database: `atgenexp_stress`
--

USE `atgenexp_stress`;

--
-- Current Database: `bar_api_db_api_test`
--

USE `bar_api_db_api_test`;

--
-- Current Database: `barley_annotations_lookup`
--

USE `barley_annotations_lookup`;

--
-- Current Database: `barley_mas`
--

USE `barley_mas`;

--
-- Current Database: `barley_rma`
--

USE `barley_rma`;

--
-- Current Database: `barley_seed`
--

USE `barley_seed`;

--
-- Current Database: `barley_spike_meristem`
--

USE `barley_spike_meristem`;

--
-- Current Database: `barley_spike_meristem_v3`
--

USE `barley_spike_meristem_v3`;

--
-- Current Database: `bayer_canola_expressolog`
--

USE `bayer_canola_expressolog`;

--
-- Current Database: `brachypodium`
--

USE `brachypodium`;

--
-- Current Database: `brachypodium_Bd21`
--

USE `brachypodium_Bd21`;

--
-- Current Database: `brachypodium_embryogenesis`
--

USE `brachypodium_embryogenesis`;

--
-- Current Database: `brachypodium_grains`
--

USE `brachypodium_grains`;

--
-- Current Database: `brachypodium_metabolites_map`
--

USE `brachypodium_metabolites_map`;

--
-- Current Database: `brachypodium_photo_thermocycle`
--

USE `brachypodium_photo_thermocycle`;

--
-- Current Database: `brassica_rapa`
--

USE `brassica_rapa`;

--
-- Current Database: `cacao_developmental_atlas`
--

USE `cacao_developmental_atlas`;

--
-- Current Database: `cacao_developmental_atlas_sca`
--

USE `cacao_developmental_atlas_sca`;

--
-- Current Database: `cacao_drought_diurnal_atlas`
--

USE `cacao_drought_diurnal_atlas`;

--
-- Current Database: `cacao_drought_diurnal_atlas_sca`
--

USE `cacao_drought_diurnal_atlas_sca`;

--
-- Current Database: `cacao_infection`
--

USE `cacao_infection`;

--
-- Current Database: `cacao_leaf`
--

USE `cacao_leaf`;

--
-- Current Database: `cacao_meristem_atlas_sca`
--

USE `cacao_meristem_atlas_sca`;

--
-- Current Database: `cacao_seed_atlas_sca`
--

USE `cacao_seed_atlas_sca`;

--
-- Current Database: `camelina`
--

USE `camelina`;

--
-- Current Database: `camelina_annotations_lookup`
--

USE `camelina_annotations_lookup`;

--
-- Current Database: `camelina_tpm`
--

USE `camelina_tpm`;

--
-- Current Database: `cannabis`
--

USE `cannabis`;

--
-- Current Database: `canola`
--

USE `canola`;

--
-- Current Database: `canola_annotations_lookup`
--

USE `canola_annotations_lookup`;

--
-- Current Database: `canola_nssnp`
--

USE `canola_nssnp`;

--
-- Current Database: `canola_original`
--

USE `canola_original`;

--
-- Current Database: `canola_original_v2`
--

USE `canola_original_v2`;

--
-- Current Database: `canola_seed`
--

USE `canola_seed`;

--
-- Current Database: `cassava_atlas`
--

USE `cassava_atlas`;

--
-- Current Database: `cassava_cbb`
--

USE `cassava_cbb`;

--
-- Current Database: `cassava_eacmv`
--

USE `cassava_eacmv`;

--
-- Current Database: `circadian_mutants`
--

USE `circadian_mutants`;

--
-- Current Database: `cistome`
--

USE `cistome`;

--
-- Current Database: `cistome_legacy`
--

USE `cistome_legacy`;

--
-- Current Database: `cort_db`
--

USE `cort_db`;

--
-- Current Database: `current_mappings`
--

USE `current_mappings`;

--
-- Current Database: `cuscuta`
--

USE `cuscuta`;

--
-- Current Database: `cuscuta_early_haustoriogenesis`
--

USE `cuscuta_early_haustoriogenesis`;

--
-- Current Database: `cuscuta_lmd`
--

USE `cuscuta_lmd`;

--
-- Current Database: `dna_damage`
--

USE `dna_damage`;

--
-- Current Database: `docking_db`
--

USE `docking_db`;

--
-- Current Database: `durum_wheat_abiotic_stress`
--

USE `durum_wheat_abiotic_stress`;

--
-- Current Database: `durum_wheat_biotic_stress`
--

USE `durum_wheat_biotic_stress`;

--
-- Current Database: `durum_wheat_development`
--

USE `durum_wheat_development`;

--
-- Current Database: `efp_seq_browser`
--

USE `efp_seq_browser`;

--
-- Current Database: `efpexpressiondata`
--

USE `efpexpressiondata`;

--
-- Current Database: `embryo`
--

USE `embryo`;

--
-- Current Database: `eplant2`
--

USE `eplant2`;

--
-- Current Database: `eplant_barley`
--

USE `eplant_barley`;

--
-- Current Database: `eplant_barley_legacy`
--

USE `eplant_barley_legacy`;

--
-- Current Database: `eplant_camelina`
--

USE `eplant_camelina`;

--
-- Current Database: `eplant_cassava`
--

USE `eplant_cassava`;

--
-- Current Database: `eplant_eucalyptus`
--

USE `eplant_eucalyptus`;

--
-- Current Database: `eplant_maize`
--

USE `eplant_maize`;

--
-- Current Database: `eplant_medicago`
--

USE `eplant_medicago`;

--
-- Current Database: `eplant_poplar`
--

USE `eplant_poplar`;

--
-- Current Database: `eplant_potato`
--

USE `eplant_potato`;

--
-- Current Database: `eplant_rice`
--

USE `eplant_rice`;

--
-- Current Database: `eplant_soybean`
--

USE `eplant_soybean`;

--
-- Current Database: `eplant_spruce`
--

USE `eplant_spruce`;

--
-- Current Database: `eplant_sugarcane`
--

USE `eplant_sugarcane`;

--
-- Current Database: `eplant_sunflower`
--

USE `eplant_sunflower`;

--
-- Current Database: `eplant_tomato`
--

USE `eplant_tomato`;

--
-- Current Database: `eplant_wheat`
--

USE `eplant_wheat`;

--
-- Current Database: `eplant_willow`
--

USE `eplant_willow`;

--
-- Current Database: `eucalyptus`
--

USE `eucalyptus`;

--
-- Current Database: `euphorbia`
--

USE `euphorbia`;

--
-- Current Database: `expression_max_test`
--

USE `expression_max_test`;

--
-- Current Database: `fastpheno`
--

USE `fastpheno`;

--
-- Current Database: `fastpheno2_draft`
--

USE `fastpheno2_draft`;

--
-- Current Database: `fastpheno_draft`
--

USE `fastpheno_draft`;

--
-- Current Database: `gAccounts`
--

USE `gAccounts`;

--
-- Current Database: `gaia`
--

USE `gaia`;

--
-- Current Database: `gc_drought`
--

USE `gc_drought`;

--
-- Current Database: `geneslider`
--

USE `geneslider`;

--
-- Current Database: `germination`
--

USE `germination`;

--
-- Current Database: `grape_annotations_lookup`
--

USE `grape_annotations_lookup`;

--
-- Current Database: `grape_developmental`
--

USE `grape_developmental`;

--
-- Current Database: `guard_cell`
--

USE `guard_cell`;

--
-- Current Database: `gynoecium`
--

USE `gynoecium`;

--
-- Current Database: `heterodera_schachtii`
--

USE `heterodera_schachtii`;

--
-- Current Database: `hnahal`
--

USE `hnahal`;

--
-- Current Database: `hnahal_temp`
--

USE `hnahal_temp`;

--
-- Current Database: `homologs_db`
--

USE `homologs_db`;

--
-- Current Database: `human_annotations_lookup`
--

USE `human_annotations_lookup`;

--
-- Current Database: `human_body_map_2`
--

USE `human_body_map_2`;

--
-- Current Database: `human_developmental`
--

USE `human_developmental`;

--
-- Current Database: `human_developmental_SpongeLab`
--

USE `human_developmental_SpongeLab`;

--
-- Current Database: `human_diseased`
--

USE `human_diseased`;

--
-- Current Database: `interactions`
--

USE `interactions`;

--
-- Current Database: `interactions_dapseq`
--

USE `interactions_dapseq`;

--
-- Current Database: `interactions_eddi`
--

USE `interactions_eddi`;

--
-- Current Database: `interactions_grn_dev_db`
--

USE `interactions_grn_dev_db`;

--
-- Current Database: `interactions_vincent`
--

USE `interactions_vincent`;

--
-- Current Database: `interactions_vincent_v2`
--

USE `interactions_vincent_v2`;

--
-- Current Database: `kalanchoe`
--

USE `kalanchoe`;

--
-- Current Database: `kalanchoe_time_course_analysis`
--

USE `kalanchoe_time_course_analysis`;

--
-- Current Database: `klepikova`
--

USE `klepikova`;

--
-- Current Database: `lateral_root_initiation`
--

USE `lateral_root_initiation`;

--
-- Current Database: `light_series`
--

USE `light_series`;

--
-- Current Database: `lipid_map`
--

USE `lipid_map`;

--
-- Current Database: `little_millet`
--

USE `little_millet`;

--
-- Current Database: `llama3`
--

USE `llama3`;

--
-- Current Database: `localisations`
--

USE `localisations`;

--
-- Current Database: `lupin_lcm_leaf`
--

USE `lupin_lcm_leaf`;

--
-- Current Database: `lupin_lcm_pod`
--

USE `lupin_lcm_pod`;

--
-- Current Database: `lupin_lcm_stem`
--

USE `lupin_lcm_stem`;

--
-- Current Database: `lupin_pod_seed`
--

USE `lupin_pod_seed`;

--
-- Current Database: `lupin_whole_plant`
--

USE `lupin_whole_plant`;

--
-- Current Database: `maize_RMA_linear`
--

USE `maize_RMA_linear`;

--
-- Current Database: `maize_RMA_log`
--

USE `maize_RMA_log`;

--
-- Current Database: `maize_annotations`
--

USE `maize_annotations`;

--
-- Current Database: `maize_atlas`
--

USE `maize_atlas`;

--
-- Current Database: `maize_atlas_v5`
--

USE `maize_atlas_v5`;

--
-- Current Database: `maize_buell_lab`
--

USE `maize_buell_lab`;

--
-- Current Database: `maize_early_seed`
--

USE `maize_early_seed`;

--
-- Current Database: `maize_ears`
--

USE `maize_ears`;

--
-- Current Database: `maize_embryonic_leaf_development`
--

USE `maize_embryonic_leaf_development`;

--
-- Current Database: `maize_enzyme`
--

USE `maize_enzyme`;

--
-- Current Database: `maize_gdowns`
--

USE `maize_gdowns`;

--
-- Current Database: `maize_gdowns_annotations_lookup`
--

USE `maize_gdowns_annotations_lookup`;

--
-- Current Database: `maize_interactions`
--

USE `maize_interactions`;

--
-- Current Database: `maize_interactions_v5`
--

USE `maize_interactions_v5`;

--
-- Current Database: `maize_iplant`
--

USE `maize_iplant`;

--
-- Current Database: `maize_kernel_v5`
--

USE `maize_kernel_v5`;

--
-- Current Database: `maize_leaf_gradient`
--

USE `maize_leaf_gradient`;

--
-- Current Database: `maize_lipid_map`
--

USE `maize_lipid_map`;

--
-- Current Database: `maize_metabolite`
--

USE `maize_metabolite`;

--
-- Current Database: `maize_nitrogen_use_efficiency`
--

USE `maize_nitrogen_use_efficiency`;

--
-- Current Database: `maize_rice_comparison`
--

USE `maize_rice_comparison`;

--
-- Current Database: `maize_root`
--

USE `maize_root`;

--
-- Current Database: `maize_stress_v5`
--

USE `maize_stress_v5`;

--
-- Current Database: `mangosteen_annotations_lookup`
--

USE `mangosteen_annotations_lookup`;

--
-- Current Database: `mangosteen_aril_vs_rind`
--

USE `mangosteen_aril_vs_rind`;

--
-- Current Database: `mangosteen_callus`
--

USE `mangosteen_callus`;

--
-- Current Database: `mangosteen_diseased_vs_normal`
--

USE `mangosteen_diseased_vs_normal`;

--
-- Current Database: `mangosteen_fruit_ripening`
--

USE `mangosteen_fruit_ripening`;

--
-- Current Database: `mangosteen_seed_development`
--

USE `mangosteen_seed_development`;

--
-- Current Database: `mangosteen_seed_development_germination`
--

USE `mangosteen_seed_development_germination`;

--
-- Current Database: `mangosteen_seed_germination`
--

USE `mangosteen_seed_germination`;

--
-- Current Database: `marchantia_organ_stress`
--

USE `marchantia_organ_stress`;

--
-- Current Database: `markergen`
--

USE `markergen`;

--
-- Final view structure for view `test`
--

/*!50001 DROP VIEW IF EXISTS `test`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `test` AS select `gene`.`name` AS `name`,`pl`.`product_id` AS `product_id`,count(0) AS `count` from (((`polymorphism` `pl` join `pcr`) join `gene`) join `difference` `d`) where ((`gene`.`id` = `pcr`.`gene_id`) and (`gene`.`name` <> 'N/A') and (`pcr`.`dataset_id` = 1) and (`pcr`.`product_id` = `pl`.`product_id`) and (`pl`.`difference_id` = `d`.`id`) and (`d`.`pattern` <> ' ')) group by `gene`.`name`,`pl`.`product_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vie_cvi`
--

/*!50001 DROP VIEW IF EXISTS `vie_cvi`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vie_cvi` AS select `gene`.`name` AS `agi`,`a`.`name` AS `accesion_name`,`d`.`id` AS `difference_id`,`d`.`pattern` AS `difference_pattern`,`pl`.`product_id` AS `product_id` from ((((`polymorphism` `pl` join `pcr`) join `gene`) join `difference` `d`) join `accession` `a`) where ((`gene`.`id` = `pcr`.`gene_id`) and (`gene`.`name` <> 'N/A') and (`pcr`.`dataset_id` = 1) and (`pcr`.`product_id` = `pl`.`product_id`) and (`pl`.`difference_id` = `d`.`id`) and (`pl`.`difference_id` <> 1) and (`d`.`pattern` <> '') and (`a`.`id` = `pl`.`accession_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vie_cvi1`
--

/*!50001 DROP VIEW IF EXISTS `vie_cvi1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vie_cvi1` AS select `vie_cvi`.`agi` AS `agi`,`vie_cvi`.`accesion_name` AS `accesion_name`,`vie_cvi`.`difference_id` AS `difference_id`,`vie_cvi`.`difference_pattern` AS `difference_pattern`,`vie_cvi`.`product_id` AS `product_id` from `vie_cvi` where (`vie_cvi`.`accesion_name` = 'cvi-0') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vie_cvi2`
--

/*!50001 DROP VIEW IF EXISTS `vie_cvi2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vie_cvi2` AS select `A`.`agi` AS `agi`,`A`.`accesion_name` AS `accesion_name`,`A`.`difference_id` AS `difference_id`,`A`.`difference_pattern` AS `difference_pattern`,`A`.`product_id` AS `product_id` from (`vie_cvi` `A` join `vie_cvi1` `B`) where ((`A`.`agi` = `B`.`agi`) and (`A`.`difference_id` = `B`.`difference_id`) and (`A`.`accesion_name` <> 'cvi-0')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vie_cvi3`
--

/*!50001 DROP VIEW IF EXISTS `vie_cvi3`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vie_cvi3` AS select `A`.`agi` AS `agi`,`A`.`accesion_name` AS `accesion_name`,`A`.`difference_id` AS `difference_id`,`A`.`difference_pattern` AS `difference_pattern`,`A`.`product_id` AS `product_id` from (`vie_cvi` `A` join `vie_cvi1` `B`) where ((`A`.`agi` = `B`.`agi`) and (`A`.`difference_pattern` = `B`.`difference_pattern`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vie_poly`
--

/*!50001 DROP VIEW IF EXISTS `vie_poly`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vie_poly` AS select `gene`.`name` AS `name`,`pcr`.`forward_id` AS `forward_id`,`primera`.`seq` AS `forward_seq`,`pcr`.`reverse_id` AS `reverse_id`,`primerb`.`seq` AS `reverse_seq`,`pl`.`product_id` AS `product_id`,`product`.`target_seq` AS `target_seq`,`a`.`id` AS `accesion_id`,`a`.`name` AS `accesion_name`,`d`.`id` AS `difference_id`,`d`.`pattern` AS `difference_pattern` from (((((((`polymorphism` `pl` join `pcr`) join `gene`) join `product`) join `difference` `d`) join `accession` `a`) join `primer` `primera`) join `primer` `primerb`) where ((`gene`.`id` = `pcr`.`gene_id`) and (`gene`.`name` <> 'N/A') and (`pcr`.`product_id` = `pl`.`product_id`) and (`pl`.`product_id` = `product`.`id`) and (`d`.`pattern` <> '') and (`pl`.`difference_id` = `d`.`id`) and (`a`.`id` = `pl`.`accession_id`) and (`pcr`.`forward_id` = `primera`.`id`) and (`pcr`.`reverse_id` = `primerb`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vie_poly1`
--

/*!50001 DROP VIEW IF EXISTS `vie_poly1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vie_poly1` AS select `gene`.`name` AS `name`,`pcr`.`forward_id` AS `forward_id`,`primera`.`seq` AS `forward_seq`,`pcr`.`reverse_id` AS `reverse_id`,`primerb`.`seq` AS `reverse_seq`,`pl`.`product_id` AS `product_id`,`product`.`target_seq` AS `target_seq`,`a`.`id` AS `accesion_id`,`a`.`name` AS `accesion_name`,`d`.`id` AS `difference_id`,`d`.`pattern` AS `difference_pattern` from (((((((`polymorphism` `pl` join `pcr`) join `gene`) join `product`) join `difference` `d`) join `accession` `a`) join `primer` `primera`) join `primer` `primerb`) where ((`gene`.`id` = `pcr`.`gene_id`) and (`gene`.`name` <> 'N/A') and (`pcr`.`dataset_id` = 1) and (`pcr`.`product_id` = `pl`.`product_id`) and (`pl`.`product_id` = `product`.`id`) and (`pl`.`difference_id` <> 1) and (`d`.`pattern` <> '') and (`pl`.`difference_id` = `d`.`id`) and (`a`.`id` = `pl`.`accession_id`) and (`pcr`.`forward_id` = `primera`.`id`) and (`pcr`.`reverse_id` = `primerb`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `markergen_pop`
--

USE `markergen_pop`;

--
-- Current Database: `markergen_test`
--

USE `markergen_test`;

--
-- Current Database: `medicago_annotations_lookup`
--

USE `medicago_annotations_lookup`;

--
-- Current Database: `medicago_mas`
--

USE `medicago_mas`;

--
-- Current Database: `medicago_rma`
--

USE `medicago_rma`;

--
-- Current Database: `medicago_root`
--

USE `medicago_root`;

--
-- Current Database: `medicago_root_v5`
--

USE `medicago_root_v5`;

--
-- Current Database: `medicago_seed`
--

USE `medicago_seed`;

--
-- Current Database: `meristem_db`
--

USE `meristem_db`;

--
-- Current Database: `meristem_db_new`
--

USE `meristem_db_new`;

--
-- Current Database: `mouse_db`
--

USE `mouse_db`;

--
-- Current Database: `mysql`
--

USE `mysql`;

--
-- Current Database: `ngm_nina`
--

USE `ngm_nina`;

--
-- Current Database: `oat`
--

USE `oat`;

--
-- Current Database: `ontologies`
--

USE `ontologies`;

--
-- Current Database: `ortholog_db`
--

USE `ortholog_db`;

--
-- Current Database: `phelipanche`
--

USE `phelipanche`;

--
-- Current Database: `phelipanche_annotations_lookup`
--

USE `phelipanche_annotations_lookup`;

--
-- Current Database: `phpmyadmin`
--

USE `phpmyadmin`;

--
-- Current Database: `physcomitrella_annotations_lookup`
--

USE `physcomitrella_annotations_lookup`;

--
-- Current Database: `physcomitrella_db`
--

USE `physcomitrella_db`;

--
-- Current Database: `poplar`
--

USE `poplar`;

--
-- Current Database: `poplar_annotations_lookup`
--

USE `poplar_annotations_lookup`;

--
-- Current Database: `poplar_hormone`
--

USE `poplar_hormone`;

--
-- Current Database: `poplar_interactions`
--

USE `poplar_interactions`;

--
-- Current Database: `poplar_leaf`
--

USE `poplar_leaf`;

--
-- Current Database: `poplar_new_annotations`
--

USE `poplar_new_annotations`;

--
-- Current Database: `poplar_nssnp`
--

USE `poplar_nssnp`;

--
-- Current Database: `poplar_xylem`
--

USE `poplar_xylem`;

--
-- Current Database: `potato_annotations`
--

USE `potato_annotations`;

--
-- Current Database: `potato_dev`
--

USE `potato_dev`;

--
-- Current Database: `potato_stress`
--

USE `potato_stress`;

--
-- Current Database: `potato_wounding`
--

USE `potato_wounding`;

--
-- Current Database: `prot_model_data`
--

USE `prot_model_data`;

--
-- Current Database: `rice_abiotic_stress_sc_pseudobulk`
--

USE `rice_abiotic_stress_sc_pseudobulk`;

--
-- Current Database: `rice_annotations_lookup`
--

USE `rice_annotations_lookup`;

--
-- Current Database: `rice_drought_heat_stress`
--

USE `rice_drought_heat_stress`;

--
-- Current Database: `rice_interactions`
--

USE `rice_interactions`;

--
-- Current Database: `rice_leaf_gradient`
--

USE `rice_leaf_gradient`;

--
-- Current Database: `rice_maize_comparison`
--

USE `rice_maize_comparison`;

--
-- Current Database: `rice_mas`
--

USE `rice_mas`;

--
-- Current Database: `rice_metabolite`
--

USE `rice_metabolite`;

--
-- Current Database: `rice_rma`
--

USE `rice_rma`;

--
-- Current Database: `rice_root`
--

USE `rice_root`;

--
-- Current Database: `rohan`
--

USE `rohan`;

--
-- Current Database: `root`
--

USE `root`;

--
-- Current Database: `root_Schaefer_lab`
--

USE `root_Schaefer_lab`;

--
-- Current Database: `rpatel`
--

USE `rpatel`;

--
-- Current Database: `rsvp`
--

USE `rsvp`;

--
-- Current Database: `seed_db`
--

USE `seed_db`;

--
-- Current Database: `seedcoat`
--

USE `seedcoat`;

--
-- Current Database: `selaginella`
--

USE `selaginella`;

--
-- Current Database: `shoot_apex`
--

USE `shoot_apex`;

--
-- Current Database: `silique`
--

USE `silique`;

--
-- Current Database: `single_cell`
--

USE `single_cell`;

--
-- Current Database: `sorghum_atlas_w_BS_cells`
--

USE `sorghum_atlas_w_BS_cells`;

--
-- Current Database: `sorghum_bundle_sheath`
--

USE `sorghum_bundle_sheath`;

--
-- Current Database: `sorghum_comparative_transcriptomics`
--

USE `sorghum_comparative_transcriptomics`;

--
-- Current Database: `sorghum_developmental`
--

USE `sorghum_developmental`;

--
-- Current Database: `sorghum_developmental_2`
--

USE `sorghum_developmental_2`;

--
-- Current Database: `sorghum_flowering_activation`
--

USE `sorghum_flowering_activation`;

--
-- Current Database: `sorghum_low_phosphorus`
--

USE `sorghum_low_phosphorus`;

--
-- Current Database: `sorghum_nitrogen_stress`
--

USE `sorghum_nitrogen_stress`;

--
-- Current Database: `sorghum_nitrogen_use_efficiency`
--

USE `sorghum_nitrogen_use_efficiency`;

--
-- Current Database: `sorghum_phosphate_stress`
--

USE `sorghum_phosphate_stress`;

--
-- Current Database: `sorghum_plasma`
--

USE `sorghum_plasma`;

--
-- Current Database: `sorghum_saline_alkali_stress`
--

USE `sorghum_saline_alkali_stress`;

--
-- Current Database: `sorghum_stress`
--

USE `sorghum_stress`;

--
-- Current Database: `sorghum_strigolactone_variation`
--

USE `sorghum_strigolactone_variation`;

--
-- Current Database: `sorghum_sulfur_stress`
--

USE `sorghum_sulfur_stress`;

--
-- Current Database: `sorghum_temperature_stress`
--

USE `sorghum_temperature_stress`;

--
-- Current Database: `sorghum_vascularization_and_internode`
--

USE `sorghum_vascularization_and_internode`;

--
-- Current Database: `soybean`
--

USE `soybean`;

--
-- Current Database: `soybean_annotations_lookup`
--

USE `soybean_annotations_lookup`;

--
-- Current Database: `soybean_embryonic_development`
--

USE `soybean_embryonic_development`;

--
-- Current Database: `soybean_heart_cotyledon_globular`
--

USE `soybean_heart_cotyledon_globular`;

--
-- Current Database: `soybean_nssnp`
--

USE `soybean_nssnp`;

--
-- Current Database: `soybean_senescence`
--

USE `soybean_senescence`;

--
-- Current Database: `soybean_severin`
--

USE `soybean_severin`;

--
-- Current Database: `spruce`
--

USE `spruce`;

--
-- Current Database: `strawberry`
--

USE `strawberry`;

--
-- Current Database: `strawberry_annotations_lookup`
--

USE `strawberry_annotations_lookup`;

--
-- Current Database: `striga`
--

USE `striga`;

--
-- Current Database: `striga_annotations_lookup`
--

USE `striga_annotations_lookup`;

--
-- Current Database: `string`
--

USE `string`;

--
-- Current Database: `sugarcane_culms`
--

USE `sugarcane_culms`;

--
-- Current Database: `sugarcane_leaf`
--

USE `sugarcane_leaf`;

--
-- Current Database: `summarization`
--

USE `summarization`;

--
-- Current Database: `sunflower`
--

USE `sunflower`;

--
-- Current Database: `thellungiella_annotations_lookup`
--

USE `thellungiella_annotations_lookup`;

--
-- Current Database: `thellungiella_db`
--

USE `thellungiella_db`;

--
-- Current Database: `tomato`
--

USE `tomato`;

--
-- Current Database: `tomato_annotations_lookup`
--

USE `tomato_annotations_lookup`;

--
-- Current Database: `tomato_ils`
--

USE `tomato_ils`;

--
-- Current Database: `tomato_ils2`
--

USE `tomato_ils2`;

--
-- Current Database: `tomato_ils3`
--

USE `tomato_ils3`;

--
-- Current Database: `tomato_meristem`
--

USE `tomato_meristem`;

--
-- Current Database: `tomato_nssnp`
--

USE `tomato_nssnp`;

--
-- Current Database: `tomato_renormalized`
--

USE `tomato_renormalized`;

--
-- Current Database: `tomato_root`
--

USE `tomato_root`;

--
-- Current Database: `tomato_root_field_pot`
--

USE `tomato_root_field_pot`;

--
-- Current Database: `tomato_s_pennellii`
--

USE `tomato_s_pennellii`;

--
-- Current Database: `tomato_seed`
--

USE `tomato_seed`;

--
-- Current Database: `tomato_sequence`
--

USE `tomato_sequence`;

--
-- Current Database: `tomato_shade_mutants`
--

USE `tomato_shade_mutants`;

--
-- Current Database: `tomato_shade_timecourse`
--

USE `tomato_shade_timecourse`;

--
-- Current Database: `tomato_trait`
--

USE `tomato_trait`;

--
-- Current Database: `triphysaria`
--

USE `triphysaria`;

--
-- Current Database: `triphysaria_annotations_lookup`
--

USE `triphysaria_annotations_lookup`;

--
-- Current Database: `triticale`
--

USE `triticale`;

--
-- Current Database: `triticale_annotations_lookup`
--

USE `triticale_annotations_lookup`;

--
-- Current Database: `triticale_mas`
--

USE `triticale_mas`;

--
-- Current Database: `tung_tree`
--

USE `tung_tree`;

--
-- Current Database: `wheat`
--

USE `wheat`;

--
-- Current Database: `wheat_abiotic_stress`
--

USE `wheat_abiotic_stress`;

--
-- Current Database: `wheat_embryogenesis`
--

USE `wheat_embryogenesis`;

--
-- Current Database: `wheat_meiosis`
--

USE `wheat_meiosis`;

--
-- Current Database: `wheat_root`
--

USE `wheat_root`;

--
-- Current Database: `willow`
--

USE `willow`;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!50606 SET GLOBAL INNODB_STATS_AUTO_RECALC=@OLD_INNODB_STATS_AUTO_RECALC */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-28 16:30:58
