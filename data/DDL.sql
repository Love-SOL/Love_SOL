CREATE DATABASE  IF NOT EXISTS `lovesol` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `lovesol`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: lovesol
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `image_id` int NOT NULL,
  `content` varchar(255) NOT NULL,
  `create_at` datetime NOT NULL,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `FK_comment_Image_id__idx` (`image_id`),
  CONSTRAINT `FK_comment_image_id` FOREIGN KEY (`image_id`) REFERENCES `image` (`Image_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `couple`
--

DROP TABLE IF EXISTS `couple`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `couple` (
  `couple_id` int NOT NULL AUTO_INCREMENT,
  `common_account` varchar(25) NOT NULL,
  `anniversary` date NOT NULL,
  `onwer_id` int NOT NULL,
  `sub_onwer_id` int DEFAULT NULL,
  `onwer_total` int NOT NULL DEFAULT '0',
  `sub_onwer_total` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`couple_id`),
  KEY `FK_onwer_id__idx` (`onwer_id`),
  KEY `FK_sub_onwer_id__idx` (`sub_onwer_id`),
  CONSTRAINT `FK_onwer_id` FOREIGN KEY (`onwer_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_sub_onwer_id` FOREIGN KEY (`sub_onwer_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datelog`
--

DROP TABLE IF EXISTS `datelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datelog` (
  `datelog_id` varchar(255) NOT NULL,
  `couple_id` int NOT NULL,
  `date_at` date NOT NULL,
  `mileage` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`datelog_id`),
  KEY `FK_DateLog_Couple_id__idx` (`couple_id`),
  CONSTRAINT `FK_DateLog_Couple_id` FOREIGN KEY (`couple_id`) REFERENCES `couple` (`couple_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `datelog_id` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `create_at` datetime DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `KF_Image_DateLog_id__idx` (`datelog_id`),
  CONSTRAINT `KF_Image_DateLog_id` FOREIGN KEY (`datelog_id`) REFERENCES `datelog` (`datelog_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `id` varchar(25) NOT NULL,
  `password` varchar(255) NOT NULL,
  `personal_acount` varchar(25) NOT NULL,
  `name` varchar(25) NOT NULL,
  `birth_at` date DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `Member_UNIQUE` (`id`),
  UNIQUE KEY `Member_id_UNIQUE` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(255) NOT NULL,
  `createAt` varchar(45) NOT NULL,
  `send_id` int NOT NULL,
  `receive_id` int NOT NULL,
  PRIMARY KEY (`notice_id`),
  KEY `send_id__idx` (`send_id`),
  KEY `FK_received_id__idx` (`receive_id`),
  CONSTRAINT `FK_received_id` FOREIGN KEY (`receive_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_send_id` FOREIGN KEY (`send_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paymentlog`
--

DROP TABLE IF EXISTS `paymentlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paymentlog` (
  `payment_id` varchar(45) NOT NULL,
  `datelog_id` varchar(255) NOT NULL,
  `amount` int NOT NULL,
  `pay_at` datetime NOT NULL,
  `detail` varchar(255) NOT NULL,
  PRIMARY KEY (`Payment_id`),
  KEY `FK_Payment_DateLog_id__idx` (`dateLog_id`),
  CONSTRAINT `FK_Payment_DateLog_id` FOREIGN KEY (`dateLog_id`) REFERENCES `datelog` (`datelog_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `couple_id` int NOT NULL,
  `name` varchar(25) NOT NULL,
  `exp` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `kind` int DEFAULT '0',
  `level` int DEFAULT '1',
  KEY `FK_couple_id_idx` (`couple_id`),
  CONSTRAINT `FK_couple_id` FOREIGN KEY (`couple_id`) REFERENCES `couple` (`couple_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `couple_id` int NOT NULL,
  `start_at` datetime NOT NULL,
  `end_at` datetime NOT NULL,
  `content` varchar(255) DEFAULT NULL,
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`schedule_id`),
  KEY `FK_Couple_id_idx` (`couple_id`),
  CONSTRAINT `FK_schedule_couple_id` FOREIGN KEY (`couple_id`) REFERENCES `couple` (`couple_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
