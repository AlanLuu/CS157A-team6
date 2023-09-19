CREATE SCHEMA tasku;
USE tasku;

CREATE TABLE `Users` (
  `UserId` integer NOT NULL AUTO_INCREMENT,
  `Username` varchar(255),
  `Email` varchar(255),
  `Password` integer,
  PRIMARY KEY (`UserId`)
);

CREATE TABLE `Courses` (
  `EntryId` integer NOT NULL AUTO_INCREMENT,
  `CourseId` varchar(255),
  `UserId` integer,
  `CourseName` varchar(255),
  `Schedule` varchar(255),
  PRIMARY KEY (`EntryId`)
);

CREATE TABLE `Tasks` (
  `TaskId` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `CourseId` varchar(255),
  `Title` varchar(255),
  `Description` text,
  `DueDate` varchar(255),
  `Priority` varchar(255),
  `Category` varchar(255),
  `Status` varchar(255),
  `AllocatedTime` integer,
  `CreationDate` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`TaskId`)
);

CREATE TABLE `SubTasks` (
  `SubTaskId` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `TaskId` integer,
  `SubTaskName` varchar(255),
  `SubTaskDescription` varchar(255),
  `SubTaskStatus` varchar(255),
  `AllocatedTime` integer,
  PRIMARY KEY (`SubTaskId`)
);

CREATE TABLE `Categories` (
  `CategoryID` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `TaskId` integer,
  `CategoryName` varchar(255),
  PRIMARY KEY (`CategoryID`)
);

CREATE TABLE `Reminders` (
  `ReminderId` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `TaskId` integer,
  `ReminderTitle` varchar(255),
  `DateAndTime` varchar(255),
  PRIMARY KEY (`ReminderId`)
);

CREATE TABLE `ProgressTracking` (
  `ProgressId` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `TaskId` integer,
  `SubTaskId` integer,
  `ProgressBar` integer,
  `LastUpdate` date,
  PRIMARY KEY (`ProgressId`)
);

CREATE TABLE `UserRewards` (
  `RewardId` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `RewardName` varchar(255),
  `RewardBadge` varchar(255),
  `RewardPoints` integer,
  `EarnedDate` date,
  PRIMARY KEY (`RewardId`)
);

CREATE TABLE `Calendar` (
  `CalendarId` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `TaskId` integer,
  `ReminderId` integer,
  `EventTitle` varchar(255),
  `DateAndTime` timestamp,
  `Description` varchar(255),
  PRIMARY KEY (`CalendarId`)
);

CREATE TABLE `ActivityLog` (
  `LogId` integer NOT NULL AUTO_INCREMENT,
  `UserId` integer,
  `ActivityType` varchar(255),
  `Timestamp` timestamp,
  PRIMARY KEY (`LogId`)
);

-- ALTER TABLE `Courses` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `Tasks` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `SubTasks` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `Categories` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `Reminders` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `ProgressTracking` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `UserRewards` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `Calendar` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `ActivityLog` ADD FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);

-- ALTER TABLE `SubTasks` ADD FOREIGN KEY (`TaskId`) REFERENCES `Tasks` (`TaskId`);

-- ALTER TABLE `Categories` ADD FOREIGN KEY (`TaskId`) REFERENCES `Tasks` (`TaskId`);

-- ALTER TABLE `Reminders` ADD FOREIGN KEY (`TaskId`) REFERENCES `Tasks` (`TaskId`);

-- ALTER TABLE `ProgressTracking` ADD FOREIGN KEY (`TaskId`) REFERENCES `Tasks` (`TaskId`);

-- ALTER TABLE `ProgressTracking` ADD FOREIGN KEY (`SubTaskId`) REFERENCES `SubTasks` (`SubTaskId`);

-- ALTER TABLE `Calendar` ADD FOREIGN KEY (`TaskId`) REFERENCES `Tasks` (`TaskId`);

-- ALTER TABLE `Calendar` ADD FOREIGN KEY (`ReminderId`) REFERENCES `Reminders` (`ReminderId`);

INSERT INTO tasku.tasks(UserId, CourseId, Title, description, DueDate, Priority, Category, Status, AllocatedTime) VALUES (1, 'CS 157A', 'Complete homework', 'Complete homework 1', '9/11/2023', 'High', 'Homework', 'Completed', 60);
