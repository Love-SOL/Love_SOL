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
  `CommentId` int NOT NULL AUTO_INCREMENT,
  `ImageId` int NOT NULL,
  `Content` varchar(255) NOT NULL,
  `CreateAt` datetime NOT NULL,
  PRIMARY KEY (`CommentId`),
  KEY `FK_Comment_ImageId_idx` (`ImageId`),
  CONSTRAINT `FK_Comment_ImageId` FOREIGN KEY (`ImageId`) REFERENCES `image` (`ImageId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `couple`
--

DROP TABLE IF EXISTS `couple`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `couple` (
  `CoupleId` int NOT NULL AUTO_INCREMENT,
  `CommonAccount` varchar(25) NOT NULL,
  `Anniversary` date NOT NULL,
  `OnwerId` int NOT NULL,
  `SubOnwerId` int DEFAULT NULL,
  `OnwerTotal` int NOT NULL DEFAULT '0',
  `SubOnwerTotal` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`CoupleId`),
  KEY `FK_OnwerId_idx` (`OnwerId`),
  KEY `FK_SubOnwerId_idx` (`SubOnwerId`),
  CONSTRAINT `FK_OnwerId` FOREIGN KEY (`OnwerId`) REFERENCES `member` (`MemberId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SubOnwerId` FOREIGN KEY (`SubOnwerId`) REFERENCES `member` (`MemberId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datelog`
--

DROP TABLE IF EXISTS `datelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datelog` (
  `DateLogId` varchar(255) NOT NULL,
  `CoupleId` int NOT NULL,
  `DateAt` date NOT NULL,
  `Mileage` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`DateLogId`),
  KEY `FK_DateLog_CoupleId_idx` (`CoupleId`),
  CONSTRAINT `FK_DateLog_CoupleId` FOREIGN KEY (`CoupleId`) REFERENCES `couple` (`CoupleId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `ImageId` int NOT NULL AUTO_INCREMENT,
  `DateLogId` varchar(255) NOT NULL,
  `URL` varchar(255) NOT NULL,
  `CreateAt` datetime DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ImageId`),
  KEY `KF_Image_DateLogId_idx` (`DateLogId`),
  CONSTRAINT `KF_Image_DateLogId` FOREIGN KEY (`DateLogId`) REFERENCES `datelog` (`DateLogId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `MemberId` int NOT NULL AUTO_INCREMENT,
  `ID` varchar(25) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `PersonalAcount` varchar(25) NOT NULL,
  `Name` varchar(25) NOT NULL,
  `BirthAt` date DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`MemberId`),
  UNIQUE KEY `new_tableMembercol_UNIQUE` (`ID`),
  UNIQUE KEY `MemberId_UNIQUE` (`MemberId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `NoticeId` int NOT NULL AUTO_INCREMENT,
  `Content` varchar(255) NOT NULL,
  `CreateAt` varchar(45) NOT NULL,
  `SendId` int NOT NULL,
  `ReceiveId` int NOT NULL,
  PRIMARY KEY (`NoticeId`),
  KEY `SendId_idx` (`SendId`),
  KEY `FK_ReceivedId_idx` (`ReceiveId`),
  CONSTRAINT `FK_ReceivedId` FOREIGN KEY (`ReceiveId`) REFERENCES `member` (`MemberId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SendId` FOREIGN KEY (`SendId`) REFERENCES `member` (`MemberId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paymentlog`
--

DROP TABLE IF EXISTS `paymentlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paymentlog` (
  `PaymentId` varchar(45) NOT NULL,
  `DateLogId` varchar(255) NOT NULL,
  `Amount` int NOT NULL,
  `PayAt` datetime NOT NULL,
  `Detail` varchar(255) NOT NULL,
  PRIMARY KEY (`PaymentId`),
  KEY `FK_Payment_DateLogId_idx` (`DateLogId`),
  CONSTRAINT `FK_Payment_DateLogId` FOREIGN KEY (`DateLogId`) REFERENCES `datelog` (`DateLogId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `CoupleId` int NOT NULL,
  `Name` varchar(25) NOT NULL,
  `Exp` int NOT NULL DEFAULT '0',
  `Status` int NOT NULL DEFAULT '0',
  `Kind` int DEFAULT '0',
  `Level` int DEFAULT '1',
  KEY `FK_CoupleId_idx` (`CoupleId`),
  CONSTRAINT `FK_CoupleId` FOREIGN KEY (`CoupleId`) REFERENCES `couple` (`CoupleId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `ScheduleId` int NOT NULL AUTO_INCREMENT,
  `CoupleId` int NOT NULL,
  `startAt` datetime NOT NULL,
  `endAt` datetime NOT NULL,
  `content` varchar(255) DEFAULT NULL,
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ScheduleId`),
  KEY `FK_CoupleId_idx` (`CoupleId`),
  CONSTRAINT `FK_Schedule_CoupleId` FOREIGN KEY (`CoupleId`) REFERENCES `couple` (`CoupleId`) ON DELETE CASCADE ON UPDATE CASCADE
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

-- Dump completed on 2023-08-30 22:18:46
