-- MySQL dump 10.13  Distrib 8.2.0, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: tasku
-- ------------------------------------------------------
-- Server version	8.2.0

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
-- Table structure for table `activities`
--

CREATE DATABASE IF NOT EXISTS tasku;
USE tasku;

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activities` (
                              `ActivityID` int NOT NULL AUTO_INCREMENT,
                              `UserID` int DEFAULT NULL,
                              `Activity` varchar(255) DEFAULT NULL,
                              `ActivityDate` varchar(255) DEFAULT NULL,
                              PRIMARY KEY (`ActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (1,1,'Created task CS 157A final exam','2023-11-30 11:04:16'),(2,1,'Created task CS 157A project presentation','2023-11-30 11:06:12'),(3,1,'Created task A task','2023-11-30 11:06:48'),(4,1,'Created task Medium priority task','2023-11-30 11:08:18'),(5,1,'Created task Complete task','2023-11-30 11:09:15'),(6,1,'Completed task Complete task','2023-11-30 11:09:30'),(7,1,'Deleted task Medium priority task','2023-11-30 12:46:06'),(8,1,'Deleted task A task','2023-11-30 12:46:09'),(9,1,'Deleted task CS 157A project presentation','2023-11-30 12:46:11'),(10,1,'Deleted task CS 157A final exam','2023-11-30 12:46:13'),(11,1,'Created task CS 157A final exam','2023-11-30 12:48:04'),(12,1,'Deleted task Complete task','2023-11-30 12:55:32'),(13,1,'Completed task CS 157A final exam','2023-11-30 13:00:50'),(14,1,'Deleted task CS 157A final exam','2023-11-30 13:01:05'),(15,1,'Created task CS 157A final exam','2023-11-30 13:57:07'),(16,1,'Created task cs 151 final exam','2023-11-30 16:28:37'),(17,1,'Created task Medium priority task','2023-11-30 16:30:23'),(18,1,'Created task A task name','2023-11-30 16:30:43'),(19,1,'Created task CS157 Hw 6','2023-11-30 16:56:08'),(20,1,'Completed task Medium priority task','2023-11-30 16:58:38'),(21,1,'Deleted task CS157 Hw 6','2023-11-30 16:59:46'),(22,1,'Created task FSDJDK','2023-11-30 17:03:37'),(23,1,'Completed task CS 157A final exam','2023-12-09 23:39:10'),(24,1,'Completed task cs 151 final exam','2023-12-09 23:39:16'),(25,1,'Completed task A task name','2023-12-09 23:39:24'),(26,1,'Completed task FSDJDK','2023-12-09 23:39:29'),(27,1,'Created task CS 131 Final Exam','2023-12-09 23:40:55'),(28,1,'Created task Task A','2023-12-09 23:41:19'),(29,1,'Created task Task B','2023-12-09 23:41:33'),(30,1,'Created task Task C','2023-12-09 23:43:55'),(31,1,'Created task Task D','2023-12-09 23:44:15'),(32,1,'Created task Task E','2023-12-09 23:44:30'),(33,1,'Created task Task F','2023-12-09 23:44:51'),(34,3,'Created task Finish CS 157A Project','2023-12-09 23:45:50'),(35,3,'Created task CS 157A Homework','2023-12-09 23:47:50'),(36,3,'Completed task CS 157A Homework','2023-12-09 23:47:54'),(37,3,'Created task Task A','2023-12-09 23:48:22'),(38,1,'Completed task Task D','2023-12-09 23:57:22'),(39,1,'Completed task Task E','2023-12-09 23:57:22'),(40,1,'Completed task Task C','2023-12-09 23:57:22'),(41,1,'Completed task Task B','2023-12-09 23:57:22'),(42,1,'Completed task Task F','2023-12-09 23:57:22'),(43,1,'Completed task CS 131 Final Exam','2023-12-09 23:57:22'),(44,1,'Completed task Task A','2023-12-09 23:57:22'),(45,1,'Created task test','2023-12-10 08:01:51'),(46,1,'Created task Test 2','2023-12-10 08:05:05'),(47,17,'Created task CS 157A Final Project','2023-12-10 11:10:10'),(48,17,'Completed task CS 157A Final Project','2023-12-10 11:23:45'),(49,17,'Deleted task CS 157A Final Project','2023-12-10 13:00:48'),(50,17,'Created task CS 157A Final Project','2023-12-10 13:02:19'),(51,17,'Created task test','2023-12-10 15:09:12'),(52,17,'Created task test 2','2023-12-10 15:10:00'),(53,1,'Created task test123','2023-12-10 15:23:42'),(54,1,'Created task math 39 task','2023-12-10 15:28:31'),(55,1,'Created task cs 157a task','2023-12-10 15:29:20'),(56,1,'Created task cs 131 task','2023-12-10 15:29:52');
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
                              `CategoryID` int NOT NULL AUTO_INCREMENT,
                              `UserId` int DEFAULT NULL,
                              `CategoryName` varchar(255) DEFAULT NULL,
                              PRIMARY KEY (`CategoryID`),
                              KEY `UserId` (`UserId`),
                              CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,1,'Finals'),(2,1,'Homework'),(3,1,'Projects'),(4,1,'Personal Goals'),(5,1,'Health and Fitness'),(6,1,'Sports'),(7,1,'Finances'),(8,1,'Reading List'),(9,1,'Hobbies and Interests'),(10,1,'Daily Routine'),(11,1,'Volunteer Work'),(12,1,'Creative Projects'),(13,1,'Self-Care'),(14,1,'Learning and Development'),(15,1,'General Responsibilities'),(17,17,'Projects');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
                           `CourseID` int NOT NULL AUTO_INCREMENT,
                           `UserID` int DEFAULT NULL,
                           `CourseName` varchar(255) DEFAULT NULL,
                           PRIMARY KEY (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,1,'CS 157A'),(2,1,'CS 171'),(3,1,'CS 131'),(4,1,'CS 147'),(5,1,'CS 151'),(11,1,'CS 158'),(12,1,'PHIL 134'),(13,1,'MATH 30'),(14,1,'MATH 31'),(15,1,'MATH 39'),(16,1,'MATH 42'),(17,1,'MATH 161A'),(18,1,'CS 46A'),(19,1,'CS 46B'),(20,1,'CS 47'),(21,3,'CS 157A'),(22,17,'CS 157A');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reminders`
--

DROP TABLE IF EXISTS `reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reminders` (
                             `ReminderID` int NOT NULL AUTO_INCREMENT,
                             `TaskID` int NOT NULL,
                             `SetTime` datetime DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`ReminderID`),
                             KEY `TaskID` (`TaskID`),
                             CONSTRAINT `reminders_ibfk_1` FOREIGN KEY (`TaskID`) REFERENCES `tasks` (`TaskID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reminders`
--

LOCK TABLES `reminders` WRITE;
/*!40000 ALTER TABLE `reminders` DISABLE KEYS */;
INSERT INTO `reminders` VALUES (2,15,'2023-11-30 13:57:50'),(3,16,'2023-11-30 17:00:59'),(4,17,'2023-12-09 23:58:58'),(12,18,'2023-12-09 23:58:58'),(13,20,'2023-12-09 23:58:58'),(14,21,'2023-12-09 23:58:58'),(15,22,'2023-12-09 23:58:58'),(16,23,'2023-12-09 23:58:58'),(17,24,'2023-12-09 23:58:58'),(18,25,'2023-12-09 23:58:58'),(19,26,'2023-12-09 23:58:58'),(20,27,'2023-12-09 23:58:58'),(21,28,'2023-12-09 23:58:58'),(22,29,'2023-12-09 23:58:58'),(23,30,'2023-12-09 23:58:58');
/*!40000 ALTER TABLE `reminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rewarddescs`
--

DROP TABLE IF EXISTS `rewarddescs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rewarddescs` (
                               `RewardID` int NOT NULL AUTO_INCREMENT,
                               `RewardName` varchar(255) NOT NULL,
                               `RewardDesc` varchar(255) NOT NULL,
                               PRIMARY KEY (`RewardID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rewarddescs`
--

LOCK TABLES `rewarddescs` WRITE;
/*!40000 ALTER TABLE `rewarddescs` DISABLE KEYS */;
INSERT INTO `rewarddescs` VALUES (1,'Task Initiate','Complete your first task and become a Task Initiate.'),(2,'Frequent Finisher','Reach the milestone of 5 completed tasks and earn the title of Frequent Finisher'),(3,'Task Tackler','Tackle and triumph over 10 tasks to achieve Task Tackler status.'),(4,'Productivity Pioneer','Blaze a path to success by completing 15 tasks and become a Productivity Pioneer.'),(5,'Task Dynamo','Power through 20 tasks and unleash your dynamism as a Task Dynamo'),(6,'Efficiency Expert','Master the art of efficiency with 25 completed tasks and be recognized as an Efficiency Expert'),(7,'Task Maestro','Conduct your symphony of productivity with 30 tasks completed and earn the title of Task Maestro.'),(8,'Task Connoisseur','Refine your task-handling skills by completing 35 tasks and become a Task Connoisseur.'),(9,'Mighty Taskmaster','Command and conquer your to-do list with 40 completed tasks and become a Mighty Taskmaster.'),(10,'Task Dynamo Elite','Reach the impressive milestone of 45 completed tasks and ascend to Task Dynamo Elite.'),(11,'Task Legend','Achieve legendary status by completing 50 tasks and earn the coveted title of Task Legend.'),(12,'Task Virtuoso','Showcase your virtuosity in task management by reaching 55 completed tasks.'),(13,'Task Dominator','Dominate your to-do list with 60 completed tasks and claim the title of Task Dominator.'),(14,'Task Trailblazer Supreme','Elevate your trailblazing skills with 65 completed tasks and become a Task Trailblazer Supreme.'),(15,'Task Grandmaster','Attain mastery over your tasks by completing 70 tasks, and be recognized as a Task Grandmaster.');
/*!40000 ALTER TABLE `rewarddescs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rewardpoints`
--

DROP TABLE IF EXISTS `rewardpoints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rewardpoints` (
                                `RewardID` int NOT NULL AUTO_INCREMENT,
                                `RewardPoints` int NOT NULL,
                                `NumTasks` int NOT NULL,
                                PRIMARY KEY (`RewardID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rewardpoints`
--

LOCK TABLES `rewardpoints` WRITE;
/*!40000 ALTER TABLE `rewardpoints` DISABLE KEYS */;
INSERT INTO `rewardpoints` VALUES (1,10,1),(2,10,5),(3,20,10),(4,20,15),(5,30,20),(6,30,25),(7,40,30),(8,40,35),(9,50,40),(10,50,45),(11,60,50),(12,60,55),(13,70,60),(14,70,65),(15,80,70);
/*!40000 ALTER TABLE `rewardpoints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subtasks`
--

DROP TABLE IF EXISTS `subtasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subtasks` (
                            `SubTaskId` int NOT NULL AUTO_INCREMENT,
                            `UserId` int DEFAULT NULL,
                            `TaskId` int DEFAULT NULL,
                            `SubTaskName` varchar(255) DEFAULT NULL,
                            `SubTaskDescription` varchar(255) DEFAULT NULL,
                            `SubTaskDueDate` varchar(255) DEFAULT NULL,
                            `SubTaskStatus` varchar(255) DEFAULT NULL,
                            `AllocatedTime` varchar(255) DEFAULT NULL,
                            PRIMARY KEY (`SubTaskId`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subtasks`
