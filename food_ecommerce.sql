-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 27, 2022 at 07:53 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `food_ecommerce`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCheapest` ()   BEGIN

declare name varchar(50);
declare id varchar(50);
declare f_cost int;
declare counter int default 0;
DECLARE done INT DEFAULT FALSE;

DECLARE c CURSOR FOR SELECT food_items.food_name, food_items.cost FROM food_items ORDER BY food_items.cost ASC LIMIT 5;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;

open c;

read_loop: LOOP
    FETCH c into name, f_cost;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SELECT name, f_cost;
  END LOOP;


close c;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prod_details` (IN `fid` VARCHAR(25), OUT `food_stock` INT(5))   BEGIN
	SELECT stock into food_stock
    FROM food_items 
    WHERE food_id = fid;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `totalProducts` (`rid` VARCHAR(255)) RETURNS INT(11)  BEGIN
	DECLARE total INT(11);
	select COUNT(*) into total
    from food_items
	where restaurant_id=rid;
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` varchar(7) NOT NULL,
  `coupon_code` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `coupon_code`) VALUES
('C002', NULL),
('C003', NULL),
('C004', 'BIGTREAT'),
('C006', 'BIGTREAT'),
('C001', 'SPOOKY15'),
('C005', 'SPOOKY15');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `quantity_chosen` int(2) NOT NULL,
  `date_added` date NOT NULL,
  `cart_id` varchar(7) NOT NULL,
  `food_id` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`quantity_chosen`, `date_added`, `cart_id`, `food_id`) VALUES
(2, '2022-11-15', 'C002', 'F004'),
(3, '2022-11-15', 'C002', 'F005'),
(2, '2022-11-26', 'C003', 'F012'),
(1, '2022-11-26', 'C003', 'F013'),
(2, '2022-11-16', 'C004', 'F006'),
(2, '2022-11-15', 'C004', 'F007'),
(3, '2022-11-16', 'C004', 'F008'),
(1, '2022-11-18', 'C004', 'F009');

-- --------------------------------------------------------

--
-- Table structure for table `coupon`
--

CREATE TABLE `coupon` (
  `coupon_code` varchar(10) NOT NULL,
  `discount` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `coupon`
--

INSERT INTO `coupon` (`coupon_code`, `discount`) VALUES
('BIGTREAT', 10),
('SPOOKY15', 15);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` varchar(6) NOT NULL,
  `customer_password` varchar(10) NOT NULL,
  `customer_name` varchar(20) NOT NULL,
  `customer_address` varchar(20) NOT NULL,
  `pincode` varchar(6) NOT NULL,
  `phone_no` varchar(10) NOT NULL,
  `cart_id` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `customer_password`, `customer_name`, `customer_address`, `pincode`, `phone_no`, `cart_id`) VALUES
('CUS001', 'a', 'amogh', 'abcd', '560098', '1122334455', 'C001'),
('CUS002', 'b', 'bhuvan', 'abde', '560062', '1144772255', 'C002'),
('CUS003', 'c', 'chitanya', 'lmno', '560062', '3366445588', 'C003'),
('CUS004', 'd', 'dhanush', 'wxyz', '560098', '5522441199', 'C004'),
('CUS005', 'e', 'esha', 'klmn', '560059', '8844991133', 'C005');

-- --------------------------------------------------------

--
-- Table structure for table `food_items`
--

