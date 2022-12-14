# CREATE DATABASE  IF NOT EXISTS `cs336project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `cs336project`;

DROP TABLE IF EXISTS `customer_service`;
DROP TABLE IF EXISTS `bid_history`;
DROP TABLE IF EXISTS `bids_on`;
DROP TABLE IF EXISTS `clothing`;
DROP TABLE IF EXISTS `wishlist`;
DROP TABLE IF EXISTS `alert`;
DROP TABLE IF EXISTS `user`;

-- Table structure for table `user`
CREATE TABLE `user` (
  `username` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `password` varchar(50) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `isCR` bit DEFAULT 0,
  PRIMARY KEY (`username`)
);


-- Dumping data for table `user`
INSERT INTO `user` VALUES
('testuser','John Doe','userpass','testuseraddress',0),
('testuser2','Jane Doe','userpass','testuseraddress',0),
('testuser3','Joe Smith','userpass','testuseraddress',0),
('admin','Adam Min', 'adminpass','adminaddress',1),
('crep','Chris Rep','creppass','crepaddress',1);
 
 
-- Table structure for table `clothing`
CREATE TABLE `clothing` (
  `seller` varchar(50) NOT NULL,
  `cid` int NOT NULL AUTO_INCREMENT,
  `type` ENUM('tops', 'jeans', 'shoes') NOT NULL,
  `size` int NOT NULL,
  `initial_price` float NOT NULL,
  `current_bid` float DEFAULT 0,
  `close_date` DATETIME NOT NULL,
  `increment` float NOT NULL,
  `minimum` float NOT NULL,
  `description` varchar(200) DEFAULT "No description available.",
  `is_available` bit DEFAULT 1,
  `current_bidder` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  CONSTRAINT FOREIGN KEY (`seller`) references `user` (`username`),
  CONSTRAINT FOREIGN KEY (`current_bidder`) references `user` (`username`)
); 


-- Dumping data for table `clothing`
INSERT INTO `clothing` VALUES
('testuser', 0, 'tops', 8, 3.00, default, '2022-10-31', 1.00, 10.00, "Orange top", 1, default),
('testuser', 0, 'jeans', 12, 7.50, default, '2022-07-07', 1.00, 15.00, default, 1, default),
('testuser', 0, 'jeans', 9, 4.00, default, '2022-05-28', 1.00, 12.00, "Grey jeans", 1, default),
('testuser', 0, 'shoes', 6, 8.00, default, '2022-11-26', 1.00, 20.00, "White sneakers", 1, default),

('testuser2', 0, 'tops', 8, 3.50, default, '2022-05-09', 1.00, 9.00, "Green polo", 1, default),
('testuser2', 0, 'tops', 9, 2.50, default, '2022-06-01', 1.00, 10.00, "Yellow vest", 1, default),
('testuser2', 0, 'jeans', 11, 6.00, default, '2022-06-06', 1.00, 18.50, "Blue jeans", 1, default),
('testuser2', 0, 'shoes', 9, 5.00, default, '2022-07-11', 1.00, 15.00, "Black boots", 1, default),
('testuser2', 0, 'shoes', 7, 4.50, default, '2022-05-15', 1.00, 12.50, "Red heels", 1, default);


-- Table structure for relationship tables 
-- `bids_on`, `bid_history`, `customer_service`
CREATE TABLE `bids_on`(
`buyer` varchar(50) NOT NULL,
`cid` int NOT NULL,
`maximum` float, 
PRIMARY KEY (`buyer`, `cid`), 
CONSTRAINT FOREIGN KEY (`buyer`) references `user` (`username`), 
CONSTRAINT FOREIGN KEY (`cid`) references `clothing` (`cid`)
);

CREATE TABLE `bid_history` (
`bidID` int NOT NULL AUTO_INCREMENT,
`user` varchar(50) NOT NULL,
`cid` int NOT NULL,
`amount` float NOT NULL,
`anon` bit DEFAULT 0,
PRIMARY KEY (`bidID`), 
CONSTRAINT FOREIGN KEY (`user`) references `user` (`username`), 
CONSTRAINT FOREIGN KEY (`cid`) references `clothing` (`cid`)
); 

CREATE TABLE `customer_service` (
`qid` int NOT NULL AUTO_INCREMENT,
`user` varchar(50) NOT NULL,
`question` varchar(100) NOT NULL,
`answer` varchar(100),
PRIMARY KEY (`qid`)
);

CREATE TABLE `wishlist` (
`user` varchar(50) NOT NULL,
`type` ENUM('tops', 'jeans', 'shoes') NOT NULL,
`size` int NOT NULL,
CONSTRAINT FOREIGN KEY (`user`) references `user` (`username`), 
PRIMARY KEY (`user`, `type`, `size`)
);

CREATE TABLE `alert` (
`user` varchar(50) NOT NULL,
`description` varchar(100) NOT NULL,
CONSTRAINT FOREIGN KEY (`user`) references `user` (`username`), 
PRIMARY KEY (`user`, `description`)
);
