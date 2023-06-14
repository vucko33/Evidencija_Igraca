-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: evidencijaigraca
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
-- Table structure for table `igraci`
--

DROP TABLE IF EXISTS `igraci`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `igraci` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Ime` varchar(25) DEFAULT NULL,
  `Prezime` varchar(25) DEFAULT NULL,
  `GodinaRodjenja` int DEFAULT NULL,
  `BrojDresa` int DEFAULT NULL,
  `ProsecanBrojPoena` decimal(5,2) DEFAULT NULL,
  `AgentID` int DEFAULT NULL,
  `TimID` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `AgentID` (`AgentID`),
  KEY `TimID` (`TimID`),
  CONSTRAINT `igraci_ibfk_1` FOREIGN KEY (`AgentID`) REFERENCES `skauti` (`ID`),
  CONSTRAINT `igraci_ibfk_2` FOREIGN KEY (`TimID`) REFERENCES `timovi` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `igraci`
--

LOCK TABLES `igraci` WRITE;
/*!40000 ALTER TABLE `igraci` DISABLE KEYS */;
INSERT INTO `igraci` VALUES (1,'Nikola','Jokic',1995,15,43.00,1,1),(2,'Jimmy','Butler',1992,22,26.50,4,5),(3,'Jamal','Murrey',1994,7,27.00,2,1),(4,'Mikal','Bridges',1993,1,21.00,3,3),(5,'Lebron','James',1986,23,24.40,2,2);
/*!40000 ALTER TABLE `igraci` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skauti`
--

DROP TABLE IF EXISTS `skauti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skauti` (
  `ID` int NOT NULL,
  `Ime` varchar(25) DEFAULT NULL,
  `Prezime` varchar(25) DEFAULT NULL,
  `Agencija` varchar(25) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  `lozinka` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skauti`
--

LOCK TABLES `skauti` WRITE;
/*!40000 ALTER TABLE `skauti` DISABLE KEYS */;
INSERT INTO `skauti` VALUES (1,'Misko','Raznatovic','Misko Transfer','miskoR@gmail.com','misko123'),(2,'Andrija','Vuckovic','Vucko Transfer','vucko98@gmail.com','vucko123'),(3,'Ilija','Milojkovic','Ikac Transfer','ikac99@gmail.com','ikac123'),(4,'Lazar','Milojkovic','Lazica Transfer','lazica01@gmail.com','lazica123');
/*!40000 ALTER TABLE `skauti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timovi`
--

DROP TABLE IF EXISTS `timovi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timovi` (
  `ID` int NOT NULL,
  `Naziv` varchar(25) DEFAULT NULL,
  `Konferencija` varchar(25) DEFAULT NULL,
  `Grad` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timovi`
--

LOCK TABLES `timovi` WRITE;
/*!40000 ALTER TABLE `timovi` DISABLE KEYS */;
INSERT INTO `timovi` VALUES (1,'Nuggets','Zapad','Denver'),(2,'Lakers','Zapad','Los Angeles'),(3,'Nets','Istok','Brooklyn'),(4,'Celtics','Istok','Boston'),(5,'Heat','Istok','Miami'),(6,'Bulls','Istok','Chicago');
/*!40000 ALTER TABLE `timovi` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-13 19:45:32
