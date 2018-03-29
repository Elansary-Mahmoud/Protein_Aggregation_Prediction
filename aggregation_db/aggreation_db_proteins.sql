CREATE DATABASE  IF NOT EXISTS `aggreation_db` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `aggreation_db`;
-- MySQL dump 10.13  Distrib 5.5.9, for Win32 (x86)
--
-- Host: localhost    Database: aggreation_db
-- ------------------------------------------------------
-- Server version	5.1.56-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `proteins`
--

DROP TABLE IF EXISTS `proteins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proteins` (
  `uniprot_ID` varchar(45) NOT NULL,
  `Protein_Name` varchar(500) DEFAULT NULL,
  `Short_Name` varchar(45) DEFAULT NULL,
  `PDB_ID` varchar(45) DEFAULT NULL,
  `TANGO` float DEFAULT NULL,
  `Waltz` float DEFAULT NULL,
  `Agadir` float DEFAULT NULL,
  `LIMBO` float DEFAULT NULL,
  PRIMARY KEY (`uniprot_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proteins`
--

LOCK TABLES `proteins` WRITE;
/*!40000 ALTER TABLE `proteins` DISABLE KEYS */;
INSERT INTO `proteins` VALUES ('P00439','HUMAN Phenylalanine-4-hydroxylase','PAH','1J8U_1PHZ',1460.53,1802.66,187.831,0),('P00441','HUMAN Superoxide dismutase [Cu-Zn]','SOD1','2C9V',87.2439,511.299,15.5901,0),('P02511','HUMAN Alpha-crystallin B','CryAB','2WJ7',27.1368,30.4696,108.158,0),('P04406','HUMAN Glyceraldehyde-3-phosphate dehydrogenase','GAPDH','1U8F',752.356,1767.42,115.962,0),('P04637','HUMAN Cellular tumor antigen p53','P53','2AC0',704.106,275.646,523.071,0),('P06280','HUMAN Alpha-galactosidase A','alpha-GalA','3HG3',1471.26,1201.56,208.128,0),('P07315','HUMAN Gamma-crystallin C','human_gammaC-crystallin','2v2u',99.1055,11.2574,36.1772,0),('P07320','HUMAN Gamma-crystallin D','HGDC','1HK0',24.5827,566.888,46.4466,0),('P14621','HUMAN Acylphosphatase-2','Acp','2acy',58.6205,20.6709,208.314,0),('P16615','HUMAN Sarcoplasmic/endoplasmic reticulum calcium ATPase 2','SERCA2','3ar4',12721.9,2579.09,1334.85,0),('P30131','ECOLI Carbamoyltransferase hypF','HypF-N','1GXT',840.095,1024.34,1047.35,0),('P37840','HUMAN Alpha-synuclein','Alpha-synuclein','3Q25_3Q26_3Q27_3Q28_2X6M',790.69,202.296,30.3915,0),('P42771','HUMAN Cyclin-dependent kinase inhibitor 2A','P16','1BI7',433.95,0.312563,306.154,1502.31),('P60484','HUMAN Phosphatidylinositol-3,4,5-trisphosphate 3-phosphatase and dual-specificity protein phosphatase PTEN','PTEN','1D5R',2196.21,793.406,171.142,0),('P61769','HUMAN Beta-2-microglobulin','b2m','2D4F',1696.22,180.518,107.973,0),('Q13813','HUMAN Spectrin alpha chain','Spc-SH3','1shg',587.706,36.0833,36.0528,0),('Q99574','HUMAN Neuroserpin','human_neuroserpin','3FGQ',3897.85,1654.23,883.775,0);
/*!40000 ALTER TABLE `proteins` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-05-04 23:28:48
