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
-- Table structure for table `short_stretch`
--

DROP TABLE IF EXISTS `short_stretch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `short_stretch` (
  `Short_Stretch_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Sequence_ID` int(11) DEFAULT NULL,
  `Start` int(11) DEFAULT NULL,
  `End` int(11) DEFAULT NULL,
  `Aup_Helical_Content` float DEFAULT NULL,
  `Stretch` varchar(45) DEFAULT NULL,
  `Score` float DEFAULT NULL,
  `Gatekeeper1` varchar(45) DEFAULT NULL,
  `Gatekeeper2` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Short_Stretch_ID`),
  KEY `Sequecne_ID_FK` (`Sequence_ID`),
  CONSTRAINT `Sequecne_ID_FK` FOREIGN KEY (`Sequence_ID`) REFERENCES `sequences` (`Sequence_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `short_stretch`
--

LOCK TABLES `short_stretch` WRITE;
/*!40000 ALTER TABLE `short_stretch` DISABLE KEYS */;
INSERT INTO `short_stretch` VALUES (1,1,36,40,0.292341,'VVGWV',11.1397,'ARKIG','KNTSK'),(2,2,36,40,0.292634,'VVGWV',11.1397,'ARKIG','KNTSK'),(3,3,36,40,0.29276,'VVGWV',11.1397,'ARKIG','KNTSK'),(4,4,36,40,0.292646,'VVGWV',11.1397,'ARKIG','KNTSK'),(5,5,36,40,0.424947,'VVGWV',10.217,'ARKIG','KNTSK'),(6,6,36,40,0.276909,'VVGWV',11.4954,'ARKIG','KNTSK'),(7,7,36,40,0.27252,'VVGWV',11.4177,'ARKIG','KNTSK'),(8,8,36,40,0.292269,'VVGWV',11.1386,'ARKIG','KNTSK'),(9,9,36,40,0.292269,'VVGWV',11.1386,'ARKIG','KNTSK'),(10,10,36,40,0.292269,'VVGWV',11.1386,'ARKIG','KNTSK'),(11,11,36,40,0.292269,'VVGWV',11.1386,'ARKIG','KNTSK'),(12,12,36,40,0.292269,'VVGWV',11.1386,'ARKIG','KNTSK'),(13,13,36,40,0.292269,'VVGWV',11.1386,'ARKIG','KNTSK'),(14,14,36,40,0.292269,'VVGWV',11.1387,'ARKIG','KNTSK'),(15,15,36,40,0.292269,'VVGWV',11.1386,'ARKIG','KNTSK'),(16,16,18,24,0.971954,'FLALVSW',76.5907,'ALALR','DIPGA'),(17,17,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(18,18,18,24,0.971954,'FLALVSW',76.6251,'ALALR','DIPGA'),(19,19,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(20,20,18,24,0.971954,'FLALVSW',76.5633,'ALALR','DIPGA'),(21,21,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(22,22,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(23,23,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(24,24,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(25,25,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(26,26,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(27,27,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(28,28,316,320,0.758703,'VIAII',89.6853,'LQDKD','QDPLG'),(29,29,18,24,0.971954,'FLALVSW',76.6251,'ALALR','DIPGA'),(30,30,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(31,31,18,24,0.971954,'FLALVSW',76.6251,'ALALR','DIPGA'),(32,32,18,24,0.971954,'FLALVSW',76.5942,'ALALR','DIPGA'),(33,33,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(34,34,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(35,35,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(36,36,68,78,0.21644,'GAVVTGVTAVA',40.6723,'VTNVG','QKTVE'),(37,37,68,78,0.21644,'GAVVTGVTAVA',40.3908,'VTNVG','QKTVE'),(38,38,68,78,0.21644,'GAVVTGVTAVA',40.3908,'VTNVG','QKTVE'),(39,39,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(40,40,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(41,41,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(42,42,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(43,43,36,41,0.0599367,'GVLFVG',63.8906,'GKTKE','SKTKE'),(44,44,36,41,0.0605847,'GVLWVG',43.1148,'GKTKE','SKTKE'),(45,45,68,78,0.21644,'GAVVTGVTAVA',40.6723,'VTNVG','QKTVE'),(46,46,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(47,47,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(48,48,68,78,0.21644,'GAVVTGVTAVA',40.3908,'VTNVG','QKTVE'),(49,49,68,78,0.21644,'GAVVTGVTAVA',40.3908,'VTNVG','QKTVE'),(50,50,68,78,0.21644,'GAVVTGVTAVA',40.3908,'VTNVG','QKTVE'),(51,51,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(52,52,68,78,0.21644,'GAVVTGVTAVA',40.6723,'VTNVG','QKTVE'),(53,53,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(54,54,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(55,55,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(56,56,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(57,57,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(58,58,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(59,59,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(60,60,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(61,61,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(62,63,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(63,63,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(64,64,68,78,0.21644,'GAVVTGVTAVA',40.6723,'VTNVG','QKTVE'),(65,65,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(66,66,68,78,0.21644,'GAVVTGVTAVA',40.3908,'VTNVG','QKTVE'),(67,67,68,78,0.21644,'GAVVTGVTAVA',40.5317,'VTNVG','QKTVE'),(68,68,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(69,69,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(70,70,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(71,71,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(72,72,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(73,73,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(74,74,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(75,75,36,41,0.0600657,'GVLYVG',39.2383,'GKTKE','SKTKE'),(76,76,66,78,0.0493449,'VGGAVVTGVTVVA',62.9031,'EQVTN','QKTVE'),(77,77,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(78,78,69,78,0.238084,'AVVTGVTAVA',43.7573,'TNVGG','QKTVE'),(79,79,69,78,0.238084,'AVVTGVTAVA',42.7029,'TNVPG','QKTVE'),(80,80,63,78,0.148802,'VTNVGAAVVTGVTAVA',42.1211,'KTKEQ','QKTVE'),(81,81,69,78,0.238084,'AVVTGVTAVA',58.7082,'TNVGE','QKTVE'),(82,82,69,78,0.238084,'AVVTGVTAVA',42.0407,'TNVGP','QKTVE'),(83,83,36,41,0.0600657,'GVLYVG',39.2383,'GKTKE','SKTKE'),(84,84,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(85,85,69,78,0.238084,'AVVTGVTAVA',43.5888,'TPVGG','QKTVE'),(86,86,68,78,0.21644,'GAVVTGVTAVA',40.5317,'VTNVG','QKTVE'),(87,87,69,78,0.238084,'AVVTGVTAVA',43.5443,'PNVGG','QKTVE'),(88,88,68,78,0.310715,'GAVVAGVTAVA',46.8443,'VTNVG','QKTVE'),(89,89,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(90,90,36,41,0.0600657,'GVLYVG',39.2382,'GKTKE','SKTKE'),(91,91,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(92,92,36,41,0.0600657,'GVLYVG',39.2382,'GKTKE','SKTKE'),(93,93,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(94,94,69,78,0.238084,'AVVTGVTAVA',43.6444,'TNVGG','QKTVE'),(95,95,69,78,0.238084,'AVVTGVTAVA',43.5463,'TNVGG','QKTVE'),(96,96,69,78,0.238084,'AVVTGVTAVA',43.5467,'TNVGG','QKTVE'),(97,97,69,78,0.238084,'AVVTGVTAVA',42.4148,'TNPGG','QKTVE'),(98,98,69,78,0.238084,'AVVTGVTAVA',42.7614,'TNSGG','QKTVE'),(99,99,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(100,100,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(101,105,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(102,102,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(103,103,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(104,104,36,41,0.0600657,'GVLYVG',39.2383,'GKTKE','SKTKE'),(105,105,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(106,106,36,41,0.0600657,'GVLYVG',39.0826,'GKTKE','SKTKE'),(107,107,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(108,108,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(109,109,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(110,110,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(111,111,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(112,112,68,78,0.21644,'GAVVTGVTAVA',40.5316,'VTNVG','QKTVE'),(113,113,81,88,0.509389,'SFYLLYYT',66.7869,'FSKDG','EFTPT'),(114,114,4,18,3.76765,'SVALAVLALLSLSGL',62.7633,'MSR','EAIQR'),(115,115,80,88,1.0923,'VSFYLLYYT',79.8381,'SFSKD','EFTPT'),(116,116,80,88,0.486577,'WSFYLLYYT',89.3618,'SFSKP','EFTPT'),(117,118,42,47,4.48968,'YMVYMF',64.5421,'FIDLN','QYDST'),(118,121,42,46,0.546074,'CWMLY',12.362,'RVESG','ERPNY'),(119,122,2,12,0.932201,'AFLGLFSLLVL',90.4007,'M','QSMAT'),(120,123,2,12,0.932201,'AFLGLFSLLVL',90.4007,'M','QSMAT'),(121,124,2,12,0.932201,'AFLGLFSLLVL',90.4024,'M','QSMAT'),(122,125,2,12,0.932201,'AFLGLFSLLVL',90.4022,'M','QSMAT'),(123,126,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(124,127,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(125,128,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(126,129,56,62,3.8853,'TFLVQLY',20.2029,'REDPE','QHCPP'),(127,130,25,29,0.0766896,'FVWQL',6.1931,'VGFRP','AQQLN'),(128,131,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(129,132,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(130,133,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(131,134,56,62,3.44548,'TFLVQLY',20.2855,'REDAE','QHCPP'),(132,135,56,62,3.37294,'TFLVQLY',20.3153,'REDPE','QHCAP'),(133,136,56,62,3.40799,'TFLVQLY',20.2903,'REDPE','QHCGP'),(134,137,56,62,3.87,'TFLVQLY',20.2221,'REDPE','QHCPA'),(135,138,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(136,139,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(137,140,56,62,3.8853,'TFLVQLY',20.2258,'REDPE','QHCPP'),(138,141,56,62,3.8853,'TFLVQLY',20.2854,'REDPE','QHCPP'),(139,142,56,62,3.50978,'TFLVQLY',20.4858,'REDPK','QHCPP'),(140,143,56,62,3.8853,'TFLVQLY',20.1076,'REDPE','QHCPP'),(141,144,93,97,1.09754,'TLVVL',81.2396,'EGFLD','HRAGA'),(142,145,93,97,1.09903,'TLVVL',81.2282,'EGFLD','HRAGA'),(143,146,93,97,1.09754,'TLVVL',81.2509,'EGFLD','HRAGA'),(144,147,93,97,1.09754,'TLVVL',81.2396,'EGFLD','HRAGA'),(145,148,93,97,1.09754,'TLVVL',81.3409,'EGFLD','HRAGA'),(146,149,93,97,1.09754,'TLVVL',81.2396,'EGFLD','HRAGA'),(147,150,93,97,1.09754,'TLVVL',81.2396,'EGFLD','HRAGA'),(148,151,93,97,0.652251,'TLVVL',81.4214,'EGFLD','HRAWA'),(149,152,93,97,1.09754,'TLVVL',81.1378,'EGFLD','HRAGA'),(150,153,93,97,0.373316,'TLVVL',36.1067,'EGFLD','HPAGA'),(151,154,93,97,1.09754,'TLVVL',81.2396,'EGFLD','HRAGA'),(152,155,93,97,1.09754,'TLVVL',81.2282,'EGFLD','HRAGA'),(153,157,90,97,0.60963,'FLFTLVVL',99.1557,'AAREG','HRAGA'),(154,158,90,98,2.85647,'FLDTLVVLR',36.9597,'AAREG','RAGAR'),(155,159,59,65,2.62331,'VAFLLLL',89.7108,'MGSAR','HGAEP'),(156,160,93,97,1.09754,'TLVVL',81.2396,'EGFLD','HRAGA'),(157,161,250,257,0.06848,'PILTIITL',77.4397,'GMNRR','EDSSG'),(158,162,250,257,0.06848,'PILTIITL',77.4411,'GMNRR','EDSSG'),(159,163,250,257,0.06848,'PILTIITL',77.4397,'GMNRR','EDSSG'),(160,164,251,257,0.0782629,'ILTIITL',87.2219,'MNQRP','EDSSG'),(161,165,251,257,0.0782707,'ILTIITL',67.1553,'MNRSP','EDSSG'),(162,166,250,257,0.06848,'PILTIITL',77.4411,'GMNRR','EDSSG'),(163,167,251,257,0.0782629,'ILTIITL',87.2227,'MNWRP','EDSSG'),(164,168,250,257,0.130103,'LILTIITL',98.6159,'GMNRR','EDSSG'),(165,169,251,258,0,'ILTIITLV',98.1919,'MNRRP','DSSGN'),(166,170,250,257,0.06848,'PILTIITL',77.4397,'GMNRR','EDSSG'),(167,171,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(168,172,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(169,173,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(170,174,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(171,175,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(172,176,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(173,177,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(174,178,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(175,179,321,329,1.16781,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(176,180,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(177,181,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(178,182,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(179,183,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(180,184,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(181,185,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(182,186,321,329,1.18031,'LATIYWFTV',88.7193,'EYIEK','EFGLC'),(183,187,321,329,1.1818,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(184,188,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(185,189,321,329,1.18031,'LATIYWFTV',88.7158,'EYIEK','EFGLC'),(186,190,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(187,191,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(188,192,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(189,193,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(190,194,321,329,1.18031,'LATIYWFTV',88.7175,'EYIEK','EFGLC'),(191,195,315,321,0.722012,'YLVLTLT',73.7532,'DNDKE','KNDLD'),(192,196,315,321,0.722012,'YLVLTLT',73.7329,'DNDKE','KNDLD'),(193,197,315,321,0.722012,'YLVLTLT',73.7329,'DNDKE','KNDLD'),(194,198,315,321,0.722012,'YLVLTLT',73.7532,'DNDKE','KNDLD'),(195,199,315,321,0.722012,'YLVLTLT',73.7532,'DNDKE','KNDLD'),(196,200,315,321,0.722012,'YLVLTLT',73.7532,'DNDKE','KNDLD'),(197,201,315,321,0.722012,'YLVLTLT',73.7329,'DNDKE','KNDLD'),(198,202,315,321,0.722012,'YLVLTLT',73.7329,'DNDKE','KNDLD'),(199,203,133,140,2.39703,'VMIYAYLL',87.9921,'KGRTG','HRGKF'),(200,204,315,321,0.722012,'YLVLTLT',73.7329,'DNDKE','KNDLD'),(201,205,315,321,0.722012,'YLVLTLT',73.7352,'DNDKE','KNDLD'),(202,206,315,321,0.722012,'YLVLTLT',73.7329,'DNDKE','KNDLD'),(203,207,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(204,208,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(205,209,64,78,5.05286,'ISLLAACISFVLAWF',95.7988,'DLLVR','EEGEE'),(206,210,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(207,211,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(208,212,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(209,213,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(210,214,64,78,30.2013,'ILLLAACISFVLAWF',98.1213,'DLLVR','EEGEE'),(211,215,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(212,216,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(213,217,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(214,218,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(215,219,64,78,30.2013,'ILLLAACISFVLAWF',98.1214,'DLLVR','EEGEE'),(216,220,5,9,0,'VVCVL',12.4665,'MATK','KGDGP'),(217,221,145,153,0.169783,'LACGVIGIA',8.90104,'NAGSR','Q'),(218,222,145,153,0.169783,'LACGVIGIA',8.84769,'NAGSR','Q'),(219,223,145,153,0.169783,'LACGVIGIA',8.90104,'NAGSR','Q'),(220,225,8,13,0.620686,'LVLALY',79.4544,'ETGKE','DYQEK'),(221,226,8,13,0.620686,'LVLALY',79.4544,'ETGKE','DYQEK'),(222,227,8,13,0.620686,'LVLALY',79.4552,'ETGKE','DYQEK'),(223,228,8,13,0.620686,'LVLALY',79.5253,'ETGKE','DYQEK');
/*!40000 ALTER TABLE `short_stretch` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-05-04 23:28:45