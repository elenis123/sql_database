-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: chargetrack
-- ------------------------------------------------------
-- Server version	8.0.25
DROP SCHEMA IF EXISTS `ChargeTrack`;
CREATE SCHEMA `ChargeTrack`;
USE `ChargeTrack`;

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
-- Temporary view structure for view `availablespotsperstation`
--

DROP TABLE IF EXISTS `availablespotsperstation`;
/*!50001 DROP VIEW IF EXISTS `availablespotsperstation`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `availablespotsperstation` AS SELECT 
 1 AS `ChargingStationID`,
 1 AS `AvailableSpotCount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `avgdurationandrentpervehicletype`
--

DROP TABLE IF EXISTS `avgdurationandrentpervehicletype`;
/*!50001 DROP VIEW IF EXISTS `avgdurationandrentpervehicletype`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `avgdurationandrentpervehicletype` AS SELECT 
 1 AS `VehicleType`,
 1 AS `AvgDurationMinutes`,
 1 AS `AvgPaymentRent`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `avgenergyandpaymentpervehicletype`
--

DROP TABLE IF EXISTS `avgenergyandpaymentpervehicletype`;
/*!50001 DROP VIEW IF EXISTS `avgenergyandpaymentpervehicletype`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `avgenergyandpaymentpervehicletype` AS SELECT 
 1 AS `VehicleType`,
 1 AS `AvgEnergy`,
 1 AS `AvgPaymentEnergy`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `chargingsession`
--

DROP TABLE IF EXISTS `chargingsession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chargingsession` (
  `ChargingSessionID` int NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime NOT NULL,
  `ChargingSpotID` int NOT NULL,
  `ChargingStationID` int NOT NULL,
  `VehicleID` int NOT NULL,
  `Energy` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`ChargingSessionID`),
  UNIQUE KEY `StartDate_UNIQUE` (`StartDate`),
  UNIQUE KEY `EndDate_UNIQUE` (`EndDate`),
  UNIQUE KEY `ChargingSessionID_UNIQUE` (`ChargingSessionID`),
  UNIQUE KEY `ChargingStationID_UNIQUE` (`ChargingStationID`),
  UNIQUE KEY `ChargingSessionIDEnergy` (`ChargingSessionID`,`Energy`),
  KEY `ChargingSpotID_idx` (`ChargingSpotID`),
  KEY `VehicleID_idx` (`VehicleID`),
  CONSTRAINT `ChargingSpotID` FOREIGN KEY (`ChargingSpotID`) REFERENCES `chargingspot` (`ChargingSpotID`),
  CONSTRAINT `ChargingStationID2` FOREIGN KEY (`ChargingStationID`) REFERENCES `chargingstation` (`ChargingStationID`),
  CONSTRAINT `VehicleID1` FOREIGN KEY (`VehicleID`) REFERENCES `vehicle` (`VehicleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chargingsession`
--

LOCK TABLES `chargingsession` WRITE;
/*!40000 ALTER TABLE `chargingsession` DISABLE KEYS */;
INSERT INTO `chargingsession` VALUES (4,'2024-12-22 10:15:00','2024-12-22 11:00:00',57,26,98,'33'),(21,'2024-12-22 11:30:00','2024-12-22 12:15:00',60,8,4,'69'),(36,'2024-12-24 08:00:00','2024-12-24 08:45:00',100,44,37,'74'),(58,'2024-12-23 09:00:00','2024-12-23 09:30:00',80,50,101,'588'),(177,'2024-12-23 15:45:00','2024-12-23 16:30:00',87,37,54,'22'),(254,'2024-12-21 12:30:20','2024-12-21 13:15:45',2,4,7,'254'),(669,'2024-12-21 14:00:00','2024-12-21 14:45:00',12,55,3,'14');
/*!40000 ALTER TABLE `chargingsession` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ChargingSession_BEFORE_INSERT` BEFORE INSERT ON `chargingsession` FOR EACH ROW BEGIN
	DECLARE overlap INT;
	IF NEW.Energy IS NULL THEN
      SET NEW.Energy= '-1';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM Vehicle WHERE VehicleID = NEW.VehicleID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid VehicleID: No such vehicle exists.';
    END IF;
    
    IF NEW.EndDate IS NOT NULL AND NEW.StartDate >= NEW.EndDate THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'StartTime must be earlier than EndTime.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Vehicle WHERE VehicleID = NEW.VehicleID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid VehicleID: No such vehicle exists.';
    END IF;
  
    IF EXISTS (SELECT 1 FROM ChargingSession WHERE ChargingSessionID = NEW.ChargingSessionID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ChargingSessionID must be unique.';
    END IF;
    
	

    
	SELECT COUNT(*)
	INTO overlap
	FROM ChargingSession
	WHERE ChargingSpotID = NEW.ChargingSpotID
	AND NEW.StartDate < EndDate
	AND NEW.EndDate > StartDate;

 
    IF overlap > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Time slot is already reserved for this ChargingSpotID.';
    END IF;
    
   

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ChargingSession_BEFORE_UPDATE` BEFORE UPDATE ON `chargingsession` FOR EACH ROW BEGIN
	DECLARE overlap INT;
    IF NEW.Energy IS NULL THEN
      SET NEW.Energy= '-1';
	END IF;
    
    IF NEW.EndDate IS NOT NULL AND NEW.StartDate >= NEW.EndDate THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'StartTime must be earlier than EndTime.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Vehicle WHERE VehicleID = NEW.VehicleID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid VehicleID: No such vehicle exists.';
    END IF;

    IF NEW.ChargingSessionID != OLD.ChargingSessionID THEN
        IF EXISTS (SELECT 1 FROM ChargingSession WHERE ChargingSessionID = NEW.ChargingSessionID) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ChargingSessionID must be unique.';
        END IF;
    END IF;
    
    SELECT COUNT(*)
    INTO overlap
    FROM ChargingSession
    WHERE ChargingSpotID = NEW.ChargingSpotID
      AND NEW.StartDate < EndDate
      AND NEW.EndDate > StartDate
      AND ChargingSessionID != OLD.ChargingSessionID;

    
    IF overlap > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Time slot is already reserved for this ChargingSpotID.';
    END IF;
    
   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `chargingspot`
--

DROP TABLE IF EXISTS `chargingspot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chargingspot` (
  `ChargingSpotID` int NOT NULL,
  `ChargingStationID` int NOT NULL,
  `Availability` enum('YES','NO') NOT NULL,
  `Coordinates` varchar(255) NOT NULL,
  `SpotType` varchar(35) NOT NULL,
  PRIMARY KEY (`ChargingSpotID`,`ChargingStationID`),
  UNIQUE KEY `ChargingSpotID_UNIQUE` (`ChargingSpotID`),
  KEY `ChargingStationID_idx` (`ChargingStationID`),
  CONSTRAINT `ChargingStationID1` FOREIGN KEY (`ChargingStationID`) REFERENCES `chargingstation` (`ChargingStationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chargingspot`
--

LOCK TABLES `chargingspot` WRITE;
/*!40000 ALTER TABLE `chargingspot` DISABLE KEYS */;
INSERT INTO `chargingspot` VALUES (2,4,'YES','31.9765, 23.8366','Car'),(12,55,'NO','40.6501, 22.3345','Scooter'),(57,26,'NO','87.2455, 21.7345','Trailer'),(60,8,'YES','90.2345, 22.6789','Car'),(80,50,'YES','97.2135, 24.7654','Bus'),(87,37,'NO','100.4125, 33.7612','Scooter'),(100,44,'YES','99.6234, 40.7869','Motorcycle');
/*!40000 ALTER TABLE `chargingspot` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ChargingSpot_BEFORE_INSERT` BEFORE INSERT ON `chargingspot` FOR EACH ROW BEGIN
    IF NOT EXISTS (SELECT 1 FROM ChargingStation WHERE ChargingStationID = NEW.ChargingStationID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid ChargingStationID.';
    END IF;

    IF EXISTS (SELECT 1 FROM ChargingSpot WHERE ChargingStationID = NEW.ChargingStationID AND ChargingSpotID = NEW.ChargingSpotID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ChargingSpotID must be unique for each ChargingStation.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ChargingSpot_BEFORE_UPDATE` BEFORE UPDATE ON `chargingspot` FOR EACH ROW BEGIN
    IF NOT EXISTS (SELECT 1 FROM ChargingStation WHERE ChargingStationID = NEW.ChargingStationID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid ChargingStationID.';
    END IF;

    IF EXISTS (SELECT 1 FROM ChargingSpot WHERE ChargingStationID = NEW.ChargingStationID AND ChargingSpotID = NEW.ChargingSpotID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ChargingSpotID must be unique for each ChargingStation.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `chargingstation`
--

DROP TABLE IF EXISTS `chargingstation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chargingstation` (
  `ChargingStationID` int NOT NULL,
  `NumberOfSpots` varchar(35) NOT NULL,
  `Location` varchar(35) NOT NULL,
  PRIMARY KEY (`ChargingStationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chargingstation`
--

LOCK TABLES `chargingstation` WRITE;
/*!40000 ALTER TABLE `chargingstation` DISABLE KEYS */;
INSERT INTO `chargingstation` VALUES (4,'90','Ampelokipoi,Athens'),(8,'30','Center,Lamia'),(26,'20','Agria,Volos'),(37,'5','Nea Smirni, Athens'),(44,'43','Kastro,Ioannina'),(50,'10','Center,Katerini'),(55,'5','Pylaia,Thessaloniki');
/*!40000 ALTER TABLE `chargingstation` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ChargingStation_BEFORE_INSERT` BEFORE INSERT ON `chargingstation` FOR EACH ROW BEGIN
	IF NOT NEW.Location REGEXP '^[a-zA-Z0-9 ]+,[a-zA-Z ]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Location should have the format "region, city"';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ChargingStation_BEFORE_UPDATE` BEFORE UPDATE ON `chargingstation` FOR EACH ROW BEGIN
	IF NOT NEW.Location REGEXP '^[a-zA-Z0-9 ]+,[a-zA-Z ]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Location should have the format "region, city"';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `datasent`
--

DROP TABLE IF EXISTS `datasent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datasent` (
  `ChargingSessionID` int NOT NULL,
  `NotificationType` enum('StartSession','EndSession','Reminder','Error') NOT NULL,
  `DataSent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ChargingSessionID`,`NotificationType`),
  UNIQUE KEY `ChargingSessionID_UNIQUE` (`ChargingSessionID`) /*!80000 INVISIBLE */,
  CONSTRAINT `NotificationTypeChargingSessionID` FOREIGN KEY (`ChargingSessionID`, `NotificationType`) REFERENCES `notification` (`ChargingSessionID`, `NotificationType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datasent`
--

LOCK TABLES `datasent` WRITE;
/*!40000 ALTER TABLE `datasent` DISABLE KEYS */;
INSERT INTO `datasent` VALUES (4,'EndSession','Session ends at 2024-12-22 11:00:00'),(21,'Reminder','Reminder for Session at 2024-12-22 11:30:00'),(36,'EndSession','Session ends at 2024-12-24 08:45:00'),(58,'Error','Error at ongoing Session 2024-12-23 09:00:00'),(177,'StartSession','Session starts at 2024-12-23 15:45:00'),(254,'Error','Error at ongoing Session 2024-12-21 12:35:20'),(669,'StartSession','Session starts at 2024-12-21 14:00:00');
/*!40000 ALTER TABLE `datasent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `energyprovider`
--

DROP TABLE IF EXISTS `energyprovider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `energyprovider` (
  `EnergyProviderID` int NOT NULL,
  `ProviderName` varchar(35) NOT NULL,
  `ContactPhone` char(13) NOT NULL,
  `ContactEmail` varchar(35) NOT NULL,
  PRIMARY KEY (`EnergyProviderID`),
  UNIQUE KEY `EnergyProviderID_UNIQUE` (`EnergyProviderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `energyprovider`
--

LOCK TABLES `energyprovider` WRITE;
/*!40000 ALTER TABLE `energyprovider` DISABLE KEYS */;
INSERT INTO `energyprovider` VALUES (2,'Energy (NRG)','+302318538201','info@nrg.com'),(3,'GreenPower','+302310345678','contact@greenpower.gr'),(7,'VoltPlus Energy','+302310642964','info@voltplusenergy.com'),(9,'ChargeNet Enterprises','+302310743600','info@chargenet-enterprises.gr'),(24,'Zenith','+302310222540','info@zenith.gr'),(47,'Elpedison','+302102145789','info@elpedison.gr'),(88,'Protergia','+302141714596','info@protergia.gr');
/*!40000 ALTER TABLE `energyprovider` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `EnergyProvider_BEFORE_INSERT` BEFORE INSERT ON `energyprovider` FOR EACH ROW BEGIN	
   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `EnergyProvider_BEFORE_UPDATE` BEFORE UPDATE ON `energyprovider` FOR EACH ROW BEGIN
	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `energyproviderchargingstations`
--

DROP TABLE IF EXISTS `energyproviderchargingstations`;
/*!50001 DROP VIEW IF EXISTS `energyproviderchargingstations`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `energyproviderchargingstations` AS SELECT 
 1 AS `ChargingStationID`,
 1 AS `NumberOfSpots`,
 1 AS `Location`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `ChargingSessionID` int NOT NULL,
  `NotificationID` int NOT NULL,
  `NotificationType` enum('StartSession','EndSession','Reminder','Error') NOT NULL,
  PRIMARY KEY (`ChargingSessionID`,`NotificationID`),
  UNIQUE KEY `NotificationID_UNIQUE` (`NotificationID`),
  UNIQUE KEY `NotificationTypeChargingSessionID` (`ChargingSessionID`,`NotificationType`) /*!80000 INVISIBLE */,
  UNIQUE KEY `ChargingSessionID_UNIQUE` (`ChargingSessionID`),
  KEY `ChargingSessionID_idx` (`ChargingSessionID`) /*!80000 INVISIBLE */,
  CONSTRAINT `ChargingSessionID` FOREIGN KEY (`ChargingSessionID`) REFERENCES `chargingsession` (`ChargingSessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (4,62,'EndSession'),(21,12,'Reminder'),(36,27,'EndSession'),(58,25,'Error'),(177,74,'StartSession'),(254,36,'Error'),(669,57,'StartSession');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `PaymentID` int NOT NULL,
  `PaymentAmount` varchar(10) DEFAULT NULL,
  `PaymentMethod` enum('Cash','Card') DEFAULT NULL,
  `ChargingSessionID` int NOT NULL,
  PRIMARY KEY (`PaymentID`,`ChargingSessionID`),
  UNIQUE KEY `PaymentID_UNIQUE` (`PaymentID`),
  KEY `ChargingSessionID_idx` (`ChargingSessionID`),
  CONSTRAINT `ChargingSessionID7` FOREIGN KEY (`ChargingSessionID`) REFERENCES `chargingsession` (`ChargingSessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (4,'51.00','Card',4),(21,'114.00','Card',21),(36,'85.00','Card',36),(58,'44.00','Cash',58),(177,'35.00','Cash',177),(254,'72.00','Cash',254),(669,'51.00','Card',669);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paymentenergy`
--

DROP TABLE IF EXISTS `paymentenergy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paymentenergy` (
  `ChargingSessionID` int NOT NULL,
  `Energy` varchar(8) NOT NULL,
  `PaymentEnergy` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ChargingSessionID`,`Energy`),
  UNIQUE KEY `ChargingSessionID_UNIQUE` (`ChargingSessionID`) /*!80000 INVISIBLE */,
  CONSTRAINT `ChargingSessionIDEnergy` FOREIGN KEY (`ChargingSessionID`, `Energy`) REFERENCES `chargingsession` (`ChargingSessionID`, `Energy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paymentenergy`
--

LOCK TABLES `paymentenergy` WRITE;
/*!40000 ALTER TABLE `paymentenergy` DISABLE KEYS */;
INSERT INTO `paymentenergy` VALUES (4,'33','41'),(21,'69','100'),(36,'74','75'),(58,'588','36'),(177,'22','17'),(254,'254','52'),(669,'14','41');
/*!40000 ALTER TABLE `paymentenergy` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PaymentEnergy_BEFORE_INSERT` BEFORE INSERT ON `paymentenergy` FOR EACH ROW BEGIN
	 DECLARE session_energy VARCHAR(8);
	SELECT Energy INTO session_energy
	FROM ChargingSession
    WHERE ChargingSession.ChargingSessionID = NEW.ChargingSessionID;

    -- If the Energy in ChargingSession is NULL, insert -1 in PaymentEnergy
    IF session_energy IS NULL THEN
        SET NEW.Energy = '-1';
    ELSE
        SET NEW.Energy = session_energy;
    END IF; 
    
    IF NEW.Energy = '-1' THEN
        SET NEW.PaymentEnergy = NULL;
    END IF;
   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PaymentEnergy_AFTER_INSERT` AFTER INSERT ON `paymentenergy` FOR EACH ROW BEGIN
    DECLARE totalEnergy VARCHAR(10);
    DECLARE totalRent VARCHAR(10);
    DECLARE totalAmount VARCHAR(10);
    
    
    SELECT IFNULL(SUM(PaymentEnergy.PaymentEnergy), 0) INTO totalEnergy
    FROM PaymentEnergy
    WHERE PaymentEnergy.ChargingSessionID = NEW.ChargingSessionID;

    -- Υπολογισμός του συνολικού rent
    SELECT IFNULL(SUM(PaymentRent.PaymentRent), 0) INTO totalRent
    FROM PaymentRent
    WHERE PaymentRent.ChargingSessionID = NEW.ChargingSessionID;

    
    SET totalAmount = totalEnergy + totalRent;

    UPDATE Payment
    SET PaymentAmount = totalAmount
    WHERE ChargingSessionID = NEW.ChargingSessionID;
    
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PaymentEnergy_BEFORE_UPDATE` BEFORE UPDATE ON `paymentenergy` FOR EACH ROW BEGIN
	
    DECLARE session_energy VARCHAR(8);
    SELECT Energy INTO session_energy
    FROM ChargingSession
    WHERE ChargingSession.ChargingSessionID = NEW.ChargingSessionID; 
    
	IF session_energy IS NULL THEN
        SET NEW.Energy = '-1';
		ELSE
        SET NEW.Energy = session_energy;
	END IF; 
    
 
    
    IF CURRENT_TIMESTAMP < (SELECT StartDate FROM ChargingSession WHERE ChargingSessionID = NEW.ChargingSessionID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Energy and PaymentEnergy cannot be updated before the session starts.';
    END IF;
      
    
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `paymentrent`
--

DROP TABLE IF EXISTS `paymentrent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paymentrent` (
  `ChargingSessionID` int NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime NOT NULL,
  `PaymentRent` varchar(10) NOT NULL,
  PRIMARY KEY (`ChargingSessionID`,`StartDate`,`EndDate`),
  UNIQUE KEY `EndDate_UNIQUE` (`EndDate`),
  UNIQUE KEY `StartDate_UNIQUE` (`StartDate`),
  UNIQUE KEY `ChargingSessionID_UNIQUE` (`ChargingSessionID`),
  CONSTRAINT `ChargingSessionID6` FOREIGN KEY (`ChargingSessionID`) REFERENCES `chargingsession` (`ChargingSessionID`),
  CONSTRAINT `EndDate` FOREIGN KEY (`EndDate`) REFERENCES `chargingsession` (`EndDate`),
  CONSTRAINT `StartDate` FOREIGN KEY (`StartDate`) REFERENCES `chargingsession` (`StartDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paymentrent`
--

LOCK TABLES `paymentrent` WRITE;
/*!40000 ALTER TABLE `paymentrent` DISABLE KEYS */;
INSERT INTO `paymentrent` VALUES (4,'2024-12-22 10:15:00','2024-12-22 11:00:00','10'),(21,'2024-12-22 11:30:00','2024-12-22 12:15:00','14'),(36,'2024-12-24 08:00:00','2024-12-24 08:45:00','10'),(58,'2024-12-23 09:00:00','2024-12-23 09:30:00','8'),(177,'2024-12-23 15:45:00','2024-12-23 16:30:00','18'),(254,'2024-12-21 12:30:20','2024-12-21 13:15:45','20'),(669,'2024-12-21 14:00:00','2024-12-21 14:45:00','10');
/*!40000 ALTER TABLE `paymentrent` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PaymentRent_AFTER_INSERT` AFTER INSERT ON `paymentrent` FOR EACH ROW BEGIN
    DECLARE totalEnergy DECIMAL(10, 2);
    DECLARE totalRent DECIMAL(10, 2);
    DECLARE totalAmount DECIMAL(10, 2);

    -- Υπολογισμός του συνολικού energy
    SELECT IFNULL(SUM(PaymentEnergy.PaymentEnergy), 0) INTO totalEnergy
    FROM PaymentEnergy
    WHERE PaymentEnergy.ChargingSessionID = NEW.ChargingSessionID;

    -- Υπολογισμός του συνολικού rent
    SELECT IFNULL(SUM(PaymentRent.PaymentRent), 0) INTO totalRent
    FROM PaymentRent
    WHERE PaymentRent.ChargingSessionID = NEW.ChargingSessionID;

    -- Υπολογισμός του συνολικού ποσού
    SET totalAmount = totalEnergy + totalRent;

    -- Ενημέρωση του PaymentAmount
    UPDATE Payment
    SET PaymentAmount = totalAmount
    WHERE ChargingSessionID = NEW.ChargingSessionID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `posses`
--

DROP TABLE IF EXISTS `posses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posses` (
  `VehicleID` int NOT NULL,
  `VehicleOwnerID` int NOT NULL,
  PRIMARY KEY (`VehicleID`,`VehicleOwnerID`),
  KEY `VehicleOwnerID_idx` (`VehicleOwnerID`),
  CONSTRAINT `VehicleID` FOREIGN KEY (`VehicleID`) REFERENCES `vehicle` (`VehicleID`),
  CONSTRAINT `VehicleOwnerID` FOREIGN KEY (`VehicleOwnerID`) REFERENCES `vehicleowner` (`VehicleOwnerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posses`
--

LOCK TABLES `posses` WRITE;
/*!40000 ALTER TABLE `posses` DISABLE KEYS */;
INSERT INTO `posses` VALUES (3,1),(98,4),(101,7),(4,9),(7,12),(54,32),(37,45);
/*!40000 ALTER TABLE `posses` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Posses_BEFORE_INSERT` BEFORE INSERT ON `posses` FOR EACH ROW BEGIN
   IF NOT EXISTS (SELECT 1 FROM Vehicle WHERE VehicleID = NEW.VehicleID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid VehicleID: No such vehicle exists.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM VehicleOwner WHERE VehicleOwnerID = NEW.VehicleOwnerID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid OwnerID: No such owner exists.';
    END IF;

    IF EXISTS (SELECT 1 FROM Posses WHERE VehicleID = NEW.VehicleID AND VehicleOwnerID = NEW.VehicleOwnerID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The relationship between this vehicle and owner already exists.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Posses_BEFORE_UPDATE` BEFORE UPDATE ON `posses` FOR EACH ROW BEGIN
	 IF NOT EXISTS (SELECT 1 FROM Vehicle WHERE VehicleID = NEW.VehicleID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid VehicleID: No such vehicle exists.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Owner WHERE VehicleOwnerID = NEW.VehicleOwnerID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid OwnerID: No such owner exists.';
    END IF;

    IF EXISTS (SELECT 1 FROM Posses WHERE VehicleID = NEW.VehicleID AND VehicleOwnerID = NEW.VehicleOwnerID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The relationship between this vehicle and owner already exists.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `power`
--

DROP TABLE IF EXISTS `power`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `power` (
  `EnergyProviderID` int NOT NULL,
  `ChargingStationID` int NOT NULL,
  PRIMARY KEY (`EnergyProviderID`,`ChargingStationID`),
  KEY `ChargingStationID_idx` (`ChargingStationID`),
  CONSTRAINT `ChargingStationID3` FOREIGN KEY (`ChargingStationID`) REFERENCES `chargingstation` (`ChargingStationID`),
  CONSTRAINT `EnergyProviderID` FOREIGN KEY (`EnergyProviderID`) REFERENCES `energyprovider` (`EnergyProviderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `power`
--

LOCK TABLES `power` WRITE;
/*!40000 ALTER TABLE `power` DISABLE KEYS */;
INSERT INTO `power` VALUES (3,4),(9,8),(2,26),(47,37),(88,44),(24,50),(7,55);
/*!40000 ALTER TABLE `power` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Power_BEFORE_INSERT` BEFORE INSERT ON `power` FOR EACH ROW BEGIN
	 IF NOT EXISTS (SELECT 1 FROM ChargingStation WHERE ChargingStationID = NEW.ChargingStationID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid data.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EnergyProvider WHERE EnergyProviderID = NEW.EnergyProviderID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid data';
    END IF;

    IF EXISTS (SELECT 1 FROM Power WHERE ChargingStationID = NEW.ChargingStationID AND EnergyProviderID = NEW.EnergyProviderID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The relationship between this chargingstation and energyprovider already exists.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Power_BEFORE_UPDATE` BEFORE UPDATE ON `power` FOR EACH ROW BEGIN
	IF NOT EXISTS (SELECT 1 FROM ChargingStation WHERE ChargingStationID = NEW.ChargingStationID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid data.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EnergyProvider WHERE EnergyProviderID = NEW.EnergyProviderID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid data';
    END IF;

    IF EXISTS (SELECT 1 FROM Power WHERE ChargingStationID = NEW.ChargingStationID AND EnergyProviderID = NEW.EnergyProviderID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The relationship between this chargingstation and energyprovider already exists.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `receive`
--

DROP TABLE IF EXISTS `receive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receive` (
  `ReceiveID` int NOT NULL,
  `NotificationID` int NOT NULL,
  `ChargingSessionID` int NOT NULL,
  `VehicleOwnerID` int NOT NULL,
  PRIMARY KEY (`ReceiveID`),
  UNIQUE KEY `ReceiveID_UNIQUE` (`ReceiveID`),
  KEY `NotificationID_idx` (`NotificationID`),
  KEY `ChargingSessionID_idx` (`ChargingSessionID`),
  KEY `VehicleOwnerID_idx` (`VehicleOwnerID`),
  CONSTRAINT `ChargingSessionID4` FOREIGN KEY (`ChargingSessionID`) REFERENCES `chargingsession` (`ChargingSessionID`),
  CONSTRAINT `NotificationID` FOREIGN KEY (`NotificationID`) REFERENCES `notification` (`NotificationID`),
  CONSTRAINT `VehicleOwnerID1` FOREIGN KEY (`VehicleOwnerID`) REFERENCES `vehicleowner` (`VehicleOwnerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receive`
--

LOCK TABLES `receive` WRITE;
/*!40000 ALTER TABLE `receive` DISABLE KEYS */;
INSERT INTO `receive` VALUES (1,74,177,32),(5,36,254,12),(36,57,669,1),(69,62,4,4),(147,12,21,9),(214,25,58,7),(333,27,36,45);
/*!40000 ALTER TABLE `receive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `totalenergyperprovider`
--

DROP TABLE IF EXISTS `totalenergyperprovider`;
/*!50001 DROP VIEW IF EXISTS `totalenergyperprovider`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `totalenergyperprovider` AS SELECT 
 1 AS `EnergyProviderID`,
 1 AS `ProviderName`,
 1 AS `TotalEnergy`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `totalenergyperstation`
--

DROP TABLE IF EXISTS `totalenergyperstation`;
/*!50001 DROP VIEW IF EXISTS `totalenergyperstation`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `totalenergyperstation` AS SELECT 
 1 AS `ChargingStationID`,
 1 AS `Location`,
 1 AS `TotalEnergy`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle` (
  `VehicleID` int NOT NULL,
  `LicensePlate` varchar(7) NOT NULL,
  `VehicleType` varchar(35) NOT NULL,
  PRIMARY KEY (`VehicleID`),
  UNIQUE KEY `VehicleID_UNIQUE` (`VehicleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle`
--

LOCK TABLES `vehicle` WRITE;
/*!40000 ALTER TABLE `vehicle` DISABLE KEYS */;
INSERT INTO `vehicle` VALUES (3,'NZZ8888','Car'),(4,'NKK741','Scooter'),(7,'INY8919','Trailer'),(37,'HKN6554','Bus'),(54,'KBA2123','Car'),(98,'IMH590','Motorcycle'),(101,'AHP4387','Trailer');
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vehiclelocationview`
--

DROP TABLE IF EXISTS `vehiclelocationview`;
/*!50001 DROP VIEW IF EXISTS `vehiclelocationview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vehiclelocationview` AS SELECT 
 1 AS `VehicleID`,
 1 AS `Location`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `vehicleowner`
--

DROP TABLE IF EXISTS `vehicleowner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicleowner` (
  `VehicleOwnerID` int NOT NULL,
  `Name` varchar(35) NOT NULL,
  `Email` varchar(35) NOT NULL,
  `PhoneNumber` char(13) NOT NULL,
  PRIMARY KEY (`VehicleOwnerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicleowner`
--

LOCK TABLES `vehicleowner` WRITE;
/*!40000 ALTER TABLE `vehicleowner` DISABLE KEYS */;
INSERT INTO `vehicleowner` VALUES (1,'Achilleas Diamond','Achilleasdiamond@gmail.com','+306933224477'),(4,'Gina Piles','Ginapiles@gmail.com','+306921314152'),(7,'Giannis Nikolaidis','giannisinikol@gmail.com','+306972345678'),(9,'Theo Pitt','Theopitt@gmail.com','+306987676796'),(12,'George Papadopoulos','Georgepapadopoulos@gmail.com','+306987654321'),(32,'Chris Samaras','samagiamarina@gmail.com','+306933456789'),(45,'Evelina Finou','evelinafinou01@gmail.com','+306984567890');
/*!40000 ALTER TABLE `vehicleowner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vehicleownerchargingsessions`
--

DROP TABLE IF EXISTS `vehicleownerchargingsessions`;
/*!50001 DROP VIEW IF EXISTS `vehicleownerchargingsessions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vehicleownerchargingsessions` AS SELECT 
 1 AS `ChargingSessionID`,
 1 AS `StartDate`,
 1 AS `EndDate`,
 1 AS `ChargingSpotID`,
 1 AS `ChargingStationID`,
 1 AS `VehicleID`,
 1 AS `Energy`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vehicleownerdatasent`
--

DROP TABLE IF EXISTS `vehicleownerdatasent`;
/*!50001 DROP VIEW IF EXISTS `vehicleownerdatasent`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vehicleownerdatasent` AS SELECT 
 1 AS `ChargingSessionID`,
 1 AS `NotificationType`,
 1 AS `DataSent`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vehicleownerpaymentrent`
--

DROP TABLE IF EXISTS `vehicleownerpaymentrent`;
/*!50001 DROP VIEW IF EXISTS `vehicleownerpaymentrent`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vehicleownerpaymentrent` AS SELECT 
 1 AS `ChargingSessionID`,
 1 AS `StartDate`,
 1 AS `EndDate`,
 1 AS `PaymentRent`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `availablespotsperstation`
--

/*!50001 DROP VIEW IF EXISTS `availablespotsperstation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `availablespotsperstation` AS select `chargingspot`.`ChargingStationID` AS `ChargingStationID`,count(`chargingspot`.`ChargingSpotID`) AS `AvailableSpotCount` from `chargingspot` where (`chargingspot`.`Availability` = 'YES') group by `chargingspot`.`ChargingStationID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `avgdurationandrentpervehicletype`
--

/*!50001 DROP VIEW IF EXISTS `avgdurationandrentpervehicletype`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `avgdurationandrentpervehicletype` AS select `v`.`VehicleType` AS `VehicleType`,avg(timestampdiff(MINUTE,`cs`.`StartDate`,`cs`.`EndDate`)) AS `AvgDurationMinutes`,avg(`pr`.`PaymentRent`) AS `AvgPaymentRent` from ((`chargingsession` `cs` join `vehicle` `v` on((`cs`.`VehicleID` = `v`.`VehicleID`))) join `paymentrent` `pr` on(((`cs`.`StartDate` = `pr`.`StartDate`) and (`cs`.`EndDate` = `pr`.`EndDate`)))) group by `v`.`VehicleType` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `avgenergyandpaymentpervehicletype`
--

/*!50001 DROP VIEW IF EXISTS `avgenergyandpaymentpervehicletype`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `avgenergyandpaymentpervehicletype` AS select `v`.`VehicleType` AS `VehicleType`,avg(`cs`.`Energy`) AS `AvgEnergy`,avg(`pe`.`PaymentEnergy`) AS `AvgPaymentEnergy` from ((`chargingsession` `cs` join `paymentenergy` `pe` on((`cs`.`ChargingSessionID` = `pe`.`ChargingSessionID`))) join `vehicle` `v` on((`cs`.`VehicleID` = `v`.`VehicleID`))) group by `v`.`VehicleType` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `energyproviderchargingstations`
--

/*!50001 DROP VIEW IF EXISTS `energyproviderchargingstations`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `energyproviderchargingstations` AS select `st`.`ChargingStationID` AS `ChargingStationID`,`st`.`NumberOfSpots` AS `NumberOfSpots`,`st`.`Location` AS `Location` from ((`chargingstation` `st` join `power` `p` on((`st`.`ChargingStationID` = `p`.`ChargingStationID`))) join `energyprovider` `ep` on((`p`.`EnergyProviderID` = `ep`.`EnergyProviderID`))) where (`ep`.`EnergyProviderID` = (select `ep2`.`EnergyProviderID` from `energyprovider` `ep2` where (`ep2`.`EnergyProviderID` = current_user()))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `totalenergyperprovider`
--

/*!50001 DROP VIEW IF EXISTS `totalenergyperprovider`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `totalenergyperprovider` AS select `ep`.`EnergyProviderID` AS `EnergyProviderID`,`ep`.`ProviderName` AS `ProviderName`,sum(`cs`.`Energy`) AS `TotalEnergy` from (((`chargingsession` `cs` join `chargingstation` `st` on((`cs`.`ChargingStationID` = `st`.`ChargingStationID`))) join `power` `p` on((`st`.`ChargingStationID` = `p`.`ChargingStationID`))) join `energyprovider` `ep` on((`p`.`EnergyProviderID` = `ep`.`EnergyProviderID`))) group by `ep`.`EnergyProviderID`,`ep`.`ProviderName` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `totalenergyperstation`
--

/*!50001 DROP VIEW IF EXISTS `totalenergyperstation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `totalenergyperstation` AS select `st`.`ChargingStationID` AS `ChargingStationID`,`st`.`Location` AS `Location`,sum(`cs`.`Energy`) AS `TotalEnergy` from (`chargingsession` `cs` join `chargingstation` `st` on((`cs`.`ChargingStationID` = `st`.`ChargingStationID`))) group by `st`.`ChargingStationID`,`st`.`Location` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vehiclelocationview`
--

/*!50001 DROP VIEW IF EXISTS `vehiclelocationview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vehiclelocationview` AS select `v`.`VehicleID` AS `VehicleID`,`st`.`Location` AS `Location` from ((`chargingsession` `cs` join `chargingstation` `st` on((`cs`.`ChargingStationID` = `st`.`ChargingStationID`))) join `vehicle` `v` on((`cs`.`VehicleID` = `v`.`VehicleID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vehicleownerchargingsessions`
--

/*!50001 DROP VIEW IF EXISTS `vehicleownerchargingsessions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vehicleownerchargingsessions` AS select `cs`.`ChargingSessionID` AS `ChargingSessionID`,`cs`.`StartDate` AS `StartDate`,`cs`.`EndDate` AS `EndDate`,`cs`.`ChargingSpotID` AS `ChargingSpotID`,`cs`.`ChargingStationID` AS `ChargingStationID`,`cs`.`VehicleID` AS `VehicleID`,`cs`.`Energy` AS `Energy` from (((`chargingsession` `cs` join `vehicle` `v` on((`cs`.`VehicleID` = `v`.`VehicleID`))) join `posses` `p` on((`v`.`VehicleID` = `p`.`VehicleID`))) join `vehicleowner` `vo` on((`p`.`VehicleOwnerID` = `vo`.`VehicleOwnerID`))) where (`vo`.`VehicleOwnerID` = current_user()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vehicleownerdatasent`
--

/*!50001 DROP VIEW IF EXISTS `vehicleownerdatasent`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vehicleownerdatasent` AS select `ds`.`ChargingSessionID` AS `ChargingSessionID`,`ds`.`NotificationType` AS `NotificationType`,`ds`.`DataSent` AS `DataSent` from ((((`datasent` `ds` join `chargingsession` `cs` on((`ds`.`ChargingSessionID` = `cs`.`ChargingSessionID`))) join `vehicle` `v` on((`cs`.`VehicleID` = `v`.`VehicleID`))) join `posses` `p` on((`v`.`VehicleID` = `p`.`VehicleID`))) join `vehicleowner` `vo` on((`p`.`VehicleOwnerID` = `vo`.`VehicleOwnerID`))) where (`vo`.`VehicleOwnerID` = current_user()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vehicleownerpaymentrent`
--

/*!50001 DROP VIEW IF EXISTS `vehicleownerpaymentrent`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vehicleownerpaymentrent` AS select `pr`.`ChargingSessionID` AS `ChargingSessionID`,`pr`.`StartDate` AS `StartDate`,`pr`.`EndDate` AS `EndDate`,`pr`.`PaymentRent` AS `PaymentRent` from ((((`paymentrent` `pr` join `chargingsession` `cs` on((`pr`.`ChargingSessionID` = `cs`.`ChargingSessionID`))) join `vehicle` `v` on((`cs`.`VehicleID` = `v`.`VehicleID`))) join `posses` `p` on((`v`.`VehicleID` = `p`.`VehicleID`))) join `vehicleowner` `vo` on((`p`.`VehicleOwnerID` = `vo`.`VehicleOwnerID`))) where (`vo`.`VehicleOwnerID` = current_user()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-28 16:21:02
