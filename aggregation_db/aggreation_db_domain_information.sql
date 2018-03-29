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
-- Table structure for table `domain_information`
--

DROP TABLE IF EXISTS `domain_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain_information` (
  `Domain_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Protein_ID` varchar(45) DEFAULT NULL,
  `Source` varchar(45) DEFAULT NULL,
  `Start` int(11) DEFAULT NULL,
  `End` int(11) DEFAULT NULL,
  `Domain_Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Domain_ID`),
  KEY `Domain_Protein_ID_FK` (`Protein_ID`),
  CONSTRAINT `Domain_Protein_ID_FK` FOREIGN KEY (`Protein_ID`) REFERENCES `proteins` (`uniprot_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_information`
--

LOCK TABLES `domain_information` WRITE;
/*!40000 ALTER TABLE `domain_information` DISABLE KEYS */;
INSERT INTO `domain_information` VALUES (1,'P14621','Pfam A ',1,98,'Acylphosphatase '),(2,'P06280','sig_p ',1,31,'n/a '),(3,'P06280','Pfam A ',33,149,'Melibiase '),(4,'P37840','Pfam A ',1,132,'Synuclein '),(5,'P61769','sig_p ',1,20,'n/a '),(6,'P61769','Pfam A ',31,112,'C1-set '),(7,'P61769','SMART',40,110,'IGc1'),(8,'P02511','Pfam A ',1,59,'Crystallin '),(9,'P02511','Pfam A ',67,162,'HSP20 '),(10,'P04406','Pfam A ',4,152,'Gp_dh_N '),(11,'P04406','Pfam A ',157,314,'Gp_dh_C '),(12,'P04406','SMART',4,152,'Gp_dh_N'),(13,'P07320','Pfam A ',3,82,'Crystall '),(14,'P07320','Pfam A ',89,170,'Crystall '),(15,'P07320','SMART',3,82,'XTALbg'),(16,'P07320','SMART',89,170,'XTALbg'),(17,'P07315','Pfam A ',3,82,'Crystall '),(18,'P07315','Pfam A ',89,170,'Crystall '),(19,'P07315','SMART',3,82,'XTALbg'),(20,'P07315','SMART',89,170,'XTALbg'),(21,'Q99574','sig_p ',1,18,'n/a '),(22,'Q99574','Pfam A ',24,397,'Serpin '),(23,'Q99574','SMART',31,397,'SERPIN'),(24,'P30131','Pfam A ',1,91,'Acylphosphatase '),(25,'P30131','Pfam A ',108,142,'zf-HYPF '),(26,'P30131','Pfam A ',158,192,'zf-HYPF '),(27,'P30131','Pfam A ',208,374,'Sua5_yciO_yrdC '),(28,'P42771','Pfam A ',16,43,'Ank '),(29,'P42771','SMART',44,72,'ANK'),(30,'P42771','SMART',77,106,'ANK'),(31,'P04637','Pfam A ',5,29,'P53_TAD '),(32,'P04637','Pfam A ',95,289,'P53 '),(33,'P04637','Pfam A ',318,359,'P53_tetramer '),(34,'P00439','Pfam A',35,100,'ACT'),(35,'P00439','Pfam A',119,450,'Biopterin_H'),(36,'P00439','low_complexity',360,371,'n/a'),(37,'P60484','Pfam A ',47,175,'DSPc '),(38,'P60484','Pfam A ',188,349,'PTEN_C2 '),(39,'P16615','Pfam A ',4,72,'Cation_ATPase_N '),(40,'P16615','transmembrane ',60,78,'n/a '),(41,'P16615','transmembrane ',84,107,'n/a '),(42,'P16615','Pfam A ',93,341,'E1-E2_ATPase '),(43,'P16615','transmembrane ',260,280,'n/a '),(44,'P16615','transmembrane ',292,321,'n/a '),(45,'P16615','Pfam A ',345,714,'Hydrolase '),(46,'P16615','transmembrane ',759,782,'n/a '),(47,'P16615','Pfam A ',783,986,'Cation_ATPase_C '),(48,'P16615','transmembrane ',833,856,'n/a '),(49,'P16615','transmembrane ',930,949,'n/a '),(50,'P16615','transmembrane ',955,978,'n/a '),(51,'P16615','transmembrane ',1013,1031,'n/a '),(52,'P16615','SMART',3,77,'Cation_ATPase_N'),(53,'P16615','SMART',84,106,'transmembrane'),(54,'P16615','SMART',260,279,'transmembrane'),(55,'P16615','SMART',299,321,'transmembrane'),(56,'P16615','SMART',759,781,'transmembrane'),(57,'P16615','SMART',836,858,'transmembrane'),(58,'P16615','SMART',930,952,'transmembrane'),(59,'P16615','SMART',1013,1030,'transmembrane'),(60,'P00441','Pfam A ',5,150,'Sod_Cu '),(61,'Q13813','Pfam A ',44,147,'Spectrin '),(62,'Q13813','Pfam A ',149,252,'Spectrin '),(63,'Q13813','coiled_coil ',184,204,'n/a '),(64,'Q13813','Pfam A ',255,359,'Spectrin '),(65,'Q13813','coiled_coil ',290,324,'n/a '),(66,'Q13813','Pfam A ',361,465,'Spectrin '),(67,'Q13813','coiled_coil ',386,416,'n/a '),(68,'Q13813','Pfam A ',467,571,'Spectrin '),(69,'Q13813','coiled_coil ',502,522,'n/a '),(70,'Q13813','Pfam A ',573,676,'Spectrin '),(71,'Q13813','coiled_coil ',614,634,'n/a '),(72,'Q13813','Pfam A ',678,782,'Spectrin '),(73,'Q13813','coiled_coil ',713,733,'n/a '),(74,'Q13813','Pfam A ',784,888,'Spectrin '),(75,'Q13813','coiled_coil ',858,889,'n/a '),(76,'Q13813','Pfam A ',890,973,'Spectrin '),(77,'Q13813','Pfam A ',973,1018,'SH3_1 '),(78,'Q13813','Pfam A ',1092,1176,'Spectrin '),(79,'Q13813','coiled_coil ',1126,1160,'n/a '),(80,'Q13813','Pfam A ',1233,1337,'Spectrin '),(81,'Q13813','coiled_coil ',1268,1288,'n/a '),(82,'Q13813','Pfam A ',1339,1443,'Spectrin '),(83,'Q13813','Pfam A ',1445,1549,'Spectrin '),(84,'Q13813','Pfam A ',1551,1656,'Spectrin '),(85,'Q13813','Pfam A ',1658,1762,'Spectrin '),(86,'Q13813','coiled_coil ',1693,1727,'n/a '),(87,'Q13813','Pfam A ',1764,1868,'Spectrin '),(88,'Q13813','Pfam A ',1870,1974,'Spectrin '),(89,'Q13813','Pfam A ',1976,2081,'Spectrin '),(90,'Q13813','Pfam A ',2091,2195,'Spectrin '),(91,'Q13813','coiled_coil ',2172,2204,'n/a '),(92,'Q13813','Pfam A ',2205,2310,'Spectrin '),(93,'Q13813','Pfam A ',2322,2395,'EF_hand_5 '),(94,'Q13813','Pfam A ',2402,2471,'efhand_Ca_insen '),(95,'Q13813','SMART',47,146,'SPEC'),(96,'Q13813','SMART',152,252,'SPEC'),(97,'Q13813','SMART',258,358,'SPEC'),(98,'Q13813','SMART',364,464,'SPEC'),(99,'Q13813','SMART',470,570,'SPEC'),(100,'Q13813','SMART',576,675,'SPEC'),(101,'Q13813','SMART',681,781,'SPEC'),(102,'Q13813','SMART',787,887,'SPEC'),(103,'Q13813','SMART',893,1088,'SPEC'),(104,'Q13813','SMART',970,1025,'SH3'),(105,'Q13813','SMART',1094,1230,'SPEC'),(106,'Q13813','SMART',1236,1336,'SPEC'),(107,'Q13813','SMART',1342,1442,'SPEC'),(108,'Q13813','SMART',1448,1548,'SPEC'),(109,'Q13813','SMART',1554,1655,'SPEC'),(110,'Q13813','SMART',1661,1761,'SPEC'),(111,'Q13813','SMART',1767,1867,'SPEC'),(112,'Q13813','SMART',1873,1973,'SPEC'),(113,'Q13813','SMART',1979,2080,'SPEC'),(114,'Q13813','SMART',2094,2194,'SPEC'),(115,'Q13813','SMART',2208,2309,'SPEC'),(116,'Q13813','SMART',2327,2355,'EFh'),(117,'Q13813','SMART',2370,2398,'EFh');
/*!40000 ALTER TABLE `domain_information` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-05-04 23:28:43
