-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 25, 2022 at 10:21 PM
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
-- Database: `qrcode`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `ID` int(4) NOT NULL,
  `cust_name` varchar(400) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(15) NOT NULL,
  `phone` varchar(12) NOT NULL,
  `address` varchar(100) NOT NULL,
  `photo` varchar(1000) NOT NULL,
  `balance` int(22) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`ID`, `cust_name`, `email`, `password`, `phone`, `address`, `photo`, `balance`) VALUES
(1, 'Bari Kanubari', 'bari_2012@gmail.com', '111111', '09085645343', '70 Ikono rd, Ikot Ekpene', 'uploads/image_picker7972632195675544877.jpg', 9000),
(2, 'Inemesit Walter', 'newleastpaysolution@gmail.com', 'escobar2012', '08099088753', 'Nto Idem rd', 'uploads/passport.jpg', 517200);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `ID` int(4) NOT NULL,
  `paymentID` varchar(20) NOT NULL,
  `owner_username` varchar(33) NOT NULL,
  `customer_email` varchar(90) NOT NULL,
  `restuarant` varchar(300) NOT NULL,
  `amount` varchar(15) NOT NULL,
  `date_payment` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`ID`, `paymentID`, `owner_username`, `customer_email`, `restuarant`, `amount`, `date_payment`) VALUES
(4, '83902', 'walterjnr1', 'newleastpaysolution@gmail.com', 'Mma Ufiob foods', '3400', '2022-09-24'),
(5, '36458', 'walterjnr1', 'newleastpaysolution@gmail.com', 'Mma Ufiob foods', '10700 ', '2022-10-24'),
(6, '24335', 'udemy', 'newleastpaysolution@gmail.com', 'Panuku Eatery', '5600', '9/09/2022'),
(7, '90904', 'udemy', 'bari_2012@gmail.com', 'Panuku Eatery', '26000', '09/09/2022'),
(8, '42323', 'walterjnr1', 'bari_2012@gmail.com', 'Mma Ufiob foods', '1200', '12/2/2022'),
(9, '45343', 'walterjnr1', 'newleastpaysolution@gmail.com', 'Mma Ufiob Foods', '26000', '09/09/2022'),
(11, '84071', 'walterjnr1', 'newleastpaysolution@gmail.com', 'Mma Ufiob foods', ' 10700 ', '2022-10-25'),
(12, '13224', 'walterjnr1 ', 'newleastpaysolution@gmail.com', 'Panuku Eatery', ' 10700 ', '2022-10-25');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `ID` int(3) NOT NULL,
  `product_no` varchar(7) NOT NULL,
  `username` varchar(15) NOT NULL,
  `product_name` varchar(500) NOT NULL,
  `amount` int(20) NOT NULL,
  `photo` varchar(1600) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`ID`, `product_no`, `username`, `product_name`, `amount`, `photo`) VALUES
(6, '5908', 'walterjnr1', 'Fried Rice', 3500, 'uploads/image_picker1153734753903672985.jpg'),
(7, '9711', 'walterjnr1', 'Table Water', 800, 'uploads/image_picker1772573550765299559.jpg'),
(8, '5807', 'walterjnr1', 'Can Coke', 250, 'uploads/image_picker3765154500143260181.jpg'),
(9, '7869', 'walterjnr1', 'Biscuits', 250, 'uploads/image_picker3325422444105319201.jpg'),
(10, '9188', 'walterjnr1', 'Big Brother Bread', 1200, 'uploads/image_picker9095479021996994606.jpg'),
(11, '1211', 'walterjnr1', 'Chin Chin', 120, 'uploads/chin chin.jpg'),
(12, '9751', 'walterjnr1', 'Afang soup', 1900, 'uploads/image_picker119240632202358886.jpg'),
(13, '3961', 'walterjnr1', 'Cake', 4500, 'uploads/cake.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(4) NOT NULL,
  `company_name` varchar(150) NOT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `phone` varchar(12) NOT NULL,
  `address` varchar(60) NOT NULL,
  `photo` varchar(1000) NOT NULL,
  `balance` int(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`ID`, `company_name`, `username`, `password`, `fullname`, `phone`, `address`, `photo`, `balance`) VALUES
(27, 'Mma Ufiob foods', 'walterjnr1', 'escobar2012', 'Ndueso Walter', '08067361023', '2 Uyo rd, Ikot Ekpene', 'uploads/image_picker974870824315647526.jpg', 32100),
(28, 'Udemobong carteen', 'udemy', '11111111', 'Udeme Solomon', '08067361023', '56 Aba Rd, Calabar', 'uploads/image_picker4913120785245560408.jpg', 1200);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `ID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `ID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `ID` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