--

LOCK TABLES `subtasks` WRITE;
/*!40000 ALTER TABLE `subtasks` DISABLE KEYS */;
INSERT INTO `subtasks` VALUES (1,1,9,'Study functional dependencies','Study functional dependencies','2023-12-08','Not Started',NULL),(2,1,15,'Functional dependencies','Study functional dependencies','2023-12-08','Completed',NULL),(3,1,17,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(4,1,17,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(5,1,21,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(6,1,21,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(7,1,21,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(8,1,22,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(9,1,22,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(10,1,22,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(11,1,17,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(12,1,17,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(13,1,17,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(14,1,17,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(15,1,17,'Subtask 1','it is a subtask','2023-12-06','Completed',NULL),(16,17,33,'157A Final Project Paper','Complete 157A Final Project Paper','2023-12-10','Completed',NULL);
/*!40000 ALTER TABLE `subtasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
                         `TaskID` int NOT NULL AUTO_INCREMENT,
                         `UserID` int DEFAULT NULL,
                         `Title` varchar(255) DEFAULT NULL,
                         `Description` varchar(255) DEFAULT NULL,
                         `DueDate` varchar(255) DEFAULT NULL,
                         `Priority` varchar(255) DEFAULT NULL,
                         `Course` varchar(255) DEFAULT NULL,
                         `Category` varchar(255) DEFAULT NULL,
                         `Status` varchar(255) DEFAULT NULL,
                         PRIMARY KEY (`TaskID`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (15,1,'CS 157A final exam','Study for CS 157A final exam','2023-12-08','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Completed'),(16,1,'cs 151 final exam','Study for cs 151 final exam','2023-12-11','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Completed'),(17,1,'Medium priority task','Medium priority task','2023-12-08','Medium','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nHomework','Completed'),(18,1,'A task name','A task','2023-12-08','Medium','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Completed'),(20,1,'FSDJDK','','2023-11-30','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nSports','Completed'),(21,1,'CS 131 Final Exam','Study for CS 131 Final Exam','2023-12-11','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Completed'),(22,1,'Task A','','2023-12-13','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nHomework','Completed'),(23,1,'Task B','','2023-12-13','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nHomework','Completed'),(24,1,'Task C','','2023-12-11','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Completed'),(25,1,'Task D','','2023-12-12','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nHomework','Completed'),(26,1,'Task E','','2023-12-12','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nHomework','Completed'),(27,1,'Task F','','2023-12-12','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Completed'),(28,3,'Finish CS 157A Project','Finish CS 157A Project','2023-12-10','High',NULL,NULL,'In Progress'),(29,3,'CS 157A Homework','CS 157A Homework','2023-12-10','Medium','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A',NULL,'Completed'),(30,3,'Task A','Task A','2023-12-12','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A',NULL,'In Progress'),(31,1,'test','test','2023-12-11','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Not Started'),(32,1,'Test 2','Test 2','2023-12-11','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Not Started'),(34,17,'CS 157A Final Project','Turn in CS 157A Final Project','2023-12-10','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nProjects','Completed'),(35,17,'test','test','2023-12-10','High','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nProjects','Not Started'),(36,17,'test 2','test 2','2023-12-10','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nProjects','Not Started'),(37,1,'math 31 task','math 31 task','2023-12-10','Low','MATH 31','Homework','In Progress'),(38,1,'math 39 task','math 39 task','2023-12-10','Low','MATH 39','Projects','Not Started'),(39,1,'cs 157a task','cs 157a task','2023-12-10','Low','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nCS 157A','Homework','Not Started'),(40,1,'cs 131 task','cs 131 task','2023-12-10','Low','CS 131','\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nFinals','Not Started');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
/*!50032 DROP TRIGGER IF EXISTS after_task_insert */;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_task_insert` AFTER INSERT ON `tasks` FOR EACH ROW INSERT INTO activities (UserId, Activity, ActivityDate)
VALUES (NEW.UserID, CONCAT('Created task ', (NEW.Title)), CURRENT_TIMESTAMP()) */;;
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
/*!50032 DROP TRIGGER IF EXISTS after_task_complete */;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_task_complete` AFTER UPDATE ON `tasks` FOR EACH ROW BEGIN
	IF NEW.status = 'Completed' AND OLD.status <> 'Completed' THEN
		INSERT INTO activities (UserId, Activity, ActivityDate)
		VALUES (OLD.UserID, CONCAT('Completed task ', (OLD.Title)), CURRENT_TIMESTAMP());
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
/*!50032 DROP TRIGGER IF EXISTS after_task_delete */;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_task_delete` AFTER DELETE ON `tasks` FOR EACH ROW INSERT INTO activities (UserId, Activity, ActivityDate)
VALUES (OLD.UserID, CONCAT('Deleted task ', (OLD.Title)), CURRENT_TIMESTAMP()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `userrewards`
--

DROP TABLE IF EXISTS `userrewards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userrewards` (
                               `UserID` int NOT NULL,
                               `RewardID` int NOT NULL,
                               PRIMARY KEY (`UserID`,`RewardID`),
                               KEY `userrewards_ibfk_2` (`RewardID`),
                               CONSTRAINT `userrewards_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE,
                               CONSTRAINT `userrewards_ibfk_2` FOREIGN KEY (`RewardID`) REFERENCES `rewarddescs` (`RewardID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userrewards`
--

LOCK TABLES `userrewards` WRITE;
/*!40000 ALTER TABLE `userrewards` DISABLE KEYS */;
INSERT INTO `userrewards` VALUES (1,1),(3,1),(17,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14);
/*!40000 ALTER TABLE `userrewards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
                         `UserID` int NOT NULL AUTO_INCREMENT,
                         `Name` varchar(255) DEFAULT NULL,
                         `Email` varchar(255) NOT NULL,
                         `Password` varchar(255) NOT NULL,
                         PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Alan Luu','alan.luu@sjsu.edu','password123'),(3,'A Smith','a@a.com','password123'),(4,'B Smith','b@b.com','password123'),(5,'C Smith','c@c.com','password123'),(6,'D Smith','d@d.com','password123'),(7,'E Smith','e@e.com','password123'),(8,'F Smith','f@f.com','password123'),(9,'G Smith','g@g.com','password123'),(10,'H Smith','h@h.com','password123'),(11,'I Smith','i@i.com','password123'),(12,'J Smith','j@j.com','password123'),(13,'K Smith','k@k.com','password123'),(14,'L Smith','l@l.com','password123'),(15,'M Smith','m@m.com','password123'),(16,'N Smith','n@n.com','password123'),(17,'Test Student','test@test.com','password123');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-10 15:34:19