CREATE TABLE `food_items` (
  `food_id` varchar(7) NOT NULL,
  `food_name` varchar(30) NOT NULL,
  `category` varchar(15) NOT NULL,
  `serves` int(2) NOT NULL,
  `cost` int(5) NOT NULL,
  `stock` int(3) NOT NULL,
  `restaurant_id` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_items`
--

INSERT INTO `food_items` (`food_id`, `food_name`, `category`, `serves`, `cost`, `stock`, `restaurant_id`) VALUES
('F001', 'Gobi Manchuri', 'Starters', 2, 220, 35, 'RS001'),
('F002', 'Fried Rice', 'Rice', 2, 190, 30, 'RS001'),
('F003', 'Paani Puri', 'Chats', 1, 50, 25, 'RS001'),
('F004', 'Mexican Cheese Rice', 'Rice', 2, 335, 30, 'RS002'),
('F005', 'Pomodoro Soup', 'Soup', 1, 150, 45, 'RS002'),
('F006', 'Soya Taka Tak', 'Chats', 2, 120, 30, 'RS003'),
('F007', 'Cream Of Tomato', 'Soup', 1, 160, 35, 'RS003'),
('F008', 'Curd Rice', 'Rice', 2, 90, 55, 'RS003'),
('F009', 'Paneer Fried Rice', 'Rice', 2, 200, 15, 'RS003'),
('F011', 'Gobi Manchuri', 'Starters', 2, 150, 30, 'RS003'),
('F012', 'Roti', 'Indian Bread', 1, 60, 35, 'RS004'),
('F013', 'Aloo Paratha', 'Indian Bread', 1, 90, 20, 'RS004');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `payment_id` varchar(7) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_type` varchar(10) NOT NULL,
  `customer_id` varchar(6) NOT NULL,
  `cart_id` varchar(7) NOT NULL,
  `amount` decimal(6,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`payment_id`, `payment_date`, `payment_type`, `customer_id`, `cart_id`, `amount`) VALUES
('P001', '2022-11-26', 'GPay', 'CUS001', 'C001', '621'),
('P002', '2022-11-18', 'Card', 'CUS002', 'C002', '927'),
('P005', '2022-11-18', 'PhonePe', 'CUS005', 'C005', '785');

--
-- Triggers `payment`
--
DELIMITER $$
CREATE TRIGGER `clear_cart_after_payment` AFTER INSERT ON `payment` FOR EACH ROW BEGIN
	DELETE FROM cart_items WHERE cart_id = NEW.cart_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `restaurant`
--

CREATE TABLE `restaurant` (
  `restaurant_id` varchar(6) NOT NULL,
  `restaurant_password` varchar(10) NOT NULL,
  `restaurant_name` varchar(20) NOT NULL,
  `restaurant_address` varchar(20) NOT NULL,
  `pincode` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `restaurant`
--

INSERT INTO `restaurant` (`restaurant_id`, `restaurant_password`, `restaurant_name`, `restaurant_address`, `pincode`) VALUES
('RS001', 'p', 'Paakshala', 'efgh', '560098'),
('RS002', 'a', 'Ambrosia', 'hijk', '560098'),
('RS003', 'b', 'Barbeque Nation', 'qwer', '560062'),
('RS004', 'n', '1947', 'abcd', '560062');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_phone_no`
--

CREATE TABLE `restaurant_phone_no` (
  `phone_no` varchar(10) NOT NULL,
  `restaurant_id` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `restaurant_phone_no`
--

INSERT INTO `restaurant_phone_no` (`phone_no`, `restaurant_id`) VALUES
('1234789650', 'RS001'),
('2255698745', 'RS003'),
('5478963254', 'RS002'),
('8520147963', 'RS001'),
('8899765432', 'RS002');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `coupon_code` (`coupon_code`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`cart_id`,`food_id`),
  ADD KEY `food_id` (`food_id`);

--
-- Indexes for table `coupon`
--
ALTER TABLE `coupon`
  ADD PRIMARY KEY (`coupon_code`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `cart_id` (`cart_id`);

--
-- Indexes for table `food_items`
--
ALTER TABLE `food_items`
  ADD PRIMARY KEY (`food_id`),
  ADD KEY `restaurant_id` (`restaurant_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `cart_id` (`cart_id`);

--
-- Indexes for table `restaurant`
--
ALTER TABLE `restaurant`
  ADD PRIMARY KEY (`restaurant_id`);

--
-- Indexes for table `restaurant_phone_no`
--
ALTER TABLE `restaurant_phone_no`
  ADD PRIMARY KEY (`phone_no`,`restaurant_id`),
  ADD KEY `restaurant_id` (`restaurant_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`coupon_code`) REFERENCES `coupon` (`coupon_code`);

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`),
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`food_id`) REFERENCES `food_items` (`food_id`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`);

--
-- Constraints for table `food_items`
--
ALTER TABLE `food_items`
  ADD CONSTRAINT `food_items_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`) ON DELETE SET NULL;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`);

--
-- Constraints for table `restaurant_phone_no`
--
ALTER TABLE `restaurant_phone_no`
  ADD CONSTRAINT `restaurant_phone_no_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
