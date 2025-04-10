-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 10, 2025 at 04:25 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tapsndrc_db1`
--

-- --------------------------------------------------------

--
-- Table structure for table `batches`
--

CREATE TABLE `batches` (
  `id` int(11) NOT NULL,
  `batch_id` varchar(50) NOT NULL,
  `status` enum('pending','processing','completed','failed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL,
  `fulfiller_id` int(11) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `total_tickets` int(11) DEFAULT 0,
  `completed_tickets` int(11) DEFAULT 0,
  `batch_amount` decimal(10,2) DEFAULT 0.00,
  `processing_started_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `batch_tickets`
--

CREATE TABLE `batch_tickets` (
  `id` int(11) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `assigned_at` timestamp NULL DEFAULT current_timestamp(),
  `completed_at` timestamp NULL DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT 0.00,
  `processing_time` int(11) DEFAULT 0,
  `error_count` int(11) DEFAULT 0,
  `last_error` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `batch_tickets`
--
DELIMITER $$
CREATE TRIGGER `after_batch_ticket_update` AFTER UPDATE ON `batch_tickets` FOR EACH ROW BEGIN
    IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
        UPDATE batches 
        SET completed_tickets = completed_tickets + 1
        WHERE id = NEW.batch_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bot_settings`
--

CREATE TABLE `bot_settings` (
  `id` int(11) NOT NULL,
  `validation_group_id` varchar(255) DEFAULT NULL,
  `notification_group_id` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `bot_settings`
--

INSERT INTO `bot_settings` (`id`, `validation_group_id`, `notification_group_id`, `updated_at`) VALUES
(1, NULL, NULL, '2025-03-08 04:09:15');

-- --------------------------------------------------------

--
-- Table structure for table `completion_images`
--

CREATE TABLE `completion_images` (
  `id` int(11) NOT NULL,
  `form_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crypto_transactions`
--

CREATE TABLE `crypto_transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `reference_id` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `wallet_id` int(11) NOT NULL,
  `status` enum('pending','completed','failed') NOT NULL,
  `user_id_from` int(11) NOT NULL,
  `user_id_to` int(11) NOT NULL,
  `address_from` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `transaction_hash` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `address_to` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `token_type` enum('USDT','BTC','ETH') NOT NULL,
  `transaction_type` enum('credit','debit','deposit','withdraw') NOT NULL,
  `gas_fee` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `crypto_transactions`
--

INSERT INTO `crypto_transactions` (`id`, `user_id`, `amount`, `description`, `reference_id`, `created_at`, `wallet_id`, `status`, `user_id_from`, `user_id_to`, `address_from`, `transaction_hash`, `address_to`, `token_type`, `transaction_type`, `gas_fee`) VALUES
(35, 18, 1.00, 'Deposit from client\'s wallet to fulfiller\'s wallet', 'DEP-1743920488343-553tlfve8', '2025-04-06 06:21:28', 11, 'pending', 18, 0, '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'deposit', 0.00),
(36, 18, 12.00, 'Withdrawal from wallet', 'WD-1743921260309-otsar3sqt', '2025-04-06 06:34:20', 11, 'pending', 0, 0, '', '', '', 'USDT', 'credit', 0.00),
(37, 18, 23.00, 'Withdrawal from wallet', 'WD-1743921526886-x9zsu4k6d', '2025-04-06 06:38:46', 11, 'pending', 0, 0, '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', 'deposit', 0.00),
(38, 18, 1.00, 'Deposit from client\'s wallet to fulfiller\'s wallet', 'DEP-1744058013694-1efrjmg33', '2025-04-07 20:33:33', 11, 'pending', 18, 0, '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'deposit', 0.00),
(39, 18, 1.00, 'Deposit from client\'s wallet to fulfiller\'s wallet', 'DEP-1744058516590-33f6k7f55', '2025-04-07 20:41:56', 11, 'pending', 18, 0, '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', '', '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', 'USDT', 'deposit', 0.00),
(56, 18, 13.00, 'Deposit from client\'s wallet to admin\'s wallet', 'DEP-1744103938391-3lct38o0y', '2025-04-08 09:18:58', 11, 'pending', 18, 21, '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', '', '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', 'USDT', 'deposit', 0.00),
(57, 18, 10.00, 'Withdrawal from wallet', 'WD-1744104994578-ty75yh3rh', '2025-04-08 09:36:34', 11, 'pending', 21, 0, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(58, 18, 13.00, 'Withdrawal from wallet', 'WD-1744105897990-vlx43czt0', '2025-04-08 09:51:38', 11, 'pending', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(59, 18, 100.00, 'Deposit from client\'s wallet to admin\'s wallet', 'DEP-1744106655711-ntorwo8mi', '2025-04-08 10:04:15', 11, 'pending', 18, 21, '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', '', '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', 'USDT', 'deposit', 0.00),
(60, 18, 5.00, 'Withdrawal from wallet', 'WD-1744106676527-2yvkwbotm', '2025-04-08 10:04:36', 11, '', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(61, 18, 10.00, 'Withdrawal from wallet', 'WD-1744106870372-hcjjjxsqe', '2025-04-08 10:07:50', 11, '', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(62, 18, 10.00, 'Withdrawal from wallet', 'WD-1744106977847-pa55tjjwf', '2025-04-08 10:09:37', 11, '', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(63, 18, 1.00, 'Withdrawal from wallet', 'WD-1744107015831-5zqa05kne', '2025-04-08 10:10:15', 11, '', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(64, 18, 1.00, 'Withdrawal from wallet', 'WD-1744107141148-yhztezhh1', '2025-04-08 10:12:21', 11, '', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(65, 18, 1.00, 'Deposit from client\'s wallet to admin\'s wallet', 'DEP-1744107188358-vjt58ut3t', '2025-04-08 10:13:08', 11, '', 18, 21, '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', '', '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', 'USDT', 'deposit', 0.00),
(66, 18, 1.00, 'Withdrawal from wallet', 'WD-1744107208515-zi2hxvh4v', '2025-04-08 10:13:28', 11, '', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', '', 0.00),
(67, 18, 1.00, 'Withdrawal from wallet', 'WD-1744107397893-ha0hdfxq9', '2025-04-08 10:16:37', 11, '', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', 'withdraw', 0.00),
(68, 19, 5.00, 'Withdrawal from wallet', 'WD-1744140341861-s8hm6w9dg', '2025-04-08 19:25:41', 12, '', 0, 21, '', '', '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', 'USDT', 'withdraw', 0.00),
(69, 19, 1.00, 'Withdrawal from wallet', 'WD-1744140767211-bnycjk9lf', '2025-04-08 19:32:47', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(70, 19, 1.00, 'Withdrawal from wallet', 'WD-1744142258985-nfmgzvw2l', '2025-04-08 19:57:39', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(71, 19, 1.00, 'Withdrawal from wallet', 'WD-1744142320952-5ddru4zue', '2025-04-08 19:58:40', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(72, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168072294-wz1ck5sje', '2025-04-09 03:07:52', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(73, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168201559-yhtsg6uho', '2025-04-09 03:10:01', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(74, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168259922-hclta694y', '2025-04-09 03:10:59', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(75, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168330767-e70rradee', '2025-04-09 03:12:10', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(76, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168402959-2t06uo5sj', '2025-04-09 03:13:22', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(77, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168455840-0cqvbncw3', '2025-04-09 03:14:15', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(78, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168485039-zuzfnki0g', '2025-04-09 03:14:45', 12, '', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(79, 18, 1.00, 'Deposit from client\'s wallet to admin\'s wallet', 'DEP-1744168783908-6r9s5ogz3', '2025-04-09 03:19:43', 11, 'pending', 18, 21, '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', '', '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', 'USDT', 'deposit', 0.00),
(80, 18, 1.00, 'Withdrawal from wallet', 'WD-1744168824735-kynzzkk7f', '2025-04-09 03:20:24', 11, 'pending', 21, 18, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 'USDT', 'withdraw', 0.00),
(81, 19, 1.00, 'Withdrawal from wallet', 'WD-1744168844871-yl4631bsa', '2025-04-09 03:20:44', 12, 'pending', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(82, 19, 1.00, 'Withdrawal from wallet', 'WD-1744169017733-18qvadtos', '2025-04-09 03:23:37', 12, 'pending', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00),
(83, 19, 1.00, 'Withdrawal from wallet', 'WD-1744170635798-rosi30qf6', '2025-04-09 03:50:35', 12, 'pending', 21, 19, '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', '', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 'USDT', 'withdraw', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `csrf_tokens`
--

CREATE TABLE `csrf_tokens` (
  `id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `event_type` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_configurations`
--

CREATE TABLE `form_configurations` (
  `id` int(11) NOT NULL,
  `domain_id` int(11) DEFAULT NULL,
  `header_text` text DEFAULT NULL,
  `footer_text` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_domains`
--

CREATE TABLE `form_domains` (
  `id` int(11) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `telegram_chat_id` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `form_domains`
--

INSERT INTO `form_domains` (`id`, `domain`, `group_name`, `telegram_chat_id`, `active`, `created_at`, `updated_at`) VALUES
(1, '11s.tapsndr.com', '11s Group', '-1002324697837', 1, '2025-02-28 07:17:09', '2025-03-08 05:48:51'),
(2, 'chloes.tapsndr.com', 'Chloes Group', '-1009876543210', 1, '2025-02-28 07:17:09', '2025-02-28 07:17:09'),
(3, 'dds.tapsndr.com', 'DDS Group', '-4750875832', 1, '2025-02-28 07:17:09', '2025-03-10 05:20:53'),
(4, 'valley.tapsndr.com', 'Victory valley', '-1001567890123', 1, '2025-02-28 07:17:09', '2025-03-06 21:54:13');

-- --------------------------------------------------------

--
-- Table structure for table `form_game_options`
--

CREATE TABLE `form_game_options` (
  `id` int(11) NOT NULL,
  `game_name` varchar(255) NOT NULL,
  `domain_id` int(11) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `form_game_options`
--

INSERT INTO `form_game_options` (`id`, `game_name`, `domain_id`, `display_order`, `active`, `created_at`, `updated_at`) VALUES
(1, 'Golden Dragon', NULL, 1, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(2, 'Magic City', NULL, 2, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(3, 'V-Blink', NULL, 3, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(4, 'Ultra Panda', NULL, 4, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(5, 'Orion Star', NULL, 5, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(6, 'Fire Kirin', NULL, 6, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(7, 'Milky Way', NULL, 7, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(8, 'Panda Master', NULL, 8, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(9, 'River Sweeps', NULL, 9, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(10, 'Juwa', NULL, 10, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(11, 'Fire Phoenix', NULL, 11, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03');

-- --------------------------------------------------------

--
-- Table structure for table `form_payment_methods`
--

CREATE TABLE `form_payment_methods` (
  `id` int(11) NOT NULL,
  `method_name` varchar(255) NOT NULL,
  `domain_id` int(11) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `form_payment_methods`
--

INSERT INTO `form_payment_methods` (`id`, `method_name`, `domain_id`, `display_order`, `active`, `created_at`, `updated_at`) VALUES
(1, 'CashApp', NULL, 1, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(2, 'Venmo', NULL, 2, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(3, 'Zelle', NULL, 3, 1, '2025-02-28 08:58:03', '2025-02-28 08:58:03'),
(4, 'PayPal G&S', NULL, 4, 1, '2025-02-28 08:58:03', '2025-02-28 23:45:56');

-- --------------------------------------------------------

--
-- Table structure for table `form_submissions`
--

CREATE TABLE `form_submissions` (
  `id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `game` varchar(255) NOT NULL,
  `game_id` varchar(255) NOT NULL,
  `facebook_name` varchar(255) NOT NULL,
  `transaction_number` varchar(255) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `status` enum('pending_validation','validated','declined','completed') NOT NULL,
  `validator_id` bigint(20) DEFAULT NULL,
  `fulfiller_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `validated_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `telegram_notification_sent` tinyint(1) DEFAULT 0,
  `telegram_message_id` bigint(20) DEFAULT NULL,
  `telegram_chat_id` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `form_submissions`
--

INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(1, 100.50, 'Mobile Legends', 'ML123456', 'John Doe', '7b4a23b2-25fb-49c2-845b-05f5e2e27714', 18, 'pending_validation', NULL, NULL, '2025-04-04 00:06:16', NULL, NULL, 0, NULL, NULL),
(2, 100.50, 'Mobile Legends', 'ML123456', 'John Doe', '57793a5c-5b50-457f-8339-ce8b760c6f9b', 18, 'pending_validation', NULL, NULL, '2025-04-04 00:07:07', NULL, NULL, 0, NULL, NULL),
(3, 100.50, 'Mobile Legends', 'ML123456', 'John Doe', '49161894-431f-477e-9c52-ec51ab9e3423', 18, 'pending_validation', NULL, NULL, '2025-04-04 00:08:04', NULL, NULL, 0, NULL, NULL),
(4, 100.50, 'Mobile Legends', 'ML123456', 'John Doe', 'c64ff434-7f35-4cff-9639-52d9ad88b544', 18, 'pending_validation', NULL, NULL, '2025-04-04 00:08:58', NULL, NULL, 0, NULL, NULL),
(5, 627.00, 'Test Game', 'RICCKH', 'Test User', 'a7091215-7729-41cc-85db-69af7d0207ee', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:20:28', NULL, NULL, 0, NULL, NULL),
(6, 169.00, 'Test Game', 'QP8MO6', 'Test User', 'ea016f8a-2eef-46fd-8e00-7e6003bf8df5', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:24:22', NULL, NULL, 0, NULL, NULL),
(7, 151.00, 'Test Game', 'EJQQTA', 'Test User', '208416c2-ca45-4cc7-b35d-67ada634f9e5', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:24:22', NULL, NULL, 0, NULL, NULL),
(8, 721.00, 'Test Game', 'NA8LMG', 'Test User', '0d9b1a54-326c-4369-812c-3a61adc56158', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:24:22', NULL, NULL, 0, NULL, NULL),
(9, 880.00, 'Test Game', '9X0XBO', 'Test User', '43bd8405-9344-42b1-9005-13873ed50bca', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:24:22', NULL, NULL, 0, NULL, NULL),
(10, 976.00, 'Test Game', 'EFOBX8', 'Test User', '750ca70d-1b5e-46ab-add1-37239a5c4466', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:24:42', NULL, NULL, 0, NULL, NULL),
(11, 133.00, 'Test Game', 'R99MH7', 'Test User', '4f077878-45a0-45c3-8df8-8fc950554308', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:25:02', NULL, NULL, 0, NULL, NULL),
(12, 870.00, 'Test Game', 'J7A0WI', 'Test User', '7201a679-e8b2-4ebf-a3fa-3f089cff8c67', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:25:22', NULL, NULL, 0, NULL, NULL),
(13, 840.00, 'Test Game', 'PBNZDV', 'Test User', '0fbbc521-ead6-445a-a767-e27ed0c02715', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:25:42', NULL, NULL, 0, NULL, NULL),
(14, 145.00, 'Test Game', 'MDYIQV', 'Test User', '5d2d5665-d99d-4f0e-8aed-26608ea711f3', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:26:02', NULL, NULL, 0, NULL, NULL),
(15, 500.00, 'Test Game', 'YLBRFA', 'Test User', 'd75d3ff0-7bde-49d3-8459-87167f41c26d', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:26:28', NULL, NULL, 0, NULL, NULL),
(16, 218.00, 'Test Game', '7QVN6O', 'Test User', 'c77012d5-b3eb-41fa-9458-2a0296ee58f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:26:28', NULL, NULL, 0, NULL, NULL),
(17, 727.00, 'Test Game', 'EMGF29', 'Test User', '4783a9d4-e866-4768-8648-b71f77425e78', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:26:28', NULL, NULL, 0, NULL, NULL),
(18, 692.00, 'Test Game', '71DO9N', 'Test User', '8391039f-952d-4083-932d-645d75d4bd2b', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:26:28', NULL, NULL, 0, NULL, NULL),
(19, 926.00, 'Test Game', 'WZJD8S', 'Test User', '16745e7f-df0c-442a-941f-b6efc81c4cc0', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:26:48', NULL, NULL, 0, NULL, NULL),
(20, 146.00, 'Test Game', 'AU4DYL', 'Test User', 'bc7b25f8-172d-40fd-9870-8053216d0960', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:27:08', NULL, NULL, 0, NULL, NULL),
(21, 669.00, 'Test Game', 'Q17849', 'Test User', '5de4da74-59b7-4368-b657-9486b6e2d32a', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:27:28', NULL, NULL, 0, NULL, NULL),
(22, 85.00, 'Test Game', 'IBO7F6', 'Test User', 'a866300b-815e-402f-ba2a-fc558e97df50', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:27:48', NULL, NULL, 0, NULL, NULL),
(23, 189.00, 'Test Game', 'DH8ZBN', 'Test User', 'd1a447d8-071b-4f95-89bf-eaf37e805c81', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:28:08', NULL, NULL, 0, NULL, NULL),
(24, 996.00, 'Test Game', '5GG8OI', 'Test User', '1dd958c9-aa04-4f79-93e0-3457d879cd7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:28:28', NULL, NULL, 0, NULL, NULL),
(25, 285.00, 'Test Game', '35U1D2', 'Test User', '659d173b-48fc-417b-b10d-d5109dffc593', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:28:48', NULL, NULL, 0, NULL, NULL),
(26, 700.00, 'Test Game', '9TV2R3', 'Test User', 'ad8b4452-4be0-4634-9209-cb49087ccac0', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:29:04', NULL, NULL, 0, NULL, NULL),
(27, 393.00, 'Test Game', 'FY0CB7', 'Test User', '4be426f8-ac46-423c-bae0-122c6075d592', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:29:24', NULL, NULL, 0, NULL, NULL),
(28, 723.00, 'PUBG Mobile', 'PU255286', 'User714', '5e1d781c-e180-4933-ade7-319244429a65', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:56:22', NULL, NULL, 0, NULL, NULL),
(29, 826.00, 'Free Fire', 'FR747741', 'User363', 'b7050621-fc54-402d-ad63-8d80be80357b', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:56:42', NULL, NULL, 0, NULL, NULL),
(30, 112.00, 'PUBG Mobile', 'PU610761', 'User904', '70b1f4bd-6e3b-4e5a-8089-e1af97eca9ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:57:02', NULL, NULL, 0, NULL, NULL),
(31, 448.00, 'Genshin Impact', 'GE665973', 'User184', '3b198c6f-6c23-4f9d-94f0-0c914875e32c', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:57:22', NULL, NULL, 0, NULL, NULL),
(32, 627.00, 'Free Fire', 'FR908102', 'User818', '0d3030c7-f993-4ffe-818a-f72563b11b83', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:57:42', NULL, NULL, 0, NULL, NULL),
(33, 418.00, 'PUBG Mobile', 'PU813960', 'User825', '5036f46a-df18-4adf-a333-81e066090d69', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:58:02', NULL, NULL, 0, NULL, NULL),
(34, 365.00, 'Mobile Legends', 'MO487928', 'User481', '42c180d0-dce8-41df-a383-c71d4c9c5f5c', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:58:22', NULL, NULL, 0, NULL, NULL),
(35, 244.00, 'Mobile Legends', 'MO966051', 'User558', '80833a1f-be4a-4319-ad87-ae2a828efeca', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:58:42', NULL, NULL, 0, NULL, NULL),
(36, 569.00, 'Free Fire', 'FR438149', 'User883', '41131300-3852-47e4-861e-7ece08bb1b7f', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:59:02', NULL, NULL, 0, NULL, NULL),
(37, 751.00, 'Genshin Impact', 'GE724535', 'User941', '2157584a-cc70-4234-8541-fa6dc916118e', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:59:22', NULL, NULL, 0, NULL, NULL),
(38, 157.00, 'Mobile Legends', 'MO615905', 'User674', 'f4bb1d6e-9313-4b49-853d-2b6d5461c14a', 19, 'pending_validation', NULL, NULL, '2025-04-09 04:59:42', NULL, NULL, 0, NULL, NULL),
(39, 841.00, 'Mobile Legends', 'MO959366', 'User59', '92dfe36d-1b48-4ab6-b6a7-2b344cf0c0a5', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:00:02', NULL, NULL, 0, NULL, NULL),
(40, 236.00, 'Free Fire', 'FR11871', 'User652', 'f3ed75bc-07e0-4978-b00b-ae71672a6fde', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:00:22', NULL, NULL, 0, NULL, NULL),
(41, 352.00, 'Genshin Impact', 'GE508261', 'User324', '3b494e09-1cf2-41da-84c4-768e93d23e70', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:00:42', NULL, NULL, 0, NULL, NULL),
(42, 757.00, 'Mobile Legends', 'MO494457', 'User569', '5d069263-2a06-4082-8640-8e6a0d39d091', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:01:02', NULL, NULL, 0, NULL, NULL),
(43, 439.00, 'PUBG Mobile', 'PU474148', 'User376', '83a87f85-8a48-4d63-a8cf-49e139ffdc02', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:01:22', NULL, NULL, 0, NULL, NULL),
(44, 702.00, 'Roblox', 'RO597527', 'User947', '4333b2a6-de9a-467f-be67-4875dd5d53ad', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:01:42', NULL, NULL, 0, NULL, NULL),
(45, 682.00, 'Genshin Impact', 'GE62566', 'User976', 'c999d4cf-d132-4354-aff2-c099593d77d6', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:02:02', NULL, NULL, 0, NULL, NULL),
(46, 223.00, 'Random Game', 'GAME-437', 'User-620', '2a5e93fc-346c-4ca1-aec9-8e3a64a6b27f', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:02:18', NULL, NULL, 0, NULL, NULL),
(47, 434.00, 'Genshin Impact', 'GE474535', 'User753', '41dfb141-653f-465a-a4ae-0007ab8bac4f', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:02:22', NULL, NULL, 0, NULL, NULL),
(48, 482.00, 'Random Game', 'GAME-999', 'User-78', 'd2f6ef9c-1ca7-4b75-9cd3-b6fc24bfe9a2', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:02:38', NULL, NULL, 0, NULL, NULL),
(49, 117.00, 'Roblox', 'RO51976', 'User223', 'de9a463c-f190-44c1-9a0f-ffdc946ae294', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:02:42', NULL, NULL, 0, NULL, NULL),
(50, 483.00, 'Random Game', 'GAME-841', 'User-58', 'be39d7ca-7bd9-4b0a-87ec-bd70590e7490', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:02:58', NULL, NULL, 0, NULL, NULL),
(51, 441.00, 'Free Fire', 'FR802702', 'User436', '220c2fd9-0b15-4b00-a0ac-2fe1e32a4530', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:03:02', NULL, NULL, 0, NULL, NULL),
(52, 1023.00, 'Random Game', 'GAME-466', 'User-378', '78661290-07ba-43b8-8cb6-875f7481f94a', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:03:18', NULL, NULL, 0, NULL, NULL),
(53, 642.00, 'PUBG Mobile', 'PU733866', 'User793', '6f723f39-30c3-4c78-a91a-6dd9d365e0cf', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:03:22', NULL, NULL, 0, NULL, NULL),
(54, 409.00, 'Random Game', 'GAME-360', 'User-860', '53b2cf75-542e-4265-a21b-bf728aaceae9', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:03:38', NULL, NULL, 0, NULL, NULL),
(55, 115.00, 'Free Fire', 'FR205559', 'User563', '5b88f52f-d2a5-45e0-a6fe-847c4bfe3fe4', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:03:42', NULL, NULL, 0, NULL, NULL),
(56, 740.00, 'Random Game', 'GAME-435', 'User-914', 'd94729c6-906a-4b6e-8050-a3faba4af469', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:03:58', NULL, NULL, 0, NULL, NULL),
(57, 436.00, 'Mobile Legends', 'MO773789', 'User597', '7f6d3796-f3a2-4055-9617-3ee4326800d0', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:04:03', NULL, NULL, 0, NULL, NULL),
(58, 63.00, 'Random Game', 'GAME-137', 'User-126', 'ab538aba-6316-454b-a9a9-ea2533ba6863', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:04:19', NULL, NULL, 0, NULL, NULL),
(59, 757.00, 'Mobile Legends', 'MO662379', 'User591', 'a2379475-496a-4dc7-bf39-d03530d2f1b5', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:04:23', NULL, NULL, 0, NULL, NULL),
(60, 1049.00, 'Random Game', 'GAME-963', 'User-628', '49989ee8-68e2-43b4-9fef-3f1585f5db45', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:04:39', NULL, NULL, 0, NULL, NULL),
(61, 302.00, 'Genshin Impact', 'GE343595', 'User708', 'b7bfb170-03ec-45a6-bfc8-8f7f08a9dd58', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:04:43', NULL, NULL, 0, NULL, NULL),
(62, 826.00, 'Random Game', 'GAME-941', 'User-0', '8d6cee71-81fe-4073-a0fe-d84691e4b6ee', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:04:59', NULL, NULL, 0, NULL, NULL),
(63, 498.00, 'Mobile Legends', 'MO438934', 'User297', '7ac2ad3e-6cff-4b0c-9dae-e5fcad9d087d', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:05:07', NULL, NULL, 0, NULL, NULL),
(64, 266.00, 'Random Game', 'GAME-525', 'User-48', 'fc3a4843-a2c4-4993-9407-3764f63cc647', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:06:07', NULL, NULL, 0, NULL, NULL),
(65, 995.00, 'PUBG Mobile', 'PU700460', 'User827', '5de62e2b-3a06-44fd-aa07-6fedd26b529a', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:06:07', NULL, NULL, 0, NULL, NULL),
(66, 915.00, 'Random Game', 'GAME-217', 'User-449', 'fad31962-5103-474a-b219-cec17fb646b1', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:07:07', NULL, NULL, 0, NULL, NULL),
(67, 773.00, 'Free Fire', 'FR833085', 'User624', '20f5b68a-f3c4-4156-a63b-fa183929a274', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:07:07', NULL, NULL, 0, NULL, NULL),
(68, 470.00, 'Random Game', 'GAME-278', 'User-962', '322e9206-7e5a-43bc-b07b-206a21ff57e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:08:07', NULL, NULL, 0, NULL, NULL),
(69, 254.00, 'Mobile Legends', 'MO327949', 'User584', 'fbc0e8a8-3ab0-4801-ae05-4013b3222c82', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:08:07', NULL, NULL, 0, NULL, NULL),
(70, 483.00, 'Random Game', 'GAME-684', 'User-297', '870dc10a-c409-4cb6-a4d9-d0a5dd93de7d', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:09:07', NULL, NULL, 0, NULL, NULL),
(71, 884.00, 'Roblox', 'RO85303', 'User583', 'dced3f66-7940-490d-b691-ff81d95f567b', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:09:07', NULL, NULL, 0, NULL, NULL),
(72, 419.00, 'Random Game', 'GAME-189', 'User-791', 'ffdf48ba-82f3-45c5-8e43-2d18eefae567', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:10:07', NULL, NULL, 0, NULL, NULL),
(73, 313.00, 'Genshin Impact', 'GE948418', 'User162', '76ca8b0d-9cd5-4735-9e5a-a51d537bc0c1', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:10:07', NULL, NULL, 0, NULL, NULL),
(74, 811.00, 'Random Game', 'GAME-891', 'User-664', '48820a51-2b4f-470b-a712-c1d4ce772d98', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:11:07', NULL, NULL, 0, NULL, NULL),
(75, 358.00, 'Free Fire', 'FR99378', 'User712', 'c1476109-0042-477c-bc22-76382978ec3a', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:11:07', NULL, NULL, 0, NULL, NULL),
(76, 363.00, 'Random Game', 'GAME-585', 'User-562', '261d2c99-326b-4e8f-80b1-bdbb62958ab6', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:12:07', NULL, NULL, 0, NULL, NULL),
(77, 894.00, 'Mobile Legends', 'MO851613', 'User360', '480416ea-afed-4b73-a008-159d4486d526', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:12:07', NULL, NULL, 0, NULL, NULL),
(78, 875.00, 'Random Game', 'GAME-10', 'User-462', 'f1ef6bee-a268-4d44-9f09-8b4fba92d53c', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:13:07', NULL, NULL, 0, NULL, NULL),
(79, 785.00, 'Genshin Impact', 'GE4236', 'User215', 'ea299aa9-d75e-4af8-8ec4-b28e9fbbbc3f', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:13:07', NULL, NULL, 0, NULL, NULL),
(80, 535.00, 'Random Game', 'GAME-543', 'User-727', 'aeb56f3d-8c16-4944-8a15-0efb522f9ebd', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:14:07', NULL, NULL, 0, NULL, NULL),
(81, 407.00, 'Free Fire', 'FR636837', 'User431', '9b86f740-67a0-4030-a7be-f8bd2147fb72', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:14:07', NULL, NULL, 0, NULL, NULL),
(82, 438.00, 'Random Game', 'GAME-651', 'User-314', '6988b5ff-c598-4a3b-aeb2-09d70f9f4bc0', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:15:07', NULL, NULL, 0, NULL, NULL),
(83, 128.00, 'Free Fire', 'FR639228', 'User338', '916ebc43-61a9-4f59-b7c4-dc85fb7ad354', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:15:07', NULL, NULL, 0, NULL, NULL),
(84, 578.00, 'Genshin Impact', 'GE300178', 'User796', '2d5fa2f5-8b1c-4e37-a342-0337e22e31c3', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:16:07', NULL, NULL, 0, NULL, NULL),
(85, 404.00, 'Random Game', 'GAME-336', 'User-689', '1c5f94b2-247b-4d7f-b8b0-362c66fd5128', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:16:07', NULL, NULL, 0, NULL, NULL),
(86, 887.00, 'Random Game', 'GAME-881', 'User-802', '2544cbcf-e010-479a-a364-1995c58dde49', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:17:07', NULL, NULL, 0, NULL, NULL),
(87, 758.00, 'Mobile Legends', 'MO379572', 'User830', 'cb142bb0-8b8a-43c8-8fe3-1c4b448279f1', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:17:07', NULL, NULL, 0, NULL, NULL),
(88, 521.00, 'Random Game', 'GAME-53', 'User-790', '48eb9dde-3977-4a8e-b4e6-d50fc872a802', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:18:07', NULL, NULL, 0, NULL, NULL),
(89, 469.00, 'Free Fire', 'FR193416', 'User894', 'b46036de-3dcb-461f-b8ab-ced8c54eed91', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:18:07', NULL, NULL, 0, NULL, NULL),
(90, 136.00, 'Free Fire', 'FR397529', 'User417', '6da773e1-f9f1-4fd8-a654-b8a26c0363f0', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:19:07', NULL, NULL, 0, NULL, NULL),
(91, 588.00, 'Random Game', 'GAME-1', 'User-239', '5a3d7197-5d22-409b-9249-da4192731fb5', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:19:07', NULL, NULL, 0, NULL, NULL),
(92, 775.00, 'Random Game', 'GAME-428', 'User-635', '8d7231a8-a036-4ec4-9e47-8efc5680e8c6', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:20:07', NULL, NULL, 0, NULL, NULL),
(93, 721.00, 'Roblox', 'RO429579', 'User73', '57b90b8d-9cc5-4673-a789-e7d074a7d384', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:20:07', NULL, NULL, 0, NULL, NULL),
(94, 311.00, 'Random Game', 'GAME-358', 'User-64', 'be3c8d2b-066d-419c-8eaf-13d0aff1f27c', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:21:07', NULL, NULL, 0, NULL, NULL),
(95, 761.00, 'Mobile Legends', 'MO658379', 'User962', '8ce91f43-15b2-46ab-a8ed-a8c280cc1743', 19, 'pending_validation', NULL, NULL, '2025-04-09 05:21:07', NULL, NULL, 0, NULL, NULL),
(96, 289.00, 'Random Game', 'GAME-885', 'User-328', '3ec620d5-7fae-4bb7-8c04-1ad96f61d983', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:20:30', NULL, NULL, 0, NULL, NULL),
(97, 178.00, 'Random Game', 'GAME-920', 'User-733', 'e2220853-d727-4981-9aa3-713fbe36b768', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:20:30', NULL, NULL, 0, NULL, NULL),
(98, 296.00, 'Random Game', 'GAME-636', 'User-65', '9d201946-11a9-4683-b452-877db218ef40', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:20:50', NULL, NULL, 0, NULL, NULL),
(99, 90.00, 'Random Game', 'GAME-639', 'User-301', '3820c541-a4af-4270-9417-a7d6ee161cd8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:20:50', NULL, NULL, 0, NULL, NULL),
(100, 481.00, 'Random Game', 'GAME-492', 'User-820', '06ec7dbd-0fab-4fef-8340-c5bbe272e813', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:21:10', NULL, NULL, 0, NULL, NULL),
(101, 942.00, 'Random Game', 'GAME-942', 'User-184', '266c6af9-8de2-49a9-a6d9-da540ce2f46b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:21:10', NULL, NULL, 0, NULL, NULL),
(102, 523.00, 'Random Game', 'GAME-852', 'User-767', '4e935c6c-aae9-4f19-8c37-77311091bb18', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:21:30', NULL, NULL, 0, NULL, NULL),
(103, 1038.00, 'Random Game', 'GAME-242', 'User-877', 'df126de4-d7e7-4800-95cb-9be31bdcdb6b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:21:30', NULL, NULL, 0, NULL, NULL),
(104, 497.00, 'Random Game', 'GAME-533', 'User-705', 'bb74286e-54ec-41b1-b61b-83de58903b5e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:21:50', NULL, NULL, 0, NULL, NULL),
(105, 542.00, 'Random Game', 'GAME-140', 'User-501', 'c29ac757-4bf9-41f9-95c0-bc974677d1be', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:21:50', NULL, NULL, 0, NULL, NULL),
(106, 954.00, 'Random Game', 'GAME-412', 'User-947', '27cb5f4a-a0e4-4b3a-88c2-33dcf44c3e7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:22:10', NULL, NULL, 0, NULL, NULL),
(107, 901.00, 'Random Game', 'GAME-299', 'User-43', '26d8b672-40af-4b03-a59e-355d9c1d612f', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:22:10', NULL, NULL, 0, NULL, NULL),
(108, 171.00, 'Random Game', 'GAME-460', 'User-707', '6595b491-2558-487a-b56a-f239b84ddfed', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:22:30', NULL, NULL, 0, NULL, NULL),
(109, 445.00, 'Random Game', 'GAME-76', 'User-996', '384f1412-78bf-4115-beed-7381e2201692', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:22:30', NULL, NULL, 0, NULL, NULL),
(110, 132.00, 'Random Game', 'GAME-368', 'User-939', 'a117b204-130f-49c3-95d0-7e8c85ff4348', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:22:50', NULL, NULL, 0, NULL, NULL),
(111, 1024.00, 'Random Game', 'GAME-43', 'User-314', '348cf321-5b03-4a26-ab6d-f2b7e0c7ac26', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:22:50', NULL, NULL, 0, NULL, NULL),
(112, 183.00, 'Random Game', 'GAME-606', 'User-504', '7b4a6b80-6360-4726-ba29-27325c42cb10', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:23:10', NULL, NULL, 0, NULL, NULL),
(113, 672.00, 'Random Game', 'GAME-454', 'User-369', '04a47e0a-2744-460d-ae69-477dfda04acc', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:23:10', NULL, NULL, 0, NULL, NULL),
(114, 242.00, 'Random Game', 'GAME-11', 'User-868', 'e7043838-811f-4e00-9fa8-cbfc28f4c655', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:23:30', NULL, NULL, 0, NULL, NULL),
(115, 1033.00, 'Random Game', 'GAME-399', 'User-555', 'db890fda-58f3-4064-b97f-9ec90b610afe', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:23:30', NULL, NULL, 0, NULL, NULL),
(116, 412.00, 'Random Game', 'GAME-117', 'User-785', 'f47c21db-da1a-4332-a56f-7784ec01e20f', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:23:51', NULL, NULL, 0, NULL, NULL),
(117, 288.00, 'Random Game', 'GAME-387', 'User-512', 'ef6990ca-234b-40d7-8405-703d0a105cb5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:23:51', NULL, NULL, 0, NULL, NULL),
(118, 445.00, 'Random Game', 'GAME-529', 'User-0', '75bccf1e-a2b9-4616-8151-af2e392a729c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:24:10', NULL, NULL, 0, NULL, NULL),
(119, 934.00, 'Random Game', 'GAME-301', 'User-978', '1957a2c7-d6a7-437e-89fa-c9283efb8b3b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:24:10', NULL, NULL, 0, NULL, NULL),
(120, 133.00, 'Random Game', 'GAME-884', 'User-577', '4ad65dee-1d84-4144-be7e-18fe29472a12', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:24:30', NULL, NULL, 0, NULL, NULL),
(121, 617.00, 'Random Game', 'GAME-670', 'User-339', 'cc0b7cff-e266-48ab-9c9b-945699ce4702', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:24:30', NULL, NULL, 0, NULL, NULL),
(122, 621.00, 'Random Game', 'GAME-561', 'User-902', '585cf0e8-eca6-4d0f-a508-e70143a965dd', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:24:50', NULL, NULL, 0, NULL, NULL),
(123, 904.00, 'Random Game', 'GAME-724', 'User-732', '64b7a6a7-2d6e-4eca-b3ed-8a26f7626a2e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:24:50', NULL, NULL, 0, NULL, NULL),
(124, 129.00, 'Random Game', 'GAME-63', 'User-548', '9e757314-eae8-4668-8adc-622072bc12dc', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:25:10', NULL, NULL, 0, NULL, NULL),
(125, 963.00, 'Random Game', 'GAME-9', 'User-471', 'fa269449-6f27-49fb-bc60-5a642bc81dd5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:25:10', NULL, NULL, 0, NULL, NULL),
(126, 414.00, 'Random Game', 'GAME-432', 'User-513', '6cfdfb8a-a508-46c2-acda-0434684d0351', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:25:30', NULL, NULL, 0, NULL, NULL),
(127, 318.00, 'Random Game', 'GAME-905', 'User-568', '044c1928-3f49-43e4-b11f-8550cf36d675', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:25:30', NULL, NULL, 0, NULL, NULL),
(128, 641.00, 'Random Game', 'GAME-771', 'User-523', '31877d1b-46f5-4864-9885-a7d419d358b6', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:25:50', NULL, NULL, 0, NULL, NULL),
(129, 1038.00, 'Random Game', 'GAME-115', 'User-55', 'e81545b9-5b55-431a-9eab-0777a9e26682', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:25:50', NULL, NULL, 0, NULL, NULL),
(130, 714.00, 'Random Game', 'GAME-549', 'User-289', '447d8cf1-7e03-4799-98cc-0d9af396eb82', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:26:10', NULL, NULL, 0, NULL, NULL),
(131, 68.00, 'Random Game', 'GAME-335', 'User-969', 'e2e8b170-b498-45b8-b872-5a5ac5b36968', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:26:10', NULL, NULL, 0, NULL, NULL),
(132, 536.00, 'Random Game', 'GAME-231', 'User-313', '49ba31bb-e4bf-4d8e-8d21-665cbb30da4e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:26:30', NULL, NULL, 0, NULL, NULL),
(133, 346.00, 'Random Game', 'GAME-564', 'User-697', 'b0d4bc8e-ab5b-4639-9158-13210be15d3a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:26:30', NULL, NULL, 0, NULL, NULL),
(134, 360.00, 'Random Game', 'GAME-249', 'User-659', '0f147362-4081-45f4-b4ba-d1f1350005e4', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:26:50', NULL, NULL, 0, NULL, NULL),
(135, 406.00, 'Random Game', 'GAME-802', 'User-113', '0a56968c-e5a4-4869-900b-89260afee5db', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:26:50', NULL, NULL, 0, NULL, NULL),
(136, 451.00, 'Random Game', 'GAME-456', 'User-927', '073b7471-3ea3-4fec-be67-537dee0ff837', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:27:10', NULL, NULL, 0, NULL, NULL),
(137, 455.00, 'Random Game', 'GAME-813', 'User-819', '19d44dea-3699-44f3-8f97-8354b70ec34b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:27:10', NULL, NULL, 0, NULL, NULL),
(138, 607.00, 'Random Game', 'GAME-441', 'User-582', 'f90dde7e-a043-4268-814c-f48662a4cf40', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:27:30', NULL, NULL, 0, NULL, NULL),
(139, 447.00, 'Random Game', 'GAME-439', 'User-809', '0c90a216-96c7-45db-b9e9-cd3b10f56bf4', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:27:30', NULL, NULL, 0, NULL, NULL),
(140, 716.00, 'Random Game', 'GAME-536', 'User-41', 'a44b28c6-2ae0-4a38-8d91-6e3422b2eec6', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:27:50', NULL, NULL, 0, NULL, NULL),
(141, 760.00, 'Random Game', 'GAME-283', 'User-242', 'cb0039a3-dccc-4491-a039-02edf1251fab', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:27:50', NULL, NULL, 0, NULL, NULL),
(142, 608.00, 'Random Game', 'GAME-601', 'User-739', 'e3b65626-d95b-4582-ae96-c22c8cea4de2', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:28:10', NULL, NULL, 0, NULL, NULL),
(143, 725.00, 'Random Game', 'GAME-22', 'User-389', '706e7bd7-bd69-49ae-a467-e9a4733a229a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:28:10', NULL, NULL, 0, NULL, NULL),
(144, 939.00, 'Random Game', 'GAME-850', 'User-216', '57b31755-85de-4295-919f-efed20a3de24', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:28:30', NULL, NULL, 0, NULL, NULL),
(145, 82.00, 'Random Game', 'GAME-677', 'User-483', '88dadf80-e69c-4ec4-90ef-a7b39542a381', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:28:30', NULL, NULL, 0, NULL, NULL),
(146, 477.00, 'Random Game', 'GAME-487', 'User-353', '77872870-ccb2-448a-b319-9b9241cc707d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:28:50', NULL, NULL, 0, NULL, NULL),
(147, 81.00, 'Random Game', 'GAME-816', 'User-323', '0dea8e24-719e-42fa-b36e-b6268fc9179f', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:28:50', NULL, NULL, 0, NULL, NULL),
(148, 534.00, 'Random Game', 'GAME-61', 'User-976', 'cf8cfcc1-fa51-47a1-8649-87b698d19d44', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:29:10', NULL, NULL, 0, NULL, NULL),
(149, 979.00, 'Random Game', 'GAME-690', 'User-235', '96780f37-1cd4-4253-ad70-df391a0457c6', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:29:10', NULL, NULL, 0, NULL, NULL),
(150, 468.00, 'Random Game', 'GAME-511', 'User-178', '62a37654-44bf-477b-a512-f903fde89670', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:29:30', NULL, NULL, 0, NULL, NULL),
(151, 626.00, 'Random Game', 'GAME-255', 'User-926', '909eb129-859b-4cd3-b658-a08f21bafd4e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:29:30', NULL, NULL, 0, NULL, NULL),
(152, 666.00, 'Random Game', 'GAME-799', 'User-40', '106ad420-9644-4209-9c36-71a486632313', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:29:50', NULL, NULL, 0, NULL, NULL),
(153, 950.00, 'Random Game', 'GAME-298', 'User-959', '925ccc64-326e-456e-9204-f9bbd3607e8d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:29:50', NULL, NULL, 0, NULL, NULL),
(154, 456.00, 'Random Game', 'GAME-951', 'User-837', '1b8919fe-a390-4be0-8350-c1203157d6d9', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:30:10', NULL, NULL, 0, NULL, NULL),
(155, 972.00, 'Random Game', 'GAME-512', 'User-401', '5bc2a04a-a21f-41ed-ba7c-900d3623a1a8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:30:10', NULL, NULL, 0, NULL, NULL),
(156, 558.00, 'Random Game', 'GAME-15', 'User-571', '94a90988-12fe-414c-8420-62db5da3efb5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:30:30', NULL, NULL, 0, NULL, NULL),
(157, 595.00, 'Random Game', 'GAME-555', 'User-933', 'b4dcf5ee-90de-4e4e-9065-46305f2ec05a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:30:30', NULL, NULL, 0, NULL, NULL),
(158, 310.00, 'Random Game', 'GAME-520', 'User-421', '4d3bec39-79a8-4fa9-808c-1370ed1f632f', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:30:50', NULL, NULL, 0, NULL, NULL),
(159, 815.00, 'Random Game', 'GAME-193', 'User-803', '106def4f-9538-4245-b82d-a4994251c267', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:30:50', NULL, NULL, 0, NULL, NULL),
(160, 853.00, 'Random Game', 'GAME-333', 'User-962', '6ccc6546-8b58-4d07-80c2-17be3c6aaf18', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:31:10', NULL, NULL, 0, NULL, NULL),
(161, 647.00, 'Random Game', 'GAME-426', 'User-870', '7f082cff-0272-4f86-ac7c-ce5b8248a278', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:31:10', NULL, NULL, 0, NULL, NULL),
(162, 706.00, 'Random Game', 'GAME-635', 'User-261', '3ec033b1-8612-4f02-97f3-dc320c55614a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:31:30', NULL, NULL, 0, NULL, NULL),
(163, 306.00, 'Random Game', 'GAME-878', 'User-936', '6dc5fc9e-62f5-467a-837b-ebdc8439c9f5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:31:30', NULL, NULL, 0, NULL, NULL),
(164, 896.00, 'Random Game', 'GAME-914', 'User-708', '9236259d-adc7-4120-88ca-4d04640acb81', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:31:50', NULL, NULL, 0, NULL, NULL),
(165, 689.00, 'Random Game', 'GAME-18', 'User-46', '33221a5c-fac0-428b-be03-9eb328ae0838', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:31:50', NULL, NULL, 0, NULL, NULL),
(166, 848.00, 'Random Game', 'GAME-163', 'User-554', 'd332e273-2498-4194-a6d7-a2e41bba31e9', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:32:10', NULL, NULL, 0, NULL, NULL),
(167, 896.00, 'Random Game', 'GAME-615', 'User-474', '509ffc04-5867-4266-8af8-8cd9b4776a29', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:32:10', NULL, NULL, 0, NULL, NULL),
(168, 358.00, 'Random Game', 'GAME-25', 'User-879', 'ed5362f4-829e-4006-8a3e-5f2d9c06ce48', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:32:30', NULL, NULL, 0, NULL, NULL),
(169, 1006.00, 'Random Game', 'GAME-364', 'User-312', 'df2f8eec-cb00-447c-8652-21fd556d7b2d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:32:30', NULL, NULL, 0, NULL, NULL),
(170, 280.00, 'Random Game', 'GAME-419', 'User-671', 'dd89f1d9-cd5f-404e-b5f0-a7446d1bacc2', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:32:50', NULL, NULL, 0, NULL, NULL),
(171, 1028.00, 'Random Game', 'GAME-553', 'User-463', '07b699a0-d463-4c80-8cf2-77a6ca04ff91', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:32:50', NULL, NULL, 0, NULL, NULL),
(172, 705.00, 'Random Game', 'GAME-706', 'User-958', '76e6c93d-b458-4834-85c4-a6f1ad7e6a38', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:33:10', NULL, NULL, 0, NULL, NULL),
(173, 961.00, 'Random Game', 'GAME-60', 'User-371', '07d0900b-83d5-4deb-8a8c-7adef89bdff5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:33:10', NULL, NULL, 0, NULL, NULL),
(174, 667.00, 'Random Game', 'GAME-609', 'User-729', 'eaed75d0-9711-4f51-9982-555f254cea16', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:33:30', NULL, NULL, 0, NULL, NULL),
(175, 323.00, 'Random Game', 'GAME-98', 'User-34', 'a393ef48-a736-448e-979d-ef616ec074ea', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:33:30', NULL, NULL, 0, NULL, NULL),
(176, 675.00, 'Random Game', 'GAME-655', 'User-926', '839e9623-afc9-4305-9df5-5dfeca2f1089', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:33:46', NULL, NULL, 0, NULL, NULL),
(177, 727.00, 'Random Game', 'GAME-443', 'User-748', 'ddb5e35e-b5e4-4252-9731-5881012b5d15', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:33:46', NULL, NULL, 0, NULL, NULL),
(178, 666.00, 'Random Game', 'GAME-182', 'User-827', '1d64d900-9e3b-45d6-859b-21ccc3741da8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:34:06', NULL, NULL, 0, NULL, NULL),
(179, 860.00, 'Random Game', 'GAME-146', 'User-725', 'be458c3f-4472-4702-b1fe-bca9c0c68815', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:34:06', NULL, NULL, 0, NULL, NULL),
(180, 806.00, 'Random Game', 'GAME-990', 'User-332', 'e5911ee3-3d7a-47e0-a254-546b09859b67', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:34:26', NULL, NULL, 0, NULL, NULL),
(181, 448.00, 'Random Game', 'GAME-837', 'User-800', 'cad6fc51-a6f4-4fc4-bb1d-19a0f4f6e72e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:34:26', NULL, NULL, 0, NULL, NULL),
(182, 632.00, 'Random Game', 'GAME-995', 'User-221', '3c2ee1b4-8903-4891-9831-14d8ad88461c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:34:46', NULL, NULL, 0, NULL, NULL),
(183, 402.00, 'Random Game', 'GAME-339', 'User-824', 'b7172b27-d60c-413a-a878-353d1d74b03d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:34:46', NULL, NULL, 0, NULL, NULL),
(184, 253.00, 'Random Game', 'GAME-101', 'User-750', '827c171c-9085-4a35-9e41-71fcf9607436', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:35:06', NULL, NULL, 0, NULL, NULL),
(185, 438.00, 'Random Game', 'GAME-241', 'User-700', '7fe993d2-31aa-42e5-ac05-e958bdf2636e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:35:06', NULL, NULL, 0, NULL, NULL),
(186, 76.00, 'Random Game', 'GAME-805', 'User-951', 'f544c93c-5e0c-43b0-acbe-eb3612b4218e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:35:26', NULL, NULL, 0, NULL, NULL),
(187, 617.00, 'Random Game', 'GAME-216', 'User-833', '1d6fbffb-ebb9-4d7a-ba44-aed812f9ce65', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:35:26', NULL, NULL, 0, NULL, NULL),
(188, 973.00, 'Random Game', 'GAME-938', 'User-49', 'ed5bf395-a83c-4063-b5fa-2f28784a1ddb', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:35:46', NULL, NULL, 0, NULL, NULL),
(189, 791.00, 'Random Game', 'GAME-56', 'User-384', '98e160d1-198e-471d-ba83-6f1afd0456e5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:35:46', NULL, NULL, 0, NULL, NULL),
(190, 683.00, 'Random Game', 'GAME-786', 'User-148', 'f19e749c-4e7a-47d0-bc42-80ea3c0bfb84', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:36:06', NULL, NULL, 0, NULL, NULL),
(191, 619.00, 'Random Game', 'GAME-743', 'User-308', '99e53cbf-98a9-4699-958d-44afd1521916', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:36:06', NULL, NULL, 0, NULL, NULL),
(192, 328.00, 'Random Game', 'GAME-122', 'User-625', '7cb7f51c-d31e-4333-95b6-3c8e7cd153a5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:36:27', NULL, NULL, 0, NULL, NULL),
(193, 183.00, 'Random Game', 'GAME-806', 'User-893', '77e95ac3-f7ed-4dae-ae87-a16c8228ff27', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:36:27', NULL, NULL, 0, NULL, NULL),
(194, 559.00, 'Random Game', 'GAME-521', 'User-958', '4592f39a-a8ce-4960-89af-e0ef95d192d2', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:36:47', NULL, NULL, 0, NULL, NULL),
(195, 420.00, 'Random Game', 'GAME-22', 'User-242', '5ef8ec97-ec9c-4c04-a256-ab20ae288962', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:36:47', NULL, NULL, 0, NULL, NULL),
(196, 857.00, 'Random Game', 'GAME-759', 'User-167', '15c922fe-e946-4689-b5c2-745bd26d0e45', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:37:07', NULL, NULL, 0, NULL, NULL),
(197, 474.00, 'Random Game', 'GAME-365', 'User-57', '740561aa-56c9-48f0-bbb5-355f2f395de6', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:37:07', NULL, NULL, 0, NULL, NULL),
(198, 457.00, 'Random Game', 'GAME-196', 'User-19', '0bd5ddc8-1be2-4f39-970c-02315a5ef17e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:38:07', NULL, NULL, 0, NULL, NULL),
(199, 1022.00, 'Random Game', 'GAME-891', 'User-553', '5d8a4b9e-4f1c-4de3-979d-4b82a4d511d8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:38:07', NULL, NULL, 0, NULL, NULL),
(200, 430.00, 'Random Game', 'GAME-457', 'User-991', '06d81f94-0d2e-42da-9f11-c22390c9e766', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:39:07', NULL, NULL, 0, NULL, NULL),
(201, 440.00, 'Random Game', 'GAME-547', 'User-214', 'a9dc34b9-a950-4612-9848-85d37eb04b15', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:39:07', NULL, NULL, 0, NULL, NULL),
(202, 898.00, 'Random Game', 'GAME-234', 'User-30', '7d51099c-54c8-401e-867a-545efb3bd485', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:40:07', NULL, NULL, 0, NULL, NULL),
(203, 1021.00, 'Random Game', 'GAME-312', 'User-547', '829a76a8-aac9-4ea6-a124-ba753f4bf07d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:40:07', NULL, NULL, 0, NULL, NULL),
(204, 658.00, 'Random Game', 'GAME-24', 'User-651', '58514473-0be3-4fe1-a661-48ae03ae0d2d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:41:07', NULL, NULL, 0, NULL, NULL),
(205, 72.00, 'Random Game', 'GAME-52', 'User-928', '9d7af195-e5bf-43b1-a6d7-1a9546b4235d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:41:07', NULL, NULL, 0, NULL, NULL),
(206, 739.00, 'Random Game', 'GAME-450', 'User-288', '684215e7-11cd-40ce-9ea7-9b2c1e369f1c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:42:07', NULL, NULL, 0, NULL, NULL),
(207, 476.00, 'Random Game', 'GAME-168', 'User-750', 'fc694cc7-9411-4e6a-b521-9fe04170eb6b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:42:07', NULL, NULL, 0, NULL, NULL),
(208, 265.00, 'Random Game', 'GAME-822', 'User-80', '2b46aa5a-a021-4d6b-8727-2784215fb3fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:43:07', NULL, NULL, 0, NULL, NULL),
(209, 135.00, 'Random Game', 'GAME-512', 'User-387', 'c18098dc-cb5f-4ec8-a29b-2b03a32d8a49', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:43:07', NULL, NULL, 0, NULL, NULL),
(210, 293.00, 'Random Game', 'GAME-946', 'User-974', 'f684dede-b16f-422d-8d73-10f011c369ad', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:43:33', NULL, NULL, 0, NULL, NULL),
(211, 941.00, 'Random Game', 'GAME-164', 'User-966', 'f8b87409-825b-412d-940f-0c7cfc7d79ad', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:43:33', NULL, NULL, 0, NULL, NULL),
(212, 597.00, 'Random Game', 'GAME-956', 'User-889', '231ab40c-5bfe-443e-b7ea-8798bf3ec1f3', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:43:46', NULL, NULL, 0, NULL, NULL),
(213, 909.00, 'Random Game', 'GAME-87', 'User-24', 'b8505d55-ff18-43ce-a497-dd868222254b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:43:46', NULL, NULL, 0, NULL, NULL),
(214, 237.00, 'Random Game', 'GAME-464', 'User-846', '1dff733b-ead2-4072-81c2-1665630dbbc2', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:44:06', NULL, NULL, 0, NULL, NULL),
(215, 724.00, 'Random Game', 'GAME-564', 'User-319', '0658b3cd-39af-4be2-9dee-20d8488c08f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:44:06', NULL, NULL, 0, NULL, NULL),
(216, 903.00, 'Random Game', 'GAME-240', 'User-162', '609d3404-0ecc-4640-9fa0-2f8909b5cc3d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:44:26', NULL, NULL, 0, NULL, NULL),
(217, 992.00, 'Random Game', 'GAME-246', 'User-793', 'aa35e6ba-4052-4682-a668-75185d024201', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:44:26', NULL, NULL, 0, NULL, NULL),
(218, 800.00, 'Random Game', 'GAME-428', 'User-906', 'b1a602ea-e8e0-4c50-bf42-08cfb35b8892', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:44:46', NULL, NULL, 0, NULL, NULL),
(219, 439.00, 'Random Game', 'GAME-465', 'User-241', '8655daee-944d-4695-ab2e-98a471b51fa3', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:44:46', NULL, NULL, 0, NULL, NULL),
(220, 1036.00, 'Random Game', 'GAME-162', 'User-325', 'f5b2b352-43c6-40a3-897d-458d2e0e6c2b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:45:06', NULL, NULL, 0, NULL, NULL),
(221, 847.00, 'Random Game', 'GAME-376', 'User-337', 'aeae4f8e-cf6c-452e-9958-320fd35f850a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:45:06', NULL, NULL, 0, NULL, NULL),
(222, 81.00, 'Random Game', 'GAME-49', 'User-941', 'd4884257-fcf4-4aad-ba67-46cc88207aa5', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:45:26', NULL, NULL, 0, NULL, NULL),
(223, 660.00, 'Random Game', 'GAME-500', 'User-431', '876458a0-1052-445a-b07f-b5f12688b7fe', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:45:26', NULL, NULL, 0, NULL, NULL),
(224, 92.00, 'Random Game', 'GAME-168', 'User-371', 'f8db9e97-9116-4168-8677-5da2ba5cab69', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:45:46', NULL, NULL, 0, NULL, NULL),
(225, 558.00, 'Random Game', 'GAME-592', 'User-239', 'ad6dd08f-6251-42d0-b924-1230ef92fdb1', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:45:46', NULL, NULL, 0, NULL, NULL),
(226, 222.00, 'Random Game', 'GAME-195', 'User-373', '623e1c27-ec7c-4c47-88fa-5299af9a26c8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:46:06', NULL, NULL, 0, NULL, NULL),
(227, 67.00, 'Random Game', 'GAME-538', 'User-619', '78e6af3d-c9da-40a0-8334-4c56866f8b48', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:46:06', NULL, NULL, 0, NULL, NULL),
(228, 309.00, 'Random Game', 'GAME-25', 'User-508', '29ed3787-4648-4056-ac36-fa65b2134002', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:46:26', NULL, NULL, 0, NULL, NULL),
(229, 360.00, 'Random Game', 'GAME-25', 'User-746', 'a17f07e6-cc2a-4d08-a436-1b03c0ce3e47', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:46:26', NULL, NULL, 0, NULL, NULL),
(230, 645.00, 'Random Game', 'GAME-377', 'User-682', 'af3ffab2-892f-41a4-a784-afc4a9a6f66c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:46:46', NULL, NULL, 0, NULL, NULL),
(231, 199.00, 'Random Game', 'GAME-217', 'User-753', 'c2f21ab3-a832-47bd-a87a-a5956e1a3617', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:46:46', NULL, NULL, 0, NULL, NULL),
(232, 663.00, 'Random Game', 'GAME-377', 'User-913', '358c0dc9-57d6-4dfc-a04a-63335d402f46', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:47:06', NULL, NULL, 0, NULL, NULL),
(233, 723.00, 'Random Game', 'GAME-758', 'User-405', '78193adb-3bc6-4b6d-84ac-efcba0161562', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:47:06', NULL, NULL, 0, NULL, NULL),
(234, 314.00, 'Random Game', 'GAME-566', 'User-115', '7ab57ed6-4450-441a-a143-d18f04a2ab7b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:47:26', NULL, NULL, 0, NULL, NULL),
(235, 883.00, 'Random Game', 'GAME-254', 'User-903', '75d93448-c049-4d42-8a7d-3cf0f0a1e11a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:47:26', NULL, NULL, 0, NULL, NULL),
(236, 577.00, 'Random Game', 'GAME-428', 'User-476', '087ccffe-46d0-4203-8c52-ce7b7857e9e7', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:47:46', NULL, NULL, 0, NULL, NULL),
(237, 803.00, 'Random Game', 'GAME-447', 'User-932', '31cf9de6-16b1-4295-8de4-07b4c7123e37', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:47:46', NULL, NULL, 0, NULL, NULL),
(238, 454.00, 'Random Game', 'GAME-149', 'User-532', '6d1bc67c-169c-45ab-8752-6cd461731769', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:48:06', NULL, NULL, 0, NULL, NULL),
(239, 422.00, 'Random Game', 'GAME-121', 'User-805', 'c871b957-cd95-44ba-b9e6-25aa222c17eb', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:48:06', NULL, NULL, 0, NULL, NULL),
(240, 619.00, 'Random Game', 'GAME-197', 'User-613', '48ee4ba9-0dd5-41ed-9729-01544d09c545', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:48:26', NULL, NULL, 0, NULL, NULL),
(241, 572.00, 'Random Game', 'GAME-751', 'User-364', 'fd1a6356-e751-4c44-b517-b171563f1615', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:48:26', NULL, NULL, 0, NULL, NULL),
(242, 945.00, 'Random Game', 'GAME-967', 'User-131', '8c40f39d-a2ae-4b9f-bcdc-f1d31e0ad1f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:48:46', NULL, NULL, 0, NULL, NULL),
(243, 640.00, 'Random Game', 'GAME-875', 'User-785', 'dac733b2-e553-4736-b166-d03893b8fdd8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:48:46', NULL, NULL, 0, NULL, NULL),
(244, 823.00, 'Random Game', 'GAME-319', 'User-419', 'c1c31368-57d1-40bd-b29d-a8bc957709fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:49:06', NULL, NULL, 0, NULL, NULL),
(245, 626.00, 'Random Game', 'GAME-131', 'User-184', 'd9d0f218-51af-4959-9306-268a1e549633', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:49:06', NULL, NULL, 0, NULL, NULL),
(246, 205.00, 'Random Game', 'GAME-358', 'User-238', '64fc656c-2aa3-4652-b9bd-1021e08adf59', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:49:26', NULL, NULL, 0, NULL, NULL),
(247, 313.00, 'Random Game', 'GAME-91', 'User-252', 'f2a25998-1a39-486d-a683-4c0c9b16f2c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:49:26', NULL, NULL, 0, NULL, NULL),
(248, 507.00, 'Random Game', 'GAME-102', 'User-83', '592581f1-d64b-4ad8-ac60-0a6c3e9c7dd4', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:49:46', NULL, NULL, 0, NULL, NULL),
(249, 663.00, 'Random Game', 'GAME-350', 'User-180', 'a7536591-081a-4273-be01-59ecbe77c952', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:49:46', NULL, NULL, 0, NULL, NULL),
(250, 988.00, 'Random Game', 'GAME-798', 'User-192', '23f3e903-4cf9-4955-be29-d3535e3e9b2f', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:50:06', NULL, NULL, 0, NULL, NULL),
(251, 272.00, 'Random Game', 'GAME-652', 'User-28', 'b498843a-ed83-4a41-9c0b-882dee5c7e3e', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:50:06', NULL, NULL, 0, NULL, NULL),
(252, 1019.00, 'Random Game', 'GAME-356', 'User-772', '0546793d-6ded-446d-a197-e5be1914745a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:50:26', NULL, NULL, 0, NULL, NULL),
(253, 565.00, 'Random Game', 'GAME-807', 'User-170', '4009621d-c01a-47a1-9fd0-a4c1d413931d', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:50:26', NULL, NULL, 0, NULL, NULL),
(254, 869.00, 'Random Game', 'GAME-138', 'User-816', 'c22c9f1e-803d-4a6f-8355-a2626cdf33c4', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:50:46', NULL, NULL, 0, NULL, NULL),
(255, 95.00, 'Random Game', 'GAME-220', 'User-910', '0ebccf56-1685-4ed9-ae89-2048de0963bb', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:50:46', NULL, NULL, 0, NULL, NULL),
(256, 593.00, 'Random Game', 'GAME-363', 'User-610', '41659ebf-68b2-4133-be39-3a99aa6efb9b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:51:06', NULL, NULL, 0, NULL, NULL),
(257, 792.00, 'Random Game', 'GAME-153', 'User-553', 'd5c27c6e-5cb9-4421-8897-dd35db1224c1', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:51:06', NULL, NULL, 0, NULL, NULL),
(258, 333.00, 'Random Game', 'GAME-376', 'User-833', 'ae79dd8e-5d04-4f4f-bfc5-405e6a20d9ce', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:51:26', NULL, NULL, 0, NULL, NULL),
(259, 534.00, 'Random Game', 'GAME-838', 'User-854', '54818232-ac43-4a32-af10-77fc67a0886c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:51:26', NULL, NULL, 0, NULL, NULL),
(260, 1006.00, 'Random Game', 'GAME-941', 'User-902', 'fc6be89b-6b02-4d62-8328-85680b45725f', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:51:46', NULL, NULL, 0, NULL, NULL),
(261, 295.00, 'Random Game', 'GAME-881', 'User-957', '52671f23-7ca9-4e8f-9c69-7e72adcd99ec', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:51:46', NULL, NULL, 0, NULL, NULL),
(262, 850.00, 'Random Game', 'GAME-0', 'User-31', 'df299aa7-7078-4064-b395-cc7a77c2b8b8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:52:06', NULL, NULL, 0, NULL, NULL),
(263, 932.00, 'Random Game', 'GAME-373', 'User-49', '1e16bc2e-eb9c-4a4e-a672-9659547fd29c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:52:06', NULL, NULL, 0, NULL, NULL),
(264, 343.00, 'Random Game', 'GAME-238', 'User-69', '020ccd9e-d8e4-4572-a8f0-fb1c2423233c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:52:26', NULL, NULL, 0, NULL, NULL),
(265, 196.00, 'Random Game', 'GAME-842', 'User-336', 'db7d43ba-73de-426d-b072-a92a33a9a57b', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:52:26', NULL, NULL, 0, NULL, NULL),
(266, 1025.00, 'Random Game', 'GAME-744', 'User-120', '6387bd71-7689-40b2-83e6-42f9677d0ea4', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:52:47', NULL, NULL, 0, NULL, NULL),
(267, 213.00, 'Random Game', 'GAME-289', 'User-526', '66246790-71db-4f1b-97ca-66554da73c8a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:52:47', NULL, NULL, 0, NULL, NULL),
(268, 849.00, 'Random Game', 'GAME-930', 'User-301', '9ed648aa-1006-4d2d-bc16-aaa8250cbd55', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:53:07', NULL, NULL, 0, NULL, NULL),
(269, 290.00, 'Random Game', 'GAME-621', 'User-373', '21b5ac1b-c91e-4939-8312-cce9b08e5dcb', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:53:07', NULL, NULL, 0, NULL, NULL),
(270, 136.00, 'Random Game', 'GAME-848', 'User-699', '73b87121-40eb-4a9c-a751-9adf75c5f631', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:53:27', NULL, NULL, 0, NULL, NULL),
(271, 83.00, 'Random Game', 'GAME-471', 'User-467', '86158d20-af66-48b3-95f3-56b4d77f0cf8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:53:27', NULL, NULL, 0, NULL, NULL),
(272, 521.00, 'Random Game', 'GAME-496', 'User-658', '0c2ee3c1-5d64-4d03-aa38-82c35a83e3f2', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:54:07', NULL, NULL, 0, NULL, NULL),
(273, 483.00, 'Random Game', 'GAME-989', 'User-237', 'e465e661-de4b-4277-9366-670e715367ec', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:54:07', NULL, NULL, 0, NULL, NULL),
(274, 284.00, 'Random Game', 'GAME-919', 'User-727', '7892bbfe-2d03-4c5d-a394-e532224fb733', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:55:07', NULL, NULL, 0, NULL, NULL),
(275, 817.00, 'Random Game', 'GAME-788', 'User-243', 'ba984f79-5a44-4b35-bb5d-35ece6dfe529', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:55:07', NULL, NULL, 0, NULL, NULL),
(276, 339.00, 'Random Game', 'GAME-272', 'User-334', 'b66d85f2-1b3a-42d3-839b-1891e82f8291', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:56:07', NULL, NULL, 0, NULL, NULL),
(277, 821.00, 'Random Game', 'GAME-545', 'User-785', '369e7e91-7628-44fc-a203-045e96fa65d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:56:07', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(278, 183.00, 'Random Game', 'GAME-93', 'User-851', 'e7b029c0-7078-4b8b-8d4c-1b35fb9695a7', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:57:07', NULL, NULL, 0, NULL, NULL),
(279, 111.00, 'Random Game', 'GAME-52', 'User-96', '7b29ad46-7d2d-4e00-99ba-d3bc4b9086cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:57:07', NULL, NULL, 0, NULL, NULL),
(280, 675.00, 'Random Game', 'GAME-371', 'User-190', '49ef72d5-d432-4c1d-a90e-1b556eb0a86c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:58:07', NULL, NULL, 0, NULL, NULL),
(281, 942.00, 'Random Game', 'GAME-663', 'User-336', '7e965531-049f-4701-9d4b-27199200baf8', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:58:07', NULL, NULL, 0, NULL, NULL),
(282, 411.00, 'Random Game', 'GAME-367', 'User-156', '1bac353d-85e3-473c-afdc-649d4f667462', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:59:07', NULL, NULL, 0, NULL, NULL),
(283, 277.00, 'Random Game', 'GAME-993', 'User-817', 'feaa3887-d952-4b04-a63d-032d829fa7ea', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:59:07', NULL, NULL, 0, NULL, NULL),
(284, 144.00, 'Random Game', 'GAME-112', 'User-339', 'a4d93e0e-ecfb-4b35-a11e-faa6f7e37053', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:59:55', NULL, NULL, 0, NULL, NULL),
(285, 605.00, 'Random Game', 'GAME-844', 'User-957', '3bb1b25c-ded2-4e80-b379-5642aecb6a54', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:59:55', NULL, NULL, 0, NULL, NULL),
(286, 638.00, 'Random Game', 'GAME-202', 'User-559', '995c15cc-1374-4b64-9f43-03524161a86c', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:59:59', NULL, NULL, 0, NULL, NULL),
(287, 817.00, 'Random Game', 'GAME-668', 'User-313', '467cee05-6e6d-4822-9f96-7d3da4a1448a', 19, 'pending_validation', NULL, NULL, '2025-04-09 08:59:59', NULL, NULL, 0, NULL, NULL),
(288, 147.00, 'Random Game', 'GAME-34', 'User-283', '908eebae-b36b-4647-beb3-20050b4f21bd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:07', NULL, NULL, 0, NULL, NULL),
(289, 70.00, 'Random Game', 'GAME-354', 'User-966', '27582714-31f6-43dd-8cd4-8aba7893287d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:07', NULL, NULL, 0, NULL, NULL),
(290, 476.00, 'Random Game', 'GAME-288', 'User-112', '1abbcc3c-765d-41f6-98ec-dbe1d27e0a0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:19', NULL, NULL, 0, NULL, NULL),
(291, 792.00, 'Random Game', 'GAME-917', 'User-475', '64484937-6854-4004-ab70-07a096f173a3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:19', NULL, NULL, 0, NULL, NULL),
(292, 192.00, 'Random Game', 'GAME-936', 'User-724', 'b32828f3-5d32-40b2-9397-11e7d1fe324d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:26', NULL, NULL, 0, NULL, NULL),
(293, 190.00, 'Random Game', 'GAME-960', 'User-879', 'ddfe4897-d395-46f1-9897-5db7fd9f2886', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:26', NULL, NULL, 0, NULL, NULL),
(294, 429.00, 'Random Game', 'GAME-597', 'User-994', '1e9b15b1-5296-4f24-b6c1-d908e57daa53', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:40', NULL, NULL, 0, NULL, NULL),
(295, 590.00, 'Random Game', 'GAME-310', 'User-277', '1a6b6b63-d0ef-46a9-bbef-4bb67cd6a54e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:40', NULL, NULL, 0, NULL, NULL),
(296, 559.00, 'Random Game', 'GAME-651', 'User-767', '25a0e52f-41fc-4f58-b607-9341a81f2e11', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:47', NULL, NULL, 0, NULL, NULL),
(297, 851.00, 'Random Game', 'GAME-755', 'User-463', 'f1af0a14-8077-47e2-8e34-95fc845badde', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:00:47', NULL, NULL, 0, NULL, NULL),
(298, 257.00, 'Random Game', 'GAME-601', 'User-381', 'f2a99534-677e-4301-bcf1-234079c5c722', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:01:00', NULL, NULL, 0, NULL, NULL),
(299, 343.00, 'Random Game', 'GAME-315', 'User-514', '90119911-420a-4e80-a3bf-8c634776e53a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:01:00', NULL, NULL, 0, NULL, NULL),
(300, 1046.00, 'Random Game', 'GAME-806', 'User-950', 'f1816bfd-ab27-453f-93ec-680e7b3b6136', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:01:07', NULL, NULL, 0, NULL, NULL),
(301, 779.00, 'Random Game', 'GAME-68', 'User-241', '46cc6fdc-4845-46d8-b2f8-93ee2b2f617d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:01:07', NULL, NULL, 0, NULL, NULL),
(302, 1035.00, 'Random Game', 'GAME-105', 'User-839', '6fb2810d-86bf-40e2-80aa-c76168e5117b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:01:20', NULL, NULL, 0, NULL, NULL),
(303, 633.00, 'Random Game', 'GAME-40', 'User-284', '07077b20-6eda-4840-acb0-2a7af9fdfab4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:01:20', NULL, NULL, 0, NULL, NULL),
(304, 539.00, 'Random Game', 'GAME-728', 'User-424', '41771931-ebd7-4c8c-bc75-5984af8b5510', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:07', NULL, NULL, 0, NULL, NULL),
(305, 164.00, 'Random Game', 'GAME-16', 'User-611', 'a22dcfc4-a121-4935-b65c-7c9642b58bd9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:07', NULL, NULL, 0, NULL, NULL),
(306, 641.00, 'Random Game', 'GAME-464', 'User-597', '099a7a1a-5cb3-4432-9fb7-602389edb1dd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:07', NULL, NULL, 0, NULL, NULL),
(307, 396.00, 'Random Game', 'GAME-853', 'User-175', '7a3b4b34-56cb-4e5a-b226-1f45d247ebad', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:07', NULL, NULL, 0, NULL, NULL),
(308, 67.00, 'Random Game', 'GAME-714', 'User-373', '0c290434-ac2b-4026-8664-0635ca7b4b1c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:34', NULL, NULL, 0, NULL, NULL),
(309, 79.00, 'Random Game', 'GAME-593', 'User-368', 'f1e09b3b-df45-4102-819d-0555529836b9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:34', NULL, NULL, 0, NULL, NULL),
(310, 430.00, 'Random Game', 'GAME-313', 'User-397', 'a8b92e41-bb03-4373-a44f-b01b1e535f25', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:34', NULL, NULL, 0, NULL, NULL),
(311, 515.00, 'Random Game', 'GAME-35', 'User-306', '8327fa11-6c87-4921-a61d-cf33a87068d2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:34', NULL, NULL, 0, NULL, NULL),
(312, 988.00, 'Random Game', 'GAME-818', 'User-628', 'ca58d05d-0615-43a7-9241-b10cc62bfe0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:39', NULL, NULL, 0, NULL, NULL),
(313, 690.00, 'Random Game', 'GAME-375', 'User-43', '8bb86b4d-d586-4c24-a0f1-c849c25e0ac8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:39', NULL, NULL, 0, NULL, NULL),
(314, 984.00, 'Random Game', 'GAME-375', 'User-881', '85630934-f6c1-4061-9191-e82ee580dada', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:46', NULL, NULL, 0, NULL, NULL),
(315, 602.00, 'Random Game', 'GAME-624', 'User-867', '0646ced8-4150-47e1-8c7f-e36cd811cdbc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:46', NULL, NULL, 0, NULL, NULL),
(316, 50.00, 'Random Game', 'GAME-624', 'User-14', '8a2e13c8-fe34-41ad-be2f-9835458a6777', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:59', NULL, NULL, 0, NULL, NULL),
(317, 612.00, 'Random Game', 'GAME-454', 'User-903', 'a2a42e23-fe10-413a-b2a6-33298db0176a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:02:59', NULL, NULL, 0, NULL, NULL),
(318, 892.00, 'Random Game', 'GAME-866', 'User-803', '800138a9-bba6-4851-b0d1-77381b14dbfb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:06', NULL, NULL, 0, NULL, NULL),
(319, 854.00, 'Random Game', 'GAME-903', 'User-115', 'f9406417-c859-427a-a817-c363ab51e9fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:06', NULL, NULL, 0, NULL, NULL),
(320, 407.00, 'Random Game', 'GAME-848', 'User-755', '34130a9f-f327-4b5a-90fb-211af140a365', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:20', NULL, NULL, 0, NULL, NULL),
(321, 903.00, 'Random Game', 'GAME-722', 'User-661', 'bb9b6b6b-f074-44b2-b107-a705c997b616', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:20', NULL, NULL, 0, NULL, NULL),
(322, 75.00, 'Random Game', 'GAME-873', 'User-382', '328c0529-3011-4dc8-a971-d44a99287b9b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:26', NULL, NULL, 0, NULL, NULL),
(323, 632.00, 'Random Game', 'GAME-806', 'User-867', '6bd85519-87a5-4f0c-875d-34ca35a6891d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:26', NULL, NULL, 0, NULL, NULL),
(324, 110.00, 'Random Game', 'GAME-538', 'User-249', 'abc4e4e9-5ec9-468b-8577-ce08cd63bf24', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:40', NULL, NULL, 0, NULL, NULL),
(325, 774.00, 'Random Game', 'GAME-905', 'User-545', '89ba82fe-eeba-4937-bbb0-412b8087b27d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:40', NULL, NULL, 0, NULL, NULL),
(326, 592.00, 'Random Game', 'GAME-696', 'User-292', '3f958184-bde0-403d-aae1-7cd9d472e034', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:46', NULL, NULL, 0, NULL, NULL),
(327, 233.00, 'Random Game', 'GAME-754', 'User-265', '5cf968df-59d1-4a22-9711-de91b07303fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:46', NULL, NULL, 0, NULL, NULL),
(328, 538.00, 'Random Game', 'GAME-946', 'User-308', 'ff374cb3-e9a6-476b-9838-298731245482', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:59', NULL, NULL, 0, NULL, NULL),
(329, 304.00, 'Random Game', 'GAME-569', 'User-606', '4272aee7-c54c-431f-a541-22b8715008b5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:03:59', NULL, NULL, 0, NULL, NULL),
(330, 389.00, 'Random Game', 'GAME-675', 'User-901', '69ad652b-4105-4c0f-84a5-c9bd417717f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:06', NULL, NULL, 0, NULL, NULL),
(331, 684.00, 'Random Game', 'GAME-525', 'User-459', 'cd6a1d1b-b107-4c48-9a8f-2ab4dcf40d94', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:06', NULL, NULL, 0, NULL, NULL),
(332, 503.00, 'Random Game', 'GAME-983', 'User-363', '1a711ef8-24dd-4489-b985-98f2140418fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:19', NULL, NULL, 0, NULL, NULL),
(333, 969.00, 'Random Game', 'GAME-305', 'User-564', '5ae98b1c-60ca-4a06-8ad9-48df1bd98cc0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:19', NULL, NULL, 0, NULL, NULL),
(334, 600.00, 'Random Game', 'GAME-779', 'User-955', 'e8de2352-c318-4784-8b65-05a842b5ca1d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:26', NULL, NULL, 0, NULL, NULL),
(335, 747.00, 'Random Game', 'GAME-943', 'User-835', 'e3d6f87f-ff54-4be2-9e27-c6f8d17fbff2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:26', NULL, NULL, 0, NULL, NULL),
(336, 236.00, 'Random Game', 'GAME-62', 'User-776', 'bbe12314-f45e-484f-a871-ce2822a4d4c9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:39', NULL, NULL, 0, NULL, NULL),
(337, 873.00, 'Random Game', 'GAME-343', 'User-873', 'eccffb52-4112-4ab4-90a1-a492b93752c9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:39', NULL, NULL, 0, NULL, NULL),
(338, 217.00, 'Random Game', 'GAME-805', 'User-413', 'e7038679-b99f-442d-9aad-f7573832370c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:47', NULL, NULL, 0, NULL, NULL),
(339, 815.00, 'Random Game', 'GAME-364', 'User-587', '07a7f8a1-7b39-4077-8959-e486f0a5dcfd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:47', NULL, NULL, 0, NULL, NULL),
(340, 1003.00, 'Random Game', 'GAME-560', 'User-996', 'df4e9591-b6a2-4e12-aa5a-1f5638514a23', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:59', NULL, NULL, 0, NULL, NULL),
(341, 978.00, 'Random Game', 'GAME-342', 'User-297', '620a9b86-ee47-448f-8a7a-b41c40427328', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:04:59', NULL, NULL, 0, NULL, NULL),
(342, 727.00, 'Random Game', 'GAME-771', 'User-709', '6aedd8bf-3732-405a-91d3-6adeccd9d6ec', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:06', NULL, NULL, 0, NULL, NULL),
(343, 175.00, 'Random Game', 'GAME-694', 'User-295', 'e293d05d-f640-449f-bda7-5807f0279cd6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:06', NULL, NULL, 0, NULL, NULL),
(344, 1047.00, 'Random Game', 'GAME-828', 'User-955', '65254dff-2c72-4a6f-86ae-1df6afc01810', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:20', NULL, NULL, 0, NULL, NULL),
(345, 139.00, 'Random Game', 'GAME-124', 'User-526', 'bf7bb9c6-60cd-4dde-9e76-a7e0096dfdbf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:20', NULL, NULL, 0, NULL, NULL),
(346, 856.00, 'Random Game', 'GAME-866', 'User-528', '784ff223-fab3-4d5a-9c0d-4b2d2f2f5606', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:27', NULL, NULL, 0, NULL, NULL),
(347, 743.00, 'Random Game', 'GAME-231', 'User-814', '837bced1-d9df-4f4f-8397-d7d40fb5e50c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:27', NULL, NULL, 0, NULL, NULL),
(348, 455.00, 'Random Game', 'GAME-520', 'User-518', '71a091b1-451a-4b1c-aae2-8cc32095762f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:40', NULL, NULL, 0, NULL, NULL),
(349, 422.00, 'Random Game', 'GAME-653', 'User-825', 'b51efec1-6a1d-4225-9baa-a24c548014c5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:40', NULL, NULL, 0, NULL, NULL),
(350, 1007.00, 'Random Game', 'GAME-652', 'User-448', 'bdafa1e9-0aef-400b-a8b4-751cc51f50de', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:47', NULL, NULL, 0, NULL, NULL),
(351, 310.00, 'Random Game', 'GAME-679', 'User-322', 'a5c619f5-8ff0-4717-9672-063bac2735e3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:05:47', NULL, NULL, 0, NULL, NULL),
(352, 830.00, 'Random Game', 'GAME-651', 'User-378', '8d462661-16ee-4599-be9c-81ec92a5e58b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:00', NULL, NULL, 0, NULL, NULL),
(353, 831.00, 'Random Game', 'GAME-235', 'User-321', '7cd4f22d-f7d2-4b04-92ee-5531cbf3db91', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:00', NULL, NULL, 0, NULL, NULL),
(354, 304.00, 'Random Game', 'GAME-941', 'User-921', '9bcba8b6-7ab7-4a83-b660-8824f8ebb140', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:06', NULL, NULL, 0, NULL, NULL),
(355, 692.00, 'Random Game', 'GAME-544', 'User-723', '0607d314-3115-449a-bb46-e0acfea0b1b1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:06', NULL, NULL, 0, NULL, NULL),
(356, 864.00, 'Random Game', 'GAME-512', 'User-500', '170964ef-636e-4307-ba70-00091cbdc2cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:20', NULL, NULL, 0, NULL, NULL),
(357, 136.00, 'Random Game', 'GAME-889', 'User-469', '4cbc4c07-bb40-4098-ad83-10e73ddb871d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:20', NULL, NULL, 0, NULL, NULL),
(358, 779.00, 'Random Game', 'GAME-601', 'User-122', '6f45c95e-da70-49ef-b9a5-91e68f9354bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:27', NULL, NULL, 0, NULL, NULL),
(359, 272.00, 'Random Game', 'GAME-128', 'User-489', 'd6df550f-cf2a-4fe2-a7cd-891996a88ac7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:27', NULL, NULL, 0, NULL, NULL),
(360, 876.00, 'Random Game', 'GAME-767', 'User-490', '1af607a5-55ea-44cc-a04b-8dfb56ec8b18', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:40', NULL, NULL, 0, NULL, NULL),
(361, 944.00, 'Random Game', 'GAME-675', 'User-883', '1574d295-7048-40b8-9882-d3c0f2f7760e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:40', NULL, NULL, 0, NULL, NULL),
(362, 544.00, 'Random Game', 'GAME-454', 'User-88', '14044cec-b8a5-4ae4-9739-802b3ac469dc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:47', NULL, NULL, 0, NULL, NULL),
(363, 62.00, 'Random Game', 'GAME-3', 'User-133', '4c4b3909-1e9d-4afd-9fc6-3c2d0be49746', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:06:47', NULL, NULL, 0, NULL, NULL),
(364, 694.00, 'Random Game', 'GAME-440', 'User-203', '07c743c1-5a36-4334-a915-f047b4d60b33', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:00', NULL, NULL, 0, NULL, NULL),
(365, 635.00, 'Random Game', 'GAME-467', 'User-772', 'fea6a3f3-d44f-419c-a2c7-fe11f7de3829', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:00', NULL, NULL, 0, NULL, NULL),
(366, 642.00, 'Random Game', 'GAME-655', 'User-425', '6a8921e5-a2fc-46c0-a0e0-b079504d02e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:07', NULL, NULL, 0, NULL, NULL),
(367, 783.00, 'Random Game', 'GAME-345', 'User-88', '43e0bf53-6536-4a13-8b40-778a8dab18a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:07', NULL, NULL, 0, NULL, NULL),
(368, 804.00, 'Random Game', 'GAME-648', 'User-781', 'aaf471f4-8be4-42c0-8cb7-704df10a5b1d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:20', NULL, NULL, 0, NULL, NULL),
(369, 960.00, 'Random Game', 'GAME-649', 'User-964', '875711a9-5e5b-46cc-aca6-9bab5309ec26', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:20', NULL, NULL, 0, NULL, NULL),
(370, 923.00, 'Random Game', 'GAME-939', 'User-796', '186a7e55-54b6-406a-8511-68d9bf29f737', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:27', NULL, NULL, 0, NULL, NULL),
(371, 135.00, 'Random Game', 'GAME-29', 'User-421', 'c7e00c9e-457f-4957-ba5c-078d1ad2c864', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:27', NULL, NULL, 0, NULL, NULL),
(372, 335.00, 'Random Game', 'GAME-108', 'User-75', 'f3275c7a-fdb2-439b-9144-440cfc4a3cc0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:40', NULL, NULL, 0, NULL, NULL),
(373, 951.00, 'Random Game', 'GAME-357', 'User-219', '1a35f729-43cb-42f4-8b81-71c2cc837848', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:40', NULL, NULL, 0, NULL, NULL),
(374, 358.00, 'Random Game', 'GAME-838', 'User-743', '357f9a8b-cfae-44fd-b49c-6a7240c7c338', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:47', NULL, NULL, 0, NULL, NULL),
(375, 853.00, 'Random Game', 'GAME-818', 'User-195', '29fae534-debd-43ef-98ba-424d71fb27d9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:07:47', NULL, NULL, 0, NULL, NULL),
(376, 895.00, 'Random Game', 'GAME-249', 'User-143', '0565c386-28ba-4cc7-beab-209d08098a3d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:08:00', NULL, NULL, 0, NULL, NULL),
(377, 625.00, 'Random Game', 'GAME-305', 'User-623', 'c570beb2-cd4d-4849-a9d2-f6aa6534bb62', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:08:00', NULL, NULL, 0, NULL, NULL),
(378, 585.00, 'Random Game', 'GAME-282', 'User-26', '2c55cb7e-8d17-4b0c-950b-ed4770a3b609', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:08:07', NULL, NULL, 0, NULL, NULL),
(379, 173.00, 'Random Game', 'GAME-783', 'User-27', '5d8c7210-cdcd-4b0c-9994-09b8aae29b68', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:08:07', NULL, NULL, 0, NULL, NULL),
(380, 360.00, 'Random Game', 'GAME-951', 'User-510', 'de28b896-a1e6-4803-ab39-38e8f95d08f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:09:07', NULL, NULL, 0, NULL, NULL),
(381, 674.00, 'Random Game', 'GAME-925', 'User-472', '4835ab15-fbfa-4ec7-8118-f99b8b19394b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:09:07', NULL, NULL, 0, NULL, NULL),
(382, 568.00, 'Random Game', 'GAME-52', 'User-162', 'a9d1cc5b-acf8-4188-a48d-ebc08643ccf0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:09:07', NULL, NULL, 0, NULL, NULL),
(383, 351.00, 'Random Game', 'GAME-553', 'User-342', 'e2f24bf5-02c9-4d72-ba41-1ce79cc25e0d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:09:07', NULL, NULL, 0, NULL, NULL),
(384, 308.00, 'Random Game', 'GAME-888', 'User-822', 'fad8d5af-068f-40a4-822b-6837e67ee783', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:10:07', NULL, NULL, 0, NULL, NULL),
(385, 550.00, 'Random Game', 'GAME-679', 'User-400', '1f205e6d-4961-461b-9440-d4b5c81c7d7d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:10:07', NULL, NULL, 0, NULL, NULL),
(386, 866.00, 'Random Game', 'GAME-117', 'User-35', '69bbbefc-8631-46b0-907d-fbec16f9cf28', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:10:07', NULL, NULL, 0, NULL, NULL),
(387, 87.00, 'Random Game', 'GAME-871', 'User-695', 'beb63c4f-1d6b-458d-aaa5-f68c34b2f5e4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:10:07', NULL, NULL, 0, NULL, NULL),
(388, 548.00, 'Random Game', 'GAME-762', 'User-762', 'f93b1bca-dae3-4bb5-8cd9-0f904c9f03e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:07', NULL, NULL, 0, NULL, NULL),
(389, 520.00, 'Random Game', 'GAME-61', 'User-372', '09f5ef2b-94d4-4de5-a1b2-b9ad55845f42', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:07', NULL, NULL, 0, NULL, NULL),
(390, 825.00, 'Random Game', 'GAME-444', 'User-563', '479905d7-b2d1-4e62-9f7b-a0709be15d7e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:07', NULL, NULL, 0, NULL, NULL),
(391, 865.00, 'Random Game', 'GAME-849', 'User-886', 'c7040271-0f3f-4815-895b-ac8c628d83ee', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:07', NULL, NULL, 0, NULL, NULL),
(392, 957.00, 'Random Game', 'GAME-93', 'User-663', '5432f743-c5ce-4af7-a869-f67d26b8f166', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:52', NULL, NULL, 0, NULL, NULL),
(393, 308.00, 'Random Game', 'GAME-482', 'User-817', '43569ee8-dd5c-47a9-a859-4d292025daf7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:55', NULL, NULL, 0, NULL, NULL),
(394, 784.00, 'Random Game', 'GAME-477', 'User-996', '8240ecb9-54cd-4b68-b368-73d855720603', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:55', NULL, NULL, 0, NULL, NULL),
(395, 253.00, 'Random Game', 'GAME-861', 'User-158', '19bec93a-d2fe-4c05-bf66-9f94faf04f5a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:55', NULL, NULL, 0, NULL, NULL),
(396, 510.00, 'Random Game', 'GAME-567', 'User-698', '354a4ed8-e03f-4493-8a1a-75a8ed2e3782', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:55', NULL, NULL, 0, NULL, NULL),
(397, 551.00, 'Random Game', 'GAME-99', 'User-388', '927e090a-3b9e-44f8-a80d-31985b8f410e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:59', NULL, NULL, 0, NULL, NULL),
(398, 396.00, 'Random Game', 'GAME-558', 'User-400', '87f714aa-83f3-4bce-9f69-6cec5a6e827d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:11:59', NULL, NULL, 0, NULL, NULL),
(399, 662.00, 'Random Game', 'GAME-811', 'User-49', 'edcdc081-4755-4502-a54f-5def347d548a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:07', NULL, NULL, 0, NULL, NULL),
(400, 866.00, 'Random Game', 'GAME-32', 'User-202', 'dc1d418c-df3c-429b-89dd-3614adfbcaab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:07', NULL, NULL, 0, NULL, NULL),
(401, 812.00, 'Random Game', 'GAME-799', 'User-727', '59bcde14-88c5-41d4-be87-280381e8b686', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:13', NULL, NULL, 0, NULL, NULL),
(402, 476.00, 'Random Game', 'GAME-196', 'User-639', '1325133e-0310-4e75-b967-9d1a214556e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:19', NULL, NULL, 0, NULL, NULL),
(403, 56.00, 'Random Game', 'GAME-723', 'User-364', '0551af30-d7ae-43b7-9bf0-f56deca6d394', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:19', NULL, NULL, 0, NULL, NULL),
(404, 521.00, 'Random Game', 'GAME-367', 'User-883', '765079bb-fe6d-415c-b4da-49a3a93d2994', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:26', NULL, NULL, 0, NULL, NULL),
(405, 594.00, 'Random Game', 'GAME-161', 'User-482', '58d90bfa-c6f7-4f72-8a69-92679c3ed893', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:26', NULL, NULL, 0, NULL, NULL),
(406, 254.00, 'Random Game', 'GAME-369', 'User-216', '878d2d45-8b5a-4f7b-ae59-9ab85a4da926', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:32', NULL, NULL, 0, NULL, NULL),
(407, 673.00, 'Random Game', 'GAME-678', 'User-376', 'fe649bec-b706-4bfc-9c9c-f0efeb59d0ae', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:40', NULL, NULL, 0, NULL, NULL),
(408, 793.00, 'Random Game', 'GAME-712', 'User-989', 'a48a6618-40d2-45fb-9797-a3351b20c85b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:40', NULL, NULL, 0, NULL, NULL),
(409, 622.00, 'Random Game', 'GAME-235', 'User-307', 'e1c5a537-f833-41a9-aade-18abc41de8ec', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:46', NULL, NULL, 0, NULL, NULL),
(410, 413.00, 'Random Game', 'GAME-365', 'User-675', '7df82488-c8da-49bb-8253-07ba3b9989eb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:46', NULL, NULL, 0, NULL, NULL),
(411, 979.00, 'Random Game', 'GAME-478', 'User-52', 'a876321f-51e1-4bc9-8ca2-cba5d8e25504', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:12:53', NULL, NULL, 0, NULL, NULL),
(412, 83.00, 'Random Game', 'GAME-542', 'User-916', 'f0546b98-7622-4ea8-bcb4-956f95bf4f83', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:00', NULL, NULL, 0, NULL, NULL),
(413, 652.00, 'Random Game', 'GAME-399', 'User-561', 'bba09f13-a053-4973-997f-f7b5e15d1aa9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:00', NULL, NULL, 0, NULL, NULL),
(414, 886.00, 'Random Game', 'GAME-44', 'User-226', 'ae6f6e4b-8d48-426f-87e4-6f010dcb74bb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:07', NULL, NULL, 0, NULL, NULL),
(415, 583.00, 'Random Game', 'GAME-888', 'User-557', '3d57e45d-dad1-46a5-aa88-c5b48d225e85', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:07', NULL, NULL, 0, NULL, NULL),
(416, 663.00, 'Random Game', 'GAME-287', 'User-761', '209d4497-3471-4fe4-b0e3-1d00e7f3dfff', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:13', NULL, NULL, 0, NULL, NULL),
(417, 1036.00, 'Random Game', 'GAME-585', 'User-613', '02861a3e-8515-4f17-b3e7-df9c621e536e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:20', NULL, NULL, 0, NULL, NULL),
(418, 565.00, 'Random Game', 'GAME-606', 'User-882', 'a2db4c17-fd5e-40b3-ac16-6385fd3645bc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:20', NULL, NULL, 0, NULL, NULL),
(419, 158.00, 'Random Game', 'GAME-8', 'User-614', 'df058f9f-0c60-48c9-b822-0dd3a3b36c33', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:27', NULL, NULL, 0, NULL, NULL),
(420, 94.00, 'Random Game', 'GAME-442', 'User-59', '6c939247-de80-43e1-8785-2c3e1aea8680', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:27', NULL, NULL, 0, NULL, NULL),
(421, 1023.00, 'Random Game', 'GAME-97', 'User-893', '6d47d0ed-1729-4a7d-8939-60d2c72a374c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:33', NULL, NULL, 0, NULL, NULL),
(422, 631.00, 'Random Game', 'GAME-554', 'User-9', 'b8af007e-e6be-46fc-9d8c-c85eb9a5e3a6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:40', NULL, NULL, 0, NULL, NULL),
(423, 461.00, 'Random Game', 'GAME-772', 'User-891', 'ba6e78b5-f91f-4f3c-bd5b-bda7e34502d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:40', NULL, NULL, 0, NULL, NULL),
(424, 402.00, 'Random Game', 'GAME-598', 'User-155', '947e6f14-8f09-49a3-aa78-912f42aedb12', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:47', NULL, NULL, 0, NULL, NULL),
(425, 517.00, 'Random Game', 'GAME-168', 'User-258', '85736829-ea45-404a-8912-6035921a3602', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:13:47', NULL, NULL, 0, NULL, NULL),
(426, 88.00, 'Random Game', 'GAME-524', 'User-631', '8f018aa7-149a-4c45-9ede-02b64eb9b36a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:14:07', NULL, NULL, 0, NULL, NULL),
(427, 358.00, 'Random Game', 'GAME-554', 'User-551', 'ea03343f-af69-4712-9323-0a984a7df5de', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:14:07', NULL, NULL, 0, NULL, NULL),
(428, 862.00, 'Random Game', 'GAME-885', 'User-768', 'ba526335-6439-4224-b757-b1ab194838c1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:14:07', NULL, NULL, 0, NULL, NULL),
(429, 919.00, 'Random Game', 'GAME-705', 'User-707', '54d15c63-00be-4e62-a427-7390b2c79368', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:14:07', NULL, NULL, 0, NULL, NULL),
(430, 966.00, 'Random Game', 'GAME-447', 'User-276', 'd3f0e860-19b2-4783-9fbf-578baebf17a7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:14:07', NULL, NULL, 0, NULL, NULL),
(431, 252.00, 'Random Game', 'GAME-719', 'User-783', '02a16cd8-5265-4e44-8f29-9ae1eeae9216', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:07', NULL, NULL, 0, NULL, NULL),
(432, 740.00, 'Random Game', 'GAME-421', 'User-865', '79add574-2fbf-48a9-bf5c-4936686babfe', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:07', NULL, NULL, 0, NULL, NULL),
(433, 530.00, 'Random Game', 'GAME-443', 'User-225', '8295698b-d041-4631-a5a1-a742520f0d46', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:07', NULL, NULL, 0, NULL, NULL),
(434, 289.00, 'Random Game', 'GAME-420', 'User-33', 'c9f9007b-e384-44b1-b7aa-d35b5db6fd88', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:07', NULL, NULL, 0, NULL, NULL),
(435, 731.00, 'Random Game', 'GAME-177', 'User-822', 'ee89b7fe-1ee0-4cb4-a65e-8bf98645dfd8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:07', NULL, NULL, 0, NULL, NULL),
(436, 977.00, 'Random Game', 'GAME-481', 'User-431', '978b25c6-5f0d-45e1-9f91-29edeedd765d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:54', NULL, NULL, 0, NULL, NULL),
(437, 757.00, 'Random Game', 'GAME-461', 'User-66', '58125455-9de5-4392-9f71-326f973cd60b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:54', NULL, NULL, 0, NULL, NULL),
(438, 736.00, 'Random Game', 'GAME-58', 'User-534', 'e48dbf00-1ac7-405b-aa48-91627581c86c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:54', NULL, NULL, 0, NULL, NULL),
(439, 50.00, 'Random Game', 'GAME-641', 'User-909', 'b2ea6a90-81c3-4799-8648-9fd30d53ccd9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:54', NULL, NULL, 0, NULL, NULL),
(440, 149.00, 'Random Game', 'GAME-50', 'User-289', '34fa6944-be90-4ab7-8a7a-717e16d0ba85', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:54', NULL, NULL, 0, NULL, NULL),
(441, 301.00, 'Random Game', 'GAME-335', 'User-825', 'af26a1bb-b3e1-45b5-ba08-b3f51033f03f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:59', NULL, NULL, 0, NULL, NULL),
(442, 534.00, 'Random Game', 'GAME-693', 'User-246', '3a830c9a-d38b-4f31-af0d-d08837958f0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:15:59', NULL, NULL, 0, NULL, NULL),
(443, 83.00, 'Random Game', 'GAME-631', 'User-196', '9ca4c840-413a-4fbe-ac03-2b63d3c1ae17', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:04', NULL, NULL, 0, NULL, NULL),
(444, 743.00, 'Random Game', 'GAME-918', 'User-115', '8dc4aaf7-8b2a-4acb-8200-fdd2f68c855a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:04', NULL, NULL, 0, NULL, NULL),
(445, 1047.00, 'Random Game', 'GAME-402', 'User-314', '52818073-848f-4492-a733-c3acc4ccad59', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:07', NULL, NULL, 0, NULL, NULL),
(446, 721.00, 'Random Game', 'GAME-104', 'User-216', '533fbe8b-73c6-4d14-a761-afabef16b602', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:07', NULL, NULL, 0, NULL, NULL),
(447, 592.00, 'Random Game', 'GAME-546', 'User-810', '1876dbb5-1025-4494-9c33-08d72a163c75', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:13', NULL, NULL, 0, NULL, NULL),
(448, 560.00, 'Random Game', 'GAME-602', 'User-400', 'ef6650cc-f5fc-4873-94d9-88db3173ed98', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:20', NULL, NULL, 0, NULL, NULL),
(449, 558.00, 'Random Game', 'GAME-368', 'User-855', 'fb27333f-8fc3-4a01-bb1b-db35c4cb1740', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:20', NULL, NULL, 0, NULL, NULL),
(450, 736.00, 'Random Game', 'GAME-975', 'User-845', '87cc12e4-b07c-4513-9b40-37c3c957cfaf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:24', NULL, NULL, 0, NULL, NULL),
(451, 361.00, 'Random Game', 'GAME-966', 'User-283', '62e7adeb-db76-4065-9ff4-efe1dd610e0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:24', NULL, NULL, 0, NULL, NULL),
(452, 155.00, 'Random Game', 'GAME-913', 'User-178', 'aeca3b65-cff2-4302-b1e2-276654bbd6a3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:27', NULL, NULL, 0, NULL, NULL),
(453, 275.00, 'Random Game', 'GAME-428', 'User-125', '7ca2a2e6-5138-413a-a964-58bddb25cc60', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:27', NULL, NULL, 0, NULL, NULL),
(454, 917.00, 'Random Game', 'GAME-948', 'User-27', '39755f9e-3f0e-4ddd-ac0c-61344c9906ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:33', NULL, NULL, 0, NULL, NULL),
(455, 235.00, 'Random Game', 'GAME-575', 'User-213', 'bb18e508-d304-44e7-8c4f-2aee8f553d1d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:40', NULL, NULL, 0, NULL, NULL),
(456, 452.00, 'Random Game', 'GAME-777', 'User-324', '73675ae5-1513-4b15-81fc-e46c15257272', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:40', NULL, NULL, 0, NULL, NULL),
(457, 668.00, 'Random Game', 'GAME-596', 'User-278', '0d9c5232-0178-4dfd-8183-5de81224a444', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:44', NULL, NULL, 0, NULL, NULL),
(458, 964.00, 'Random Game', 'GAME-244', 'User-532', '300a9f11-06a3-4a77-900b-ab65f22d0769', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:44', NULL, NULL, 0, NULL, NULL),
(459, 496.00, 'Random Game', 'GAME-117', 'User-772', 'c4c4070e-226d-4fd4-8e0e-85f892dc967d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:47', NULL, NULL, 0, NULL, NULL),
(460, 692.00, 'Random Game', 'GAME-388', 'User-810', '82c55555-6fa1-484a-9e17-ce41b50b0bc8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:47', NULL, NULL, 0, NULL, NULL),
(461, 137.00, 'Random Game', 'GAME-600', 'User-699', 'd86cf692-2bba-41e6-84d0-9b52b49ac7dc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:16:53', NULL, NULL, 0, NULL, NULL),
(462, 145.00, 'Random Game', 'GAME-470', 'User-795', 'ee08d0b7-cfdc-4ba5-8d29-34e22b5b74bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:00', NULL, NULL, 0, NULL, NULL),
(463, 839.00, 'Random Game', 'GAME-986', 'User-295', 'd9417102-6918-4377-a4ab-12f949c6160f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:00', NULL, NULL, 0, NULL, NULL),
(464, 1004.00, 'Random Game', 'GAME-335', 'User-751', 'abf48b9f-5e17-4f9f-89f9-346852573dad', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:04', NULL, NULL, 0, NULL, NULL),
(465, 665.00, 'Random Game', 'GAME-350', 'User-124', '4e133fde-25ae-498b-b2b5-fcd599aa5adb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:04', NULL, NULL, 0, NULL, NULL),
(466, 305.00, 'Random Game', 'GAME-177', 'User-397', 'de7fc088-0c18-4867-b138-4c9a941998d9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:07', NULL, NULL, 0, NULL, NULL),
(467, 370.00, 'Random Game', 'GAME-196', 'User-589', 'be77272b-92a6-400a-9360-9280bc6baf92', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:07', NULL, NULL, 0, NULL, NULL),
(468, 276.00, 'Random Game', 'GAME-436', 'User-207', '3a3a699c-7f5d-4f76-9fff-c1c40da30dbc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:24', NULL, NULL, 0, NULL, NULL),
(469, 76.00, 'Random Game', 'GAME-482', 'User-87', 'e6473b8c-bdcf-47a7-8529-cec3db44a53f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:24', NULL, NULL, 0, NULL, NULL),
(470, 843.00, 'Random Game', 'GAME-390', 'User-167', 'cf156682-31d4-4f9f-b53c-097c7e9a6052', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:35', NULL, NULL, 0, NULL, NULL),
(471, 177.00, 'Random Game', 'GAME-484', 'User-565', '0544755d-5b5f-480d-a3c1-42df993f7872', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:35', NULL, NULL, 0, NULL, NULL),
(472, 89.00, 'Random Game', 'GAME-816', 'User-907', '50d401da-9a6a-463b-bbf4-8467c47d3c4f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:35', NULL, NULL, 0, NULL, NULL),
(473, 274.00, 'Random Game', 'GAME-483', 'User-346', '79aeb3b9-7c4e-478a-ad68-fb3aeb0ce8a6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:35', NULL, NULL, 0, NULL, NULL),
(474, 718.00, 'Random Game', 'GAME-506', 'User-584', 'cdc4b76a-f6ab-41d8-914a-71de4870afab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:35', NULL, NULL, 0, NULL, NULL),
(475, 625.00, 'Random Game', 'GAME-924', 'User-457', 'c109c5d1-d957-4712-a521-790425161a88', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:39', NULL, NULL, 0, NULL, NULL),
(476, 316.00, 'Random Game', 'GAME-230', 'User-836', '561b7716-3228-4e6a-a37e-a2a17589f471', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:39', NULL, NULL, 0, NULL, NULL),
(477, 254.00, 'Random Game', 'GAME-69', 'User-172', '342ea9a7-ede0-4422-b991-fefeb784f2d7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:44', NULL, NULL, 0, NULL, NULL),
(478, 861.00, 'Random Game', 'GAME-679', 'User-605', 'ec9cfffc-f83a-4ddc-a154-3afef267b596', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:44', NULL, NULL, 0, NULL, NULL),
(479, 644.00, 'Random Game', 'GAME-412', 'User-889', 'd6da83e7-0556-4e93-97e8-6a3bc9268392', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:47', NULL, NULL, 0, NULL, NULL),
(480, 831.00, 'Random Game', 'GAME-476', 'User-270', 'd363f06a-25ce-415a-a58e-7338d2ba59c3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:47', NULL, NULL, 0, NULL, NULL),
(481, 223.00, 'Random Game', 'GAME-323', 'User-106', '4beee05b-f4ac-4c8c-a594-89c5825f42f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:17:53', NULL, NULL, 0, NULL, NULL),
(482, 765.00, 'Random Game', 'GAME-284', 'User-81', '2df03d5a-cec2-46c4-a31e-4decad69cb83', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:00', NULL, NULL, 0, NULL, NULL),
(483, 464.00, 'Random Game', 'GAME-735', 'User-865', '04f964a9-dd92-4329-9aae-86b086aa94b4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:00', NULL, NULL, 0, NULL, NULL),
(484, 767.00, 'Random Game', 'GAME-340', 'User-633', '77986ff2-8393-4f70-8f40-13290be5d05e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:04', NULL, NULL, 0, NULL, NULL),
(485, 583.00, 'Random Game', 'GAME-388', 'User-504', '0c2b7c43-a521-4e64-9246-7dc25a6d2c47', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:04', NULL, NULL, 0, NULL, NULL),
(486, 1004.00, 'Random Game', 'GAME-626', 'User-649', '1ec950f7-3bae-420c-9bce-04f69785e0a7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:07', NULL, NULL, 0, NULL, NULL),
(487, 734.00, 'Random Game', 'GAME-914', 'User-591', '538985a3-8199-4a16-95c6-5a83efa0cfab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:07', NULL, NULL, 0, NULL, NULL),
(488, 54.00, 'Random Game', 'GAME-87', 'User-186', '44ae5124-f736-43fd-b1a9-cf34b9c95de6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:13', NULL, NULL, 0, NULL, NULL),
(489, 781.00, 'Random Game', 'GAME-212', 'User-591', 'e9329943-f016-4e01-a736-84b82ea7d67f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:20', NULL, NULL, 0, NULL, NULL),
(490, 742.00, 'Random Game', 'GAME-505', 'User-83', '21b9b21e-9ca0-4e4b-975b-1ecb1d98075e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:20', NULL, NULL, 0, NULL, NULL),
(491, 171.00, 'Random Game', 'GAME-544', 'User-608', 'ac0297e2-0628-40f4-9c94-97bff5234b06', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:24', NULL, NULL, 0, NULL, NULL),
(492, 229.00, 'Random Game', 'GAME-77', 'User-597', 'ba618c42-d8ff-449e-b7e1-d24460006a24', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:24', NULL, NULL, 0, NULL, NULL),
(493, 841.00, 'Random Game', 'GAME-46', 'User-507', 'cbe39f9a-186f-42a2-9bf2-e2f331304607', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:27', NULL, NULL, 0, NULL, NULL),
(494, 541.00, 'Random Game', 'GAME-57', 'User-631', 'fd2b0b05-842a-45ea-ad3f-893571a3a9c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:27', NULL, NULL, 0, NULL, NULL),
(495, 973.00, 'Random Game', 'GAME-443', 'User-164', '0b069909-4707-4a66-bb97-211dab52bde8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:33', NULL, NULL, 0, NULL, NULL),
(496, 860.00, 'Random Game', 'GAME-585', 'User-710', 'e8641d21-ffef-417d-853a-23cdd737d2a4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:40', NULL, NULL, 0, NULL, NULL),
(497, 189.00, 'Random Game', 'GAME-463', 'User-834', '3576aece-6f57-4d68-862d-e15592d16225', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:40', NULL, NULL, 0, NULL, NULL),
(498, 882.00, 'Random Game', 'GAME-640', 'User-279', '2e447ecd-867b-45bd-ae48-0d48b34ac55a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:42', NULL, NULL, 0, NULL, NULL),
(499, 645.00, 'Random Game', 'GAME-957', 'User-241', '87d2d217-9f99-4cbe-9e04-3d3d0ea188dd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:44', NULL, NULL, 0, NULL, NULL),
(500, 817.00, 'Random Game', 'GAME-344', 'User-713', '779a65b8-e846-4e1b-b311-9004d8cb4866', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:44', NULL, NULL, 0, NULL, NULL),
(501, 527.00, 'Random Game', 'GAME-368', 'User-441', 'cf43d8c9-11ba-4113-9a7c-0cfe5e569175', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:46', NULL, NULL, 0, NULL, NULL),
(502, 522.00, 'Random Game', 'GAME-397', 'User-136', '8c22e24e-aaa4-4d00-9a81-5a772c89ce32', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:46', NULL, NULL, 0, NULL, NULL),
(503, 292.00, 'Random Game', 'GAME-214', 'User-850', '2eb6bd98-cc5e-458e-9e93-b204dc11ed1d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:52', NULL, NULL, 0, NULL, NULL),
(504, 371.00, 'Random Game', 'GAME-771', 'User-82', 'f3e41ef2-952b-41f9-8f30-a98d13356d24', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:59', NULL, NULL, 0, NULL, NULL),
(505, 118.00, 'Random Game', 'GAME-740', 'User-117', 'c8a7a8b9-08df-499f-8b07-0a1341771514', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:18:59', NULL, NULL, 0, NULL, NULL),
(506, 486.00, 'Random Game', 'GAME-998', 'User-828', 'be92b329-6360-4322-b661-754e7b829b45', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:02', NULL, NULL, 0, NULL, NULL),
(507, 367.00, 'Random Game', 'GAME-319', 'User-383', '9e7fae2f-fcf7-4bff-b0f0-2f0028844f22', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:04', NULL, NULL, 0, NULL, NULL),
(508, 249.00, 'Random Game', 'GAME-249', 'User-180', '76b86dd3-5485-4800-9495-5705611e276d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:04', NULL, NULL, 0, NULL, NULL),
(509, 252.00, 'Random Game', 'GAME-973', 'User-485', '12df4459-7bfd-4d0a-a2dd-4f43417f43ff', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:06', NULL, NULL, 0, NULL, NULL),
(510, 460.00, 'Random Game', 'GAME-843', 'User-344', '04e586a9-704a-4a6a-8e48-d33a7cfbfd5c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:06', NULL, NULL, 0, NULL, NULL),
(511, 923.00, 'Random Game', 'GAME-472', 'User-683', 'cad1b8ef-293a-4fbd-bef0-c6b91c771b58', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:12', NULL, NULL, 0, NULL, NULL),
(512, 211.00, 'Random Game', 'GAME-482', 'User-168', 'da6b4966-91d6-47cc-b54b-69ea8d42b5fb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:19', NULL, NULL, 0, NULL, NULL),
(513, 380.00, 'Random Game', 'GAME-945', 'User-79', '159aded1-a083-46ba-8ed8-a5a9380e8792', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:19', NULL, NULL, 0, NULL, NULL),
(514, 603.00, 'Random Game', 'GAME-309', 'User-549', 'fac81656-375f-43b9-8a6d-b4841d87ddb5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:22', NULL, NULL, 0, NULL, NULL),
(515, 589.00, 'Random Game', 'GAME-897', 'User-0', 'fa1c7381-edfb-4393-8588-3f74f91278ff', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:24', NULL, NULL, 0, NULL, NULL),
(516, 521.00, 'Random Game', 'GAME-447', 'User-378', '6d978840-b95d-42bb-8608-c1688e3854f2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:24', NULL, NULL, 0, NULL, NULL),
(517, 113.00, 'Random Game', 'GAME-882', 'User-195', 'd4a53de4-3d1c-4ad5-b523-0a0a61fcaa88', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:26', NULL, NULL, 0, NULL, NULL),
(518, 700.00, 'Random Game', 'GAME-180', 'User-649', '24bdb6da-35c7-405a-9f09-ae2dd2d7dd60', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:26', NULL, NULL, 0, NULL, NULL),
(519, 1010.00, 'Random Game', 'GAME-357', 'User-551', 'd66f70e0-b8bd-4454-b59a-289cfb1365b7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:32', NULL, NULL, 0, NULL, NULL),
(520, 379.00, 'Random Game', 'GAME-45', 'User-73', 'ea373e00-12b1-4cb3-a59a-0605b2184282', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:40', NULL, NULL, 0, NULL, NULL),
(521, 654.00, 'Random Game', 'GAME-875', 'User-441', 'c6a81629-4c52-4a76-a277-932d34dae600', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:40', NULL, NULL, 0, NULL, NULL),
(522, 1047.00, 'Random Game', 'GAME-1', 'User-112', 'd6f9e16e-6175-41cf-a20c-3d481e392966', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:43', NULL, NULL, 0, NULL, NULL),
(523, 83.00, 'Random Game', 'GAME-189', 'User-94', '3edff248-50b0-4ba2-bebd-6da24b9d1e2d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:44', NULL, NULL, 0, NULL, NULL),
(524, 825.00, 'Random Game', 'GAME-107', 'User-568', 'dfe65dc8-1c21-4fa1-8acf-7a54ae37a1e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:44', NULL, NULL, 0, NULL, NULL),
(525, 136.00, 'Random Game', 'GAME-159', 'User-729', '1b760cf3-0c80-4a08-8834-08bd39470501', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:47', NULL, NULL, 0, NULL, NULL),
(526, 646.00, 'Random Game', 'GAME-192', 'User-205', '98c0cb28-cf05-4fea-a22c-59b48ae5e3ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:47', NULL, NULL, 0, NULL, NULL),
(527, 609.00, 'Random Game', 'GAME-47', 'User-132', 'c5e43e9c-7dcc-463f-bf49-cb18c1155c97', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:19:53', NULL, NULL, 0, NULL, NULL),
(528, 826.00, 'Random Game', 'GAME-142', 'User-841', '1fa6e734-04af-40bf-a0d0-d44fe45fcaf7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:00', NULL, NULL, 0, NULL, NULL),
(529, 520.00, 'Random Game', 'GAME-180', 'User-481', '2316a12e-f961-489b-b361-c79eee956833', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:00', NULL, NULL, 0, NULL, NULL),
(530, 1047.00, 'Random Game', 'GAME-881', 'User-612', '52de0a14-4e0f-4a57-b1bd-3c49fbdaea29', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:03', NULL, NULL, 0, NULL, NULL),
(531, 682.00, 'Random Game', 'GAME-278', 'User-724', 'c113bb7f-8085-4a78-900c-c3c2108d4a14', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:04', NULL, NULL, 0, NULL, NULL),
(532, 863.00, 'Random Game', 'GAME-880', 'User-260', '7b67ba75-ae05-4b4a-b427-797c874b6d3b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:04', NULL, NULL, 0, NULL, NULL),
(533, 371.00, 'Random Game', 'GAME-516', 'User-939', '3c736990-7a7d-43d4-8825-47149ddaf1ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:07', NULL, NULL, 0, NULL, NULL),
(534, 347.00, 'Random Game', 'GAME-361', 'User-577', '2a9f4cda-9400-4af3-952c-ad53bd03656b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:07', NULL, NULL, 0, NULL, NULL),
(535, 481.00, 'Random Game', 'GAME-597', 'User-837', '65e1ea87-9c09-440e-942b-7a07d82a6013', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:13', NULL, NULL, 0, NULL, NULL),
(536, 918.00, 'Random Game', 'GAME-507', 'User-376', '74b71d6f-f1c1-4e23-bfdd-9dbf402197b9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:20', NULL, NULL, 0, NULL, NULL),
(537, 438.00, 'Random Game', 'GAME-748', 'User-237', '9f902fbd-325c-4890-8718-9ea3715ee9ba', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:20', NULL, NULL, 0, NULL, NULL),
(538, 391.00, 'Random Game', 'GAME-6', 'User-808', '52234ac5-a0c6-4816-ab82-738470d76512', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:23', NULL, NULL, 0, NULL, NULL),
(539, 873.00, 'Random Game', 'GAME-59', 'User-864', '30e52025-5cee-4262-ab9b-01d5ef98e34c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:24', NULL, NULL, 0, NULL, NULL),
(540, 633.00, 'Random Game', 'GAME-408', 'User-191', '71d368f9-9d75-481f-bf6f-583f143569b4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:20:24', NULL, NULL, 0, NULL, NULL),
(541, 998.00, 'Random Game', 'GAME-849', 'User-607', 'cf20af0a-8f19-423d-9455-67db9623489e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:22:19', NULL, NULL, 0, NULL, NULL),
(542, 687.00, 'Random Game', 'GAME-998', 'User-694', '266030ee-5d9c-4d85-863a-b551dfa41ccd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:22:19', NULL, NULL, 0, NULL, NULL),
(543, 861.00, 'Random Game', 'GAME-560', 'User-780', '6df188c8-f3e8-40c7-bd27-1995a35a5bbc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:22:39', NULL, NULL, 0, NULL, NULL),
(544, 691.00, 'Random Game', 'GAME-491', 'User-560', 'ac6ff640-f601-47ce-bbb3-94487343ca29', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:22:39', NULL, NULL, 0, NULL, NULL),
(545, 754.00, 'Random Game', 'GAME-602', 'User-815', 'f5e98f1e-cea0-41f4-ac02-d8c01c1df06c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:22:59', NULL, NULL, 0, NULL, NULL),
(546, 251.00, 'Random Game', 'GAME-29', 'User-966', '29d3e161-049a-4af5-9a9b-f54538c58e00', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:22:59', NULL, NULL, 0, NULL, NULL),
(547, 780.00, 'Random Game', 'GAME-95', 'User-907', 'ab68a7bc-6b13-4713-a7eb-e290be5a414b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:23:20', NULL, NULL, 0, NULL, NULL),
(548, 507.00, 'Random Game', 'GAME-606', 'User-787', '77339f17-c7be-4eaf-9269-4280ece3d06e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:23:20', NULL, NULL, 0, NULL, NULL),
(549, 527.00, 'Random Game', 'GAME-965', 'User-966', '3774180d-4f2a-47ea-a955-6b10c9ae00c4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:23:40', NULL, NULL, 0, NULL, NULL),
(550, 844.00, 'Random Game', 'GAME-948', 'User-367', '8c3f9189-cc0c-425b-a308-a0d02f7da0e9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:23:40', NULL, NULL, 0, NULL, NULL),
(551, 909.00, 'Random Game', 'GAME-729', 'User-291', 'c272a4c3-5f64-45b5-bc4b-e327d4313669', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:24:00', NULL, NULL, 0, NULL, NULL),
(552, 419.00, 'Random Game', 'GAME-59', 'User-370', '7082b1fb-5329-4420-b165-e6065abfce91', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:24:00', NULL, NULL, 0, NULL, NULL),
(553, 275.00, 'Random Game', 'GAME-645', 'User-889', '5d3e7245-3667-4f27-b452-3f0915306f1e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:25:01', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(554, 109.00, 'Random Game', 'GAME-857', 'User-245', '63f42620-cc6b-4dcc-b089-f81a1e760eee', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:25:01', NULL, NULL, 0, NULL, NULL),
(555, 372.00, 'Random Game', 'GAME-934', 'User-654', '211e1e16-4466-4513-af04-5fe2c9223465', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:26:02', NULL, NULL, 0, NULL, NULL),
(556, 765.00, 'Random Game', 'GAME-600', 'User-658', 'f4b074f1-7b2c-48e0-b3e6-efaddc8b03cb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:26:02', NULL, NULL, 0, NULL, NULL),
(557, 666.00, 'Random Game', 'GAME-50', 'User-405', 'a62c6e69-ccb8-4b55-a8fa-c6543338ddb6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:26:55', NULL, NULL, 0, NULL, NULL),
(558, 324.00, 'Random Game', 'GAME-203', 'User-760', '64cb7df1-b008-4f11-a085-17668a6512b5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:26:55', NULL, NULL, 0, NULL, NULL),
(559, 337.00, 'Random Game', 'GAME-624', 'User-616', 'cafacc11-8c03-4329-b5a8-e77752505b58', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:27:00', NULL, NULL, 0, NULL, NULL),
(560, 937.00, 'Random Game', 'GAME-739', 'User-523', '6a29f9b4-4f38-4445-9e0d-4c4d79672932', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:27:00', NULL, NULL, 0, NULL, NULL),
(561, 630.00, 'Random Game', 'GAME-450', 'User-162', 'f534a3cd-c70f-4dfc-a7c8-a65f26e62c83', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:27:20', NULL, NULL, 0, NULL, NULL),
(562, 441.00, 'Random Game', 'GAME-115', 'User-154', 'c6e7a59a-258b-424e-89b7-7e2f45c86071', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:27:20', NULL, NULL, 0, NULL, NULL),
(563, 884.00, 'Random Game', 'GAME-101', 'User-886', 'cb4b4c4e-d197-4572-b9ab-f21810b52d52', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:27:40', NULL, NULL, 0, NULL, NULL),
(564, 251.00, 'Random Game', 'GAME-894', 'User-885', 'abddfe91-f0c9-424a-be0f-c08feb95321e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:27:40', NULL, NULL, 0, NULL, NULL),
(565, 147.00, 'Random Game', 'GAME-437', 'User-450', 'e12281d4-d2b2-4045-806e-1cc9d00ffa4d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:28:00', NULL, NULL, 0, NULL, NULL),
(566, 193.00, 'Random Game', 'GAME-490', 'User-262', '85512ea9-f069-4a2a-8790-f4a246b909fb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:28:00', NULL, NULL, 0, NULL, NULL),
(567, 828.00, 'Random Game', 'GAME-194', 'User-211', 'aa52e9b7-56fa-42ae-b7f3-c144089c3bf7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:28:56', NULL, NULL, 0, NULL, NULL),
(568, 792.00, 'Random Game', 'GAME-960', 'User-30', 'fc0b4276-c63e-443e-8202-fb1d6366ea7f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:28:56', NULL, NULL, 0, NULL, NULL),
(569, 455.00, 'Random Game', 'GAME-963', 'User-507', '45669c69-6cff-4c6a-9113-d4aac8d046c8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:28:59', NULL, NULL, 0, NULL, NULL),
(570, 486.00, 'Random Game', 'GAME-449', 'User-959', 'e2964921-aded-4db0-bb07-fae61ff5ddb5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:28:59', NULL, NULL, 0, NULL, NULL),
(571, 508.00, 'Random Game', 'GAME-278', 'User-87', '0a4a432b-9c29-47b7-913c-e363aeef6981', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:29:19', NULL, NULL, 0, NULL, NULL),
(572, 182.00, 'Random Game', 'GAME-799', 'User-381', '78111acd-a25a-476a-9bff-a7436fe61faa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:29:19', NULL, NULL, 0, NULL, NULL),
(573, 551.00, 'Random Game', 'GAME-628', 'User-674', '0090cab3-3014-4f5e-bb10-6229f893ec56', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:29:39', NULL, NULL, 0, NULL, NULL),
(574, 755.00, 'Random Game', 'GAME-924', 'User-752', '27c1d1cb-0462-452e-b105-76577a7f6d33', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:29:39', NULL, NULL, 0, NULL, NULL),
(575, 914.00, 'Random Game', 'GAME-764', 'User-462', '918ce4b1-dcfb-4dc2-b0ab-d4e8edcc246a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:29:59', NULL, NULL, 0, NULL, NULL),
(576, 390.00, 'Random Game', 'GAME-451', 'User-137', 'd98877d3-9025-431f-8dda-a82654c4fa0f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:29:59', NULL, NULL, 0, NULL, NULL),
(577, 223.00, 'Random Game', 'GAME-19', 'User-43', '4795afc3-3d70-41eb-800c-b1ee1ac3c2f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:30:19', NULL, NULL, 0, NULL, NULL),
(578, 157.00, 'Random Game', 'GAME-898', 'User-602', '38076ab3-306f-425f-b2c5-8990457bbd79', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:30:19', NULL, NULL, 0, NULL, NULL),
(579, 205.00, 'Random Game', 'GAME-847', 'User-804', '94d11066-4671-47cc-97f2-fc9faad8a92b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:30:39', NULL, NULL, 0, NULL, NULL),
(580, 348.00, 'Random Game', 'GAME-917', 'User-20', '50a902f7-1106-4512-8694-66bc26bcc3ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:30:39', NULL, NULL, 0, NULL, NULL),
(581, 394.00, 'Random Game', 'GAME-480', 'User-769', '51646e01-f7c0-4c00-a2cb-d07c691e1658', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:30:59', NULL, NULL, 0, NULL, NULL),
(582, 363.00, 'Random Game', 'GAME-324', 'User-837', '1107fb76-5f7c-4ddc-b031-e74d342383d0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:30:59', NULL, NULL, 0, NULL, NULL),
(583, 524.00, 'Random Game', 'GAME-270', 'User-3', '7ecdbc83-2295-4515-b8bd-cba8c1889cf3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:31:19', NULL, NULL, 0, NULL, NULL),
(584, 193.00, 'Random Game', 'GAME-680', 'User-22', '1268aa95-1b8b-46a5-99fa-0907a23f2c6e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:31:19', NULL, NULL, 0, NULL, NULL),
(585, 431.00, 'Random Game', 'GAME-50', 'User-4', '05518580-71ae-4c9f-89ac-4a245771f903', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:31:39', NULL, NULL, 0, NULL, NULL),
(586, 467.00, 'Random Game', 'GAME-68', 'User-4', 'b116f420-ff38-4814-81e2-4b44975abbf5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:31:39', NULL, NULL, 0, NULL, NULL),
(587, 794.00, 'Random Game', 'GAME-585', 'User-971', '52778b56-a739-4c13-a4e2-7aa73bd757ad', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:31:59', NULL, NULL, 0, NULL, NULL),
(588, 964.00, 'Random Game', 'GAME-849', 'User-475', 'b0404201-de03-49c0-b057-8d748b68538c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:31:59', NULL, NULL, 0, NULL, NULL),
(589, 727.00, 'Random Game', 'GAME-105', 'User-636', '5b27c829-1996-4f57-af04-18508aa8205c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:32:19', NULL, NULL, 0, NULL, NULL),
(590, 453.00, 'Random Game', 'GAME-369', 'User-662', '160843fb-8200-4281-b656-b48c1148b6c0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:32:19', NULL, NULL, 0, NULL, NULL),
(591, 471.00, 'Random Game', 'GAME-563', 'User-13', '18ffe64f-96f7-4a0c-8f62-f94f6ffbe9d7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:32:39', NULL, NULL, 0, NULL, NULL),
(592, 764.00, 'Random Game', 'GAME-999', 'User-917', 'a1acec70-aa70-408c-8b40-95645e50811e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:32:39', NULL, NULL, 0, NULL, NULL),
(593, 447.00, 'Random Game', 'GAME-139', 'User-401', '966a955e-3ebe-4abb-99b1-5cda991a4da6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:32:59', NULL, NULL, 0, NULL, NULL),
(594, 818.00, 'Random Game', 'GAME-278', 'User-958', 'eb24ed5e-1157-409e-aaf6-1ba6f42c5798', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:32:59', NULL, NULL, 0, NULL, NULL),
(595, 1011.00, 'Random Game', 'GAME-126', 'User-145', '9e7917e6-a0cd-4105-b390-13a40f1253bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:33:19', NULL, NULL, 0, NULL, NULL),
(596, 444.00, 'Random Game', 'GAME-292', 'User-764', '6e7ec525-d96f-430d-bf22-5e9afb756306', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:33:19', NULL, NULL, 0, NULL, NULL),
(597, 868.00, 'Random Game', 'GAME-490', 'User-899', 'b2eca0e8-6124-4e7b-8c47-c28f856a8223', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:33:39', NULL, NULL, 0, NULL, NULL),
(598, 305.00, 'Random Game', 'GAME-208', 'User-70', '35e723ea-b475-4988-b6d4-133b563eb6ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:33:39', NULL, NULL, 0, NULL, NULL),
(599, 180.00, 'Random Game', 'GAME-898', 'User-966', 'f0e45b44-5756-41cd-84f0-aaa6458b4e06', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:33:59', NULL, NULL, 0, NULL, NULL),
(600, 968.00, 'Random Game', 'GAME-644', 'User-947', '027b8e2c-c74d-4c54-b205-891182a26b19', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:33:59', NULL, NULL, 0, NULL, NULL),
(601, 882.00, 'Random Game', 'GAME-987', 'User-207', '4b29b18a-7189-406d-9391-ead83b86761b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:34:19', NULL, NULL, 0, NULL, NULL),
(602, 946.00, 'Random Game', 'GAME-196', 'User-884', '30427662-af6c-4fa4-81ea-0d4de54ee9f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:34:19', NULL, NULL, 0, NULL, NULL),
(603, 826.00, 'Random Game', 'GAME-47', 'User-591', '05208222-4e69-49f3-860d-23b64b219e8f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:34:39', NULL, NULL, 0, NULL, NULL),
(604, 509.00, 'Random Game', 'GAME-894', 'User-10', '58a5dda6-c28b-49b4-9a9b-2080e15eab4a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:34:39', NULL, NULL, 0, NULL, NULL),
(605, 377.00, 'Random Game', 'GAME-5', 'User-109', 'de416cf2-3739-4531-9624-5f8fc133cfd7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:34:59', NULL, NULL, 0, NULL, NULL),
(606, 297.00, 'Random Game', 'GAME-676', 'User-15', '383ba266-cde8-49c6-aa76-b5cb23452451', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:34:59', NULL, NULL, 0, NULL, NULL),
(607, 335.00, 'Random Game', 'GAME-347', 'User-962', '9d257120-85d5-4d91-a17a-3a71c25d79cb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:35:19', NULL, NULL, 0, NULL, NULL),
(608, 565.00, 'Random Game', 'GAME-900', 'User-112', '25666bf8-c7d2-42aa-9049-255df02e36d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:35:19', NULL, NULL, 0, NULL, NULL),
(609, 962.00, 'Random Game', 'GAME-846', 'User-876', '3ef9696a-e5c9-462d-875d-2b8c45fa0f52', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:35:39', NULL, NULL, 0, NULL, NULL),
(610, 680.00, 'Random Game', 'GAME-570', 'User-601', '4d78859d-dc1a-4dda-b190-5d58d574ddc4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:35:39', NULL, NULL, 0, NULL, NULL),
(611, 570.00, 'Random Game', 'GAME-602', 'User-152', '75f3952f-aea3-4fda-8a72-1c88740cd4b6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:35:47', NULL, NULL, 0, NULL, NULL),
(612, 574.00, 'Random Game', 'GAME-953', 'User-837', '2dd09717-95b3-4933-af22-aaced04e55e3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:35:59', NULL, NULL, 0, NULL, NULL),
(613, 781.00, 'Random Game', 'GAME-83', 'User-488', '18971593-2d41-4f40-a138-e4bb466e8ac5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:35:59', NULL, NULL, 0, NULL, NULL),
(614, 934.00, 'Random Game', 'GAME-908', 'User-462', '3c1e359e-d968-487d-a063-09b9b321fb0c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:07', NULL, NULL, 0, NULL, NULL),
(615, 413.00, 'Random Game', 'GAME-462', 'User-869', '716ca8a4-2983-4f7c-a65a-e3e2819beec9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:19', NULL, NULL, 0, NULL, NULL),
(616, 774.00, 'Random Game', 'GAME-117', 'User-888', 'b63ee914-c75d-4608-8201-2df915dcab84', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:19', NULL, NULL, 0, NULL, NULL),
(617, 376.00, 'Random Game', 'GAME-345', 'User-80', '6050a088-eab6-41c5-868a-0706d114fbaf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:27', NULL, NULL, 0, NULL, NULL),
(618, 339.00, 'Random Game', 'GAME-909', 'User-975', '4b28fd6a-6dfb-4624-b417-2200ba95dfcf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:39', NULL, NULL, 0, NULL, NULL),
(619, 278.00, 'Random Game', 'GAME-637', 'User-590', '3bb17349-9f5e-4a7a-ad14-583d7958b7cf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:39', NULL, NULL, 0, NULL, NULL),
(620, 283.00, 'Random Game', 'GAME-511', 'User-826', 'd61e725f-e42c-4080-b06f-8227fa1bd819', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:46', NULL, NULL, 0, NULL, NULL),
(621, 864.00, 'Random Game', 'GAME-516', 'User-12', 'da80611d-b11f-46a1-a20c-761d20948b6a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:47', NULL, NULL, 0, NULL, NULL),
(622, 178.00, 'Random Game', 'GAME-574', 'User-429', 'caaa6efb-e488-4f2e-83a6-06d0e76af220', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:59', NULL, NULL, 0, NULL, NULL),
(623, 634.00, 'Random Game', 'GAME-59', 'User-235', '90d43bbb-827c-41ae-8a7f-3e1a148e2cd5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:36:59', NULL, NULL, 0, NULL, NULL),
(624, 222.00, 'Random Game', 'GAME-516', 'User-736', 'f6e0f3cc-172d-44c8-ac03-ac811273f242', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:06', NULL, NULL, 0, NULL, NULL),
(625, 323.00, 'Random Game', 'GAME-340', 'User-754', '726e6dd4-bcdf-413e-8b71-a2ff0874addd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:07', NULL, NULL, 0, NULL, NULL),
(626, 862.00, 'Random Game', 'GAME-982', 'User-856', 'eb5adb78-b44d-4607-b371-c7b513729cab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:19', NULL, NULL, 0, NULL, NULL),
(627, 162.00, 'Random Game', 'GAME-666', 'User-611', '0f4b2c43-a256-474d-8afa-c6ede472702d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:19', NULL, NULL, 0, NULL, NULL),
(628, 643.00, 'Random Game', 'GAME-888', 'User-619', '6c400e50-7557-49d2-824b-aa89091934f5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:26', NULL, NULL, 0, NULL, NULL),
(629, 912.00, 'Random Game', 'GAME-266', 'User-43', '8bb8bd53-5792-4cbe-8a09-0810680ca8ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:27', NULL, NULL, 0, NULL, NULL),
(630, 291.00, 'Random Game', 'GAME-395', 'User-225', 'f1f0a37c-43e0-4ea8-b2ca-45b482a0d423', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:39', NULL, NULL, 0, NULL, NULL),
(631, 105.00, 'Random Game', 'GAME-546', 'User-74', 'be09c4b0-ac45-4436-b5fb-793a61f637a6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:39', NULL, NULL, 0, NULL, NULL),
(632, 560.00, 'Random Game', 'GAME-138', 'User-462', '1a7630a7-f239-446b-8a52-9edff94583bc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:46', NULL, NULL, 0, NULL, NULL),
(633, 599.00, 'Random Game', 'GAME-165', 'User-454', 'b3689c60-c22d-4704-baf3-fdc64f0e77d0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:47', NULL, NULL, 0, NULL, NULL),
(634, 141.00, 'Random Game', 'GAME-969', 'User-825', 'a871f00d-7d3a-4c11-9346-5c0de6c581d6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:59', NULL, NULL, 0, NULL, NULL),
(635, 831.00, 'Random Game', 'GAME-803', 'User-562', '69f365fa-807d-4836-bfb9-03f7eae07ea2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:37:59', NULL, NULL, 0, NULL, NULL),
(636, 505.00, 'Random Game', 'GAME-109', 'User-836', '0e7163bd-6d01-41a6-898d-3fe9569d206f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:06', NULL, NULL, 0, NULL, NULL),
(637, 579.00, 'Random Game', 'GAME-17', 'User-453', '2ddc4a92-43db-4cf4-b9e1-5e12d5636423', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:07', NULL, NULL, 0, NULL, NULL),
(638, 216.00, 'Random Game', 'GAME-92', 'User-159', 'f8e07442-dbdc-4cca-9761-46b007427163', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:19', NULL, NULL, 0, NULL, NULL),
(639, 143.00, 'Random Game', 'GAME-731', 'User-584', '5aa72d8d-050a-4a6d-b4bd-98c4f51a73b9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:19', NULL, NULL, 0, NULL, NULL),
(640, 520.00, 'Random Game', 'GAME-495', 'User-259', 'd0ece21e-4053-4e83-8802-90f3ea30b1c3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:26', NULL, NULL, 0, NULL, NULL),
(641, 368.00, 'Random Game', 'GAME-999', 'User-251', '164bd06f-d89c-4dea-b3b4-0cc723e7d127', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:27', NULL, NULL, 0, NULL, NULL),
(642, 70.00, 'Random Game', 'GAME-355', 'User-440', 'df9c6ce5-6334-4816-9b95-9969924b6258', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:39', NULL, NULL, 0, NULL, NULL),
(643, 414.00, 'Random Game', 'GAME-716', 'User-493', '158b1e75-f4bd-4c0a-905d-4ebce515cdf1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:39', NULL, NULL, 0, NULL, NULL),
(644, 311.00, 'Random Game', 'GAME-249', 'User-407', '40b84f18-2039-4b57-869f-845817fa9eb1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:46', NULL, NULL, 0, NULL, NULL),
(645, 512.00, 'Random Game', 'GAME-452', 'User-259', '0ff6f811-0294-49fd-8591-22a43bd10d82', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:47', NULL, NULL, 0, NULL, NULL),
(646, 527.00, 'Random Game', 'GAME-421', 'User-307', '49deacd0-611d-430c-840d-a6581077ca72', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:59', NULL, NULL, 0, NULL, NULL),
(647, 1020.00, 'Random Game', 'GAME-483', 'User-154', '5ab1bf93-548f-4ea5-8215-5c1959910f0e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:38:59', NULL, NULL, 0, NULL, NULL),
(648, 214.00, 'Random Game', 'GAME-388', 'User-800', '3ef0e80d-787e-4a96-a750-d7aaef2ccccf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:06', NULL, NULL, 0, NULL, NULL),
(649, 771.00, 'Random Game', 'GAME-381', 'User-590', '2bb15a80-7d2a-4a10-9d59-fd7b2a6e59ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:07', NULL, NULL, 0, NULL, NULL),
(650, 177.00, 'Random Game', 'GAME-511', 'User-781', 'fda60daf-ea5b-4985-99c7-81642bedb49a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:19', NULL, NULL, 0, NULL, NULL),
(651, 746.00, 'Random Game', 'GAME-60', 'User-720', '6aa99fef-6db8-4ed3-b87d-5a5c17349fe2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:19', NULL, NULL, 0, NULL, NULL),
(652, 136.00, 'Random Game', 'GAME-91', 'User-15', '57f1157f-5051-4de0-9377-b36449b7d193', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:22', NULL, NULL, 0, NULL, NULL),
(653, 210.00, 'Random Game', 'GAME-591', 'User-897', 'b9025552-284e-439a-98f8-c4bb214501cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:22', NULL, NULL, 0, NULL, NULL),
(654, 982.00, 'Random Game', 'GAME-679', 'User-847', '0dee185c-32c4-464c-853f-069e516dafd2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:24', NULL, NULL, 0, NULL, NULL),
(655, 855.00, 'Random Game', 'GAME-349', 'User-192', 'bdc54cd7-6b2e-4dce-91a3-861a5aab4119', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:24', NULL, NULL, 0, NULL, NULL),
(656, 737.00, 'Random Game', 'GAME-809', 'User-903', '3ed65693-d180-43ca-8640-4cc9aec51fd1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:42', NULL, NULL, 0, NULL, NULL),
(657, 165.00, 'Random Game', 'GAME-238', 'User-275', 'a936329a-c6fe-492e-bfb9-a0db0489ec17', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:42', NULL, NULL, 0, NULL, NULL),
(658, 122.00, 'Random Game', 'GAME-5', 'User-19', '1a685f18-3e3f-41f3-94ac-3c52c264ad08', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:44', NULL, NULL, 0, NULL, NULL),
(659, 484.00, 'Random Game', 'GAME-272', 'User-504', '89ddae39-ddd7-4ee1-b98e-bda6b967eac5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:39:44', NULL, NULL, 0, NULL, NULL),
(660, 878.00, 'Random Game', 'GAME-182', 'User-225', 'db38b977-5fb6-4e5c-ae8b-052838c04fb2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:02', NULL, NULL, 0, NULL, NULL),
(661, 702.00, 'Random Game', 'GAME-705', 'User-532', 'bd908652-5dd2-401b-afc6-197fa01c1293', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:02', NULL, NULL, 0, NULL, NULL),
(662, 826.00, 'Random Game', 'GAME-463', 'User-342', 'efde29ca-7a5b-43a8-8357-fa42562b144a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:04', NULL, NULL, 0, NULL, NULL),
(663, 104.00, 'Random Game', 'GAME-895', 'User-583', '1207c5f4-13de-4073-9d7d-305f0cfa8915', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:04', NULL, NULL, 0, NULL, NULL),
(664, 982.00, 'Random Game', 'GAME-656', 'User-3', '6bd9844e-147c-4657-9b80-f44b63017088', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:22', NULL, NULL, 0, NULL, NULL),
(665, 394.00, 'Random Game', 'GAME-790', 'User-522', 'c8f27500-0e2d-4201-a412-bdc6a887f3a1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:22', NULL, NULL, 0, NULL, NULL),
(666, 1003.00, 'Random Game', 'GAME-573', 'User-56', '94f8eb90-1b0b-4237-b9f7-659c233eda1f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:24', NULL, NULL, 0, NULL, NULL),
(667, 394.00, 'Random Game', 'GAME-119', 'User-483', 'fb74c609-a9a3-4430-8d77-7226b471bb71', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:24', NULL, NULL, 0, NULL, NULL),
(668, 896.00, 'Random Game', 'GAME-221', 'User-876', 'b8318bd7-38bf-4485-b60a-fed8be8b1b37', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:42', NULL, NULL, 0, NULL, NULL),
(669, 967.00, 'Random Game', 'GAME-761', 'User-554', '8d0b2ac7-7aa8-485d-8e37-705daebdb94f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:42', NULL, NULL, 0, NULL, NULL),
(670, 54.00, 'Random Game', 'GAME-70', 'User-640', 'd56c269c-7160-4689-9478-a969a4ab0655', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:44', NULL, NULL, 0, NULL, NULL),
(671, 351.00, 'Random Game', 'GAME-952', 'User-49', '85242093-c9f6-41a2-ab8a-3ab18d6e9e8e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:40:44', NULL, NULL, 0, NULL, NULL),
(672, 804.00, 'Random Game', 'GAME-990', 'User-957', '4b1e6443-b169-4c54-abfc-640d557f5c0c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:02', NULL, NULL, 0, NULL, NULL),
(673, 90.00, 'Random Game', 'GAME-741', 'User-269', 'cc5425ec-f341-4d33-96a3-4113dd596aba', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:02', NULL, NULL, 0, NULL, NULL),
(674, 69.00, 'Random Game', 'GAME-461', 'User-237', 'c48c9e73-7569-4800-82b3-005f3adff38f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:04', NULL, NULL, 0, NULL, NULL),
(675, 356.00, 'Random Game', 'GAME-306', 'User-661', '114bea84-3701-4683-a914-18a2f01d7bf4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:04', NULL, NULL, 0, NULL, NULL),
(676, 462.00, 'Random Game', 'GAME-589', 'User-688', '07c76fb5-48cd-43ce-9f09-1970efbc79ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:22', NULL, NULL, 0, NULL, NULL),
(677, 155.00, 'Random Game', 'GAME-355', 'User-155', 'e354f592-91b6-416d-8f6d-eff1dd76488f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:22', NULL, NULL, 0, NULL, NULL),
(678, 884.00, 'Random Game', 'GAME-400', 'User-108', '44cef7fc-b6c0-42bf-b6ee-11a23e5c6391', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:24', NULL, NULL, 0, NULL, NULL),
(679, 84.00, 'Random Game', 'GAME-181', 'User-886', '5bf248da-1e09-4fe7-9d7f-a0205cffee82', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:24', NULL, NULL, 0, NULL, NULL),
(680, 545.00, 'Random Game', 'GAME-56', 'User-45', 'ddf319c1-bb03-4478-ba77-f6a59411a90e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:42', NULL, NULL, 0, NULL, NULL),
(681, 358.00, 'Random Game', 'GAME-435', 'User-932', '780ef861-9a54-4f9d-8e4b-a97a09ed0f47', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:42', NULL, NULL, 0, NULL, NULL),
(682, 370.00, 'Random Game', 'GAME-626', 'User-366', '72857c3a-5df3-4ff8-8abf-64f7350e78eb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:44', NULL, NULL, 0, NULL, NULL),
(683, 896.00, 'Random Game', 'GAME-568', 'User-245', '375829e8-cd81-49e8-a863-4f8a0735f691', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:41:44', NULL, NULL, 0, NULL, NULL),
(684, 620.00, 'Random Game', 'GAME-477', 'User-111', '00b3f71f-43b5-4af1-846d-613ee472af58', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:02', NULL, NULL, 0, NULL, NULL),
(685, 359.00, 'Random Game', 'GAME-847', 'User-972', 'f0a0ecbb-7dc5-4ae7-ae87-dee7436753df', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:02', NULL, NULL, 0, NULL, NULL),
(686, 336.00, 'Random Game', 'GAME-930', 'User-564', '9c655619-6a96-474f-a556-0d0fdafb3e49', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:04', NULL, NULL, 0, NULL, NULL),
(687, 1047.00, 'Random Game', 'GAME-890', 'User-708', '62c50eae-aac0-4dd3-bc6a-339d76ba02a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:04', NULL, NULL, 0, NULL, NULL),
(688, 912.00, 'Random Game', 'GAME-276', 'User-967', 'f7117c68-ab90-4819-ae94-1f07c8c87d1f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:22', NULL, NULL, 0, NULL, NULL),
(689, 705.00, 'Random Game', 'GAME-936', 'User-257', '1e5588ff-0140-4856-877e-a6be06924676', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:22', NULL, NULL, 0, NULL, NULL),
(690, 416.00, 'Random Game', 'GAME-107', 'User-463', '2cb62129-24cf-447c-b3c1-297ea68397ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:24', NULL, NULL, 0, NULL, NULL),
(691, 275.00, 'Random Game', 'GAME-462', 'User-584', '6397c735-88b3-4d7e-b4d4-f6863cfbe031', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:24', NULL, NULL, 0, NULL, NULL),
(692, 836.00, 'Random Game', 'GAME-164', 'User-600', 'f8fb80ec-7bbe-4770-bd6a-0e8d117c7c4a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:42', NULL, NULL, 0, NULL, NULL),
(693, 173.00, 'Random Game', 'GAME-544', 'User-467', '0490152c-5365-45df-90fc-2d1f087c7d6a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:42', NULL, NULL, 0, NULL, NULL),
(694, 1048.00, 'Random Game', 'GAME-458', 'User-957', '0895457a-7a46-4bba-bf97-19b0ccda808e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:44', NULL, NULL, 0, NULL, NULL),
(695, 797.00, 'Random Game', 'GAME-594', 'User-328', 'c1f506d4-37f9-4ede-a21a-7ce87c029d05', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:42:44', NULL, NULL, 0, NULL, NULL),
(696, 973.00, 'Random Game', 'GAME-262', 'User-903', '4097d032-012c-479f-b7c5-6f95a324f0ae', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:02', NULL, NULL, 0, NULL, NULL),
(697, 69.00, 'Random Game', 'GAME-395', 'User-145', '00d0f404-ab39-495c-98b5-cbabcf2823f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:02', NULL, NULL, 0, NULL, NULL),
(698, 421.00, 'Random Game', 'GAME-986', 'User-778', 'c9009d29-06f7-436f-bcd1-7249e99ae520', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:04', NULL, NULL, 0, NULL, NULL),
(699, 382.00, 'Random Game', 'GAME-194', 'User-669', '31e7b8e2-1158-440d-a9db-e33c5e5cb98b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:04', NULL, NULL, 0, NULL, NULL),
(700, 334.00, 'Random Game', 'GAME-704', 'User-3', 'c88a23be-f74a-4662-ac55-23334a84d641', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:22', NULL, NULL, 0, NULL, NULL),
(701, 1018.00, 'Random Game', 'GAME-275', 'User-31', 'c39c7959-dda3-4ff6-b583-79b1894c8bc6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:22', NULL, NULL, 0, NULL, NULL),
(702, 680.00, 'Random Game', 'GAME-419', 'User-746', 'fe893fb4-bd9f-429f-b604-91cf9a166a06', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:24', NULL, NULL, 0, NULL, NULL),
(703, 374.00, 'Random Game', 'GAME-395', 'User-651', 'f825f91f-d4b0-4367-bb6a-467cb1a3d6c9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:24', NULL, NULL, 0, NULL, NULL),
(704, 761.00, 'Random Game', 'GAME-983', 'User-109', '35f4e671-3ea8-4cb5-a943-e3a713ce5172', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:42', NULL, NULL, 0, NULL, NULL),
(705, 926.00, 'Random Game', 'GAME-468', 'User-58', '8bb4dd0b-4a80-4793-a764-eb7f4144f90d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:42', NULL, NULL, 0, NULL, NULL),
(706, 491.00, 'Random Game', 'GAME-954', 'User-412', '155a8dcf-4e67-4875-9260-3289f46758de', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:44', NULL, NULL, 0, NULL, NULL),
(707, 436.00, 'Random Game', 'GAME-604', 'User-255', 'f7f492ef-71ab-4434-816f-d295d8776083', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:43:44', NULL, NULL, 0, NULL, NULL),
(708, 704.00, 'Random Game', 'GAME-170', 'User-915', 'cf64de44-975e-4b85-97d2-08bb2d12a96f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:02', NULL, NULL, 0, NULL, NULL),
(709, 74.00, 'Random Game', 'GAME-679', 'User-709', 'a59aab68-860e-423b-901e-454a0a3bf8cc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:02', NULL, NULL, 0, NULL, NULL),
(710, 651.00, 'Random Game', 'GAME-512', 'User-734', 'e513018a-bb40-454a-87c6-3bbb4ce882bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:04', NULL, NULL, 0, NULL, NULL),
(711, 685.00, 'Random Game', 'GAME-698', 'User-922', '37e48f70-9119-4441-8f00-a00a8fdfcbd6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:04', NULL, NULL, 0, NULL, NULL),
(712, 141.00, 'Random Game', 'GAME-534', 'User-80', '028f00e7-53d8-4e69-b0c2-0410a38ac8e6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:22', NULL, NULL, 0, NULL, NULL),
(713, 481.00, 'Random Game', 'GAME-799', 'User-641', '475a8ced-cf10-46e9-9672-fc98460ab610', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:22', NULL, NULL, 0, NULL, NULL),
(714, 167.00, 'Random Game', 'GAME-388', 'User-352', 'df24c2a2-9fdf-4c48-aca8-c12d48506e64', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:24', NULL, NULL, 0, NULL, NULL),
(715, 332.00, 'Random Game', 'GAME-580', 'User-969', 'af167aa5-dfb0-408e-b49d-8844d8253f6c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:24', NULL, NULL, 0, NULL, NULL),
(716, 800.00, 'Random Game', 'GAME-466', 'User-80', '6c457bc1-2dcf-4193-bdbc-1918fbc194fd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:42', NULL, NULL, 0, NULL, NULL),
(717, 311.00, 'Random Game', 'GAME-766', 'User-598', 'e8c7eb7b-6720-4fab-8d7c-d55e86aff9f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:42', NULL, NULL, 0, NULL, NULL),
(718, 785.00, 'Random Game', 'GAME-690', 'User-25', '45245037-e5c8-486b-a616-b5b5cd9ce584', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:44', NULL, NULL, 0, NULL, NULL),
(719, 966.00, 'Random Game', 'GAME-523', 'User-154', 'd48b7777-8ccb-4c4a-b4b5-f4ed86f58b0d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:44:44', NULL, NULL, 0, NULL, NULL),
(720, 544.00, 'Random Game', 'GAME-202', 'User-593', 'e2f708e1-5d80-4371-b2fe-ae6311a8331d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:02', NULL, NULL, 0, NULL, NULL),
(721, 415.00, 'Random Game', 'GAME-655', 'User-841', 'a66a57fc-fcea-4e42-a471-2213ec9667d3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:02', NULL, NULL, 0, NULL, NULL),
(722, 59.00, 'Random Game', 'GAME-374', 'User-458', '932fa576-c810-4b31-ab4a-184daf811653', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:04', NULL, NULL, 0, NULL, NULL),
(723, 308.00, 'Random Game', 'GAME-496', 'User-721', '470d395b-e329-44c4-a834-595cbc776073', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:04', NULL, NULL, 0, NULL, NULL),
(724, 538.00, 'Random Game', 'GAME-515', 'User-517', '36cef186-9748-472c-95ef-8df53fd5815e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:22', NULL, NULL, 0, NULL, NULL),
(725, 760.00, 'Random Game', 'GAME-553', 'User-364', '61efcc54-dd05-4489-aaa8-5f044c43b9f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:22', NULL, NULL, 0, NULL, NULL),
(726, 775.00, 'Random Game', 'GAME-92', 'User-922', 'fdb36d03-2b21-448b-9f5d-4adce34f1dbf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:24', NULL, NULL, 0, NULL, NULL),
(727, 606.00, 'Random Game', 'GAME-216', 'User-614', 'eafe6db3-a204-4b98-9ef6-f0c27d5c0280', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:24', NULL, NULL, 0, NULL, NULL),
(728, 359.00, 'Random Game', 'GAME-871', 'User-879', 'f44df02e-8aa2-4e19-a66c-75b38201ba46', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:42', NULL, NULL, 0, NULL, NULL),
(729, 212.00, 'Random Game', 'GAME-105', 'User-570', 'a276e95a-e813-4bf5-ba0f-e694658cee6c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:42', NULL, NULL, 0, NULL, NULL),
(730, 243.00, 'Random Game', 'GAME-178', 'User-846', 'ac676199-33b0-4b9f-88b9-47b7bf70e8de', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:44', NULL, NULL, 0, NULL, NULL),
(731, 63.00, 'Random Game', 'GAME-668', 'User-114', 'b8021408-38e4-4550-84b7-45d57d8b7af8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:45:44', NULL, NULL, 0, NULL, NULL),
(732, 941.00, 'Random Game', 'GAME-347', 'User-827', '5478ebeb-2668-48e5-84b3-fe2d1b99f7f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:02', NULL, NULL, 0, NULL, NULL),
(733, 585.00, 'Random Game', 'GAME-664', 'User-803', '1be9a9e4-758b-4ad8-90cb-08f4ec93b78a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:02', NULL, NULL, 0, NULL, NULL),
(734, 706.00, 'Random Game', 'GAME-965', 'User-815', '3c04154e-b3a5-4c59-b1d3-3d1a3f8fa161', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:04', NULL, NULL, 0, NULL, NULL),
(735, 232.00, 'Random Game', 'GAME-413', 'User-942', '1569b1ae-b7b4-4742-80c8-5b8a26989157', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:04', NULL, NULL, 0, NULL, NULL),
(736, 557.00, 'Random Game', 'GAME-721', 'User-83', 'bf81246f-41fa-4ef9-8882-a738b8a73d10', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:06', NULL, NULL, 0, NULL, NULL),
(737, 508.00, 'Random Game', 'GAME-332', 'User-337', '49dd9ed5-66a8-4a46-9958-1e0dca811fd9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:22', NULL, NULL, 0, NULL, NULL),
(738, 269.00, 'Random Game', 'GAME-850', 'User-755', '0e1d2701-2478-4d7e-9fbc-af8fe3677a50', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:22', NULL, NULL, 0, NULL, NULL),
(739, 77.00, 'Random Game', 'GAME-904', 'User-845', '449bcd39-a6ad-4fdc-809b-19d10f29dd62', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:24', NULL, NULL, 0, NULL, NULL),
(740, 988.00, 'Random Game', 'GAME-739', 'User-623', '7196738a-c589-412e-b0c0-0de9e0596c54', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:24', NULL, NULL, 0, NULL, NULL),
(741, 884.00, 'Random Game', 'GAME-996', 'User-816', 'cbbffad2-519d-43db-be87-1680d0f5ab2d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:26', NULL, NULL, 0, NULL, NULL),
(742, 192.00, 'Random Game', 'GAME-317', 'User-909', 'ad441c60-db88-4ee4-933e-a29061031d0c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:28', NULL, NULL, 0, NULL, NULL),
(743, 395.00, 'Random Game', 'GAME-583', 'User-825', '4aa821d1-e7c3-408c-ab08-92d653545c4f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:28', NULL, NULL, 0, NULL, NULL),
(744, 1008.00, 'Random Game', 'GAME-76', 'User-302', 'ba966e2b-126b-46be-9089-c30efc7db951', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:42', NULL, NULL, 0, NULL, NULL),
(745, 772.00, 'Random Game', 'GAME-397', 'User-497', 'a21e6694-cba9-4851-9f71-2deb6b82b6b7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:42', NULL, NULL, 0, NULL, NULL),
(746, 998.00, 'Random Game', 'GAME-930', 'User-910', 'c92b924b-6c04-45c7-abda-a4d30449fb66', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:44', NULL, NULL, 0, NULL, NULL),
(747, 647.00, 'Random Game', 'GAME-817', 'User-909', '314bb073-c89d-41af-88cc-ec3eb8c95d28', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:44', NULL, NULL, 0, NULL, NULL),
(748, 476.00, 'Random Game', 'GAME-542', 'User-126', '279e4835-904c-49b2-92b7-073c3ed8634b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:46', NULL, NULL, 0, NULL, NULL),
(749, 961.00, 'Random Game', 'GAME-338', 'User-247', 'b923ebdf-9426-4a60-8d64-18aa391ddd53', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:48', NULL, NULL, 0, NULL, NULL),
(750, 666.00, 'Random Game', 'GAME-754', 'User-735', '0efc3932-e749-47f1-9eb4-c0f56719e22a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:46:48', NULL, NULL, 0, NULL, NULL),
(751, 748.00, 'Random Game', 'GAME-984', 'User-268', 'd5e2f59c-b522-45b5-bbf6-b805852fbdbc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:02', NULL, NULL, 0, NULL, NULL),
(752, 688.00, 'Random Game', 'GAME-897', 'User-374', '616bf0ea-ea75-46e7-a803-eecbb7dc54ee', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:02', NULL, NULL, 0, NULL, NULL),
(753, 912.00, 'Random Game', 'GAME-970', 'User-338', 'e0e12016-6822-4be7-80c0-58b81339d5a7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:04', NULL, NULL, 0, NULL, NULL),
(754, 407.00, 'Random Game', 'GAME-854', 'User-451', '68b30d1c-a5ce-453a-8959-517fa11b1a80', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:04', NULL, NULL, 0, NULL, NULL),
(755, 193.00, 'Random Game', 'GAME-847', 'User-336', '5214b679-a7df-440a-9ea5-4109ca0dae94', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:06', NULL, NULL, 0, NULL, NULL),
(756, 246.00, 'Random Game', 'GAME-491', 'User-148', '26dfccd8-dc63-45dd-b759-30faba5b7c40', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:07', NULL, NULL, 0, NULL, NULL),
(757, 570.00, 'Random Game', 'GAME-514', 'User-254', '32db63a8-ecb3-49b1-b417-606ad27f2faf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:07', NULL, NULL, 0, NULL, NULL),
(758, 717.00, 'Random Game', 'GAME-368', 'User-91', '8323172c-1686-4709-be7c-1c228cf8f2d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:08', NULL, NULL, 0, NULL, NULL),
(759, 589.00, 'Random Game', 'GAME-488', 'User-4', 'b3325471-7087-42ae-982a-d3cd6cbf5eb2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:08', NULL, NULL, 0, NULL, NULL),
(760, 546.00, 'Random Game', 'GAME-382', 'User-764', 'f6577de8-945c-4e47-8986-f5b934599554', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:22', NULL, NULL, 0, NULL, NULL),
(761, 408.00, 'Random Game', 'GAME-828', 'User-72', '3097b676-00ec-4340-b760-0eaf27cd5c71', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:22', NULL, NULL, 0, NULL, NULL),
(762, 907.00, 'Random Game', 'GAME-501', 'User-177', '47ef0106-6d68-478d-98f2-f894d999251b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:24', NULL, NULL, 0, NULL, NULL),
(763, 191.00, 'Random Game', 'GAME-144', 'User-340', 'fbef64ce-4793-43c1-9bb1-b4964dbb3b6f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:24', NULL, NULL, 0, NULL, NULL),
(764, 276.00, 'Random Game', 'GAME-70', 'User-71', '8bb56d09-e690-46af-b7f7-dab56796d3e2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:26', NULL, NULL, 0, NULL, NULL),
(765, 582.00, 'Random Game', 'GAME-923', 'User-910', '4f485802-fdf1-47f1-8a5b-d4e626243098', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:27', NULL, NULL, 0, NULL, NULL),
(766, 201.00, 'Random Game', 'GAME-323', 'User-124', 'a10878b7-43a6-4620-9de1-f26ae7bf859b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:27', NULL, NULL, 0, NULL, NULL),
(767, 182.00, 'Random Game', 'GAME-65', 'User-359', '7fbb5ec0-d71e-4476-b723-80da60363d31', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:28', NULL, NULL, 0, NULL, NULL),
(768, 296.00, 'Random Game', 'GAME-989', 'User-226', 'c526d004-9b46-4ff8-91e2-ff2093c5d457', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:28', NULL, NULL, 0, NULL, NULL),
(769, 617.00, 'Random Game', 'GAME-626', 'User-515', '845494ce-9c95-4f07-956f-c81deb1704be', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:42', NULL, NULL, 0, NULL, NULL),
(770, 531.00, 'Random Game', 'GAME-679', 'User-852', 'd3dff823-82f4-46c6-8bd6-710681738297', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:42', NULL, NULL, 0, NULL, NULL),
(771, 917.00, 'Random Game', 'GAME-775', 'User-500', 'dd1acbb9-1154-4eb9-b3a9-029b38a02f1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:44', NULL, NULL, 0, NULL, NULL),
(772, 572.00, 'Random Game', 'GAME-312', 'User-2', '8dc76733-7686-41a2-954d-ce7450c41540', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:44', NULL, NULL, 0, NULL, NULL),
(773, 449.00, 'Random Game', 'GAME-286', 'User-720', '4d463130-30e9-421f-b55f-d200301e66b6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:46', NULL, NULL, 0, NULL, NULL),
(774, 938.00, 'Random Game', 'GAME-223', 'User-97', 'd4c690be-709f-4a0b-b6ec-cb88a35a4654', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:47', NULL, NULL, 0, NULL, NULL),
(775, 774.00, 'Random Game', 'GAME-721', 'User-81', '8c3ad4a0-abc3-467e-b20e-12111dd61ca8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:47', NULL, NULL, 0, NULL, NULL),
(776, 898.00, 'Random Game', 'GAME-854', 'User-350', 'd7e9e5dd-91af-4fd2-9e36-b3c85ebd7f55', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:48', NULL, NULL, 0, NULL, NULL),
(777, 533.00, 'Random Game', 'GAME-151', 'User-526', '86aae285-a2c5-4b17-968f-40d01764c8c1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:48', NULL, NULL, 0, NULL, NULL),
(778, 789.00, 'Random Game', 'GAME-318', 'User-802', '57c293b8-f908-4210-9b78-c943f28d3c4d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:58', NULL, NULL, 0, NULL, NULL),
(779, 683.00, 'Random Game', 'GAME-143', 'User-777', '40b36494-efb1-420f-8be9-1a42516040e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:47:58', NULL, NULL, 0, NULL, NULL),
(780, 935.00, 'Random Game', 'GAME-779', 'User-80', '521fbecc-a285-48f5-9036-efb50fe82ff0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:02', NULL, NULL, 0, NULL, NULL),
(781, 782.00, 'Random Game', 'GAME-93', 'User-384', 'a04fbd2d-0e69-4e1c-8b7a-62225056a403', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:02', NULL, NULL, 0, NULL, NULL),
(782, 846.00, 'Random Game', 'GAME-935', 'User-798', '6992d764-a49a-4122-9bd6-8f0a418e9fd1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:04', NULL, NULL, 0, NULL, NULL),
(783, 148.00, 'Random Game', 'GAME-38', 'User-92', '671cba0e-7232-4314-802b-eb4afc1db740', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:04', NULL, NULL, 0, NULL, NULL),
(784, 286.00, 'Random Game', 'GAME-610', 'User-65', 'a52e49df-b721-476a-a0d7-d2ecfec497d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:06', NULL, NULL, 0, NULL, NULL),
(785, 355.00, 'Random Game', 'GAME-434', 'User-245', '1689c49a-35ff-4bff-84c0-7d104bdbcb6e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:07', NULL, NULL, 0, NULL, NULL),
(786, 332.00, 'Random Game', 'GAME-426', 'User-402', '2813c16f-5f13-4c81-a796-22e8a0a4716f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:07', NULL, NULL, 0, NULL, NULL),
(787, 814.00, 'Random Game', 'GAME-919', 'User-356', '5399e418-1558-45f4-a1eb-5f3f8a9ea93b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:08', NULL, NULL, 0, NULL, NULL),
(788, 274.00, 'Random Game', 'GAME-513', 'User-27', '167b6135-6637-4dc0-ad30-3e355818020f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:08', NULL, NULL, 0, NULL, NULL),
(789, 730.00, 'Random Game', 'GAME-968', 'User-616', '2f013c68-d04a-466e-ba8d-bad8dde7e9f3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:18', NULL, NULL, 0, NULL, NULL),
(790, 198.00, 'Random Game', 'GAME-710', 'User-738', '8e19933d-4d5d-4f51-a4f3-925dcc98b7ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:18', NULL, NULL, 0, NULL, NULL),
(791, 993.00, 'Random Game', 'GAME-63', 'User-599', '2ead32dd-c5a4-4b55-ac73-c0237c64392d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:22', NULL, NULL, 0, NULL, NULL),
(792, 399.00, 'Random Game', 'GAME-898', 'User-542', '871c7eba-5b68-4db4-9de7-3c8c0aced2dd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:22', NULL, NULL, 0, NULL, NULL),
(793, 928.00, 'Random Game', 'GAME-7', 'User-528', '97718329-f1f7-4e10-8059-2faf8f83eca8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:24', NULL, NULL, 0, NULL, NULL),
(794, 832.00, 'Random Game', 'GAME-58', 'User-162', 'b1b28f2d-4a23-482b-8bfe-6a38ea78d153', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:24', NULL, NULL, 0, NULL, NULL),
(795, 304.00, 'Random Game', 'GAME-893', 'User-630', 'cfd7af03-f171-4788-befa-f1023c07aac0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:26', NULL, NULL, 0, NULL, NULL),
(796, 630.00, 'Random Game', 'GAME-798', 'User-155', '215327c3-3870-4404-bb97-a47d23bf85c7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:27', NULL, NULL, 0, NULL, NULL),
(797, 490.00, 'Random Game', 'GAME-463', 'User-137', '3a20a137-f4ae-48bb-963a-3b679947c59d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:27', NULL, NULL, 0, NULL, NULL),
(798, 301.00, 'Random Game', 'GAME-672', 'User-110', 'bae337b6-397d-4956-9fc4-3ea475d41709', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:28', NULL, NULL, 0, NULL, NULL),
(799, 728.00, 'Random Game', 'GAME-404', 'User-30', 'b4954d1d-09de-4420-91db-1052b23ea1aa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:28', NULL, NULL, 0, NULL, NULL),
(800, 692.00, 'Random Game', 'GAME-852', 'User-748', '2725bccc-ec5b-490f-ab00-ea491cace7e1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:38', NULL, NULL, 0, NULL, NULL),
(801, 120.00, 'Random Game', 'GAME-765', 'User-876', 'f8d8ee69-5c87-4a5d-ba41-653fc24bc1fd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:38', NULL, NULL, 0, NULL, NULL),
(802, 562.00, 'Random Game', 'GAME-661', 'User-98', '5e1baba5-00bd-4873-90c9-8f9f434da177', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:42', NULL, NULL, 0, NULL, NULL),
(803, 123.00, 'Random Game', 'GAME-633', 'User-761', 'f9eb74b1-7dfe-4ed0-8af7-71561d4d3651', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:42', NULL, NULL, 0, NULL, NULL),
(804, 190.00, 'Random Game', 'GAME-131', 'User-998', 'e0156a41-66f7-4833-ba95-0e935e544b2b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:44', NULL, NULL, 0, NULL, NULL),
(805, 788.00, 'Random Game', 'GAME-231', 'User-267', '540c50e3-5b3e-4ee3-94e2-e1f54f2875e9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:44', NULL, NULL, 0, NULL, NULL),
(806, 83.00, 'Random Game', 'GAME-889', 'User-803', '449b94c0-addf-44d9-ae82-13ba3d966e7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:46', NULL, NULL, 0, NULL, NULL),
(807, 537.00, 'Random Game', 'GAME-939', 'User-105', '4693697c-18a7-4fe4-9ab8-899d70fadc9d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:47', NULL, NULL, 0, NULL, NULL),
(808, 289.00, 'Random Game', 'GAME-294', 'User-600', '045627ae-0042-4526-85b9-7645d214b277', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:47', NULL, NULL, 0, NULL, NULL),
(809, 662.00, 'Random Game', 'GAME-739', 'User-536', 'a1504957-e54c-49fc-a8cc-c030782d3b41', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:48', NULL, NULL, 0, NULL, NULL),
(810, 634.00, 'Random Game', 'GAME-388', 'User-462', 'e004d933-3a1f-4cb5-9fc7-926136cb5607', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:48', NULL, NULL, 0, NULL, NULL),
(811, 979.00, 'Random Game', 'GAME-871', 'User-494', '199dfc12-3cf4-40d6-bafb-00fa15283e86', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:58', NULL, NULL, 0, NULL, NULL),
(812, 81.00, 'Random Game', 'GAME-330', 'User-544', '3a8d1ee2-091a-4285-b202-d08e99c7dedf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:48:58', NULL, NULL, 0, NULL, NULL),
(813, 1040.00, 'Random Game', 'GAME-806', 'User-82', 'cde76bab-adfa-42d9-b9de-c87c77353f80', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:02', NULL, NULL, 0, NULL, NULL),
(814, 613.00, 'Random Game', 'GAME-848', 'User-673', '0b5d768a-9c98-41e0-af1f-84f5b85e794c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:02', NULL, NULL, 0, NULL, NULL),
(815, 251.00, 'Random Game', 'GAME-33', 'User-161', 'e0b055f6-9c20-4bb9-a097-e949ee23ded9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:04', NULL, NULL, 0, NULL, NULL),
(816, 632.00, 'Random Game', 'GAME-503', 'User-590', 'eb4bc04b-6c5d-453f-a0f6-17e518be51ca', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:04', NULL, NULL, 0, NULL, NULL),
(817, 607.00, 'Random Game', 'GAME-766', 'User-492', 'dbdb0518-6671-4b89-8869-a271f01d66cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:06', NULL, NULL, 0, NULL, NULL),
(818, 562.00, 'Random Game', 'GAME-314', 'User-675', '33bbaa8d-6ba7-495d-a10c-d9dce7fcea83', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:07', NULL, NULL, 0, NULL, NULL),
(819, 799.00, 'Random Game', 'GAME-10', 'User-345', '6b157838-67b1-4b1a-a813-2d33a9f753a7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:07', NULL, NULL, 0, NULL, NULL),
(820, 429.00, 'Random Game', 'GAME-947', 'User-50', '31391ed7-8a1e-4129-95ae-da0ef7d6cfe0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:08', NULL, NULL, 0, NULL, NULL),
(821, 678.00, 'Random Game', 'GAME-107', 'User-30', '58f50987-8b2a-4c2b-84b2-68b2566730ff', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:08', NULL, NULL, 0, NULL, NULL),
(822, 161.00, 'Random Game', 'GAME-675', 'User-257', '9eefd496-a186-4628-b61c-ff84e9daed3a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:18', NULL, NULL, 0, NULL, NULL),
(823, 998.00, 'Random Game', 'GAME-515', 'User-166', '920098b3-f169-4e28-8ac3-014c6cbd4fe7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:18', NULL, NULL, 0, NULL, NULL),
(824, 983.00, 'Random Game', 'GAME-502', 'User-233', '07e4a0c9-005f-4814-b946-31a1c1001e32', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:22', NULL, NULL, 0, NULL, NULL),
(825, 598.00, 'Random Game', 'GAME-611', 'User-337', '6b12aa8d-e2e2-4c1a-9c47-6c3bc9a09bff', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:22', NULL, NULL, 0, NULL, NULL),
(826, 954.00, 'Random Game', 'GAME-51', 'User-606', '7d77a47a-95c8-4779-ae0f-e1bc08ef3464', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:24', NULL, NULL, 0, NULL, NULL),
(827, 1015.00, 'Random Game', 'GAME-289', 'User-620', '67dd62cf-7f3d-4029-b23c-b099eee6826f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:24', NULL, NULL, 0, NULL, NULL),
(828, 407.00, 'Random Game', 'GAME-671', 'User-945', 'a1cd7ec9-e9e0-4e83-94d9-8fe62b3ea08f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:26', NULL, NULL, 0, NULL, NULL),
(829, 348.00, 'Random Game', 'GAME-741', 'User-240', 'be2585aa-2f58-4986-aba4-c86725572e37', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:27', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(830, 656.00, 'Random Game', 'GAME-146', 'User-643', '2c9b99f5-12d5-4d82-8924-f4e1ebfa1bd4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:27', NULL, NULL, 0, NULL, NULL),
(831, 305.00, 'Random Game', 'GAME-898', 'User-191', '1ce3d167-b614-4ad3-be13-7a92d4abd70a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:28', NULL, NULL, 0, NULL, NULL),
(832, 227.00, 'Random Game', 'GAME-887', 'User-860', '0dc0a4e2-f51b-4e14-9a7b-a777c3336734', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:28', NULL, NULL, 0, NULL, NULL),
(833, 714.00, 'Random Game', 'GAME-386', 'User-85', 'b9fd1591-72ae-431f-b9a5-569a6c723727', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:38', NULL, NULL, 0, NULL, NULL),
(834, 153.00, 'Random Game', 'GAME-711', 'User-888', 'b2015ad3-cdd9-4f15-8af2-b4dc1f9dd41d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:38', NULL, NULL, 0, NULL, NULL),
(835, 821.00, 'Random Game', 'GAME-29', 'User-141', '3ed99fe6-ea94-437c-b39f-b115626b883a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:42', NULL, NULL, 0, NULL, NULL),
(836, 717.00, 'Random Game', 'GAME-323', 'User-798', 'cb708d76-b84e-49d2-86d0-fa3f84ce6a0f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:42', NULL, NULL, 0, NULL, NULL),
(837, 87.00, 'Random Game', 'GAME-936', 'User-683', '57498d14-c78f-4d76-b228-c78e5816eb48', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:44', NULL, NULL, 0, NULL, NULL),
(838, 996.00, 'Random Game', 'GAME-973', 'User-197', '7f051bb3-28c1-4c7e-832b-3f1f9711d162', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:44', NULL, NULL, 0, NULL, NULL),
(839, 447.00, 'Random Game', 'GAME-146', 'User-671', '493208d0-ea91-428a-95f4-dbb132ee4ba1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:46', NULL, NULL, 0, NULL, NULL),
(840, 968.00, 'Random Game', 'GAME-977', 'User-609', '3ebb5db4-74cc-480a-a705-dc584d2a2d37', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:47', NULL, NULL, 0, NULL, NULL),
(841, 797.00, 'Random Game', 'GAME-132', 'User-958', '78e300bb-62d3-42b9-b16a-e8d24884cee4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:47', NULL, NULL, 0, NULL, NULL),
(842, 340.00, 'Random Game', 'GAME-387', 'User-924', 'f9e9899c-eb81-4439-8eba-c4e8f7d83b3e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:48', NULL, NULL, 0, NULL, NULL),
(843, 565.00, 'Random Game', 'GAME-822', 'User-700', '37acfda9-9e97-4fff-8c96-416bb9f66867', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:48', NULL, NULL, 0, NULL, NULL),
(844, 1022.00, 'Random Game', 'GAME-586', 'User-27', '59b85828-5f5d-45ca-bf74-088a0ab5a953', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:56', NULL, NULL, 0, NULL, NULL),
(845, 932.00, 'Random Game', 'GAME-91', 'User-301', '464e4a7d-12c1-41f9-b2a2-4b829b16a676', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:56', NULL, NULL, 0, NULL, NULL),
(846, 58.00, 'Random Game', 'GAME-323', 'User-214', '854090f0-f333-4a30-9796-8c741d619d59', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:58', NULL, NULL, 0, NULL, NULL),
(847, 199.00, 'Random Game', 'GAME-726', 'User-335', '6e01e18e-8a7e-45cf-8e26-3efde9cf5ab2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:49:58', NULL, NULL, 0, NULL, NULL),
(848, 505.00, 'Random Game', 'GAME-731', 'User-596', 'c13d0db6-a272-4f5c-918f-0eea2992d89c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:02', NULL, NULL, 0, NULL, NULL),
(849, 515.00, 'Random Game', 'GAME-742', 'User-479', '000afc26-8462-412b-aae6-2f93591f764c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:02', NULL, NULL, 0, NULL, NULL),
(850, 894.00, 'Random Game', 'GAME-618', 'User-893', 'd6dadf7e-cbec-417b-8888-5a09beeae7c5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:04', NULL, NULL, 0, NULL, NULL),
(851, 374.00, 'Random Game', 'GAME-374', 'User-446', '13cbd631-5b41-4fbe-9d8b-49daba427be4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:04', NULL, NULL, 0, NULL, NULL),
(852, 599.00, 'Random Game', 'GAME-559', 'User-145', '359168fc-f021-4481-bb41-ff7d76e91c41', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:06', NULL, NULL, 0, NULL, NULL),
(853, 970.00, 'Random Game', 'GAME-962', 'User-457', '44729711-9320-4e73-b878-62c0b2578fef', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:07', NULL, NULL, 0, NULL, NULL),
(854, 914.00, 'Random Game', 'GAME-741', 'User-878', '26c226c0-ceba-4eba-a8b3-4304e5e368d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:07', NULL, NULL, 0, NULL, NULL),
(855, 878.00, 'Random Game', 'GAME-639', 'User-502', 'c824673f-7904-4355-ba22-21dfd34984c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:08', NULL, NULL, 0, NULL, NULL),
(856, 95.00, 'Random Game', 'GAME-794', 'User-161', 'ab21986b-4cc7-482c-b0b0-e3d302efa257', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:08', NULL, NULL, 0, NULL, NULL),
(857, 319.00, 'Random Game', 'GAME-157', 'User-398', 'f6db6c36-6fa9-4fa1-92ae-b413e03992a2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:16', NULL, NULL, 0, NULL, NULL),
(858, 160.00, 'Random Game', 'GAME-164', 'User-785', '45e9adf0-a068-4d19-9c04-2de1cefda23d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:16', NULL, NULL, 0, NULL, NULL),
(859, 503.00, 'Random Game', 'GAME-418', 'User-674', '2e2375cc-18ac-446e-ae49-cda4fe2079f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:18', NULL, NULL, 0, NULL, NULL),
(860, 991.00, 'Random Game', 'GAME-711', 'User-233', 'd6330acf-6e99-4766-96b4-349df9adfbfb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:18', NULL, NULL, 0, NULL, NULL),
(861, 895.00, 'Random Game', 'GAME-118', 'User-933', 'daaac785-590c-4f2e-8544-2aa48aae430e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:22', NULL, NULL, 0, NULL, NULL),
(862, 227.00, 'Random Game', 'GAME-76', 'User-145', '5fabf3e8-364f-4ed8-8ea0-f8a8f71f8531', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:22', NULL, NULL, 0, NULL, NULL),
(863, 820.00, 'Random Game', 'GAME-232', 'User-454', 'f68e40da-3b24-4978-9000-383ea4c97bcf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:24', NULL, NULL, 0, NULL, NULL),
(864, 784.00, 'Random Game', 'GAME-837', 'User-88', 'aefcd0f6-dad8-40d2-87fb-c606ea9298a9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:24', NULL, NULL, 0, NULL, NULL),
(865, 287.00, 'Random Game', 'GAME-926', 'User-200', '148cbc32-4030-4e8a-a45f-e6a81f563c42', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:26', NULL, NULL, 0, NULL, NULL),
(866, 665.00, 'Random Game', 'GAME-353', 'User-937', 'ad910591-a86e-4caa-b756-ee1f9a21ff56', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:27', NULL, NULL, 0, NULL, NULL),
(867, 918.00, 'Random Game', 'GAME-170', 'User-57', 'fcbcd847-32bc-44f3-be27-f08d6ab2708f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:27', NULL, NULL, 0, NULL, NULL),
(868, 203.00, 'Random Game', 'GAME-758', 'User-474', '0b5c3319-aa80-4009-b569-e977b1f75dbf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:28', NULL, NULL, 0, NULL, NULL),
(869, 167.00, 'Random Game', 'GAME-616', 'User-297', '98d39f87-2afd-4ab3-9cdb-7c50bb698134', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:28', NULL, NULL, 0, NULL, NULL),
(870, 307.00, 'Random Game', 'GAME-168', 'User-357', 'f58add7b-9808-44c9-9bb0-287516f7f08f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:36', NULL, NULL, 0, NULL, NULL),
(871, 344.00, 'Random Game', 'GAME-228', 'User-543', 'e73cd6f8-8a75-4520-b50a-c34bb5a8fc07', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:36', NULL, NULL, 0, NULL, NULL),
(872, 910.00, 'Random Game', 'GAME-93', 'User-704', '7703bf57-b4c4-4490-a43b-d45703646aaa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:38', NULL, NULL, 0, NULL, NULL),
(873, 663.00, 'Random Game', 'GAME-491', 'User-490', '9ee1f059-b399-4741-b2dc-b6a4c086e378', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:38', NULL, NULL, 0, NULL, NULL),
(874, 1005.00, 'Random Game', 'GAME-592', 'User-260', 'e955b3f4-8845-4b3f-b51a-312b01459275', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:42', NULL, NULL, 0, NULL, NULL),
(875, 660.00, 'Random Game', 'GAME-670', 'User-749', '1024fcbb-ee0d-4973-ab6b-6fc2ccb526b6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:42', NULL, NULL, 0, NULL, NULL),
(876, 777.00, 'Random Game', 'GAME-90', 'User-333', '67c1fb4b-3f10-4bea-93cd-709826f42782', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:44', NULL, NULL, 0, NULL, NULL),
(877, 737.00, 'Random Game', 'GAME-487', 'User-965', '354a1ed2-4075-4802-9ef8-6ff091fcf2f5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:44', NULL, NULL, 0, NULL, NULL),
(878, 221.00, 'Random Game', 'GAME-46', 'User-193', '82b7d1d7-291d-464a-a098-807643a1538f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:46', NULL, NULL, 0, NULL, NULL),
(879, 492.00, 'Random Game', 'GAME-711', 'User-959', 'e7571b05-818a-4506-aba9-097983698fe7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:47', NULL, NULL, 0, NULL, NULL),
(880, 923.00, 'Random Game', 'GAME-825', 'User-818', '4c0ae8da-fc98-48d4-b275-498f56fd559d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:47', NULL, NULL, 0, NULL, NULL),
(881, 524.00, 'Random Game', 'GAME-205', 'User-615', '3eb05f0a-4b7e-4920-9397-2c6a20bf9895', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:48', NULL, NULL, 0, NULL, NULL),
(882, 693.00, 'Random Game', 'GAME-695', 'User-262', '4a5c32af-ec95-4d88-b871-6ff167575327', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:48', NULL, NULL, 0, NULL, NULL),
(883, 1020.00, 'Random Game', 'GAME-172', 'User-69', 'd92d2988-66f2-464c-916f-72aad315e91b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:56', NULL, NULL, 0, NULL, NULL),
(884, 161.00, 'Random Game', 'GAME-216', 'User-11', 'f9be4b6e-4120-47e7-9dc4-fb242d9a2501', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:56', NULL, NULL, 0, NULL, NULL),
(885, 862.00, 'Random Game', 'GAME-997', 'User-789', 'ead1571f-beba-4de8-9f4b-dc81df9a8cdd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:58', NULL, NULL, 0, NULL, NULL),
(886, 650.00, 'Random Game', 'GAME-997', 'User-26', '82aaecd1-51b7-4982-a332-41a85f38f6ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:50:58', NULL, NULL, 0, NULL, NULL),
(887, 271.00, 'Random Game', 'GAME-432', 'User-92', '4810d8dd-737a-4e51-a868-ce535ea89f58', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:02', NULL, NULL, 0, NULL, NULL),
(888, 155.00, 'Random Game', 'GAME-0', 'User-303', '33456050-3862-45d4-8054-1d683ab2f986', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:02', NULL, NULL, 0, NULL, NULL),
(889, 336.00, 'Random Game', 'GAME-159', 'User-702', '3ba46b11-b451-453f-a411-beac00ca43e7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:04', NULL, NULL, 0, NULL, NULL),
(890, 874.00, 'Random Game', 'GAME-342', 'User-262', '191160ef-d668-4954-8f5f-58e1643c9a3d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:04', NULL, NULL, 0, NULL, NULL),
(891, 137.00, 'Random Game', 'GAME-778', 'User-358', '766bb5a9-3067-4457-9716-21fcede9f999', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:06', NULL, NULL, 0, NULL, NULL),
(892, 790.00, 'Random Game', 'GAME-17', 'User-768', 'd130975a-688e-4213-bc52-c378be35d34c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:07', NULL, NULL, 0, NULL, NULL),
(893, 341.00, 'Random Game', 'GAME-533', 'User-942', '645c4bf4-c0ba-49e6-bef5-9c4a8dd4695d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:07', NULL, NULL, 0, NULL, NULL),
(894, 986.00, 'Random Game', 'GAME-531', 'User-256', 'abdae505-a77f-4a4a-9285-92d95835dfaa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:08', NULL, NULL, 0, NULL, NULL),
(895, 260.00, 'Random Game', 'GAME-972', 'User-70', '88cec12d-6aff-4e07-8b52-b96493225fdf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:08', NULL, NULL, 0, NULL, NULL),
(896, 567.00, 'Random Game', 'GAME-694', 'User-449', 'e17fc13b-a824-4cca-a7bc-fa86fec0217b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:16', NULL, NULL, 0, NULL, NULL),
(897, 341.00, 'Random Game', 'GAME-617', 'User-953', '6672d112-58b9-418f-afae-469bca9acc67', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:16', NULL, NULL, 0, NULL, NULL),
(898, 681.00, 'Random Game', 'GAME-923', 'User-388', 'c96ce924-4c57-4744-b75d-215c95fe6693', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:18', NULL, NULL, 0, NULL, NULL),
(899, 451.00, 'Random Game', 'GAME-559', 'User-779', '53d5c649-5a6e-481e-a1b1-f16ad5d12b57', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:18', NULL, NULL, 0, NULL, NULL),
(900, 1036.00, 'Random Game', 'GAME-133', 'User-330', '7f4c6d0c-e6e9-4260-b69d-9aea25badd97', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:22', NULL, NULL, 0, NULL, NULL),
(901, 234.00, 'Random Game', 'GAME-260', 'User-555', '6401773f-174c-419b-bf34-e297d5cb2350', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:22', NULL, NULL, 0, NULL, NULL),
(902, 785.00, 'Random Game', 'GAME-254', 'User-346', 'c13c7cbb-206f-4a8f-8bed-9d7e23da18c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:24', NULL, NULL, 0, NULL, NULL),
(903, 647.00, 'Random Game', 'GAME-957', 'User-842', '8729bcba-a4ef-4573-bbc9-a5f2bfde2606', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:24', NULL, NULL, 0, NULL, NULL),
(904, 393.00, 'Random Game', 'GAME-96', 'User-424', '3e23f82b-1e1f-4b89-b6f1-dc88360edb5a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:26', NULL, NULL, 0, NULL, NULL),
(905, 566.00, 'Random Game', 'GAME-362', 'User-294', '5f3f0ef9-ee57-47bd-b765-38bfe0b213a1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:27', NULL, NULL, 0, NULL, NULL),
(906, 802.00, 'Random Game', 'GAME-436', 'User-662', 'c8d24729-04ea-4f35-8f6a-34c5a2923555', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:27', NULL, NULL, 0, NULL, NULL),
(907, 283.00, 'Random Game', 'GAME-955', 'User-361', '62e021b8-0d9f-4b9a-addc-2367a758ab3d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:28', NULL, NULL, 0, NULL, NULL),
(908, 1025.00, 'Random Game', 'GAME-52', 'User-448', '357cefbf-d67a-4fa7-b256-f5d285574a0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:28', NULL, NULL, 0, NULL, NULL),
(909, 399.00, 'Random Game', 'GAME-126', 'User-710', 'a8e9750b-92a6-4000-b943-6bf65707371d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:36', NULL, NULL, 0, NULL, NULL),
(910, 814.00, 'Random Game', 'GAME-140', 'User-321', '85c0fc84-078e-4770-9720-df28f846a0e2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:36', NULL, NULL, 0, NULL, NULL),
(911, 696.00, 'Random Game', 'GAME-901', 'User-601', '4df0543f-6909-4524-b5d1-651c78a1c56f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:38', NULL, NULL, 0, NULL, NULL),
(912, 205.00, 'Random Game', 'GAME-956', 'User-644', '43336dba-65a2-4cf0-8f37-2f834d162695', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:38', NULL, NULL, 0, NULL, NULL),
(913, 367.00, 'Random Game', 'GAME-794', 'User-783', 'c29fcc02-32fa-41cc-a4fd-fa11db0591d7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:42', NULL, NULL, 0, NULL, NULL),
(914, 353.00, 'Random Game', 'GAME-380', 'User-419', '56014bb4-0059-4ff1-922a-a094e227d852', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:42', NULL, NULL, 0, NULL, NULL),
(915, 73.00, 'Random Game', 'GAME-810', 'User-932', '7b6962d7-63d5-4a3c-802d-7ac202b46b46', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:44', NULL, NULL, 0, NULL, NULL),
(916, 508.00, 'Random Game', 'GAME-392', 'User-671', 'cf978d4c-57b7-4338-8281-07d9aff6308b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:44', NULL, NULL, 0, NULL, NULL),
(917, 795.00, 'Random Game', 'GAME-110', 'User-242', '6daf245f-2ae2-4236-9ebb-1018c52fe515', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:46', NULL, NULL, 0, NULL, NULL),
(918, 216.00, 'Random Game', 'GAME-773', 'User-669', '7d19e271-cc5e-478c-8052-fd36ac3125fa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:47', NULL, NULL, 0, NULL, NULL),
(919, 248.00, 'Random Game', 'GAME-246', 'User-707', '3c1868cb-3cae-49c0-b947-3e6e28afd849', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:47', NULL, NULL, 0, NULL, NULL),
(920, 899.00, 'Random Game', 'GAME-622', 'User-84', 'd1dee45f-8666-4f20-bb47-46e4e023fa4d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:48', NULL, NULL, 0, NULL, NULL),
(921, 608.00, 'Random Game', 'GAME-170', 'User-379', '61c44068-f2a5-4aaa-bf92-4d8a47725bd1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:48', NULL, NULL, 0, NULL, NULL),
(922, 918.00, 'Random Game', 'GAME-319', 'User-620', 'a053506d-3ba0-4cb5-bd67-95fe795d7e38', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:56', NULL, NULL, 0, NULL, NULL),
(923, 312.00, 'Random Game', 'GAME-826', 'User-18', '4d691eef-92ca-454b-9a02-5a859dcbdf21', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:56', NULL, NULL, 0, NULL, NULL),
(924, 254.00, 'Random Game', 'GAME-560', 'User-48', 'b3e50303-c522-4291-b890-9c8b32d76b4d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:58', NULL, NULL, 0, NULL, NULL),
(925, 689.00, 'Random Game', 'GAME-387', 'User-861', '04a23c55-0a39-49bd-8c25-2a8663cb2f22', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:51:58', NULL, NULL, 0, NULL, NULL),
(926, 262.00, 'Random Game', 'GAME-239', 'User-521', '750f3158-1d41-47d6-97bd-a9073ddbb541', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:02', NULL, NULL, 0, NULL, NULL),
(927, 1040.00, 'Random Game', 'GAME-349', 'User-905', '17b86b56-89b6-42c4-8514-36d38a0baf0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:02', NULL, NULL, 0, NULL, NULL),
(928, 162.00, 'Random Game', 'GAME-939', 'User-99', '1312c527-4cbd-4901-8b69-fbaf180f62ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:04', NULL, NULL, 0, NULL, NULL),
(929, 682.00, 'Random Game', 'GAME-610', 'User-116', '13b44a78-fb5c-4519-be37-f966bfa45ef9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:04', NULL, NULL, 0, NULL, NULL),
(930, 587.00, 'Random Game', 'GAME-410', 'User-2', 'dd1f5873-429d-424f-a79a-6813df58c4f5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:06', NULL, NULL, 0, NULL, NULL),
(931, 680.00, 'Random Game', 'GAME-609', 'User-729', 'f584c22f-49bf-46c0-8212-861a8f48c7ca', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:07', NULL, NULL, 0, NULL, NULL),
(932, 370.00, 'Random Game', 'GAME-249', 'User-743', 'e88fdf10-cc74-4b3d-97eb-1b5630bb8c61', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:07', NULL, NULL, 0, NULL, NULL),
(933, 68.00, 'Random Game', 'GAME-82', 'User-710', 'cf404b5d-5ed3-499d-a26f-3be656077340', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:08', NULL, NULL, 0, NULL, NULL),
(934, 237.00, 'Random Game', 'GAME-596', 'User-49', '7c8b77ec-ca3c-467b-b1db-9c76f0a3fc5e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:08', NULL, NULL, 0, NULL, NULL),
(935, 293.00, 'Random Game', 'GAME-939', 'User-579', '9b37e9e6-36d0-4d80-8815-29c4e62c2ab3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:16', NULL, NULL, 0, NULL, NULL),
(936, 123.00, 'Random Game', 'GAME-899', 'User-116', '65eb777d-f1a9-4afb-a3b8-583558b2ddfa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:16', NULL, NULL, 0, NULL, NULL),
(937, 759.00, 'Random Game', 'GAME-144', 'User-250', 'ec6ec146-9c54-4627-95dc-28845e19618d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:18', NULL, NULL, 0, NULL, NULL),
(938, 436.00, 'Random Game', 'GAME-314', 'User-66', '21efda79-c1db-4db3-902c-9b971292fbc6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:18', NULL, NULL, 0, NULL, NULL),
(939, 197.00, 'Random Game', 'GAME-556', 'User-335', '59edc731-3eb2-40f3-ba18-657fc7a5df20', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:22', NULL, NULL, 0, NULL, NULL),
(940, 138.00, 'Random Game', 'GAME-269', 'User-578', 'a1326b89-89f1-40fe-9ada-0c9ba86ebef8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:22', NULL, NULL, 0, NULL, NULL),
(941, 981.00, 'Random Game', 'GAME-98', 'User-761', '9b600ec1-686b-4964-b0dd-7a5212c8ab35', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:24', NULL, NULL, 0, NULL, NULL),
(942, 206.00, 'Random Game', 'GAME-196', 'User-470', '4b62ccb4-751b-430e-99e7-59a09a09510b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:24', NULL, NULL, 0, NULL, NULL),
(943, 688.00, 'Random Game', 'GAME-25', 'User-529', '8dba1859-6d9e-40c4-9255-0b672f37e722', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:26', NULL, NULL, 0, NULL, NULL),
(944, 835.00, 'Random Game', 'GAME-709', 'User-173', 'a2a83ff3-30e4-4a8d-9fc2-81fcd05f5496', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:27', NULL, NULL, 0, NULL, NULL),
(945, 89.00, 'Random Game', 'GAME-684', 'User-807', '2de9db64-d44e-4475-b6fc-1a696cbe0cd5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:27', NULL, NULL, 0, NULL, NULL),
(946, 142.00, 'Random Game', 'GAME-651', 'User-343', '4c98d045-8dbe-412c-8900-0ea6be1efe53', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:28', NULL, NULL, 0, NULL, NULL),
(947, 617.00, 'Random Game', 'GAME-213', 'User-775', 'd00a0e1e-d8cb-429a-ba34-a0025898ae64', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:28', NULL, NULL, 0, NULL, NULL),
(948, 681.00, 'Random Game', 'GAME-337', 'User-39', 'ca37d599-c95f-4cda-b840-03643db6ec7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:36', NULL, NULL, 0, NULL, NULL),
(949, 255.00, 'Random Game', 'GAME-271', 'User-775', '6cacddce-e03e-4dbb-ad6b-4635c22fa0ce', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:36', NULL, NULL, 0, NULL, NULL),
(950, 340.00, 'Random Game', 'GAME-632', 'User-36', '00f879f1-8e76-4bae-a7e5-4872ccc27449', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:38', NULL, NULL, 0, NULL, NULL),
(951, 203.00, 'Random Game', 'GAME-304', 'User-933', '73b1dd70-3475-485e-a173-b00e66a5fa73', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:38', NULL, NULL, 0, NULL, NULL),
(952, 608.00, 'Random Game', 'GAME-375', 'User-800', 'e21e7e9d-58ec-4931-99a6-b0347d2040b8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:42', NULL, NULL, 0, NULL, NULL),
(953, 139.00, 'Random Game', 'GAME-273', 'User-33', '60a465e0-6def-4ec5-9daf-09e97e814ef9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:42', NULL, NULL, 0, NULL, NULL),
(954, 207.00, 'Random Game', 'GAME-431', 'User-687', '4efdf4d8-d517-4ae9-9c64-12cb6c3e28bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:44', NULL, NULL, 0, NULL, NULL),
(955, 90.00, 'Random Game', 'GAME-834', 'User-282', '0f478f9e-db3e-418d-b8f7-6d88a0cc780e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:44', NULL, NULL, 0, NULL, NULL),
(956, 1014.00, 'Random Game', 'GAME-754', 'User-223', 'e633a567-6d47-4c85-90b4-bcbc8a3909b1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:46', NULL, NULL, 0, NULL, NULL),
(957, 356.00, 'Random Game', 'GAME-470', 'User-131', '774a0258-ba7a-4ce2-befc-2fcf8e392b61', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:47', NULL, NULL, 0, NULL, NULL),
(958, 617.00, 'Random Game', 'GAME-89', 'User-219', '97488695-624d-4641-a4e2-9dd672dba1ec', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:47', NULL, NULL, 0, NULL, NULL),
(959, 949.00, 'Random Game', 'GAME-686', 'User-742', '5214940c-1993-4296-8105-b4838e493123', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:48', NULL, NULL, 0, NULL, NULL),
(960, 595.00, 'Random Game', 'GAME-664', 'User-984', '0f326336-f2ee-4b5c-85e8-eafedef9dc2d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:48', NULL, NULL, 0, NULL, NULL),
(961, 475.00, 'Random Game', 'GAME-832', 'User-686', '69ece530-b876-4452-bacc-90bf8e5b5bd3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:56', NULL, NULL, 0, NULL, NULL),
(962, 62.00, 'Random Game', 'GAME-892', 'User-692', 'eeb27be2-59f3-4eeb-92b4-4f4dbc5ed9ff', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:56', NULL, NULL, 0, NULL, NULL),
(963, 133.00, 'Random Game', 'GAME-520', 'User-386', '046ce796-0bb7-4628-a1b4-79fa0a635f93', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:58', NULL, NULL, 0, NULL, NULL),
(964, 771.00, 'Random Game', 'GAME-703', 'User-270', 'b9676eca-2b63-4604-964d-74987d7fe596', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:52:58', NULL, NULL, 0, NULL, NULL),
(965, 1028.00, 'Random Game', 'GAME-634', 'User-706', 'e14725be-1045-42e8-9efe-e02400924925', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:02', NULL, NULL, 0, NULL, NULL),
(966, 902.00, 'Random Game', 'GAME-558', 'User-392', '72f3e1c0-eddf-4cf2-bfd8-057cba29edde', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:02', NULL, NULL, 0, NULL, NULL),
(967, 239.00, 'Random Game', 'GAME-566', 'User-464', '5a2c1c00-50de-4949-95f0-5a7865f5c6f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:04', NULL, NULL, 0, NULL, NULL),
(968, 377.00, 'Random Game', 'GAME-700', 'User-657', '43d272ef-f686-4089-966f-6e035afd2dbd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:04', NULL, NULL, 0, NULL, NULL),
(969, 543.00, 'Random Game', 'GAME-281', 'User-922', 'cddf5a2a-f1c9-4613-8807-73194373fc73', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:06', NULL, NULL, 0, NULL, NULL),
(970, 479.00, 'Random Game', 'GAME-548', 'User-2', 'c7f3e55b-0324-482a-b155-cfe6fe6716f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:07', NULL, NULL, 0, NULL, NULL),
(971, 363.00, 'Random Game', 'GAME-277', 'User-314', '1c11f0a4-a639-4d1f-a3d6-3a340def283b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:07', NULL, NULL, 0, NULL, NULL),
(972, 198.00, 'Random Game', 'GAME-353', 'User-967', 'b7801c6e-8486-4414-97da-160bb9ee2671', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:08', NULL, NULL, 0, NULL, NULL),
(973, 1005.00, 'Random Game', 'GAME-650', 'User-381', 'bb05e08f-d364-4cc2-b7e9-b29468964be7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:08', NULL, NULL, 0, NULL, NULL),
(974, 950.00, 'Random Game', 'GAME-302', 'User-833', 'f526ea42-a37d-414a-8837-07fbb3ba52a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:16', NULL, NULL, 0, NULL, NULL),
(975, 320.00, 'Random Game', 'GAME-516', 'User-812', 'c1b0817c-29e5-48a8-8c47-c9b98fb7a91e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:16', NULL, NULL, 0, NULL, NULL),
(976, 587.00, 'Random Game', 'GAME-106', 'User-451', '2561d792-32e5-4418-a3a2-6375efa6c3f3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:18', NULL, NULL, 0, NULL, NULL),
(977, 823.00, 'Random Game', 'GAME-444', 'User-40', '5ce45eed-e74c-4e23-916d-aae519c4903f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:18', NULL, NULL, 0, NULL, NULL),
(978, 1015.00, 'Random Game', 'GAME-953', 'User-429', 'd32b5460-a935-4ef6-9cd9-79206563ea2d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:22', NULL, NULL, 0, NULL, NULL),
(979, 611.00, 'Random Game', 'GAME-405', 'User-354', '4a44fab8-aeea-42b4-8aae-62f57a266daa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:22', NULL, NULL, 0, NULL, NULL),
(980, 747.00, 'Random Game', 'GAME-212', 'User-965', 'cc212ffa-68ba-4e66-b49a-276a40335c26', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:24', NULL, NULL, 0, NULL, NULL),
(981, 519.00, 'Random Game', 'GAME-646', 'User-288', '97b6b4f8-3102-406d-b470-a00fc6b3bf9b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:24', NULL, NULL, 0, NULL, NULL),
(982, 192.00, 'Random Game', 'GAME-622', 'User-633', '1328c557-9995-482f-9643-0581f8c43541', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:26', NULL, NULL, 0, NULL, NULL),
(983, 284.00, 'Random Game', 'GAME-189', 'User-299', 'c186dde5-eb69-4419-aafd-5a7c2f713249', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:27', NULL, NULL, 0, NULL, NULL),
(984, 790.00, 'Random Game', 'GAME-896', 'User-828', '89fda4fa-8b10-4e7d-a85b-003e7cc5e2fb', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:27', NULL, NULL, 0, NULL, NULL),
(985, 545.00, 'Random Game', 'GAME-261', 'User-284', '2c321835-eb28-4201-a85c-a5424fec3d45', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:28', NULL, NULL, 0, NULL, NULL),
(986, 220.00, 'Random Game', 'GAME-197', 'User-513', '4a55f75f-d174-4d31-ba18-e6157b8ada13', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:28', NULL, NULL, 0, NULL, NULL),
(987, 382.00, 'Random Game', 'GAME-644', 'User-619', 'd8ee6e43-08dd-47aa-8394-96ee36b54035', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:36', NULL, NULL, 0, NULL, NULL),
(988, 266.00, 'Random Game', 'GAME-565', 'User-394', '5a9ebc4c-09c7-4d71-b0d6-f5f70da68b67', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:36', NULL, NULL, 0, NULL, NULL),
(989, 432.00, 'Random Game', 'GAME-957', 'User-731', 'e16bb2a0-210a-415e-b0b2-a0948732af9f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:38', NULL, NULL, 0, NULL, NULL),
(990, 513.00, 'Random Game', 'GAME-438', 'User-464', 'd1110483-70bb-469f-a9a6-a6a5976d6589', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:38', NULL, NULL, 0, NULL, NULL),
(991, 735.00, 'Random Game', 'GAME-745', 'User-308', '7fc145a8-78af-44bd-8729-bdb0b5755405', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:42', NULL, NULL, 0, NULL, NULL),
(992, 796.00, 'Random Game', 'GAME-308', 'User-360', '5f98a998-2ed3-4a1e-84e2-a1cbbe274c1f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:42', NULL, NULL, 0, NULL, NULL),
(993, 153.00, 'Random Game', 'GAME-897', 'User-1', '2d430215-f45d-4cb9-958f-f120b2c655c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:44', NULL, NULL, 0, NULL, NULL),
(994, 920.00, 'Random Game', 'GAME-252', 'User-39', 'a98b7a6c-0d1d-4356-a9ca-bdaf31c8df3a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:44', NULL, NULL, 0, NULL, NULL),
(995, 345.00, 'Random Game', 'GAME-752', 'User-912', '824dbf24-4a07-417e-9152-be02c2215774', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:46', NULL, NULL, 0, NULL, NULL),
(996, 283.00, 'Random Game', 'GAME-730', 'User-270', '79b72838-ff37-465a-9c43-efe4f7733427', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:47', NULL, NULL, 0, NULL, NULL),
(997, 851.00, 'Random Game', 'GAME-237', 'User-220', '9f8ef518-1a0e-4c64-ae6a-4c0fec6c80de', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:47', NULL, NULL, 0, NULL, NULL),
(998, 959.00, 'Random Game', 'GAME-293', 'User-699', '7d039800-af45-46d1-81a2-ee8f0d98b18a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:48', NULL, NULL, 0, NULL, NULL),
(999, 510.00, 'Random Game', 'GAME-387', 'User-516', 'a606edc4-76f5-4001-9ba6-1ce3bedf6e6b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:48', NULL, NULL, 0, NULL, NULL),
(1000, 136.00, 'Random Game', 'GAME-988', 'User-805', 'e32e73e1-a6f1-4c07-98d8-711ffe14ce27', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:56', NULL, NULL, 0, NULL, NULL),
(1001, 941.00, 'Random Game', 'GAME-537', 'User-668', 'b4ebb758-137a-4be6-9046-ba01ec50de4b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:56', NULL, NULL, 0, NULL, NULL),
(1002, 339.00, 'Random Game', 'GAME-144', 'User-471', '834ade25-dc00-4607-964c-31d48e0ea568', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:58', NULL, NULL, 0, NULL, NULL),
(1003, 727.00, 'Random Game', 'GAME-608', 'User-18', 'ecd5a935-9619-402b-ab62-bf6ff5d2175b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:53:58', NULL, NULL, 0, NULL, NULL),
(1004, 446.00, 'Random Game', 'GAME-101', 'User-840', '26fc9180-d943-434c-b1ac-77112fb7b73a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:02', NULL, NULL, 0, NULL, NULL),
(1005, 942.00, 'Random Game', 'GAME-236', 'User-544', '93d1dd2a-b1ce-480e-948c-43d48d54fc0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:02', NULL, NULL, 0, NULL, NULL),
(1006, 1000.00, 'Random Game', 'GAME-121', 'User-438', '7e26f85d-ce99-4d2a-9d47-18689982a443', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:04', NULL, NULL, 0, NULL, NULL),
(1007, 939.00, 'Random Game', 'GAME-524', 'User-521', '18ca63f0-cc23-4ed4-88a7-63dd5eb2a01c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:04', NULL, NULL, 0, NULL, NULL),
(1008, 493.00, 'Random Game', 'GAME-191', 'User-864', '9925be8d-f3a7-4985-a7ae-458af557442c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:06', NULL, NULL, 0, NULL, NULL),
(1009, 316.00, 'Random Game', 'GAME-952', 'User-741', '6485ce77-3df7-4548-a693-5e4ccb7838f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:07', NULL, NULL, 0, NULL, NULL),
(1010, 992.00, 'Random Game', 'GAME-689', 'User-926', '8c90a264-7101-4e9f-9b07-bd504fbff12c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:07', NULL, NULL, 0, NULL, NULL),
(1011, 305.00, 'Random Game', 'GAME-919', 'User-395', '7ace1352-e419-4249-a8ca-906aa3f46a19', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:08', NULL, NULL, 0, NULL, NULL),
(1012, 1007.00, 'Random Game', 'GAME-740', 'User-607', '82a04948-ba0c-4003-b0ce-b1d4a268d767', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:08', NULL, NULL, 0, NULL, NULL),
(1013, 419.00, 'Random Game', 'GAME-448', 'User-414', 'b2ca9d70-eb7e-46e8-a911-89372b5a081d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:16', NULL, NULL, 0, NULL, NULL),
(1014, 625.00, 'Random Game', 'GAME-865', 'User-112', '2617f403-e91f-46d4-b863-1abafd3494f0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:16', NULL, NULL, 0, NULL, NULL),
(1015, 678.00, 'Random Game', 'GAME-941', 'User-51', '87a39582-5392-4d0a-8280-b49c3b28f8ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:18', NULL, NULL, 0, NULL, NULL),
(1016, 906.00, 'Random Game', 'GAME-27', 'User-901', '395acda8-7914-44c3-9ecd-8d768af9e7e5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:18', NULL, NULL, 0, NULL, NULL),
(1017, 268.00, 'Random Game', 'GAME-294', 'User-389', '868104b0-2d1e-4732-96cd-797ace68a1ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:22', NULL, NULL, 0, NULL, NULL),
(1018, 981.00, 'Random Game', 'GAME-209', 'User-214', '268ae1b9-e688-4b35-90a7-b929c999972d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:22', NULL, NULL, 0, NULL, NULL),
(1019, 304.00, 'Random Game', 'GAME-124', 'User-360', '245128f6-f8f8-4486-be60-7091d247a52f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:24', NULL, NULL, 0, NULL, NULL),
(1020, 489.00, 'Random Game', 'GAME-799', 'User-593', 'a776d915-4a4b-4802-b94c-67bbc3eddd62', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:24', NULL, NULL, 0, NULL, NULL),
(1021, 713.00, 'Random Game', 'GAME-178', 'User-35', 'bc62ef02-bc21-46de-b2e2-cf446010d381', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:26', NULL, NULL, 0, NULL, NULL),
(1022, 810.00, 'Random Game', 'GAME-732', 'User-318', 'aa0859b5-c2d8-405a-abe6-ca351e6d8d70', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:27', NULL, NULL, 0, NULL, NULL),
(1023, 246.00, 'Random Game', 'GAME-741', 'User-917', 'cdf4ea0c-fb51-4b54-a5af-31cd66a0c844', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:27', NULL, NULL, 0, NULL, NULL),
(1024, 868.00, 'Random Game', 'GAME-326', 'User-882', '7524f64f-c742-492b-9f38-85afbc9215f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:28', NULL, NULL, 0, NULL, NULL),
(1025, 327.00, 'Random Game', 'GAME-570', 'User-283', 'c7bf17bf-800e-4a43-bd6f-63855820db17', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:28', NULL, NULL, 0, NULL, NULL),
(1026, 755.00, 'Random Game', 'GAME-189', 'User-659', 'd91df8ca-89b2-49be-88fe-4cc8a400a531', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:36', NULL, NULL, 0, NULL, NULL),
(1027, 336.00, 'Random Game', 'GAME-171', 'User-522', '9556b275-a163-453e-9e09-f41d0142245b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:36', NULL, NULL, 0, NULL, NULL),
(1028, 367.00, 'Random Game', 'GAME-777', 'User-76', 'e32ddfb8-b342-437d-9af0-02c0471d0ef6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:38', NULL, NULL, 0, NULL, NULL),
(1029, 697.00, 'Random Game', 'GAME-925', 'User-845', '0b5a244b-2d62-4c3e-ae63-b328fddd52ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:38', NULL, NULL, 0, NULL, NULL),
(1030, 360.00, 'Random Game', 'GAME-384', 'User-533', '58caa4e0-d6c8-4b2f-a192-76d6e592f605', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:42', NULL, NULL, 0, NULL, NULL),
(1031, 627.00, 'Random Game', 'GAME-987', 'User-658', '9a25cfbc-d1bd-4540-808b-28bb661db9a6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:42', NULL, NULL, 0, NULL, NULL),
(1032, 218.00, 'Random Game', 'GAME-904', 'User-32', '1b7890c8-0223-4f06-b094-acb821c5a3cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:44', NULL, NULL, 0, NULL, NULL),
(1033, 696.00, 'Random Game', 'GAME-99', 'User-749', 'a9e8391d-80af-4c5a-b7c5-4f212d73b134', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:44', NULL, NULL, 0, NULL, NULL),
(1034, 972.00, 'Random Game', 'GAME-123', 'User-121', 'ea20a803-37ae-43c3-8d77-d6c3bbf6dde9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:46', NULL, NULL, 0, NULL, NULL),
(1035, 740.00, 'Random Game', 'GAME-938', 'User-980', 'f4ae66c7-1a3f-4c34-a0eb-c15dc537ddaf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:47', NULL, NULL, 0, NULL, NULL),
(1036, 645.00, 'Random Game', 'GAME-609', 'User-692', 'a35f5e4d-6a7a-4dd6-9bd6-20b71a93d593', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:47', NULL, NULL, 0, NULL, NULL),
(1037, 729.00, 'Random Game', 'GAME-748', 'User-277', '706eed9f-b794-41a2-96db-c462cb201bf4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:48', NULL, NULL, 0, NULL, NULL),
(1038, 747.00, 'Random Game', 'GAME-384', 'User-701', 'fbc9b1be-60e0-4ec4-968a-d495195e56d0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:48', NULL, NULL, 0, NULL, NULL),
(1039, 986.00, 'Random Game', 'GAME-280', 'User-495', 'a65b01dc-3a82-42fd-a251-893df9f60b5a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:56', NULL, NULL, 0, NULL, NULL),
(1040, 116.00, 'Random Game', 'GAME-562', 'User-940', 'e8913462-44ef-4f0e-a859-b128f1c35d8f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:56', NULL, NULL, 0, NULL, NULL),
(1041, 162.00, 'Random Game', 'GAME-943', 'User-416', '00b6007a-6c7f-476a-8b0e-e809ccd77b63', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:58', NULL, NULL, 0, NULL, NULL),
(1042, 130.00, 'Random Game', 'GAME-330', 'User-367', '29b2fcf6-2317-420f-9736-6a5ff6796fdf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:54:58', NULL, NULL, 0, NULL, NULL),
(1043, 558.00, 'Random Game', 'GAME-152', 'User-892', 'db696b30-376c-4ce6-b53e-179e3e5b9a11', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:02', NULL, NULL, 0, NULL, NULL),
(1044, 721.00, 'Random Game', 'GAME-404', 'User-237', 'b7bc6781-a867-4a44-9931-f6c8bf162e9a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:02', NULL, NULL, 0, NULL, NULL),
(1045, 386.00, 'Random Game', 'GAME-446', 'User-404', '8bd4f166-8f6b-4931-b692-5e7f57e7d09b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:04', NULL, NULL, 0, NULL, NULL),
(1046, 275.00, 'Random Game', 'GAME-322', 'User-827', 'a0e9189e-1db7-49ff-8bf1-8494195cfb11', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:04', NULL, NULL, 0, NULL, NULL),
(1047, 185.00, 'Random Game', 'GAME-398', 'User-361', '454ffc78-2a38-4b9e-b85a-963cf86c6c91', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:06', NULL, NULL, 0, NULL, NULL),
(1048, 259.00, 'Random Game', 'GAME-29', 'User-546', 'f3cdec54-aad9-44f6-aac8-c67db38fb778', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:07', NULL, NULL, 0, NULL, NULL),
(1049, 310.00, 'Random Game', 'GAME-452', 'User-859', '21b3055e-c177-4c33-9ad2-a9f3c668a3b6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:07', NULL, NULL, 0, NULL, NULL),
(1050, 657.00, 'Random Game', 'GAME-957', 'User-100', 'ae4a89ea-b9db-448c-b1ff-5a851b299602', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:08', NULL, NULL, 0, NULL, NULL),
(1051, 409.00, 'Random Game', 'GAME-506', 'User-566', 'f16b880a-7612-454a-b157-d9ad5b64b6d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:08', NULL, NULL, 0, NULL, NULL),
(1052, 565.00, 'Random Game', 'GAME-856', 'User-942', '6ba584b3-43b7-4066-9b64-662bfa8ddef5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:16', NULL, NULL, 0, NULL, NULL),
(1053, 476.00, 'Random Game', 'GAME-335', 'User-993', 'ecb6c2ae-8c23-4812-9366-d3c37bbd280a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:16', NULL, NULL, 0, NULL, NULL),
(1054, 662.00, 'Random Game', 'GAME-255', 'User-899', 'c2f59aed-347d-4972-84f6-482ed3986ee1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:18', NULL, NULL, 0, NULL, NULL),
(1055, 222.00, 'Random Game', 'GAME-588', 'User-49', 'ff645a28-4aa2-4066-8dbc-f3ddf711f2d3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:18', NULL, NULL, 0, NULL, NULL),
(1056, 194.00, 'Random Game', 'GAME-465', 'User-718', '057e0ba4-8f15-40bd-9f55-6d1b0a397564', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:22', NULL, NULL, 0, NULL, NULL),
(1057, 996.00, 'Random Game', 'GAME-57', 'User-439', '0b070067-a3c2-4238-b9e5-cfc666bab235', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:22', NULL, NULL, 0, NULL, NULL),
(1058, 395.00, 'Random Game', 'GAME-762', 'User-966', 'd906c7fa-a54c-4923-ae79-af0e5b447b63', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:24', NULL, NULL, 0, NULL, NULL),
(1059, 683.00, 'Random Game', 'GAME-509', 'User-283', '74ec044d-27fd-43a6-90e5-b54a04444bd0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:24', NULL, NULL, 0, NULL, NULL),
(1060, 265.00, 'Random Game', 'GAME-915', 'User-504', '90d28df4-914e-4991-ae23-ecab4e5bf8e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:26', NULL, NULL, 0, NULL, NULL),
(1061, 738.00, 'Random Game', 'GAME-542', 'User-520', 'c5f9f40d-e658-4ed3-9b62-c04f24ec3b36', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:27', NULL, NULL, 0, NULL, NULL),
(1062, 637.00, 'Random Game', 'GAME-502', 'User-127', '6ef25e50-d7bd-4fa7-b395-36d4626497d0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:27', NULL, NULL, 0, NULL, NULL),
(1063, 705.00, 'Random Game', 'GAME-617', 'User-27', '6a3a9b60-53b0-46ae-bfee-e1ff0f2a0471', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:28', NULL, NULL, 0, NULL, NULL),
(1064, 1004.00, 'Random Game', 'GAME-628', 'User-530', '0cd330cc-7692-4ebc-87d1-3a4c8ae86452', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:28', NULL, NULL, 0, NULL, NULL),
(1065, 196.00, 'Random Game', 'GAME-871', 'User-275', '91c4d4c0-0bb3-4841-b77c-d7870654f6a4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:36', NULL, NULL, 0, NULL, NULL),
(1066, 825.00, 'Random Game', 'GAME-559', 'User-284', '728a3c82-79b9-4504-9c89-c770c4480e62', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:36', NULL, NULL, 0, NULL, NULL),
(1067, 985.00, 'Random Game', 'GAME-730', 'User-907', 'd19812cb-c712-4943-bd4c-9ba40faa115b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:38', NULL, NULL, 0, NULL, NULL),
(1068, 301.00, 'Random Game', 'GAME-106', 'User-132', '8943f89c-49fb-450a-9c97-cf6101cf39f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:38', NULL, NULL, 0, NULL, NULL),
(1069, 927.00, 'Random Game', 'GAME-263', 'User-900', 'd288e5ff-4e6e-48c6-addb-8565896b65c0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:42', NULL, NULL, 0, NULL, NULL),
(1070, 646.00, 'Random Game', 'GAME-975', 'User-912', 'de5b0c64-ab4a-49db-8022-757a2a6911ae', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:42', NULL, NULL, 0, NULL, NULL),
(1071, 215.00, 'Random Game', 'GAME-991', 'User-983', '1385e27c-4405-4faf-bed5-d04c093d08fa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:44', NULL, NULL, 0, NULL, NULL),
(1072, 307.00, 'Random Game', 'GAME-970', 'User-907', 'e963ad2d-501c-4358-950c-225cc483cbac', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:44', NULL, NULL, 0, NULL, NULL),
(1073, 347.00, 'Random Game', 'GAME-281', 'User-958', '61c00015-1fce-4606-a649-77807619f916', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:46', NULL, NULL, 0, NULL, NULL),
(1074, 608.00, 'Random Game', 'GAME-26', 'User-819', 'c8df9739-b0e9-41b7-b381-9bd989cc005e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:47', NULL, NULL, 0, NULL, NULL),
(1075, 283.00, 'Random Game', 'GAME-871', 'User-389', '46d0748c-b16e-41d5-a532-434182c184d3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:47', NULL, NULL, 0, NULL, NULL),
(1076, 981.00, 'Random Game', 'GAME-786', 'User-168', '0a5dd9e9-da5f-46a3-b3d0-8a8d6c8678c6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:48', NULL, NULL, 0, NULL, NULL),
(1077, 788.00, 'Random Game', 'GAME-339', 'User-291', '5ecfb02a-7150-47a3-a686-e7838d845155', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:48', NULL, NULL, 0, NULL, NULL),
(1078, 579.00, 'Random Game', 'GAME-864', 'User-288', '8ff4a99b-a055-44b7-9378-7c10f54b9879', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:56', NULL, NULL, 0, NULL, NULL),
(1079, 1021.00, 'Random Game', 'GAME-478', 'User-73', '8713b5dd-6978-4dc1-b9ec-58b802463a2e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:56', NULL, NULL, 0, NULL, NULL),
(1080, 741.00, 'Random Game', 'GAME-642', 'User-551', '15733486-7889-4508-ba14-5607e5f7cc7e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:58', NULL, NULL, 0, NULL, NULL),
(1081, 585.00, 'Random Game', 'GAME-23', 'User-673', 'b3ddd14c-c94d-4552-8165-5423bea74e5c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:55:58', NULL, NULL, 0, NULL, NULL),
(1082, 1045.00, 'Random Game', 'GAME-982', 'User-491', 'f2fc9c3b-7c5f-4ca6-8553-e686e3c534cc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:02', NULL, NULL, 0, NULL, NULL),
(1083, 219.00, 'Random Game', 'GAME-33', 'User-456', 'e59bd475-41e9-4732-8d71-e23df8308a67', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:02', NULL, NULL, 0, NULL, NULL),
(1084, 188.00, 'Random Game', 'GAME-46', 'User-656', '6251244b-38d7-43a4-b6ba-8b95f35b5ee3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:04', NULL, NULL, 0, NULL, NULL),
(1085, 837.00, 'Random Game', 'GAME-464', 'User-964', 'c0871867-15f1-462e-8411-092f48b3e9a1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:04', NULL, NULL, 0, NULL, NULL),
(1086, 724.00, 'Random Game', 'GAME-24', 'User-516', 'dd489f7c-73f1-49c0-8125-58f917800ec7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:06', NULL, NULL, 0, NULL, NULL),
(1087, 329.00, 'Random Game', 'GAME-896', 'User-622', '95e7e14e-3cfa-42d2-823f-d9cb37558ce6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:07', NULL, NULL, 0, NULL, NULL),
(1088, 428.00, 'Random Game', 'GAME-551', 'User-622', 'ee50ddc3-101d-427b-a5f4-55c4ba3741e6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:07', NULL, NULL, 0, NULL, NULL),
(1089, 729.00, 'Random Game', 'GAME-743', 'User-666', '1f978d00-3b26-4f26-8326-0b0157294ac6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:08', NULL, NULL, 0, NULL, NULL),
(1090, 925.00, 'Random Game', 'GAME-404', 'User-511', '4038458d-e8a2-4caa-8b79-5bb1ecdbbb95', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:08', NULL, NULL, 0, NULL, NULL),
(1091, 499.00, 'Random Game', 'GAME-253', 'User-42', 'c225b8f1-5a8e-4882-874a-a78cf547e6e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:16', NULL, NULL, 0, NULL, NULL),
(1092, 908.00, 'Random Game', 'GAME-579', 'User-406', '1283afdf-b375-489f-8f72-e791b9be6818', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:16', NULL, NULL, 0, NULL, NULL),
(1093, 224.00, 'Random Game', 'GAME-630', 'User-212', '59561864-4185-451a-ac4c-6bf66819cfd6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:18', NULL, NULL, 0, NULL, NULL),
(1094, 85.00, 'Random Game', 'GAME-646', 'User-684', '6b0e9e3c-ee14-4545-a0be-1724b2fde248', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:18', NULL, NULL, 0, NULL, NULL),
(1095, 313.00, 'Random Game', 'GAME-746', 'User-704', 'ec84edc4-0494-47fc-b7dd-16a7c716d0ec', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:22', NULL, NULL, 0, NULL, NULL),
(1096, 796.00, 'Random Game', 'GAME-369', 'User-952', '30fa8d53-b3e2-4f55-8fb8-932d90a23680', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:22', NULL, NULL, 0, NULL, NULL),
(1097, 1002.00, 'Random Game', 'GAME-480', 'User-231', '258870eb-ee2c-493f-9af1-977bfbee62f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:24', NULL, NULL, 0, NULL, NULL),
(1098, 680.00, 'Random Game', 'GAME-602', 'User-620', '18461e3f-573c-468f-a6ca-f0130598a9de', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:24', NULL, NULL, 0, NULL, NULL),
(1099, 653.00, 'Random Game', 'GAME-785', 'User-52', '76f40590-7df5-47b0-87da-de01ee2f0baa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:26', NULL, NULL, 0, NULL, NULL),
(1100, 571.00, 'Random Game', 'GAME-930', 'User-80', 'c8f06f3c-35dd-4351-91cb-5b49cb4fc602', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:27', NULL, NULL, 0, NULL, NULL),
(1101, 123.00, 'Random Game', 'GAME-181', 'User-598', '734f09fe-c1ff-4da4-bcbc-63fc7f9f70d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:27', NULL, NULL, 0, NULL, NULL),
(1102, 989.00, 'Random Game', 'GAME-7', 'User-801', 'f4d257b3-0e58-4492-a158-7428147f8456', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:28', NULL, NULL, 0, NULL, NULL),
(1103, 696.00, 'Random Game', 'GAME-905', 'User-146', 'e607cf39-f11b-4429-814a-299f1a04f2b2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:28', NULL, NULL, 0, NULL, NULL),
(1104, 81.00, 'Random Game', 'GAME-134', 'User-164', '4464beae-962e-4b77-9d3c-f1150e043a59', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:36', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(1105, 1012.00, 'Random Game', 'GAME-392', 'User-76', '68422959-d6bd-49e8-88db-0420b837af3e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:36', NULL, NULL, 0, NULL, NULL),
(1106, 273.00, 'Random Game', 'GAME-863', 'User-268', '60b97da7-3c7f-4912-a5dc-6a5b29283b96', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:38', NULL, NULL, 0, NULL, NULL),
(1107, 370.00, 'Random Game', 'GAME-553', 'User-810', '52edfb8e-ac2f-4cdc-877e-2c5a8f25cb13', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:38', NULL, NULL, 0, NULL, NULL),
(1108, 228.00, 'Random Game', 'GAME-822', 'User-891', '1ec76c11-9271-4712-ada9-fea1bbabb8a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:42', NULL, NULL, 0, NULL, NULL),
(1109, 529.00, 'Random Game', 'GAME-177', 'User-942', '4e2352c6-6746-4bc1-99f5-de1374e903c0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:42', NULL, NULL, 0, NULL, NULL),
(1110, 140.00, 'Random Game', 'GAME-506', 'User-38', '6227d918-360e-4ef6-a51f-b508f87038f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:44', NULL, NULL, 0, NULL, NULL),
(1111, 754.00, 'Random Game', 'GAME-789', 'User-353', 'f81b0c40-d602-49bb-ae36-726c6dec24fd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:44', NULL, NULL, 0, NULL, NULL),
(1112, 932.00, 'Random Game', 'GAME-401', 'User-637', 'e6c6751d-f919-44ed-9e6d-00d75585b020', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:46', NULL, NULL, 0, NULL, NULL),
(1113, 748.00, 'Random Game', 'GAME-230', 'User-668', '6003c2dd-3983-416e-bc03-10a4e321680a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:47', NULL, NULL, 0, NULL, NULL),
(1114, 926.00, 'Random Game', 'GAME-998', 'User-234', 'c7042a0a-73bf-4df2-8ace-04fd95b299b2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:47', NULL, NULL, 0, NULL, NULL),
(1115, 445.00, 'Random Game', 'GAME-191', 'User-302', '3df8b7c9-0bc3-41e4-837d-c5b12566743c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:48', NULL, NULL, 0, NULL, NULL),
(1116, 106.00, 'Random Game', 'GAME-614', 'User-375', '2589b4ad-9739-46f0-9443-789c081fb86b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:48', NULL, NULL, 0, NULL, NULL),
(1117, 312.00, 'Random Game', 'GAME-79', 'User-866', '4749274a-dedd-4e1a-9289-05b9383d41af', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:56', NULL, NULL, 0, NULL, NULL),
(1118, 874.00, 'Random Game', 'GAME-926', 'User-215', 'b360d1ee-f072-4f81-a0b8-68053fdbcdfd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:56', NULL, NULL, 0, NULL, NULL),
(1119, 827.00, 'Random Game', 'GAME-617', 'User-550', '70151b1a-68f8-4210-b35a-6179cb97cdfe', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:58', NULL, NULL, 0, NULL, NULL),
(1120, 404.00, 'Random Game', 'GAME-250', 'User-346', '8819f35b-3431-4fa6-9594-de356a22d055', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:56:58', NULL, NULL, 0, NULL, NULL),
(1121, 482.00, 'Random Game', 'GAME-775', 'User-127', '3196848e-46ee-4dd1-b811-507e996878fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:02', NULL, NULL, 0, NULL, NULL),
(1122, 395.00, 'Random Game', 'GAME-649', 'User-959', '3f829523-ad32-421e-a352-2117d6c42ed9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:02', NULL, NULL, 0, NULL, NULL),
(1123, 421.00, 'Random Game', 'GAME-156', 'User-217', 'b577cd05-5b2d-45ae-8c73-40f9d62202f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:04', NULL, NULL, 0, NULL, NULL),
(1124, 404.00, 'Random Game', 'GAME-638', 'User-782', '7ec4cb6a-9142-4989-91e7-765412cdac89', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:04', NULL, NULL, 0, NULL, NULL),
(1125, 145.00, 'Random Game', 'GAME-928', 'User-821', '84a269c6-6dfd-4e1a-9978-0163dae69ac3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:06', NULL, NULL, 0, NULL, NULL),
(1126, 454.00, 'Random Game', 'GAME-745', 'User-272', 'f4fb133f-5ae8-4599-a181-a5677d1448fd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:07', NULL, NULL, 0, NULL, NULL),
(1127, 757.00, 'Random Game', 'GAME-868', 'User-509', '3517618c-92c8-4ad8-a709-4895f6e83aaa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:07', NULL, NULL, 0, NULL, NULL),
(1128, 606.00, 'Random Game', 'GAME-364', 'User-167', '75296466-8f22-4f28-bf57-07b40d8eceda', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:08', NULL, NULL, 0, NULL, NULL),
(1129, 193.00, 'Random Game', 'GAME-808', 'User-361', '8d83b190-7c22-4930-83c1-c5dda687f271', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:08', NULL, NULL, 0, NULL, NULL),
(1130, 440.00, 'Random Game', 'GAME-903', 'User-574', '3a166b7d-3d32-44d8-994f-b94c68e717cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:16', NULL, NULL, 0, NULL, NULL),
(1131, 459.00, 'Random Game', 'GAME-647', 'User-236', '4d8ba2be-f5c1-40ee-95fd-bc949673a104', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:16', NULL, NULL, 0, NULL, NULL),
(1132, 197.00, 'Random Game', 'GAME-24', 'User-129', 'a4761ab6-e488-46bc-9280-7819e869cf31', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:18', NULL, NULL, 0, NULL, NULL),
(1133, 971.00, 'Random Game', 'GAME-666', 'User-180', '446ebb1c-393b-464b-998c-fdd7159c0c9e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:18', NULL, NULL, 0, NULL, NULL),
(1134, 290.00, 'Random Game', 'GAME-733', 'User-252', 'dd64371d-d9da-4b21-b713-8604bec8b116', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:22', NULL, NULL, 0, NULL, NULL),
(1135, 361.00, 'Random Game', 'GAME-440', 'User-896', '11bccf54-e581-4861-95ac-7e571a946cb9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:22', NULL, NULL, 0, NULL, NULL),
(1136, 207.00, 'Random Game', 'GAME-847', 'User-252', 'bcc1a206-c215-4c20-a0f6-25c4176ecffc', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:24', NULL, NULL, 0, NULL, NULL),
(1137, 64.00, 'Random Game', 'GAME-164', 'User-363', '2b909df3-9e8a-4c4e-924f-d4aef8630883', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:24', NULL, NULL, 0, NULL, NULL),
(1138, 999.00, 'Random Game', 'GAME-361', 'User-221', '42b84431-448d-480d-a3c1-2314d831b1fd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:26', NULL, NULL, 0, NULL, NULL),
(1139, 884.00, 'Random Game', 'GAME-788', 'User-856', 'a88e5f36-a3ab-4b14-a36b-ce29899e2800', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:27', NULL, NULL, 0, NULL, NULL),
(1140, 662.00, 'Random Game', 'GAME-596', 'User-439', '0af9914d-81da-4b7e-aaba-73e7120cf2a3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:27', NULL, NULL, 0, NULL, NULL),
(1141, 76.00, 'Random Game', 'GAME-755', 'User-103', 'be9e1861-62d6-4704-ab6d-8e34a4bc8651', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:28', NULL, NULL, 0, NULL, NULL),
(1142, 238.00, 'Random Game', 'GAME-453', 'User-181', '1a8b062a-e587-4963-93a6-7edac5b09926', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:28', NULL, NULL, 0, NULL, NULL),
(1143, 300.00, 'Random Game', 'GAME-376', 'User-153', '21c39238-d192-4bae-ad11-54019852ce28', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:36', NULL, NULL, 0, NULL, NULL),
(1144, 894.00, 'Random Game', 'GAME-36', 'User-223', 'ed7e8218-2dec-4d5b-81b4-102bddb3ae42', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:36', NULL, NULL, 0, NULL, NULL),
(1145, 646.00, 'Random Game', 'GAME-304', 'User-313', '9c574ddc-594c-4b3d-8ccd-d8b7d865e97d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:38', NULL, NULL, 0, NULL, NULL),
(1146, 771.00, 'Random Game', 'GAME-777', 'User-803', 'cec3c5b4-e0dc-4d39-abd6-c2b8be31cc7e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:38', NULL, NULL, 0, NULL, NULL),
(1147, 677.00, 'Random Game', 'GAME-397', 'User-897', '20840e75-d6d8-4c34-924f-59223c2711c0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:42', NULL, NULL, 0, NULL, NULL),
(1148, 343.00, 'Random Game', 'GAME-874', 'User-440', 'c288d718-59f0-4ab7-bcd4-1815d4ff7f97', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:42', NULL, NULL, 0, NULL, NULL),
(1149, 110.00, 'Random Game', 'GAME-648', 'User-927', '36160135-6edf-4c15-afc4-675b0a66aae6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:44', NULL, NULL, 0, NULL, NULL),
(1150, 470.00, 'Random Game', 'GAME-753', 'User-106', '9b8de11f-03eb-48e6-a087-43ffe309c9cf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:44', NULL, NULL, 0, NULL, NULL),
(1151, 976.00, 'Random Game', 'GAME-616', 'User-399', '70a26c6e-1457-4d39-b761-6ada23718f94', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:46', NULL, NULL, 0, NULL, NULL),
(1152, 957.00, 'Random Game', 'GAME-319', 'User-315', 'ad199b3e-cfdb-4337-acab-340b0423a759', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:47', NULL, NULL, 0, NULL, NULL),
(1153, 69.00, 'Random Game', 'GAME-842', 'User-209', 'd75614c0-1820-4023-a587-cfd020ba8bc7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:47', NULL, NULL, 0, NULL, NULL),
(1154, 494.00, 'Random Game', 'GAME-843', 'User-204', '642604b2-399b-4806-a1fc-ec0241d4242a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:48', NULL, NULL, 0, NULL, NULL),
(1155, 69.00, 'Random Game', 'GAME-424', 'User-971', 'eaa432f0-abed-46a6-adbd-10f52af5c23a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:48', NULL, NULL, 0, NULL, NULL),
(1156, 288.00, 'Random Game', 'GAME-604', 'User-92', '58d9633f-86f5-4c74-a344-92016be72b40', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:56', NULL, NULL, 0, NULL, NULL),
(1157, 1014.00, 'Random Game', 'GAME-832', 'User-192', '33176612-0a90-4c90-9e69-3c902cd85a21', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:56', NULL, NULL, 0, NULL, NULL),
(1158, 366.00, 'Random Game', 'GAME-932', 'User-266', 'f72c8d02-f54a-4a94-9e30-b3549c00c26f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:58', NULL, NULL, 0, NULL, NULL),
(1159, 897.00, 'Random Game', 'GAME-645', 'User-447', '93dc86d1-965e-43c3-9055-c2a9791e661d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:57:58', NULL, NULL, 0, NULL, NULL),
(1160, 361.00, 'Random Game', 'GAME-774', 'User-576', 'c0004661-d84c-432c-884d-00aba79d2cf3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:02', NULL, NULL, 0, NULL, NULL),
(1161, 196.00, 'Random Game', 'GAME-86', 'User-6', '0141dcfa-65f1-434e-9228-969ea7c86c92', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:02', NULL, NULL, 0, NULL, NULL),
(1162, 368.00, 'Random Game', 'GAME-778', 'User-367', '1193fd84-e01c-4b6b-bf21-61bc340ca4c9', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:04', NULL, NULL, 0, NULL, NULL),
(1163, 606.00, 'Random Game', 'GAME-432', 'User-447', '47cee912-9ef8-4487-a77c-ea601da64f83', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:04', NULL, NULL, 0, NULL, NULL),
(1164, 198.00, 'Random Game', 'GAME-785', 'User-355', '989a16a0-1195-4007-bc26-fb904bdf26ca', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:06', NULL, NULL, 0, NULL, NULL),
(1165, 643.00, 'Random Game', 'GAME-503', 'User-553', '014c9e98-c05a-4960-a515-de6a9f98b6f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:07', NULL, NULL, 0, NULL, NULL),
(1166, 143.00, 'Random Game', 'GAME-64', 'User-518', '8a30d0b1-e4d6-4832-ae62-b4dd7b966e55', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:07', NULL, NULL, 0, NULL, NULL),
(1167, 173.00, 'Random Game', 'GAME-694', 'User-84', '1581c935-2f82-482a-97a3-ba9903d18583', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:08', NULL, NULL, 0, NULL, NULL),
(1168, 283.00, 'Random Game', 'GAME-140', 'User-963', '1f07f2c2-3a34-43fd-bc2f-e63805ca16e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:08', NULL, NULL, 0, NULL, NULL),
(1169, 438.00, 'Random Game', 'GAME-607', 'User-311', '40407aec-4d03-4384-87fa-c7c80b6f228a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:16', NULL, NULL, 0, NULL, NULL),
(1170, 507.00, 'Random Game', 'GAME-535', 'User-217', '5da22855-077a-4d7d-8f53-3ea0be6f740c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:16', NULL, NULL, 0, NULL, NULL),
(1171, 671.00, 'Random Game', 'GAME-798', 'User-277', '8892dddf-144c-42b6-b045-a25afbadfe29', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:18', NULL, NULL, 0, NULL, NULL),
(1172, 334.00, 'Random Game', 'GAME-558', 'User-89', 'e42c34c9-88d7-4516-81c2-e51af0aa9a17', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:18', NULL, NULL, 0, NULL, NULL),
(1173, 292.00, 'Random Game', 'GAME-171', 'User-576', 'b6abd6db-9dfa-4dc4-aa7c-fbcade84f858', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:22', NULL, NULL, 0, NULL, NULL),
(1174, 228.00, 'Random Game', 'GAME-38', 'User-970', '1787a5d8-b9fa-4b4a-a923-92b8cde974cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:22', NULL, NULL, 0, NULL, NULL),
(1175, 626.00, 'Random Game', 'GAME-316', 'User-398', 'd908541f-3db2-4f74-adfe-1394f59d679a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:24', NULL, NULL, 0, NULL, NULL),
(1176, 206.00, 'Random Game', 'GAME-430', 'User-810', 'ff8f4b99-c001-4c1d-8d59-0b1ca1df3d0d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:24', NULL, NULL, 0, NULL, NULL),
(1177, 1033.00, 'Random Game', 'GAME-813', 'User-925', '7652fe9d-bbd0-48e6-85db-6d908dc2729b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:26', NULL, NULL, 0, NULL, NULL),
(1178, 956.00, 'Random Game', 'GAME-974', 'User-52', 'e3cac698-7a57-4e2b-ba45-49f6ddef7e19', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:27', NULL, NULL, 0, NULL, NULL),
(1179, 863.00, 'Random Game', 'GAME-872', 'User-593', '629a4582-7e86-4bb3-a8f2-bc0af9f3fa40', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:27', NULL, NULL, 0, NULL, NULL),
(1180, 636.00, 'Random Game', 'GAME-437', 'User-407', 'b45ef3f0-34df-4725-83b8-86fe56462fd1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:28', NULL, NULL, 0, NULL, NULL),
(1181, 783.00, 'Random Game', 'GAME-63', 'User-122', 'bcc07567-b4fd-4a5f-87a3-970ca686ef3c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:28', NULL, NULL, 0, NULL, NULL),
(1182, 339.00, 'Random Game', 'GAME-274', 'User-192', '91010197-2718-4896-8c68-4c11fdedb3f0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:36', NULL, NULL, 0, NULL, NULL),
(1183, 1035.00, 'Random Game', 'GAME-609', 'User-934', '7bf42f5b-61f5-4f34-afd9-e632ab5d6b75', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:36', NULL, NULL, 0, NULL, NULL),
(1184, 686.00, 'Random Game', 'GAME-346', 'User-958', '3eb61463-ddfe-4595-8701-ae0f2038d036', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:38', NULL, NULL, 0, NULL, NULL),
(1185, 124.00, 'Random Game', 'GAME-229', 'User-101', '5f881276-a15f-4e6b-aaa8-705e093e90ae', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:38', NULL, NULL, 0, NULL, NULL),
(1186, 120.00, 'Random Game', 'GAME-161', 'User-760', 'dbb0598b-e4ec-4bfa-be67-164e9ac851b4', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:42', NULL, NULL, 0, NULL, NULL),
(1187, 225.00, 'Random Game', 'GAME-385', 'User-681', '4dba229a-1c27-4a5d-82c5-c180a2fc0ad5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:42', NULL, NULL, 0, NULL, NULL),
(1188, 571.00, 'Random Game', 'GAME-629', 'User-718', 'c7ef35c5-769f-4d80-9c87-22700b55489b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:44', NULL, NULL, 0, NULL, NULL),
(1189, 1039.00, 'Random Game', 'GAME-235', 'User-643', '105f2198-662b-4fd0-8464-34e1eff55abe', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:44', NULL, NULL, 0, NULL, NULL),
(1190, 935.00, 'Random Game', 'GAME-398', 'User-595', '7233542b-192e-4556-9742-9e9e583fe1b0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:46', NULL, NULL, 0, NULL, NULL),
(1191, 1021.00, 'Random Game', 'GAME-615', 'User-715', 'e3175de9-1ce8-4ae6-87cb-a1e0536706aa', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:47', NULL, NULL, 0, NULL, NULL),
(1192, 826.00, 'Random Game', 'GAME-127', 'User-287', '599d29d8-589b-440e-b073-8001c35795ca', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:47', NULL, NULL, 0, NULL, NULL),
(1193, 784.00, 'Random Game', 'GAME-425', 'User-536', 'c47cf0e3-a746-4ec6-b1bf-991dcff9e3d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:48', NULL, NULL, 0, NULL, NULL),
(1194, 846.00, 'Random Game', 'GAME-951', 'User-924', 'bede5741-1157-42a9-80a3-2b8528a3ada2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:48', NULL, NULL, 0, NULL, NULL),
(1195, 647.00, 'Random Game', 'GAME-497', 'User-125', '61c9b5c3-81c0-462b-b3e4-7612988c54e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:56', NULL, NULL, 0, NULL, NULL),
(1196, 142.00, 'Random Game', 'GAME-437', 'User-743', '7e4002d2-06fa-4afe-83cc-f87d4baaa59c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:56', NULL, NULL, 0, NULL, NULL),
(1197, 646.00, 'Random Game', 'GAME-446', 'User-48', '82b593f3-1e14-4920-87fc-a975d54a3b1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:58', NULL, NULL, 0, NULL, NULL),
(1198, 172.00, 'Random Game', 'GAME-163', 'User-902', '38c4b755-5307-4204-a1e0-ba0263de8b9e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:58:58', NULL, NULL, 0, NULL, NULL),
(1199, 965.00, 'Random Game', 'GAME-504', 'User-976', 'd84a53c8-1ac4-4917-b0a7-56af6e270126', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:02', NULL, NULL, 0, NULL, NULL),
(1200, 497.00, 'Random Game', 'GAME-76', 'User-730', 'a29ec64a-816f-4aad-b0a1-c15cf06383a8', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:02', NULL, NULL, 0, NULL, NULL),
(1201, 876.00, 'Random Game', 'GAME-550', 'User-835', '7739c11f-c55a-4446-9122-22d0073bac99', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:04', NULL, NULL, 0, NULL, NULL),
(1202, 990.00, 'Random Game', 'GAME-524', 'User-14', 'a09b1d1d-1944-4049-b496-ab0ec930a492', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:04', NULL, NULL, 0, NULL, NULL),
(1203, 421.00, 'Random Game', 'GAME-511', 'User-531', 'e2f21efc-5415-4672-87cf-034319c259da', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:06', NULL, NULL, 0, NULL, NULL),
(1204, 180.00, 'Random Game', 'GAME-204', 'User-185', 'e6159666-f5fc-47b5-88a4-8cecb6cee3ad', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:07', NULL, NULL, 0, NULL, NULL),
(1205, 745.00, 'Random Game', 'GAME-781', 'User-331', '3f5e1c7a-db08-4711-9463-ab5fa699e2bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:07', NULL, NULL, 0, NULL, NULL),
(1206, 755.00, 'Random Game', 'GAME-324', 'User-585', '10f96bff-6b47-4db2-9d8e-ba252d83fb5d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:08', NULL, NULL, 0, NULL, NULL),
(1207, 384.00, 'Random Game', 'GAME-441', 'User-152', '6bb80f6f-2306-47b3-99f2-52605ad30eed', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:08', NULL, NULL, 0, NULL, NULL),
(1208, 913.00, 'Random Game', 'GAME-890', 'User-196', '383e8879-ddb7-4a30-90ea-4afc5c017a3c', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:16', NULL, NULL, 0, NULL, NULL),
(1209, 111.00, 'Random Game', 'GAME-697', 'User-360', '2048bc55-0bc4-4a17-996f-62f866bf3b80', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:16', NULL, NULL, 0, NULL, NULL),
(1210, 77.00, 'Random Game', 'GAME-815', 'User-235', '161d8a8c-0259-45fb-ab9c-c858fcef20f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:18', NULL, NULL, 0, NULL, NULL),
(1211, 571.00, 'Random Game', 'GAME-728', 'User-337', 'cffc1381-b57e-447d-b039-ff6f865400ea', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:18', NULL, NULL, 0, NULL, NULL),
(1212, 915.00, 'Random Game', 'GAME-86', 'User-328', '39252426-e7c6-47d6-a46a-2f55b6ce8b2d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:22', NULL, NULL, 0, NULL, NULL),
(1213, 947.00, 'Random Game', 'GAME-272', 'User-652', 'e933e8ff-9846-447c-8300-dfd85eb69a59', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:22', NULL, NULL, 0, NULL, NULL),
(1214, 191.00, 'Random Game', 'GAME-210', 'User-870', '05721104-57e6-4348-8548-d740db6d5aa2', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:24', NULL, NULL, 0, NULL, NULL),
(1215, 565.00, 'Random Game', 'GAME-110', 'User-170', '3acd762b-95b7-4a38-80aa-1738480496be', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:24', NULL, NULL, 0, NULL, NULL),
(1216, 1022.00, 'Random Game', 'GAME-790', 'User-720', '03639da9-9cdd-4b42-b225-dc6317c3f4a7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:26', NULL, NULL, 0, NULL, NULL),
(1217, 904.00, 'Random Game', 'GAME-703', 'User-970', '9fe0e548-db8a-4064-9531-d9593c01e4f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:27', NULL, NULL, 0, NULL, NULL),
(1218, 950.00, 'Random Game', 'GAME-36', 'User-224', '12cfdf58-4f88-4e54-a996-ba8973d1f05f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:27', NULL, NULL, 0, NULL, NULL),
(1219, 61.00, 'Random Game', 'GAME-58', 'User-505', '02718c02-2df1-4a33-a124-728f5de5f1c3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:28', NULL, NULL, 0, NULL, NULL),
(1220, 776.00, 'Random Game', 'GAME-828', 'User-141', 'ad9b0e9f-8b31-42f5-b7cf-4fa42b754677', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:28', NULL, NULL, 0, NULL, NULL),
(1221, 854.00, 'Random Game', 'GAME-539', 'User-535', 'abd3e67d-8357-4f2c-9645-8d69ff036d06', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:36', NULL, NULL, 0, NULL, NULL),
(1222, 916.00, 'Random Game', 'GAME-146', 'User-206', '5ef84f93-866f-46fc-8308-b54385b977f1', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:36', NULL, NULL, 0, NULL, NULL),
(1223, 475.00, 'Random Game', 'GAME-774', 'User-991', '1bd7f114-6948-45ea-92ea-54b197face34', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:38', NULL, NULL, 0, NULL, NULL),
(1224, 280.00, 'Random Game', 'GAME-859', 'User-421', 'fffd46a5-d8bb-4857-9687-7d4d8d0ca53e', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:38', NULL, NULL, 0, NULL, NULL),
(1225, 364.00, 'Random Game', 'GAME-257', 'User-210', 'b9b45ef6-06e6-462f-a49f-757c9863dc38', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:42', NULL, NULL, 0, NULL, NULL),
(1226, 281.00, 'Random Game', 'GAME-978', 'User-999', 'b6d81e75-eb13-4cae-a6b4-3b3f299da9e7', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:42', NULL, NULL, 0, NULL, NULL),
(1227, 745.00, 'Random Game', 'GAME-9', 'User-922', '8388f3c8-9938-4e25-a46a-7f1a9603270d', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:44', NULL, NULL, 0, NULL, NULL),
(1228, 451.00, 'Random Game', 'GAME-852', 'User-88', '386b4280-8220-426f-afa0-875d510e94a3', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:44', NULL, NULL, 0, NULL, NULL),
(1229, 240.00, 'Random Game', 'GAME-633', 'User-341', '7f4497fa-7093-4123-8466-813c22ae177a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:46', NULL, NULL, 0, NULL, NULL),
(1230, 222.00, 'Random Game', 'GAME-61', 'User-295', 'e7b0b66d-5c9e-49a1-9cf8-cbfe5a70820a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:47', NULL, NULL, 0, NULL, NULL),
(1231, 543.00, 'Random Game', 'GAME-300', 'User-751', 'df53801d-0ce2-482a-b222-d27f0027848f', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:47', NULL, NULL, 0, NULL, NULL),
(1232, 288.00, 'Random Game', 'GAME-852', 'User-405', '0cd93f61-2939-46f0-98ba-f3775c75e53b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:48', NULL, NULL, 0, NULL, NULL),
(1233, 174.00, 'Random Game', 'GAME-910', 'User-808', '78e14a23-a8df-4198-9e8f-6d902893fd7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:48', NULL, NULL, 0, NULL, NULL),
(1234, 617.00, 'Random Game', 'GAME-1', 'User-852', 'e388ecc1-96a4-4373-8cda-de151ae04fe0', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:56', NULL, NULL, 0, NULL, NULL),
(1235, 999.00, 'Random Game', 'GAME-423', 'User-645', '5174fe96-6220-4c5d-bde6-a277b679bd3b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:56', NULL, NULL, 0, NULL, NULL),
(1236, 1031.00, 'Random Game', 'GAME-168', 'User-438', 'd35ddac1-b969-4571-b899-a35797f46e1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:58', NULL, NULL, 0, NULL, NULL),
(1237, 75.00, 'Random Game', 'GAME-56', 'User-516', '6dafb687-8844-4edb-a4f4-44933f0fdb37', 19, 'pending_validation', NULL, NULL, '2025-04-09 09:59:58', NULL, NULL, 0, NULL, NULL),
(1238, 678.00, 'Random Game', 'GAME-516', 'User-958', '3d3ad69c-08f7-407d-889a-143a17768d19', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:02', NULL, NULL, 0, NULL, NULL),
(1239, 996.00, 'Random Game', 'GAME-857', 'User-321', 'c931a044-c00d-4cc2-94b0-a003acd5186b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:02', NULL, NULL, 0, NULL, NULL),
(1240, 848.00, 'Random Game', 'GAME-311', 'User-585', '2656a9c5-c932-469f-b0a0-e9c82d9b93de', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:04', NULL, NULL, 0, NULL, NULL),
(1241, 430.00, 'Random Game', 'GAME-764', 'User-628', '1ab4f5c9-77ce-467e-b2e6-e46deca8dad8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:04', NULL, NULL, 0, NULL, NULL),
(1242, 301.00, 'Random Game', 'GAME-738', 'User-623', '059db9a6-4ba3-4ae6-8295-c386e3314a3f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:06', NULL, NULL, 0, NULL, NULL),
(1243, 874.00, 'Random Game', 'GAME-187', 'User-595', '98bee14b-8b4a-4952-8f11-38a11c10e800', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:07', NULL, NULL, 0, NULL, NULL),
(1244, 481.00, 'Random Game', 'GAME-951', 'User-469', '9e6c7024-2a9f-412a-9eed-a6e673b6b6b9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:07', NULL, NULL, 0, NULL, NULL),
(1245, 670.00, 'Random Game', 'GAME-104', 'User-937', 'e3a298d2-2f07-4e29-b719-ce40de9a2017', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:08', NULL, NULL, 0, NULL, NULL),
(1246, 982.00, 'Random Game', 'GAME-146', 'User-868', '5634a467-7363-440a-ada6-09feaf467764', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:08', NULL, NULL, 0, NULL, NULL),
(1247, 221.00, 'Random Game', 'GAME-940', 'User-465', '1a92c998-0163-4105-9746-70726005e0cc', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:16', NULL, NULL, 0, NULL, NULL),
(1248, 224.00, 'Random Game', 'GAME-539', 'User-700', '2f34b5c6-cf32-46ca-8e7b-403d86ed5dfe', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:16', NULL, NULL, 0, NULL, NULL),
(1249, 653.00, 'Random Game', 'GAME-931', 'User-964', '1c53e8bb-e77c-4ee8-bbbe-9d6407b21330', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:18', NULL, NULL, 0, NULL, NULL),
(1250, 789.00, 'Random Game', 'GAME-368', 'User-272', '35ea1c9e-10bf-4141-a5d7-09832b5cb9e6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:18', NULL, NULL, 0, NULL, NULL),
(1251, 462.00, 'Random Game', 'GAME-879', 'User-161', '0c7e2ed8-9a32-41cc-8468-14951c2be3f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:22', NULL, NULL, 0, NULL, NULL),
(1252, 52.00, 'Random Game', 'GAME-334', 'User-200', 'a4235be3-7d94-4a50-815b-3f7a9c91308c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:22', NULL, NULL, 0, NULL, NULL),
(1253, 51.00, 'Random Game', 'GAME-753', 'User-303', '78dbb9f8-1f34-4030-9e5c-84ff6e887a63', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:24', NULL, NULL, 0, NULL, NULL),
(1254, 608.00, 'Random Game', 'GAME-139', 'User-213', '362917e4-a050-4b6b-8951-0093a8db40c7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:24', NULL, NULL, 0, NULL, NULL),
(1255, 292.00, 'Random Game', 'GAME-946', 'User-337', '677a6a07-a3bf-4e68-a65f-fbf2b3a4a840', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:26', NULL, NULL, 0, NULL, NULL),
(1256, 679.00, 'Random Game', 'GAME-55', 'User-936', 'e3c7360f-1a2e-45ed-b42d-75e243c47941', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:27', NULL, NULL, 0, NULL, NULL),
(1257, 695.00, 'Random Game', 'GAME-445', 'User-93', '8b542f95-b8be-4420-bfee-dd6af89b9f4a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:27', NULL, NULL, 0, NULL, NULL),
(1258, 630.00, 'Random Game', 'GAME-598', 'User-536', 'eef214ef-4a8c-463a-9f04-335ceb307ce5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:28', NULL, NULL, 0, NULL, NULL),
(1259, 257.00, 'Random Game', 'GAME-456', 'User-951', 'a8e4066f-827c-4e17-8df3-58fd703ca327', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:28', NULL, NULL, 0, NULL, NULL),
(1260, 618.00, 'Random Game', 'GAME-270', 'User-550', '7a75c748-2138-4963-873e-d10ccca5bb66', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:36', NULL, NULL, 0, NULL, NULL),
(1261, 88.00, 'Random Game', 'GAME-829', 'User-661', '0106c134-e292-4d4a-8490-fd21d7f5e87a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:36', NULL, NULL, 0, NULL, NULL),
(1262, 952.00, 'Random Game', 'GAME-818', 'User-637', '9f6a374d-23b8-4a94-967c-49251be8778a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:38', NULL, NULL, 0, NULL, NULL),
(1263, 384.00, 'Random Game', 'GAME-403', 'User-104', '1ad6216f-f938-4fa9-81e7-af66ed26ae61', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:38', NULL, NULL, 0, NULL, NULL),
(1264, 837.00, 'Random Game', 'GAME-335', 'User-582', 'b9e97506-8ee9-44d2-88da-43458ef3d110', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:42', NULL, NULL, 0, NULL, NULL),
(1265, 410.00, 'Random Game', 'GAME-880', 'User-641', '730bf6ed-b7a8-453d-af06-528f9834748a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:42', NULL, NULL, 0, NULL, NULL),
(1266, 961.00, 'Random Game', 'GAME-426', 'User-628', 'c1c67bd6-9c98-440d-b2fd-a0997d412f18', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:44', NULL, NULL, 0, NULL, NULL),
(1267, 215.00, 'Random Game', 'GAME-131', 'User-261', '4ff31ba3-e0af-4db1-ac1a-d3b5a8e67bcc', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:44', NULL, NULL, 0, NULL, NULL),
(1268, 821.00, 'Random Game', 'GAME-46', 'User-358', '895a0abb-6a73-4871-b892-dd5580266678', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:46', NULL, NULL, 0, NULL, NULL),
(1269, 206.00, 'Random Game', 'GAME-256', 'User-192', '5a4d1daa-1726-4f2c-ba4d-beff349b8c5e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:47', NULL, NULL, 0, NULL, NULL),
(1270, 894.00, 'Random Game', 'GAME-279', 'User-811', '6d0fe44d-b819-4b6d-9c73-e047d13f84c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:47', NULL, NULL, 0, NULL, NULL),
(1271, 487.00, 'Random Game', 'GAME-275', 'User-569', '72f38691-d0e0-46fe-bd37-08db26e8d0a1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:48', NULL, NULL, 0, NULL, NULL),
(1272, 172.00, 'Random Game', 'GAME-976', 'User-51', 'e94104ca-e77e-4250-924b-13974edee30c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:48', NULL, NULL, 0, NULL, NULL),
(1273, 954.00, 'Random Game', 'GAME-816', 'User-70', '6c7ce050-9447-4de0-9d75-605a8efa360d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:56', NULL, NULL, 0, NULL, NULL),
(1274, 92.00, 'Random Game', 'GAME-533', 'User-826', '6036b504-e515-43ed-a259-d7e72eb17bc9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:56', NULL, NULL, 0, NULL, NULL),
(1275, 1005.00, 'Random Game', 'GAME-515', 'User-474', 'f274fd51-2c20-44a8-bd30-1391f4764699', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:58', NULL, NULL, 0, NULL, NULL),
(1276, 314.00, 'Random Game', 'GAME-694', 'User-559', '1bf849f4-861e-4559-8ee1-50aa50c3cbce', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:00:58', NULL, NULL, 0, NULL, NULL),
(1277, 398.00, 'Random Game', 'GAME-775', 'User-17', '2eafdd22-a28d-4065-b863-ec39170479d7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:02', NULL, NULL, 0, NULL, NULL),
(1278, 82.00, 'Random Game', 'GAME-470', 'User-140', '6cb5830b-131f-44fc-9642-93d521d080b5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:02', NULL, NULL, 0, NULL, NULL),
(1279, 988.00, 'Random Game', 'GAME-127', 'User-573', '23354d83-b536-409b-b6d4-4fc9132840e2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:04', NULL, NULL, 0, NULL, NULL),
(1280, 184.00, 'Random Game', 'GAME-245', 'User-600', '32658b0d-080c-4f4a-b0f6-afe00efd2515', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:04', NULL, NULL, 0, NULL, NULL),
(1281, 967.00, 'Random Game', 'GAME-281', 'User-734', '617a63cb-7848-42ed-a7a8-e26bb58a2678', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:06', NULL, NULL, 0, NULL, NULL),
(1282, 923.00, 'Random Game', 'GAME-629', 'User-758', 'aa54b0c5-beb9-4de5-b5a8-b5930163457c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:07', NULL, NULL, 0, NULL, NULL),
(1283, 971.00, 'Random Game', 'GAME-751', 'User-460', '161b902c-6084-4d74-8faf-fd9070e3f1cb', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:07', NULL, NULL, 0, NULL, NULL),
(1284, 365.00, 'Random Game', 'GAME-592', 'User-424', 'c2e3e750-5b8c-43d2-978e-ae5dce4ec935', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:08', NULL, NULL, 0, NULL, NULL),
(1285, 889.00, 'Random Game', 'GAME-103', 'User-758', 'fd4bb92d-b2da-4168-baf7-015a72a7b323', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:08', NULL, NULL, 0, NULL, NULL),
(1286, 266.00, 'Random Game', 'GAME-580', 'User-885', '80a6f581-04c7-4b3d-941c-c7ded4240f61', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:16', NULL, NULL, 0, NULL, NULL),
(1287, 971.00, 'Random Game', 'GAME-113', 'User-169', 'f2b623ab-20b5-4589-80ab-66e9fd1f27a5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:16', NULL, NULL, 0, NULL, NULL),
(1288, 747.00, 'Random Game', 'GAME-629', 'User-730', 'e33748c6-50ec-4fef-be3b-b7586ba2e810', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:18', NULL, NULL, 0, NULL, NULL),
(1289, 672.00, 'Random Game', 'GAME-448', 'User-392', 'fc17846f-e3fb-4e22-b17a-8e5c405f8ee8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:18', NULL, NULL, 0, NULL, NULL),
(1290, 652.00, 'Random Game', 'GAME-744', 'User-34', '1e991133-d986-4b14-91a5-02fba0682dcf', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:22', NULL, NULL, 0, NULL, NULL),
(1291, 811.00, 'Random Game', 'GAME-414', 'User-364', '4712a594-4548-4448-8b92-7e6f81e4a1c1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:22', NULL, NULL, 0, NULL, NULL),
(1292, 70.00, 'Random Game', 'GAME-264', 'User-640', 'f31c8626-29ee-42c3-8ca8-5560d36fde8b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:24', NULL, NULL, 0, NULL, NULL),
(1293, 912.00, 'Random Game', 'GAME-955', 'User-496', 'e86ae9e0-a8c3-465a-a82e-9bcc3024a202', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:24', NULL, NULL, 0, NULL, NULL),
(1294, 1046.00, 'Random Game', 'GAME-347', 'User-259', '6d2808a9-62f3-4e51-9993-edd61c77bc23', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:26', NULL, NULL, 0, NULL, NULL),
(1295, 747.00, 'Random Game', 'GAME-234', 'User-100', '8eb55fa6-ed37-44c0-a8b6-157f733db023', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:27', NULL, NULL, 0, NULL, NULL),
(1296, 1045.00, 'Random Game', 'GAME-753', 'User-916', 'f6cb46ad-22f3-4820-a4fa-0ac85a6ec721', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:27', NULL, NULL, 0, NULL, NULL),
(1297, 825.00, 'Random Game', 'GAME-528', 'User-499', '80458d04-b938-45eb-ab31-e065e4fc57c4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:28', NULL, NULL, 0, NULL, NULL),
(1298, 1007.00, 'Random Game', 'GAME-560', 'User-442', 'b6c0af31-f80f-4c81-b1ec-4b89bcc03795', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:28', NULL, NULL, 0, NULL, NULL),
(1299, 825.00, 'Random Game', 'GAME-332', 'User-258', 'b057c995-3b7a-47b1-b674-8aa0b3e507e9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:36', NULL, NULL, 0, NULL, NULL),
(1300, 555.00, 'Random Game', 'GAME-205', 'User-948', 'd896bcf5-ebdc-4199-8cd8-1bf82e48ffc1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:36', NULL, NULL, 0, NULL, NULL),
(1301, 762.00, 'Random Game', 'GAME-875', 'User-731', 'c1a33858-35ff-47fc-a678-b7136eef03b7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:38', NULL, NULL, 0, NULL, NULL),
(1302, 257.00, 'Random Game', 'GAME-209', 'User-56', '11932389-3245-4edf-ae84-10350a0fbc8a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:38', NULL, NULL, 0, NULL, NULL),
(1303, 536.00, 'Random Game', 'GAME-500', 'User-342', '9c11e0f6-229f-4cb3-8523-bb2e6b12d288', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:42', NULL, NULL, 0, NULL, NULL),
(1304, 664.00, 'Random Game', 'GAME-958', 'User-220', '1d1553bd-61f9-49d9-bca1-4669935aac19', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:42', NULL, NULL, 0, NULL, NULL),
(1305, 165.00, 'Random Game', 'GAME-634', 'User-370', '22ea02dd-2a7e-46a1-a5cc-0c7d7016953a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:44', NULL, NULL, 0, NULL, NULL),
(1306, 678.00, 'Random Game', 'GAME-687', 'User-364', '4fff0e6d-f038-412d-99da-95ccdece4dcf', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:44', NULL, NULL, 0, NULL, NULL),
(1307, 747.00, 'Random Game', 'GAME-103', 'User-956', '3d5ed8c2-9df5-4553-827a-5932a4341414', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:46', NULL, NULL, 0, NULL, NULL),
(1308, 75.00, 'Random Game', 'GAME-445', 'User-545', '4a802d3c-518b-44a3-942e-a229bd9a32c0', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:47', NULL, NULL, 0, NULL, NULL),
(1309, 189.00, 'Random Game', 'GAME-239', 'User-47', '2c894109-53a8-47a6-8301-6ec236fc79a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:47', NULL, NULL, 0, NULL, NULL),
(1310, 475.00, 'Random Game', 'GAME-53', 'User-603', '5f97544a-a70d-49a6-b2e9-309edecb5dc3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:48', NULL, NULL, 0, NULL, NULL),
(1311, 1026.00, 'Random Game', 'GAME-51', 'User-902', '4d053586-ab50-481d-8c7a-a33747cb94ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:48', NULL, NULL, 0, NULL, NULL),
(1312, 590.00, 'Random Game', 'GAME-590', 'User-86', '527ba986-b4a5-47fd-915b-6d539f77ad38', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:56', NULL, NULL, 0, NULL, NULL),
(1313, 748.00, 'Random Game', 'GAME-717', 'User-727', '32bc080d-5e58-407e-818b-d77965fe589b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:56', NULL, NULL, 0, NULL, NULL),
(1314, 99.00, 'Random Game', 'GAME-625', 'User-520', 'b7e8c534-606c-4737-b5c2-8afdde868d91', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:58', NULL, NULL, 0, NULL, NULL),
(1315, 586.00, 'Random Game', 'GAME-307', 'User-296', '301a2c7e-26b4-4f18-8382-92e9516f7113', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:01:58', NULL, NULL, 0, NULL, NULL),
(1316, 813.00, 'Random Game', 'GAME-550', 'User-768', 'e1845635-e5e9-4db2-b7ac-2909fd060d03', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:02', NULL, NULL, 0, NULL, NULL),
(1317, 1013.00, 'Random Game', 'GAME-696', 'User-316', 'f104690d-f6e2-43ac-ab22-fc23ba1e65cf', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:02', NULL, NULL, 0, NULL, NULL),
(1318, 434.00, 'Random Game', 'GAME-979', 'User-875', '583a71ca-9c3d-4c54-9d15-643b28142a22', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:04', NULL, NULL, 0, NULL, NULL),
(1319, 427.00, 'Random Game', 'GAME-766', 'User-442', '797ff31d-dd00-49f9-bf11-b236b394c3c9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:04', NULL, NULL, 0, NULL, NULL),
(1320, 635.00, 'Random Game', 'GAME-174', 'User-653', 'f3646d13-1bec-4349-be59-f8ca59016bfb', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:06', NULL, NULL, 0, NULL, NULL),
(1321, 940.00, 'Random Game', 'GAME-150', 'User-869', 'd7abfdaf-a958-4528-810b-cd991c3f0886', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:07', NULL, NULL, 0, NULL, NULL),
(1322, 800.00, 'Random Game', 'GAME-570', 'User-608', 'b785f510-16a2-4d20-91df-709ebac47e1f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:07', NULL, NULL, 0, NULL, NULL),
(1323, 795.00, 'Random Game', 'GAME-68', 'User-79', '4bdd8532-c809-467c-9b80-5fd0be31cb91', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:08', NULL, NULL, 0, NULL, NULL),
(1324, 989.00, 'Random Game', 'GAME-650', 'User-693', 'e32adcff-f855-4731-b5a0-1c638f289c99', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:08', NULL, NULL, 0, NULL, NULL),
(1325, 566.00, 'Random Game', 'GAME-601', 'User-753', '9192675c-2a91-4fec-ae11-ff4a893581d2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:16', NULL, NULL, 0, NULL, NULL),
(1326, 218.00, 'Random Game', 'GAME-188', 'User-199', '2ce1fc1b-0d03-4248-bd32-ef7e01c964c6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:16', NULL, NULL, 0, NULL, NULL),
(1327, 78.00, 'Random Game', 'GAME-696', 'User-302', 'aced9d8f-dcb0-4174-a7bc-cfbab3a79fc4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:18', NULL, NULL, 0, NULL, NULL),
(1328, 954.00, 'Random Game', 'GAME-998', 'User-443', '32c5cc4f-c0d0-44a7-bf4d-8496437fe024', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:18', NULL, NULL, 0, NULL, NULL),
(1329, 999.00, 'Random Game', 'GAME-981', 'User-768', '29e36a53-1236-4168-8069-60e7a4ca17e3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:22', NULL, NULL, 0, NULL, NULL),
(1330, 285.00, 'Random Game', 'GAME-656', 'User-702', '25633d50-7fbe-45b5-88fa-7ab98db44eb3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:22', NULL, NULL, 0, NULL, NULL),
(1331, 283.00, 'Random Game', 'GAME-346', 'User-66', '0f4f45d9-7d85-4581-a2f4-9ef420f2650b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:24', NULL, NULL, 0, NULL, NULL),
(1332, 372.00, 'Random Game', 'GAME-250', 'User-572', 'ecf865bd-44d0-4b1c-b5b7-b85cfb1ea9f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:24', NULL, NULL, 0, NULL, NULL),
(1333, 567.00, 'Random Game', 'GAME-387', 'User-116', '7662eee1-19b9-4e45-9275-d345df98a0c3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:26', NULL, NULL, 0, NULL, NULL),
(1334, 808.00, 'Random Game', 'GAME-580', 'User-719', '5992c3d4-67c5-48e7-99cf-9512721a131d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:27', NULL, NULL, 0, NULL, NULL),
(1335, 469.00, 'Random Game', 'GAME-777', 'User-683', 'd8011c6c-babe-4eaa-9294-7967b4aaadbc', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:27', NULL, NULL, 0, NULL, NULL),
(1336, 127.00, 'Random Game', 'GAME-463', 'User-921', '3ee8001d-5e03-4e4b-989a-8d22f22fab73', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:28', NULL, NULL, 0, NULL, NULL),
(1337, 751.00, 'Random Game', 'GAME-542', 'User-437', '04e1f9c7-361a-484e-a7f8-d426473616fa', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:28', NULL, NULL, 0, NULL, NULL),
(1338, 968.00, 'Random Game', 'GAME-963', 'User-508', '25e739d1-c97f-40b2-b857-4cc5c7b88830', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:36', NULL, NULL, 0, NULL, NULL),
(1339, 930.00, 'Random Game', 'GAME-48', 'User-629', '49de8318-9bca-45b7-b864-1b3e2b901d40', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:36', NULL, NULL, 0, NULL, NULL),
(1340, 814.00, 'Random Game', 'GAME-369', 'User-35', 'd2a06169-7051-4941-b159-983836111ce8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:38', NULL, NULL, 0, NULL, NULL),
(1341, 362.00, 'Random Game', 'GAME-148', 'User-860', 'b0725ae1-7944-4161-8f30-3d6cf63d7dea', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:38', NULL, NULL, 0, NULL, NULL),
(1342, 609.00, 'Random Game', 'GAME-417', 'User-564', '99b8263c-e1a4-447b-927d-82f619e74f40', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:42', NULL, NULL, 0, NULL, NULL),
(1343, 110.00, 'Random Game', 'GAME-160', 'User-672', '6e4976e5-6a57-4849-b2bb-04a088ca95ba', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:42', NULL, NULL, 0, NULL, NULL),
(1344, 607.00, 'Random Game', 'GAME-773', 'User-214', '3bf4dcff-0d53-4d1f-b30b-9a6563af4d31', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:44', NULL, NULL, 0, NULL, NULL),
(1345, 944.00, 'Random Game', 'GAME-499', 'User-87', 'feed23e5-8bd5-469f-b9bc-442eabd2efbf', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:44', NULL, NULL, 0, NULL, NULL),
(1346, 1029.00, 'Random Game', 'GAME-697', 'User-765', '4fe7e665-c889-45d5-bd24-32a5ce1ffdc5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:46', NULL, NULL, 0, NULL, NULL),
(1347, 961.00, 'Random Game', 'GAME-72', 'User-366', 'e1b7b536-3c04-4638-8826-3add78a96734', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:47', NULL, NULL, 0, NULL, NULL),
(1348, 876.00, 'Random Game', 'GAME-423', 'User-676', 'c6260e55-c530-4ed3-aa88-0bdda536e78a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:47', NULL, NULL, 0, NULL, NULL),
(1349, 72.00, 'Random Game', 'GAME-607', 'User-923', '4f8b9029-80fe-43d8-ab65-fecd5f8efdf3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:48', NULL, NULL, 0, NULL, NULL),
(1350, 198.00, 'Random Game', 'GAME-48', 'User-829', 'bc6efadd-5fd1-42d1-a830-b86722e9091e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:48', NULL, NULL, 0, NULL, NULL),
(1351, 342.00, 'Random Game', 'GAME-563', 'User-129', '5f92bdfd-b7fe-4811-b5ac-c6b15bae4ded', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:56', NULL, NULL, 0, NULL, NULL),
(1352, 530.00, 'Random Game', 'GAME-144', 'User-586', '6f7c969b-79b8-450f-9f9f-b918c100db65', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:56', NULL, NULL, 0, NULL, NULL),
(1353, 181.00, 'Random Game', 'GAME-345', 'User-942', '1599bb85-1e7e-415d-b7a5-4d13236d7400', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:58', NULL, NULL, 0, NULL, NULL),
(1354, 213.00, 'Random Game', 'GAME-697', 'User-70', '8efc81ef-da1c-45c7-8966-0cc3adf1a103', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:02:58', NULL, NULL, 0, NULL, NULL),
(1355, 713.00, 'Random Game', 'GAME-594', 'User-146', '1b76eb05-c79e-4374-a9e9-c204a7be8a60', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:02', NULL, NULL, 0, NULL, NULL),
(1356, 759.00, 'Random Game', 'GAME-564', 'User-82', '87a6b04d-6306-45b4-885d-3b7ada565b98', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:02', NULL, NULL, 0, NULL, NULL),
(1357, 773.00, 'Random Game', 'GAME-846', 'User-284', '0b53e15b-88df-460d-b7c8-db09c08aea08', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:04', NULL, NULL, 0, NULL, NULL),
(1358, 918.00, 'Random Game', 'GAME-533', 'User-945', '6ba5cfef-ad19-4322-a864-80e037e4b715', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:04', NULL, NULL, 0, NULL, NULL),
(1359, 928.00, 'Random Game', 'GAME-108', 'User-582', '63db231a-37e2-4391-a0f3-3e38dd0023a2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:06', NULL, NULL, 0, NULL, NULL),
(1360, 232.00, 'Random Game', 'GAME-909', 'User-953', '2f0a6560-0b2e-4ebc-9972-6ab395031e79', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:07', NULL, NULL, 0, NULL, NULL),
(1361, 837.00, 'Random Game', 'GAME-619', 'User-611', 'f2d46ecc-b6c1-4005-8d6c-26e87c5df245', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:07', NULL, NULL, 0, NULL, NULL),
(1362, 345.00, 'Random Game', 'GAME-973', 'User-107', '45f6bf7d-d0fc-4e68-bcf6-078ca6a3b590', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:08', NULL, NULL, 0, NULL, NULL),
(1363, 758.00, 'Random Game', 'GAME-272', 'User-588', 'd9453cf5-567e-4d61-ba5b-6cbaaaaba25c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:08', NULL, NULL, 0, NULL, NULL),
(1364, 329.00, 'Random Game', 'GAME-623', 'User-654', '57439858-9a7f-4387-904b-400dc26bd26a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:16', NULL, NULL, 0, NULL, NULL),
(1365, 453.00, 'Random Game', 'GAME-827', 'User-545', 'd99de299-525d-487d-a15e-eb2c199736f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:16', NULL, NULL, 0, NULL, NULL),
(1366, 113.00, 'Random Game', 'GAME-505', 'User-629', '22c10303-5001-4aa3-94c7-8790b571f73d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:18', NULL, NULL, 0, NULL, NULL),
(1367, 160.00, 'Random Game', 'GAME-591', 'User-140', '5d76527c-9f94-4fa1-94fc-721dc637875f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:18', NULL, NULL, 0, NULL, NULL),
(1368, 266.00, 'Random Game', 'GAME-615', 'User-856', '54f80ac3-028e-4d5a-abec-d555ebd0b979', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:22', NULL, NULL, 0, NULL, NULL),
(1369, 210.00, 'Random Game', 'GAME-708', 'User-294', '7cc552cf-6569-4296-9c57-06fe16c2b992', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:22', NULL, NULL, 0, NULL, NULL),
(1370, 990.00, 'Random Game', 'GAME-651', 'User-107', 'c1f44c40-b924-4d15-bddc-44cb2ff48227', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:24', NULL, NULL, 0, NULL, NULL),
(1371, 576.00, 'Random Game', 'GAME-294', 'User-697', 'cc857247-2925-4916-94c7-73da006eef25', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:24', NULL, NULL, 0, NULL, NULL),
(1372, 399.00, 'Random Game', 'GAME-930', 'User-31', '541cd346-d802-4b6b-bc0a-4dbb37d72d4c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:26', NULL, NULL, 0, NULL, NULL),
(1373, 324.00, 'Random Game', 'GAME-703', 'User-350', '95ecbbfa-715d-4d2b-8311-21b3397dd0bb', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:27', NULL, NULL, 0, NULL, NULL),
(1374, 365.00, 'Random Game', 'GAME-433', 'User-807', '711fada8-e6dc-4ca6-b13a-82758f902e58', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:27', NULL, NULL, 0, NULL, NULL),
(1375, 813.00, 'Random Game', 'GAME-580', 'User-151', '5677855a-804f-434b-9975-7ecc96de3d50', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:28', NULL, NULL, 0, NULL, NULL),
(1376, 110.00, 'Random Game', 'GAME-823', 'User-817', '43a96e4e-52a6-4271-a410-8412b8e650e5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:28', NULL, NULL, 0, NULL, NULL),
(1377, 673.00, 'Random Game', 'GAME-338', 'User-61', 'c3637c13-ab65-4169-99e3-e5578863c3ee', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:36', NULL, NULL, 0, NULL, NULL),
(1378, 129.00, 'Random Game', 'GAME-421', 'User-741', '106f922e-8457-4806-a9d0-85e55aeec86e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:36', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(1379, 1048.00, 'Random Game', 'GAME-209', 'User-562', '5c68d32b-9acf-476d-96d5-f0836ff87fed', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:38', NULL, NULL, 0, NULL, NULL),
(1380, 945.00, 'Random Game', 'GAME-693', 'User-67', '758495ef-a0bb-496e-bd3c-35f86700a479', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:38', NULL, NULL, 0, NULL, NULL),
(1381, 755.00, 'Random Game', 'GAME-818', 'User-171', 'ba2c72f8-606f-4085-b619-c1c3b618ab22', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:42', NULL, NULL, 0, NULL, NULL),
(1382, 436.00, 'Random Game', 'GAME-536', 'User-971', '2d72026c-de59-4d72-a9a6-dd2be9152966', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:42', NULL, NULL, 0, NULL, NULL),
(1383, 325.00, 'Random Game', 'GAME-502', 'User-542', 'a3367f5c-e5fb-43cb-bfbc-1cb8d922ab1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:44', NULL, NULL, 0, NULL, NULL),
(1384, 726.00, 'Random Game', 'GAME-427', 'User-20', '861d1231-9f85-484f-84af-bac37ece5764', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:44', NULL, NULL, 0, NULL, NULL),
(1385, 52.00, 'Random Game', 'GAME-631', 'User-738', '2a53bb9c-ef03-4e52-b8a1-d6ebc77d5da4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:46', NULL, NULL, 0, NULL, NULL),
(1386, 509.00, 'Random Game', 'GAME-309', 'User-786', '5818c5cb-0894-4d43-acf5-ea1e3d3c6bbe', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:47', NULL, NULL, 0, NULL, NULL),
(1387, 890.00, 'Random Game', 'GAME-893', 'User-289', 'd13a812b-4a59-4603-90f0-8da932dd1035', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:47', NULL, NULL, 0, NULL, NULL),
(1388, 796.00, 'Random Game', 'GAME-692', 'User-621', '72dabda8-1eb1-439e-b2e1-805dc8169c4d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:48', NULL, NULL, 0, NULL, NULL),
(1389, 415.00, 'Random Game', 'GAME-981', 'User-215', '238ce707-8679-412f-b36d-498b01d55578', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:48', NULL, NULL, 0, NULL, NULL),
(1390, 674.00, 'Random Game', 'GAME-609', 'User-247', '859c6f1a-3cef-4987-a60b-61f090d0d081', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:56', NULL, NULL, 0, NULL, NULL),
(1391, 672.00, 'Random Game', 'GAME-163', 'User-897', '7ea5f2ac-2b05-4e92-988f-966e75b7981c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:56', NULL, NULL, 0, NULL, NULL),
(1392, 470.00, 'Random Game', 'GAME-278', 'User-378', '98a04fff-b99b-4c96-ba7d-cac6c188607f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:58', NULL, NULL, 0, NULL, NULL),
(1393, 968.00, 'Random Game', 'GAME-492', 'User-449', '5d04ccb2-5a72-42cc-8f08-9fb1049d2369', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:03:58', NULL, NULL, 0, NULL, NULL),
(1394, 353.00, 'Random Game', 'GAME-428', 'User-268', '5bb39670-cf00-4215-97e8-ae41b668c160', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:02', NULL, NULL, 0, NULL, NULL),
(1395, 768.00, 'Random Game', 'GAME-289', 'User-852', '4d17fa73-cbb3-4b83-91cb-7a4b95975a37', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:02', NULL, NULL, 0, NULL, NULL),
(1396, 722.00, 'Random Game', 'GAME-695', 'User-536', '420b5e78-bdd8-4435-a6f0-50221390b77e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:04', NULL, NULL, 0, NULL, NULL),
(1397, 256.00, 'Random Game', 'GAME-730', 'User-41', '80707344-3100-4f5b-9c6f-ca158071c919', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:04', NULL, NULL, 0, NULL, NULL),
(1398, 171.00, 'Random Game', 'GAME-17', 'User-652', '47c8ec5a-92b5-4e4d-80fc-bcaa5f4e93f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:06', NULL, NULL, 0, NULL, NULL),
(1399, 611.00, 'Random Game', 'GAME-304', 'User-504', '80f16690-22f2-4cca-8359-ef68fc6c0bcf', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:07', NULL, NULL, 0, NULL, NULL),
(1400, 509.00, 'Random Game', 'GAME-563', 'User-314', '6e9cb635-bc95-40c2-ab61-d2e7f4abcd2c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:07', NULL, NULL, 0, NULL, NULL),
(1401, 339.00, 'Random Game', 'GAME-877', 'User-896', 'c4d57089-317e-42b9-91c1-4c22a621d129', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:08', NULL, NULL, 0, NULL, NULL),
(1402, 107.00, 'Random Game', 'GAME-321', 'User-598', '6135cf0e-4990-4ffe-b881-c8489b7b184b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:08', NULL, NULL, 0, NULL, NULL),
(1403, 1004.00, 'Random Game', 'GAME-81', 'User-126', 'de6339d9-1da0-4b61-aa50-3ed17231ed2f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:16', NULL, NULL, 0, NULL, NULL),
(1404, 593.00, 'Random Game', 'GAME-651', 'User-657', 'd68140cc-51f2-4701-9a46-b8ebe3f584f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:16', NULL, NULL, 0, NULL, NULL),
(1405, 193.00, 'Random Game', 'GAME-523', 'User-199', '954d78b4-4ab4-459f-b5a4-bb1929e2f8da', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:18', NULL, NULL, 0, NULL, NULL),
(1406, 212.00, 'Random Game', 'GAME-877', 'User-846', '4a882d9c-e704-4168-a07a-4a87ef2e8745', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:18', NULL, NULL, 0, NULL, NULL),
(1407, 481.00, 'Random Game', 'GAME-347', 'User-670', '9009750f-0a56-429d-aea5-ccdc42f07920', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:22', NULL, NULL, 0, NULL, NULL),
(1408, 298.00, 'Random Game', 'GAME-659', 'User-277', '41ff403b-9f60-4209-b26f-152c52b6e1f3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:22', NULL, NULL, 0, NULL, NULL),
(1409, 490.00, 'Random Game', 'GAME-317', 'User-980', 'df2c3a90-186d-491a-aa77-c792ab3640a6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:24', NULL, NULL, 0, NULL, NULL),
(1410, 766.00, 'Random Game', 'GAME-100', 'User-729', 'b31a6590-3127-4a6d-b3a6-a099c579251d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:24', NULL, NULL, 0, NULL, NULL),
(1411, 296.00, 'Random Game', 'GAME-863', 'User-515', 'ebb89485-c854-418a-ad50-6009f9ef91e1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:26', NULL, NULL, 0, NULL, NULL),
(1412, 582.00, 'Random Game', 'GAME-151', 'User-841', '1db3f2f5-8166-4d11-b172-5c6db657dd72', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:27', NULL, NULL, 0, NULL, NULL),
(1413, 838.00, 'Random Game', 'GAME-204', 'User-373', 'e6f26146-c96b-4429-9404-b477b4debf39', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:27', NULL, NULL, 0, NULL, NULL),
(1414, 668.00, 'Random Game', 'GAME-491', 'User-941', 'fc6f9991-5c87-4d19-ab38-f828b702ad91', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:28', NULL, NULL, 0, NULL, NULL),
(1415, 641.00, 'Random Game', 'GAME-891', 'User-722', 'd0660914-52a4-4800-83c2-391a027778ee', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:28', NULL, NULL, 0, NULL, NULL),
(1416, 374.00, 'Random Game', 'GAME-829', 'User-176', '15587193-bfd1-450b-8e80-66ec4c80b1b3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:36', NULL, NULL, 0, NULL, NULL),
(1417, 480.00, 'Random Game', 'GAME-30', 'User-591', '8df2470e-9058-437e-8092-dd90aef91308', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:36', NULL, NULL, 0, NULL, NULL),
(1418, 119.00, 'Random Game', 'GAME-945', 'User-976', '07993cfa-808f-4a2f-bd69-702c5e9dcd96', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:38', NULL, NULL, 0, NULL, NULL),
(1419, 586.00, 'Random Game', 'GAME-320', 'User-68', '8e4fde13-b5f1-41be-9484-469eaaeeab54', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:38', NULL, NULL, 0, NULL, NULL),
(1420, 579.00, 'Random Game', 'GAME-718', 'User-89', 'a490548c-3ac9-4d4c-b9e7-ec740de191dc', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:42', NULL, NULL, 0, NULL, NULL),
(1421, 1007.00, 'Random Game', 'GAME-302', 'User-720', 'adcc3ba3-9902-451e-b506-8022cb095148', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:42', NULL, NULL, 0, NULL, NULL),
(1422, 395.00, 'Random Game', 'GAME-786', 'User-193', 'f3815ee3-b7e4-4e84-8771-a6eb69e6178c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:44', NULL, NULL, 0, NULL, NULL),
(1423, 814.00, 'Random Game', 'GAME-884', 'User-171', 'fb07d519-7752-4817-a0a9-38ddf025c21e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:44', NULL, NULL, 0, NULL, NULL),
(1424, 1027.00, 'Random Game', 'GAME-483', 'User-833', '1e52bc63-2c8d-462d-941c-c6d5612a31f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:46', NULL, NULL, 0, NULL, NULL),
(1425, 986.00, 'Random Game', 'GAME-361', 'User-373', '3ce40cae-18f8-4189-a74b-f3702ba48fba', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:47', NULL, NULL, 0, NULL, NULL),
(1426, 497.00, 'Random Game', 'GAME-765', 'User-13', 'd1acccc1-7a3d-484a-ba4c-53ad33162e39', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:47', NULL, NULL, 0, NULL, NULL),
(1427, 727.00, 'Random Game', 'GAME-286', 'User-481', '1a86fe01-d7bc-4aa7-ab39-40b03834c03e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:48', NULL, NULL, 0, NULL, NULL),
(1428, 488.00, 'Random Game', 'GAME-512', 'User-264', '9f8b57bd-5d2d-4194-a1fe-c97047da2c88', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:48', NULL, NULL, 0, NULL, NULL),
(1429, 276.00, 'Random Game', 'GAME-961', 'User-368', '845ac80b-369f-4c9c-92b1-3966dcd08078', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:56', NULL, NULL, 0, NULL, NULL),
(1430, 731.00, 'Random Game', 'GAME-140', 'User-633', 'feee7e3f-e6da-4300-a649-4980039a446a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:56', NULL, NULL, 0, NULL, NULL),
(1431, 809.00, 'Random Game', 'GAME-797', 'User-862', '5ca2222e-903f-4205-a012-eef7af97d137', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:58', NULL, NULL, 0, NULL, NULL),
(1432, 737.00, 'Random Game', 'GAME-563', 'User-670', 'd23d8f2c-9c32-4396-af90-898b55ff2ba3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:04:58', NULL, NULL, 0, NULL, NULL),
(1433, 748.00, 'Random Game', 'GAME-926', 'User-910', '7ade57b2-a75c-45f1-a0fa-2df0c0352650', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:02', NULL, NULL, 0, NULL, NULL),
(1434, 169.00, 'Random Game', 'GAME-608', 'User-744', '8851cf3c-d703-461b-b28d-e8711bc114e7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:02', NULL, NULL, 0, NULL, NULL),
(1435, 157.00, 'Random Game', 'GAME-269', 'User-448', '096ed6bf-b33b-4923-a71b-5cdfd052062c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:04', NULL, NULL, 0, NULL, NULL),
(1436, 973.00, 'Random Game', 'GAME-449', 'User-851', 'f585f7bc-c515-4bd8-bd51-bdcb93f0a7ca', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:04', NULL, NULL, 0, NULL, NULL),
(1437, 719.00, 'Random Game', 'GAME-977', 'User-347', 'd76430b8-ef84-42d0-9661-f5320ffc3e93', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:06', NULL, NULL, 0, NULL, NULL),
(1438, 618.00, 'Random Game', 'GAME-951', 'User-339', 'cda6a7e8-62ed-45c6-b851-18e776478571', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:07', NULL, NULL, 0, NULL, NULL),
(1439, 915.00, 'Random Game', 'GAME-455', 'User-682', '71aac999-ee28-427e-934c-1e73fb766697', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:07', NULL, NULL, 0, NULL, NULL),
(1440, 549.00, 'Random Game', 'GAME-61', 'User-305', 'f51a8609-8c22-4334-913e-2c5e21b314b6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:08', NULL, NULL, 0, NULL, NULL),
(1441, 923.00, 'Random Game', 'GAME-614', 'User-214', '7b6b16e2-e824-4198-9137-ef5ffd0ec518', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:08', NULL, NULL, 0, NULL, NULL),
(1442, 369.00, 'Random Game', 'GAME-945', 'User-13', 'afd05d7e-dde1-47db-b5ea-3457502fadd4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:16', NULL, NULL, 0, NULL, NULL),
(1443, 537.00, 'Random Game', 'GAME-135', 'User-658', 'e72ea9d0-8c78-4553-985d-f2eb3ed31aea', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:16', NULL, NULL, 0, NULL, NULL),
(1444, 622.00, 'Random Game', 'GAME-168', 'User-814', 'cccf4975-2ba9-4137-90d6-054111badf8d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:18', NULL, NULL, 0, NULL, NULL),
(1445, 879.00, 'Random Game', 'GAME-749', 'User-295', '191bbf0f-2bb5-4ddf-9771-867b725bf74c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:18', NULL, NULL, 0, NULL, NULL),
(1446, 878.00, 'Random Game', 'GAME-659', 'User-211', '04a3999f-c360-42f2-95e9-5f1f8dcce29a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:22', NULL, NULL, 0, NULL, NULL),
(1447, 1013.00, 'Random Game', 'GAME-154', 'User-582', '6feca9f3-e62c-496b-af81-edd6e8eeeb68', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:22', NULL, NULL, 0, NULL, NULL),
(1448, 546.00, 'Random Game', 'GAME-89', 'User-255', 'e2e18646-d112-4f2f-a33d-dd44e48502a2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:24', NULL, NULL, 0, NULL, NULL),
(1449, 216.00, 'Random Game', 'GAME-526', 'User-439', 'a765d4cf-9f58-49cb-8580-3b60c69c7379', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:24', NULL, NULL, 0, NULL, NULL),
(1450, 545.00, 'Random Game', 'GAME-885', 'User-786', '9a1f039f-f914-4fce-9935-9d3030c30724', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:26', NULL, NULL, 0, NULL, NULL),
(1451, 248.00, 'Random Game', 'GAME-304', 'User-584', '196ba01d-ef2f-4fd0-931c-ecaacc0bdfe5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:27', NULL, NULL, 0, NULL, NULL),
(1452, 524.00, 'Random Game', 'GAME-316', 'User-509', '5427b1ed-1a0d-4b65-82dd-49fbb6f5cd9b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:27', NULL, NULL, 0, NULL, NULL),
(1453, 365.00, 'Random Game', 'GAME-218', 'User-859', '8d4a38bd-704a-453a-94b2-bd7f77360c07', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:28', NULL, NULL, 0, NULL, NULL),
(1454, 1024.00, 'Random Game', 'GAME-394', 'User-478', '131c119a-c980-4278-81f3-1efe2378b79d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:28', NULL, NULL, 0, NULL, NULL),
(1455, 259.00, 'Random Game', 'GAME-610', 'User-946', 'cd2c4d97-a066-4411-9678-5fdf4164d114', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:36', NULL, NULL, 0, NULL, NULL),
(1456, 298.00, 'Random Game', 'GAME-263', 'User-395', 'e5b2305b-0063-439a-96ee-68713b845976', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:36', NULL, NULL, 0, NULL, NULL),
(1457, 75.00, 'Random Game', 'GAME-861', 'User-235', '9af8fb57-7787-4937-a6f1-920ad0c624da', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:38', NULL, NULL, 0, NULL, NULL),
(1458, 1038.00, 'Random Game', 'GAME-523', 'User-195', 'ff8b1a6b-1f0e-4597-9b6b-73b032f36792', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:38', NULL, NULL, 0, NULL, NULL),
(1459, 469.00, 'Random Game', 'GAME-400', 'User-819', '964d2064-ea18-40cd-914e-1845c56612d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:42', NULL, NULL, 0, NULL, NULL),
(1460, 425.00, 'Random Game', 'GAME-766', 'User-905', 'd43bbe55-fa37-4420-85e6-98c69bf616fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:42', NULL, NULL, 0, NULL, NULL),
(1461, 950.00, 'Random Game', 'GAME-562', 'User-677', '0c047646-f5ca-4593-b8b8-f1e5fe07e763', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:44', NULL, NULL, 0, NULL, NULL),
(1462, 471.00, 'Random Game', 'GAME-952', 'User-426', '70ae2a6f-4eb5-420c-9b27-b4bbcb6fa54c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:44', NULL, NULL, 0, NULL, NULL),
(1463, 538.00, 'Random Game', 'GAME-586', 'User-924', '64233710-143f-4a32-acf3-e4bfb07e6363', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:46', NULL, NULL, 0, NULL, NULL),
(1464, 495.00, 'Random Game', 'GAME-670', 'User-762', '1863ebcd-6260-409b-889d-b7123ab3257a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:47', NULL, NULL, 0, NULL, NULL),
(1465, 981.00, 'Random Game', 'GAME-515', 'User-537', '13294bbe-d8aa-41a7-a4c0-96f818e55026', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:47', NULL, NULL, 0, NULL, NULL),
(1466, 237.00, 'Random Game', 'GAME-74', 'User-554', '510dfcf2-4458-43bd-b13e-911b8a1d7ec0', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:48', NULL, NULL, 0, NULL, NULL),
(1467, 456.00, 'Random Game', 'GAME-691', 'User-487', '83625d24-f74a-45f4-9325-d38e2d5f8075', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:48', NULL, NULL, 0, NULL, NULL),
(1468, 381.00, 'Random Game', 'GAME-757', 'User-328', 'de9fc3da-8cea-48f1-afbf-3ee9336173d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:56', NULL, NULL, 0, NULL, NULL),
(1469, 710.00, 'Random Game', 'GAME-250', 'User-940', 'e7dfa434-f0c7-4f22-a532-4de9c93dabdb', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:56', NULL, NULL, 0, NULL, NULL),
(1470, 902.00, 'Random Game', 'GAME-101', 'User-738', 'bc6b25cd-2f9f-4a1c-8106-53695c3e8c77', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:58', NULL, NULL, 0, NULL, NULL),
(1471, 55.00, 'Random Game', 'GAME-95', 'User-601', '25722681-91f4-4fbf-a22b-eb5fec66faed', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:05:58', NULL, NULL, 0, NULL, NULL),
(1472, 101.00, 'Random Game', 'GAME-928', 'User-931', '4a030637-cb96-4fdc-bc49-d992483877b7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:02', NULL, NULL, 0, NULL, NULL),
(1473, 453.00, 'Random Game', 'GAME-637', 'User-107', 'd9428157-ef63-4eab-8403-03de94574b8b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:02', NULL, NULL, 0, NULL, NULL),
(1474, 579.00, 'Random Game', 'GAME-143', 'User-584', '5c049c12-5694-4d2a-8e6d-7303975609a8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:04', NULL, NULL, 0, NULL, NULL),
(1475, 193.00, 'Random Game', 'GAME-662', 'User-384', '84bef3cb-59c3-46ff-a139-c6be4d9f424f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:04', NULL, NULL, 0, NULL, NULL),
(1476, 105.00, 'Random Game', 'GAME-947', 'User-204', '054c6378-3dd2-47c0-8b71-ccd398add4cf', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:06', NULL, NULL, 0, NULL, NULL),
(1477, 153.00, 'Random Game', 'GAME-448', 'User-939', 'bdbb833a-597c-4c03-82b4-cbedf0c8f621', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:07', NULL, NULL, 0, NULL, NULL),
(1478, 174.00, 'Random Game', 'GAME-905', 'User-486', '026de54f-f9df-478a-acfe-6a6760247da5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:07', NULL, NULL, 0, NULL, NULL),
(1479, 750.00, 'Random Game', 'GAME-258', 'User-871', '58cdb927-f799-462a-b26e-7894cead911d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:08', NULL, NULL, 0, NULL, NULL),
(1480, 528.00, 'Random Game', 'GAME-159', 'User-234', '4271d253-b775-4b02-9660-b16ad7906917', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:08', NULL, NULL, 0, NULL, NULL),
(1481, 576.00, 'Random Game', 'GAME-65', 'User-828', '6039da3f-d0be-442f-a371-ec18aa731880', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:16', NULL, NULL, 0, NULL, NULL),
(1482, 935.00, 'Random Game', 'GAME-444', 'User-45', 'c372ad36-9efb-401d-a81a-8e4e406cb0c6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:16', NULL, NULL, 0, NULL, NULL),
(1483, 946.00, 'Random Game', 'GAME-113', 'User-309', 'cf1bf395-7b0d-4a48-bbf8-67fd591deb68', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:18', NULL, NULL, 0, NULL, NULL),
(1484, 781.00, 'Random Game', 'GAME-266', 'User-459', 'd6738c3a-e7a8-4e39-a1a7-7c6aa826131d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:18', NULL, NULL, 0, NULL, NULL),
(1485, 206.00, 'Random Game', 'GAME-281', 'User-404', '82711ed0-7db5-4dd6-991f-e5e4b9dc5a44', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:22', NULL, NULL, 0, NULL, NULL),
(1486, 1039.00, 'Random Game', 'GAME-492', 'User-649', 'f6840cc8-bc79-4518-b23b-c9ad0317a498', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:22', NULL, NULL, 0, NULL, NULL),
(1487, 135.00, 'Random Game', 'GAME-287', 'User-960', 'fa057bfa-05b9-4021-a8df-72df3913749f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:24', NULL, NULL, 0, NULL, NULL),
(1488, 640.00, 'Random Game', 'GAME-275', 'User-204', '3c633ed6-f139-4ce1-9cf7-d408b559aa1c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:24', NULL, NULL, 0, NULL, NULL),
(1489, 363.00, 'Random Game', 'GAME-536', 'User-118', '46ec1d53-3944-458d-999c-896ebba96cba', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:26', NULL, NULL, 0, NULL, NULL),
(1490, 107.00, 'Random Game', 'GAME-681', 'User-32', 'ca25b395-3c02-4de5-9ee5-e92c06a8cb61', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:27', NULL, NULL, 0, NULL, NULL),
(1491, 481.00, 'Random Game', 'GAME-339', 'User-99', 'c88fdf64-32df-4785-a511-95fb5189a825', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:27', NULL, NULL, 0, NULL, NULL),
(1492, 950.00, 'Random Game', 'GAME-657', 'User-911', '44957e61-060c-4929-b08d-0568abceed1d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:28', NULL, NULL, 0, NULL, NULL),
(1493, 55.00, 'Random Game', 'GAME-519', 'User-784', 'd1ae9a6a-5789-4dba-a0a4-33b6a39851ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:28', NULL, NULL, 0, NULL, NULL),
(1494, 984.00, 'Random Game', 'GAME-520', 'User-141', '5cfcf0ad-5bf4-4e04-8253-d437c808099e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:36', NULL, NULL, 0, NULL, NULL),
(1495, 243.00, 'Random Game', 'GAME-329', 'User-566', '75a3902f-07f4-4647-ba48-485424fad58e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:36', NULL, NULL, 0, NULL, NULL),
(1496, 116.00, 'Random Game', 'GAME-546', 'User-71', '514ab59c-2cfa-458e-8d8f-55ca02cff298', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:38', NULL, NULL, 0, NULL, NULL),
(1497, 227.00, 'Random Game', 'GAME-426', 'User-546', 'bd92966d-6cdb-4890-abb9-c99dd13faf56', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:38', NULL, NULL, 0, NULL, NULL),
(1498, 787.00, 'Random Game', 'GAME-942', 'User-958', '98bc7d42-652c-435d-928f-4e84d3ab60da', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:42', NULL, NULL, 0, NULL, NULL),
(1499, 421.00, 'Random Game', 'GAME-235', 'User-750', '4ec25b1c-1db9-4277-8b53-4c8f9b9928a9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:42', NULL, NULL, 0, NULL, NULL),
(1500, 844.00, 'Random Game', 'GAME-104', 'User-838', 'c2cf70fe-0b13-4df0-bd41-55e0ad12dcd0', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:44', NULL, NULL, 0, NULL, NULL),
(1501, 506.00, 'Random Game', 'GAME-190', 'User-541', 'ba827609-5a89-47b4-a3f1-c7dc9b38e419', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:44', NULL, NULL, 0, NULL, NULL),
(1502, 709.00, 'Random Game', 'GAME-765', 'User-70', '69626114-77c2-45f3-8158-6b72ac29b550', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:46', NULL, NULL, 0, NULL, NULL),
(1503, 142.00, 'Random Game', 'GAME-150', 'User-459', 'cd663357-4c91-48a1-92b3-8f68f8862e39', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:47', NULL, NULL, 0, NULL, NULL),
(1504, 915.00, 'Random Game', 'GAME-569', 'User-961', '58f1c557-4e87-4c08-a8a2-c6837490251b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:47', NULL, NULL, 0, NULL, NULL),
(1505, 486.00, 'Random Game', 'GAME-832', 'User-632', '3e39b108-5547-4471-ba3c-efa6ce2422a3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:48', NULL, NULL, 0, NULL, NULL),
(1506, 1005.00, 'Random Game', 'GAME-992', 'User-661', 'c01d74d4-d51c-4e52-91e4-c9fe835bc4d3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:48', NULL, NULL, 0, NULL, NULL),
(1507, 649.00, 'Random Game', 'GAME-539', 'User-312', '2dc561c2-535d-4b36-9668-c9e27c075cae', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:56', NULL, NULL, 0, NULL, NULL),
(1508, 520.00, 'Random Game', 'GAME-273', 'User-232', 'dbc2263a-9085-419b-8232-ce86ed3e8d6b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:56', NULL, NULL, 0, NULL, NULL),
(1509, 483.00, 'Random Game', 'GAME-281', 'User-542', 'ef39a47f-a5d9-410c-b050-ff1d3892d87d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:58', NULL, NULL, 0, NULL, NULL),
(1510, 307.00, 'Random Game', 'GAME-279', 'User-563', '508d9411-dc3b-48d5-a6f5-df5f4e7665f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:06:58', NULL, NULL, 0, NULL, NULL),
(1511, 128.00, 'Random Game', 'GAME-960', 'User-927', 'd57e4ec6-936a-45ae-8925-95061504b968', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:02', NULL, NULL, 0, NULL, NULL),
(1512, 416.00, 'Random Game', 'GAME-254', 'User-793', '36026af6-5a3f-4307-9179-b31c5447dcc4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:02', NULL, NULL, 0, NULL, NULL),
(1513, 1019.00, 'Random Game', 'GAME-16', 'User-761', '00fcaca4-b958-4dda-af0c-1de1666b65d2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:04', NULL, NULL, 0, NULL, NULL),
(1514, 235.00, 'Random Game', 'GAME-908', 'User-304', '0345b9b2-0101-485a-b584-4c943ed7ded8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:04', NULL, NULL, 0, NULL, NULL),
(1515, 71.00, 'Random Game', 'GAME-153', 'User-546', 'c7169c3c-726e-40ee-a701-6027cabd86d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:06', NULL, NULL, 0, NULL, NULL),
(1516, 222.00, 'Random Game', 'GAME-773', 'User-468', '17eb2a0b-7030-4f9f-9b77-fd0421d024e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:07', NULL, NULL, 0, NULL, NULL),
(1517, 202.00, 'Random Game', 'GAME-582', 'User-720', 'f12ee4ac-efc9-46f2-9732-516200d9e7e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:07', NULL, NULL, 0, NULL, NULL),
(1518, 93.00, 'Random Game', 'GAME-310', 'User-694', '4e1a2178-bc75-4024-9fa8-9c5418d6e4d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:07', NULL, NULL, 0, NULL, NULL),
(1519, 981.00, 'Random Game', 'GAME-401', 'User-352', 'a69e201a-c1e9-44db-958c-660c9dd2bc72', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:07', NULL, NULL, 0, NULL, NULL),
(1520, 918.00, 'Random Game', 'GAME-921', 'User-805', '0100c913-a8b8-4409-97b9-35be66506295', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:08', NULL, NULL, 0, NULL, NULL),
(1521, 223.00, 'Random Game', 'GAME-51', 'User-738', '44b158c1-e4a7-4b9a-9023-71a20ed596b7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:08', NULL, NULL, 0, NULL, NULL),
(1522, 564.00, 'Random Game', 'GAME-746', 'User-0', '97b44406-ae69-4461-84a4-2416ba179103', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:27', NULL, NULL, 0, NULL, NULL),
(1523, 815.00, 'Random Game', 'GAME-111', 'User-344', '2e57dd50-a6fa-4f5e-b0bd-e1507e354452', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:27', NULL, NULL, 0, NULL, NULL),
(1524, 766.00, 'Random Game', 'GAME-962', 'User-364', 'b3b00dfa-ca76-43d9-9b28-67e10a18a7c9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:28', NULL, NULL, 0, NULL, NULL),
(1525, 797.00, 'Random Game', 'GAME-137', 'User-843', 'ddb68025-0ea7-41a9-aaa4-e3136017b755', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:28', NULL, NULL, 0, NULL, NULL),
(1526, 227.00, 'Random Game', 'GAME-422', 'User-866', 'f0af73f9-bda2-4e7d-8681-2b780b091a53', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:47', NULL, NULL, 0, NULL, NULL),
(1527, 597.00, 'Random Game', 'GAME-74', 'User-114', 'c713de96-67f3-4aa9-b253-a5de6bf358b8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:47', NULL, NULL, 0, NULL, NULL),
(1528, 753.00, 'Random Game', 'GAME-549', 'User-230', '2ee2da6a-39b7-421c-9f70-69bc0ed2b306', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:48', NULL, NULL, 0, NULL, NULL),
(1529, 177.00, 'Random Game', 'GAME-774', 'User-692', 'f6122342-3f99-457b-9b51-36f4c61dda3e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:07:48', NULL, NULL, 0, NULL, NULL),
(1530, 293.00, 'Random Game', 'GAME-475', 'User-947', '0b5b11e9-4205-40e4-aaf8-76abf133ed92', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:08', NULL, NULL, 0, NULL, NULL),
(1531, 722.00, 'Random Game', 'GAME-252', 'User-967', '913dd13d-d979-4a73-9441-954e4f8b1295', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:08', NULL, NULL, 0, NULL, NULL),
(1532, 395.00, 'Random Game', 'GAME-423', 'User-663', 'f6fd7eb6-6547-471f-bbeb-cfe48b37f632', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:09', NULL, NULL, 0, NULL, NULL),
(1533, 956.00, 'Random Game', 'GAME-825', 'User-211', '5b12b799-750a-4061-8fd5-abcdb2a1909b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:09', NULL, NULL, 0, NULL, NULL),
(1534, 855.00, 'Random Game', 'GAME-834', 'User-85', 'a7af8ac5-efbb-4157-b65e-7e66dbbe9f12', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:28', NULL, NULL, 0, NULL, NULL),
(1535, 658.00, 'Random Game', 'GAME-626', 'User-746', '424c8635-0cc1-44ce-abfe-0ccff4a425d3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:28', NULL, NULL, 0, NULL, NULL),
(1536, 471.00, 'Random Game', 'GAME-628', 'User-796', '5f46db46-de20-4d9a-8c34-4742e0c37869', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:29', NULL, NULL, 0, NULL, NULL),
(1537, 689.00, 'Random Game', 'GAME-39', 'User-835', 'a6395b02-f72f-477c-8cc1-536f74fcd904', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:29', NULL, NULL, 0, NULL, NULL),
(1538, 963.00, 'Random Game', 'GAME-292', 'User-260', 'ca6140e7-2e58-4f75-97d5-261317bb96d2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:48', NULL, NULL, 0, NULL, NULL),
(1539, 424.00, 'Random Game', 'GAME-661', 'User-901', 'd235ba60-62bf-42a2-936c-731c01fbd68d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:48', NULL, NULL, 0, NULL, NULL),
(1540, 409.00, 'Random Game', 'GAME-964', 'User-14', '3ea18fab-d275-4dce-86e0-c2f43491cdf5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:49', NULL, NULL, 0, NULL, NULL),
(1541, 287.00, 'Random Game', 'GAME-971', 'User-320', 'e89b4550-5f1d-484a-bd7a-b7f26eddc072', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:08:49', NULL, NULL, 0, NULL, NULL),
(1542, 81.00, 'Random Game', 'GAME-619', 'User-627', '22edc7d7-be25-4680-bb5b-3be08c1f6a5c', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:09:50', NULL, NULL, 0, NULL, NULL),
(1543, 581.00, 'Random Game', 'GAME-156', 'User-574', '1523bed6-7b07-480b-b63a-20c216b3eaee', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:09:50', NULL, NULL, 0, NULL, NULL),
(1544, 50.00, 'Random Game', 'GAME-369', 'User-271', 'f17a32ba-4898-4238-8c5b-45b74af66ab5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:09:50', NULL, NULL, 0, NULL, NULL),
(1545, 437.00, 'Random Game', 'GAME-366', 'User-793', '3f1737bc-13ec-473a-a606-162a4a42232f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:09:50', NULL, NULL, 0, NULL, NULL),
(1546, 922.00, 'Random Game', 'GAME-750', 'User-125', 'ea6e7fed-48c7-4829-9293-0ddb228fc95d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:10:51', NULL, NULL, 0, NULL, NULL),
(1547, 685.00, 'Random Game', 'GAME-683', 'User-455', '59cd612f-0bed-4468-b45b-3a7ef31d8004', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:10:51', NULL, NULL, 0, NULL, NULL),
(1548, 132.00, 'Random Game', 'GAME-348', 'User-65', '84bf4ea6-1c97-4a10-8d50-64b89efee134', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:10:51', NULL, NULL, 0, NULL, NULL),
(1549, 981.00, 'Random Game', 'GAME-898', 'User-850', 'fc0a8885-cb3b-4923-b30f-95524674809e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:10:51', NULL, NULL, 0, NULL, NULL),
(1550, 485.00, 'Random Game', 'GAME-924', 'User-772', '6c0cff7d-724c-4c25-ad80-d32be3bfa30f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:11:52', NULL, NULL, 0, NULL, NULL),
(1551, 125.00, 'Random Game', 'GAME-15', 'User-161', '0577063f-a255-4ca9-a43b-196416857281', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:11:52', NULL, NULL, 0, NULL, NULL),
(1552, 494.00, 'Random Game', 'GAME-364', 'User-622', '67264777-1c4c-48bb-9e63-4e586e02c1c6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:11:52', NULL, NULL, 0, NULL, NULL),
(1553, 211.00, 'Random Game', 'GAME-106', 'User-444', '4173cf35-936a-4926-859a-a31277d3f089', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:11:52', NULL, NULL, 0, NULL, NULL),
(1554, 397.00, 'Random Game', 'GAME-139', 'User-106', '46a39a3f-4efd-43db-81f6-5568f8ffeb6d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:36', NULL, NULL, 0, NULL, NULL),
(1555, 742.00, 'Random Game', 'GAME-702', 'User-21', '2ddabfbd-a49b-46c9-a68d-d9906406e355', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:36', NULL, NULL, 0, NULL, NULL),
(1556, 487.00, 'Random Game', 'GAME-383', 'User-944', '201f224a-b59e-49fb-874d-ed5512759e5f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:36', NULL, NULL, 0, NULL, NULL),
(1557, 957.00, 'Random Game', 'GAME-549', 'User-511', 'b3fdbe21-f35b-43d2-b8f9-70be73e30c93', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:36', NULL, NULL, 0, NULL, NULL),
(1558, 55.00, 'Random Game', 'GAME-154', 'User-65', '15a9c7ac-cbe6-4304-a685-918ff0560b93', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:48', NULL, NULL, 0, NULL, NULL),
(1559, 115.00, 'Random Game', 'GAME-616', 'User-997', '1e986dce-a907-480d-94a9-1a2f963681d3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:48', NULL, NULL, 0, NULL, NULL),
(1560, 166.00, 'Random Game', 'GAME-100', 'User-322', '700db932-7649-440d-8659-98f31d7db321', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:49', NULL, NULL, 0, NULL, NULL),
(1561, 670.00, 'Random Game', 'GAME-762', 'User-866', '7be07a6f-52d3-4ad5-a007-d61d7a75f8cc', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:12:49', NULL, NULL, 0, NULL, NULL),
(1562, 954.00, 'Random Game', 'GAME-696', 'User-209', 'fadd0d2a-f952-433b-a0dc-564fcef339aa', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:08', NULL, NULL, 0, NULL, NULL),
(1563, 844.00, 'Random Game', 'GAME-883', 'User-798', '4993458f-b1bf-44b6-945c-d83f9dac3744', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:08', NULL, NULL, 0, NULL, NULL),
(1564, 395.00, 'Random Game', 'GAME-768', 'User-114', 'b266ea59-e677-43ee-ba62-fc89e9c47154', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:09', NULL, NULL, 0, NULL, NULL),
(1565, 1040.00, 'Random Game', 'GAME-386', 'User-680', 'eeff4406-a7b9-4694-bbf3-8b091756eb68', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:09', NULL, NULL, 0, NULL, NULL),
(1566, 402.00, 'Random Game', 'GAME-464', 'User-181', '716fd1d8-86eb-488c-a7c8-ea8cc5eb4355', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:28', NULL, NULL, 0, NULL, NULL),
(1567, 95.00, 'Random Game', 'GAME-37', 'User-614', '1cfa1218-54ff-416b-a802-82ec689eb9fd', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:28', NULL, NULL, 0, NULL, NULL),
(1568, 356.00, 'Random Game', 'GAME-384', 'User-361', '26575220-0c3c-41eb-9fec-426930e21ef6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:29', NULL, NULL, 0, NULL, NULL),
(1569, 1034.00, 'Random Game', 'GAME-428', 'User-449', 'b89952cc-61f9-4401-992a-d619474cfbe1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:13:29', NULL, NULL, 0, NULL, NULL),
(1570, 70.00, 'Random Game', 'GAME-979', 'User-72', '140d23bd-9fe5-49c3-a6bc-44fd4e22f1b2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:14:07', NULL, NULL, 0, NULL, NULL),
(1571, 274.00, 'Random Game', 'GAME-501', 'User-720', 'b5603679-30bd-4486-8797-1a3c0c0fb76a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:14:07', NULL, NULL, 0, NULL, NULL),
(1572, 218.00, 'Random Game', 'GAME-913', 'User-706', '47a2cca2-b91b-4e7d-8a60-2de25b517675', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:14:07', NULL, NULL, 0, NULL, NULL),
(1573, 356.00, 'Random Game', 'GAME-195', 'User-419', '0bedc906-535c-4c24-bb90-93f799530322', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:14:07', NULL, NULL, 0, NULL, NULL),
(1574, 229.00, 'Random Game', 'GAME-375', 'User-977', 'c6976d22-2f9e-4dc4-8eaa-f9ad668df339', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:15:07', NULL, NULL, 0, NULL, NULL),
(1575, 152.00, 'Random Game', 'GAME-10', 'User-594', '39fcca0d-07a5-408c-9a2e-3902b6b4c25e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:15:07', NULL, NULL, 0, NULL, NULL),
(1576, 321.00, 'Random Game', 'GAME-477', 'User-859', '4d0d769b-179a-4ab1-b3d9-c4f1a8540ff8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:15:07', NULL, NULL, 0, NULL, NULL),
(1577, 88.00, 'Random Game', 'GAME-136', 'User-23', '391d8a69-e5bc-4bef-a6cd-b2d07adc3fb9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:15:07', NULL, NULL, 0, NULL, NULL),
(1578, 93.00, 'Random Game', 'GAME-943', 'User-555', '185f3425-e8ae-4f65-8a95-0a31462b6315', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:16:07', NULL, NULL, 0, NULL, NULL),
(1579, 491.00, 'Random Game', 'GAME-465', 'User-22', '2b8c5a64-bf81-4577-9a4c-e6ac36d4cd0d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:16:07', NULL, NULL, 0, NULL, NULL),
(1580, 800.00, 'Random Game', 'GAME-850', 'User-652', '839433f6-19d4-4059-b258-42f3662dbda0', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:16:07', NULL, NULL, 0, NULL, NULL),
(1581, 394.00, 'Random Game', 'GAME-323', 'User-476', '50928513-7687-4d02-aee6-e8aabdb8a5f0', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:16:07', NULL, NULL, 0, NULL, NULL),
(1582, 795.00, 'Random Game', 'GAME-881', 'User-322', 'b8eef67d-27fc-4388-bfaa-dff4b74ac03e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:17:07', NULL, NULL, 0, NULL, NULL),
(1583, 99.00, 'Random Game', 'GAME-189', 'User-433', '73ef3348-66e4-4148-a151-76daf15748c4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:17:07', NULL, NULL, 0, NULL, NULL),
(1584, 674.00, 'Random Game', 'GAME-715', 'User-126', '87a9acf2-15ea-4fb9-a67e-59bb6cd53cc9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:17:07', NULL, NULL, 0, NULL, NULL),
(1585, 608.00, 'Random Game', 'GAME-822', 'User-819', '38565dd4-a1e7-4cd9-b807-6981fc55a61d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:17:07', NULL, NULL, 0, NULL, NULL),
(1586, 519.00, 'Random Game', 'GAME-313', 'User-336', '7e113613-dc36-4ea0-9db1-4fdcd139687e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:18:07', NULL, NULL, 0, NULL, NULL),
(1587, 396.00, 'Random Game', 'GAME-672', 'User-172', '41a56800-5d46-42d3-ab8e-90f53676ba46', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:18:07', NULL, NULL, 0, NULL, NULL),
(1588, 278.00, 'Random Game', 'GAME-952', 'User-924', 'e732688a-6801-4c7f-a9ff-84fe4c81146b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:18:07', NULL, NULL, 0, NULL, NULL),
(1589, 839.00, 'Random Game', 'GAME-509', 'User-131', '4e818791-fac8-47f5-b324-c4cdecdbdd89', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:18:07', NULL, NULL, 0, NULL, NULL),
(1590, 59.00, 'Random Game', 'GAME-164', 'User-132', '0c7e9580-156d-4d4f-9827-faf462076bbe', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:19:07', NULL, NULL, 0, NULL, NULL),
(1591, 795.00, 'Random Game', 'GAME-674', 'User-172', '65c36f0c-7234-4c68-8cd2-0596553bda92', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:19:07', NULL, NULL, 0, NULL, NULL),
(1592, 631.00, 'Random Game', 'GAME-279', 'User-459', 'c80b34d1-b27e-4316-971a-cb85e928e574', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:19:07', NULL, NULL, 0, NULL, NULL),
(1593, 543.00, 'Random Game', 'GAME-527', 'User-547', 'd05e6ba7-0ce0-4d60-a893-e1aa94711d48', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:19:07', NULL, NULL, 0, NULL, NULL),
(1594, 611.00, 'Random Game', 'GAME-328', 'User-994', 'ae7f8b6b-1dc0-4301-b2e3-b6ff2e035bca', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:20:07', NULL, NULL, 0, NULL, NULL),
(1595, 137.00, 'Random Game', 'GAME-770', 'User-356', 'dd6e50c1-37b3-4bd8-869c-00a8dc943e6d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:20:07', NULL, NULL, 0, NULL, NULL),
(1596, 621.00, 'Random Game', 'GAME-273', 'User-786', 'c6b226c0-b2f2-480c-a2b3-ceb2446ef2d8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:20:07', NULL, NULL, 0, NULL, NULL),
(1597, 139.00, 'Random Game', 'GAME-782', 'User-433', '59915acb-be0b-4ca2-bdf9-b20b2ce912ea', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:20:07', NULL, NULL, 0, NULL, NULL),
(1598, 206.00, 'Random Game', 'GAME-948', 'User-107', '3940f456-4b85-42d2-bcb4-a6be1f35a6c5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:21:07', NULL, NULL, 0, NULL, NULL),
(1599, 472.00, 'Random Game', 'GAME-657', 'User-553', 'd0bef3a3-f6d8-4140-8dc0-bf38c16ebf92', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:21:07', NULL, NULL, 0, NULL, NULL),
(1600, 588.00, 'Random Game', 'GAME-36', 'User-121', '49bb9662-a339-4a0c-8a22-ce10fcaf2b31', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:21:07', NULL, NULL, 0, NULL, NULL),
(1601, 948.00, 'Random Game', 'GAME-664', 'User-71', '8ade6533-44bf-4bf0-8020-33e0e41b61d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:21:07', NULL, NULL, 0, NULL, NULL),
(1602, 1030.00, 'Random Game', 'GAME-483', 'User-293', 'ee16312e-5434-4fef-bf2e-1e69ba9d22c3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:22:07', NULL, NULL, 0, NULL, NULL),
(1603, 349.00, 'Random Game', 'GAME-287', 'User-887', 'ad2cff93-a9ed-4b2d-8771-7b73a2333c71', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:22:07', NULL, NULL, 0, NULL, NULL),
(1604, 462.00, 'Random Game', 'GAME-702', 'User-383', '3113cd9f-def3-470a-86f2-04610b1ba0a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:22:07', NULL, NULL, 0, NULL, NULL),
(1605, 490.00, 'Random Game', 'GAME-698', 'User-382', '91435fd2-7b03-4e37-85ae-cadcad5c3d98', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:22:07', NULL, NULL, 0, NULL, NULL),
(1606, 227.00, 'Random Game', 'GAME-159', 'User-376', '31977b7e-13d4-4a0d-b9e0-ef02807feaa7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:28:31', NULL, NULL, 0, NULL, NULL),
(1607, 1036.00, 'Random Game', 'GAME-63', 'User-263', 'a82ec054-5a7a-4178-841e-854a496b5124', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:28:31', NULL, NULL, 0, NULL, NULL),
(1608, 190.00, 'Random Game', 'GAME-171', 'User-635', 'ca1d06e7-2263-451a-8bd3-9a50fbdac25d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:28:52', NULL, NULL, 0, NULL, NULL),
(1609, 151.00, 'Random Game', 'GAME-485', 'User-746', '64f93da8-f927-459d-9ed6-8b30cdaa3ede', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:28:52', NULL, NULL, 0, NULL, NULL),
(1610, 592.00, 'Random Game', 'GAME-402', 'User-307', 'f72fed8f-1afb-42a6-8cbd-70c629239e0e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:29:12', NULL, NULL, 0, NULL, NULL),
(1611, 569.00, 'Random Game', 'GAME-300', 'User-790', 'f3ed2c32-c629-412e-8f70-bd50e5879dd1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:29:12', NULL, NULL, 0, NULL, NULL),
(1612, 924.00, 'Random Game', 'GAME-0', 'User-665', 'cd10b23e-a83e-4973-88b5-a3507d09043b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:29:32', NULL, NULL, 0, NULL, NULL),
(1613, 182.00, 'Random Game', 'GAME-534', 'User-483', 'ebcf91ec-51fa-42c9-94f6-915ed6d15c2a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:29:32', NULL, NULL, 0, NULL, NULL),
(1614, 424.00, 'Random Game', 'GAME-890', 'User-620', '4fb3b179-fae0-4174-b4f9-d9812fd8b31d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:29:52', NULL, NULL, 0, NULL, NULL),
(1615, 594.00, 'Random Game', 'GAME-843', 'User-550', 'b902bf26-9f81-4d32-8f35-68d2b858eab5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:29:52', NULL, NULL, 0, NULL, NULL),
(1616, 105.00, 'Random Game', 'GAME-559', 'User-841', '4ca6b4d4-481c-4f6d-aa86-b180406d65f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:30:12', NULL, NULL, 0, NULL, NULL),
(1617, 414.00, 'Random Game', 'GAME-369', 'User-791', 'e9f4a112-687b-4421-9406-3a3b122d2a36', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:30:12', NULL, NULL, 0, NULL, NULL),
(1618, 968.00, 'Random Game', 'GAME-853', 'User-173', '3f3370ad-fc87-4a3a-9799-37afcd2c6982', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:30:32', NULL, NULL, 0, NULL, NULL),
(1619, 800.00, 'Random Game', 'GAME-346', 'User-477', 'ec6fe9f1-c8c8-4efb-b540-583fbabbde99', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:30:32', NULL, NULL, 0, NULL, NULL),
(1620, 152.00, 'Random Game', 'GAME-298', 'User-903', '39b46e23-58e2-42c7-a30b-33191d2f688e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:30:52', NULL, NULL, 0, NULL, NULL),
(1621, 111.00, 'Random Game', 'GAME-863', 'User-161', 'e041be4f-2828-4117-bb4c-3b48e2d20461', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:30:52', NULL, NULL, 0, NULL, NULL),
(1622, 166.00, 'Random Game', 'GAME-167', 'User-183', '7f9349ab-63e5-4848-abc7-3f108a40f41b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:31:12', NULL, NULL, 0, NULL, NULL),
(1623, 503.00, 'Random Game', 'GAME-469', 'User-398', '6ed5d3b8-7221-42f3-a467-c23d29742354', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:31:12', NULL, NULL, 0, NULL, NULL),
(1624, 469.00, 'Random Game', 'GAME-776', 'User-964', 'ac20b712-f045-4f2a-bc82-7603c524a2f5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:31:58', NULL, NULL, 0, NULL, NULL),
(1625, 297.00, 'Random Game', 'GAME-713', 'User-351', '25e6dcbe-5a00-49ff-9168-29d6dedf2117', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:31:58', NULL, NULL, 0, NULL, NULL),
(1626, 789.00, 'Random Game', 'GAME-150', 'User-411', 'c9d6095e-f80f-4d50-ab18-4d2919578e38', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:32:11', NULL, NULL, 0, NULL, NULL),
(1627, 284.00, 'Random Game', 'GAME-685', 'User-561', '7fedf838-992c-4303-9b59-6d6e21391f77', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:32:11', NULL, NULL, 0, NULL, NULL),
(1628, 402.00, 'Random Game', 'GAME-218', 'User-47', 'a601b81f-1323-4178-be31-49ebfc36735b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:32:32', NULL, NULL, 0, NULL, NULL),
(1629, 807.00, 'Random Game', 'GAME-901', 'User-995', '0d3feade-654d-47f1-a426-a454e6626525', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:32:32', NULL, NULL, 0, NULL, NULL),
(1630, 362.00, 'Random Game', 'GAME-658', 'User-150', '83750e87-4910-412a-958f-5189f40f072e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:32:52', NULL, NULL, 0, NULL, NULL),
(1631, 916.00, 'Random Game', 'GAME-239', 'User-41', 'd592fe8e-c581-41d5-8686-dad308133eb9', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:32:52', NULL, NULL, 0, NULL, NULL),
(1632, 181.00, 'Random Game', 'GAME-449', 'User-868', 'eef20e32-baed-4528-b91d-dea806cbf965', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:33:12', NULL, NULL, 0, NULL, NULL),
(1633, 139.00, 'Random Game', 'GAME-810', 'User-193', '3bd4d5d0-aeb1-4b6a-8e38-35e256cb3947', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:33:12', NULL, NULL, 0, NULL, NULL),
(1634, 345.00, 'Random Game', 'GAME-582', 'User-904', '49872ecc-1d61-4f56-9a19-36df95b2b391', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:34:07', NULL, NULL, 0, NULL, NULL),
(1635, 331.00, 'Random Game', 'GAME-488', 'User-607', 'e75eec7d-808c-4373-83ea-6b319145dcb4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:34:07', NULL, NULL, 0, NULL, NULL),
(1636, 398.00, 'Random Game', 'GAME-28', 'User-27', '346a53ed-7736-4e57-a38d-df91788fd9bd', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:35:07', NULL, NULL, 0, NULL, NULL),
(1637, 412.00, 'Random Game', 'GAME-928', 'User-730', 'eb8ccd51-fed6-4fd0-b582-29de42633912', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:35:07', NULL, NULL, 0, NULL, NULL),
(1638, 423.00, 'Random Game', 'GAME-417', 'User-929', '782510b1-88d8-40bf-8dc8-e7f8308f3897', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:36:07', NULL, NULL, 0, NULL, NULL),
(1639, 137.00, 'Random Game', 'GAME-442', 'User-212', 'ca6e4594-018d-4c81-824c-2de03d349365', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:36:07', NULL, NULL, 0, NULL, NULL),
(1640, 462.00, 'Random Game', 'GAME-159', 'User-364', '35c379c8-c5b4-49b7-a545-87d83f93b2bb', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:37:07', NULL, NULL, 0, NULL, NULL),
(1641, 643.00, 'Random Game', 'GAME-934', 'User-377', '2e00c10b-c640-4e52-ab6a-e22a49e6048d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:37:07', NULL, NULL, 0, NULL, NULL),
(1642, 603.00, 'Random Game', 'GAME-558', 'User-546', '5d2c1755-5650-4721-84c2-713ec5ca356d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:38:07', NULL, NULL, 0, NULL, NULL),
(1643, 975.00, 'Random Game', 'GAME-442', 'User-743', 'e19c56bb-f179-4ad8-90fb-de09374ace11', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:38:07', NULL, NULL, 0, NULL, NULL),
(1644, 90.00, 'Random Game', 'GAME-271', 'User-952', '52283651-3474-4b8b-b29a-2cbe8e5d3dc6', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:39:07', NULL, NULL, 0, NULL, NULL),
(1645, 833.00, 'Random Game', 'GAME-499', 'User-567', 'd439e4f5-0e0c-41d7-9eb4-e6b2608b711d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:39:07', NULL, NULL, 0, NULL, NULL),
(1646, 1046.00, 'Random Game', 'GAME-191', 'User-123', '54cfe3e8-d709-4eac-91c4-e1e0296e2f12', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:40:07', NULL, NULL, 0, NULL, NULL),
(1647, 835.00, 'Random Game', 'GAME-139', 'User-405', '7586fb59-3263-4222-8942-d9905a46e96f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:40:07', NULL, NULL, 0, NULL, NULL),
(1648, 198.00, 'Random Game', 'GAME-243', 'User-585', '4e145882-35a3-4093-9285-b88f035c7d19', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:41:07', NULL, NULL, 0, NULL, NULL),
(1649, 571.00, 'Random Game', 'GAME-282', 'User-931', '7db23521-dfec-45d4-8636-3979b31befa5', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:41:07', NULL, NULL, 0, NULL, NULL),
(1650, 765.00, 'Random Game', 'GAME-611', 'User-449', 'd3cc6f3f-b682-4c82-9fc7-d6d9089dced2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:42:07', NULL, NULL, 0, NULL, NULL),
(1651, 297.00, 'Random Game', 'GAME-791', 'User-638', '0bbd6310-6c1f-42b9-bcdd-a57f03a9b730', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:42:07', NULL, NULL, 0, NULL, NULL),
(1652, 159.00, 'Random Game', 'GAME-550', 'User-492', 'b2b456b9-2071-4032-89e1-5c2519c46eca', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:43:07', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(1653, 784.00, 'Random Game', 'GAME-424', 'User-39', 'd2ce3185-9433-44ab-b865-4fdfcb83d4f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:43:07', NULL, NULL, 0, NULL, NULL),
(1654, 983.00, 'Random Game', 'GAME-67', 'User-952', '94a2aac2-472c-4ca0-9b88-a10714e4386e', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:44:07', NULL, NULL, 0, NULL, NULL),
(1655, 336.00, 'Random Game', 'GAME-386', 'User-28', '008cc19e-8c1d-450f-b338-8eabfb5a93b2', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:44:07', NULL, NULL, 0, NULL, NULL),
(1656, 356.00, 'Random Game', 'GAME-324', 'User-62', '2143753b-dd42-48f0-8298-84f8523d83e1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:45:07', NULL, NULL, 0, NULL, NULL),
(1657, 885.00, 'Random Game', 'GAME-49', 'User-641', 'f3aa8ec2-50a0-4835-99f3-2eaeb65a6953', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:45:07', NULL, NULL, 0, NULL, NULL),
(1658, 124.00, 'Random Game', 'GAME-430', 'User-796', '0ca4b977-c02c-4077-b256-5d6bd957fe4b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:46:07', NULL, NULL, 0, NULL, NULL),
(1659, 743.00, 'Random Game', 'GAME-388', 'User-960', '414ccf80-cb8a-4165-803a-f93f4c12bf2a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:46:07', NULL, NULL, 0, NULL, NULL),
(1660, 465.00, 'Random Game', 'GAME-499', 'User-141', '8321365c-51b4-4b24-b447-57a57ee73eb4', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:47:07', NULL, NULL, 0, NULL, NULL),
(1661, 939.00, 'Random Game', 'GAME-948', 'User-386', 'd466b9b6-603c-417a-a112-27a742359373', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:47:07', NULL, NULL, 0, NULL, NULL),
(1662, 1033.00, 'Random Game', 'GAME-19', 'User-326', '9940383f-cd94-4e48-90af-a82a97aa539d', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:48:07', NULL, NULL, 0, NULL, NULL),
(1663, 840.00, 'Random Game', 'GAME-575', 'User-793', 'abfb4b35-8726-4282-976f-ffb08eb4f770', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:48:07', NULL, NULL, 0, NULL, NULL),
(1664, 975.00, 'Random Game', 'GAME-441', 'User-591', '213c00d1-ace1-46dc-984d-2f37e463606f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:49:07', NULL, NULL, 0, NULL, NULL),
(1665, 353.00, 'Random Game', 'GAME-84', 'User-749', '808d922f-32e6-4e5d-ae19-fec9602a4262', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:49:07', NULL, NULL, 0, NULL, NULL),
(1666, 536.00, 'Random Game', 'GAME-729', 'User-16', '7f8405f4-421b-44fa-a3a3-e9124cce93a1', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:50:07', NULL, NULL, 0, NULL, NULL),
(1667, 1039.00, 'Random Game', 'GAME-529', 'User-157', '87f34e8f-cc47-4798-be39-4a538a452461', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:50:07', NULL, NULL, 0, NULL, NULL),
(1668, 390.00, 'Random Game', 'GAME-156', 'User-820', 'b5cb3ac2-e46d-435b-815e-278168ae4342', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:51:07', NULL, NULL, 0, NULL, NULL),
(1669, 124.00, 'Random Game', 'GAME-429', 'User-454', '4b720652-13d0-4a5b-a63a-654d1f5cf02a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:51:07', NULL, NULL, 0, NULL, NULL),
(1670, 813.00, 'Random Game', 'GAME-794', 'User-605', 'f80a58a8-faea-4dc9-8a14-7aa10c4aa924', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:52:07', NULL, NULL, 0, NULL, NULL),
(1671, 620.00, 'Random Game', 'GAME-953', 'User-418', '244b7627-b4b8-40cf-a6aa-cec7611cac56', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:52:07', NULL, NULL, 0, NULL, NULL),
(1672, 349.00, 'Random Game', 'GAME-684', 'User-70', '8ba9a6e0-b8cd-4622-b9fd-16a76102cb9a', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:53:07', NULL, NULL, 0, NULL, NULL),
(1673, 897.00, 'Random Game', 'GAME-963', 'User-643', '1ebc4830-16c8-43be-8756-d9fe62b96440', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:53:07', NULL, NULL, 0, NULL, NULL),
(1674, 441.00, 'Random Game', 'GAME-368', 'User-555', '1491c060-d6eb-4f8b-a988-72ff030a2214', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:54:07', NULL, NULL, 0, NULL, NULL),
(1675, 878.00, 'Random Game', 'GAME-428', 'User-37', '3d794116-22a2-434d-b5ac-1af908be805f', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:54:07', NULL, NULL, 0, NULL, NULL),
(1676, 431.00, 'Random Game', 'GAME-429', 'User-776', '76c67a1e-69ac-4d6c-920e-165f5df9ec70', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:55:07', NULL, NULL, 0, NULL, NULL),
(1677, 635.00, 'Random Game', 'GAME-208', 'User-349', 'a530ee53-8f6f-4368-a061-4b7eece6cd20', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:55:07', NULL, NULL, 0, NULL, NULL),
(1678, 696.00, 'Random Game', 'GAME-93', 'User-341', '6f04757b-e20c-47a4-926b-9617ccf6e436', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:56:07', NULL, NULL, 0, NULL, NULL),
(1679, 550.00, 'Random Game', 'GAME-798', 'User-561', '30632f99-7d23-4eb9-82c0-95a9383b1f5b', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:56:07', NULL, NULL, 0, NULL, NULL),
(1680, 1023.00, 'Random Game', 'GAME-599', 'User-746', '8a37a79f-ed30-41d6-afe7-9efebe4260d8', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:57:07', NULL, NULL, 0, NULL, NULL),
(1681, 745.00, 'Random Game', 'GAME-675', 'User-377', '7bddfc19-979e-462d-a08e-86116c147651', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:57:07', NULL, NULL, 0, NULL, NULL),
(1682, 505.00, 'Random Game', 'GAME-804', 'User-797', '34f59bc5-e9c6-4693-9fd8-a6acef657105', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:58:07', NULL, NULL, 0, NULL, NULL),
(1683, 986.00, 'Random Game', 'GAME-833', 'User-949', 'fd089b4b-5e09-483f-9c81-4efb870f40f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:58:07', NULL, NULL, 0, NULL, NULL),
(1684, 342.00, 'Random Game', 'GAME-224', 'User-328', 'd26a7959-a97f-412c-9acf-975e0e04dbf3', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:59:07', NULL, NULL, 0, NULL, NULL),
(1685, 785.00, 'Random Game', 'GAME-735', 'User-474', '51707015-c030-4019-be84-73cf742be9e7', 19, 'pending_validation', NULL, NULL, '2025-04-09 10:59:07', NULL, NULL, 0, NULL, NULL),
(1686, 975.00, 'Random Game', 'GAME-373', 'User-64', '3b925a62-8494-40fc-a9a1-9eca728f858e', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:00:07', NULL, NULL, 0, NULL, NULL),
(1687, 914.00, 'Random Game', 'GAME-794', 'User-469', '77a92b29-ba9b-4369-a879-13440df866f8', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:00:07', NULL, NULL, 0, NULL, NULL),
(1688, 73.00, 'Random Game', 'GAME-417', 'User-18', 'abf9dd7f-b809-487a-9997-616d06010e18', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:01:07', NULL, NULL, 0, NULL, NULL),
(1689, 862.00, 'Random Game', 'GAME-449', 'User-734', 'a29b5230-9997-4780-aee3-510b1fe0a630', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:01:07', NULL, NULL, 0, NULL, NULL),
(1690, 536.00, 'Random Game', 'GAME-803', 'User-467', 'dec3f6cd-94b0-4cbe-a060-66ea3d2dbfeb', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:02:07', NULL, NULL, 0, NULL, NULL),
(1691, 1026.00, 'Random Game', 'GAME-720', 'User-282', '83518076-2c23-44ae-aefe-597257fd61f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:02:07', NULL, NULL, 0, NULL, NULL),
(1692, 985.00, 'Random Game', 'GAME-951', 'User-131', 'd511a28e-207d-40dc-a3ac-0fb157f2c0bd', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:03:07', NULL, NULL, 0, NULL, NULL),
(1693, 273.00, 'Random Game', 'GAME-889', 'User-506', 'd318f75a-565d-44a2-b8c0-0ccb6d8a4769', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:03:07', NULL, NULL, 0, NULL, NULL),
(1694, 449.00, 'Random Game', 'GAME-134', 'User-108', '12e01c21-a354-4699-be02-d2c29594157a', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:04:07', NULL, NULL, 0, NULL, NULL),
(1695, 975.00, 'Random Game', 'GAME-430', 'User-177', 'e4006d9b-c051-4c32-ab5e-ff03cabc28ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:04:07', NULL, NULL, 0, NULL, NULL),
(1696, 312.00, 'Random Game', 'GAME-0', 'User-916', '38b73a7c-8f03-4fb4-af2b-c061f5fc0db3', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:05:07', NULL, NULL, 0, NULL, NULL),
(1697, 223.00, 'Random Game', 'GAME-926', 'User-591', '4c07c78e-0cc9-429d-9575-54108524f19e', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:05:07', NULL, NULL, 0, NULL, NULL),
(1698, 515.00, 'Random Game', 'GAME-686', 'User-242', '1c2ec20b-7878-4a55-a61e-e91d86e866cc', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:06:07', NULL, NULL, 0, NULL, NULL),
(1699, 245.00, 'Random Game', 'GAME-633', 'User-800', 'ce228e52-2d05-49b0-80e0-48b8dcfa01ef', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:06:07', NULL, NULL, 0, NULL, NULL),
(1700, 640.00, 'Random Game', 'GAME-453', 'User-125', '5697a716-4f38-4f4e-a97c-b61bc9922e89', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:07:07', NULL, NULL, 0, NULL, NULL),
(1701, 265.00, 'Random Game', 'GAME-927', 'User-878', '2e7fe1a0-ccd0-45cb-879f-dabbf4bb198c', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:07:07', NULL, NULL, 0, NULL, NULL),
(1702, 314.00, 'Random Game', 'GAME-597', 'User-871', '8b93bf71-5b7e-41e0-b043-1cfe4b4a6560', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:08:07', NULL, NULL, 0, NULL, NULL),
(1703, 261.00, 'Random Game', 'GAME-32', 'User-904', '31120986-a283-41b4-9aeb-f28f7dd37b82', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:08:07', NULL, NULL, 0, NULL, NULL),
(1704, 73.00, 'Random Game', 'GAME-75', 'User-493', '2a30e20f-e8ca-4628-be61-c00d65936024', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:09:07', NULL, NULL, 0, NULL, NULL),
(1705, 723.00, 'Random Game', 'GAME-742', 'User-572', '28bce587-9ad5-4c6c-b4af-05c0dcdba0f2', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:09:07', NULL, NULL, 0, NULL, NULL),
(1706, 277.00, 'Random Game', 'GAME-786', 'User-656', '50788d8d-2297-493d-b060-c8bebfa43d08', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:10:07', NULL, NULL, 0, NULL, NULL),
(1707, 567.00, 'Random Game', 'GAME-38', 'User-909', 'd3ef8824-1155-46aa-b2bf-217315d8ec1e', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:10:07', NULL, NULL, 0, NULL, NULL),
(1708, 194.00, 'Random Game', 'GAME-941', 'User-927', '4e22c511-1ec7-49c1-94b4-62bd4ca6324e', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:11:07', NULL, NULL, 0, NULL, NULL),
(1709, 212.00, 'Random Game', 'GAME-616', 'User-629', '489de4a1-b47e-41c1-a6e1-a50433909486', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:11:07', NULL, NULL, 0, NULL, NULL),
(1710, 516.00, 'Random Game', 'GAME-769', 'User-241', 'e85c8592-443a-4c32-9852-f9f8761f56a4', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:12:07', NULL, NULL, 0, NULL, NULL),
(1711, 579.00, 'Random Game', 'GAME-813', 'User-749', '2f3950f7-8bc4-4b05-bf7f-2451de6bc683', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:12:07', NULL, NULL, 0, NULL, NULL),
(1712, 746.00, 'Random Game', 'GAME-352', 'User-136', 'cede15b6-0cda-4f00-8b95-6b8dd8968ee6', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:13:07', NULL, NULL, 0, NULL, NULL),
(1713, 137.00, 'Random Game', 'GAME-455', 'User-510', '3d4335d7-7a20-4c94-b086-d7e24b1a8e25', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:13:07', NULL, NULL, 0, NULL, NULL),
(1714, 738.00, 'Random Game', 'GAME-471', 'User-382', '45045961-9c46-4a46-802c-4a380adbe05b', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:14:07', NULL, NULL, 0, NULL, NULL),
(1715, 790.00, 'Random Game', 'GAME-926', 'User-41', 'e21a7b8e-b179-4b42-9763-a1c71739d884', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:14:07', NULL, NULL, 0, NULL, NULL),
(1716, 993.00, 'Random Game', 'GAME-240', 'User-503', '6bf9d872-c38f-4b46-8915-30d237788322', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:15:07', NULL, NULL, 0, NULL, NULL),
(1717, 174.00, 'Random Game', 'GAME-885', 'User-713', '7b31fb23-bc88-47af-a4f3-7a0c7c30ac92', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:15:07', NULL, NULL, 0, NULL, NULL),
(1718, 436.00, 'Random Game', 'GAME-360', 'User-277', '6a3594ea-c7f6-443b-93a9-75aeb933adec', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:16:07', NULL, NULL, 0, NULL, NULL),
(1719, 939.00, 'Random Game', 'GAME-902', 'User-908', '313a1d57-70b8-478b-8382-60c686e8a761', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:16:07', NULL, NULL, 0, NULL, NULL),
(1720, 947.00, 'Random Game', 'GAME-352', 'User-671', '5a7a1818-cc31-4dec-8707-baf5861ea42b', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:17:07', NULL, NULL, 0, NULL, NULL),
(1721, 805.00, 'Random Game', 'GAME-893', 'User-330', '7f6a519b-754d-4394-9fb4-54e103ec65a6', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:17:07', NULL, NULL, 0, NULL, NULL),
(1722, 789.00, 'Random Game', 'GAME-220', 'User-348', '362bdac9-e9ed-4949-9453-2c4385cb6f74', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:18:07', NULL, NULL, 0, NULL, NULL),
(1723, 620.00, 'Random Game', 'GAME-544', 'User-273', '8336c6f5-5e28-4141-bba6-ba3967165ef3', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:18:07', NULL, NULL, 0, NULL, NULL),
(1724, 882.00, 'Random Game', 'GAME-281', 'User-697', 'e4696c88-589a-42f8-a82e-586cb75036db', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:19:07', NULL, NULL, 0, NULL, NULL),
(1725, 274.00, 'Random Game', 'GAME-818', 'User-936', 'f0eedc91-84aa-4677-aea0-b7060ef90d0c', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:19:07', NULL, NULL, 0, NULL, NULL),
(1726, 483.00, 'Random Game', 'GAME-643', 'User-650', '0e177ac4-eaf7-4d08-98fc-40d795dbdf58', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:20:07', NULL, NULL, 0, NULL, NULL),
(1727, 456.00, 'Random Game', 'GAME-923', 'User-78', 'f28b3f22-176a-4891-95b3-cfe14c37af1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:20:07', NULL, NULL, 0, NULL, NULL),
(1728, 973.00, 'Random Game', 'GAME-304', 'User-280', '09c78298-a947-4c85-9be9-52c901175d86', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:21:07', NULL, NULL, 0, NULL, NULL),
(1729, 67.00, 'Random Game', 'GAME-875', 'User-347', 'cd801c4c-bc35-4f2a-9933-3f452d98b483', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:21:07', NULL, NULL, 0, NULL, NULL),
(1730, 612.00, 'Random Game', 'GAME-589', 'User-750', 'd78396cd-4621-480c-819f-4b9abd7f313c', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:22:07', NULL, NULL, 0, NULL, NULL),
(1731, 949.00, 'Random Game', 'GAME-577', 'User-704', 'd059acd0-6e42-47d4-a49b-2787064085b2', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:22:07', NULL, NULL, 0, NULL, NULL),
(1732, 552.00, 'Random Game', 'GAME-677', 'User-189', 'd1a2bbdb-d2c9-4641-bcdd-3610c850a00a', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:23:07', NULL, NULL, 0, NULL, NULL),
(1733, 468.00, 'Random Game', 'GAME-279', 'User-488', 'c7fd84b7-f4b5-4d14-a577-e700f902f24b', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:23:07', NULL, NULL, 0, NULL, NULL),
(1734, 542.00, 'Random Game', 'GAME-539', 'User-373', 'c91d3281-b7e7-4f71-ac93-639e47df414e', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:24:07', NULL, NULL, 0, NULL, NULL),
(1735, 392.00, 'Random Game', 'GAME-880', 'User-648', '13882a97-da02-4682-bb89-600526af164a', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:24:07', NULL, NULL, 0, NULL, NULL),
(1736, 737.00, 'Random Game', 'GAME-10', 'User-312', '81a2d3e5-9026-4fe4-9834-b759b97db844', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:25:07', NULL, NULL, 0, NULL, NULL),
(1737, 306.00, 'Random Game', 'GAME-965', 'User-179', '8121f398-aea4-4008-9e24-10645cd6717d', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:25:07', NULL, NULL, 0, NULL, NULL),
(1738, 882.00, 'Random Game', 'GAME-990', 'User-798', '1a99cde4-cb16-4750-a688-108aaa0bd03a', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:26:07', NULL, NULL, 0, NULL, NULL),
(1739, 937.00, 'Random Game', 'GAME-619', 'User-924', '211894df-adaf-48d0-bbb2-640cfcbb3cb1', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:26:07', NULL, NULL, 0, NULL, NULL),
(1740, 904.00, 'Random Game', 'GAME-619', 'User-467', '5e3fc0b2-d317-4cc2-8cfd-a774e7132ae0', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:27:07', NULL, NULL, 0, NULL, NULL),
(1741, 1041.00, 'Random Game', 'GAME-963', 'User-732', '457a6f75-e88c-4da9-9dcf-33da997958b8', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:27:07', NULL, NULL, 0, NULL, NULL),
(1742, 81.00, 'Random Game', 'GAME-750', 'User-462', '91e1b6a1-dc25-4054-8326-142d2a69758b', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:28:07', NULL, NULL, 0, NULL, NULL),
(1743, 657.00, 'Random Game', 'GAME-309', 'User-454', '222f9111-f1a8-41a7-82fb-f06c1229034b', 19, 'pending_validation', NULL, NULL, '2025-04-09 11:28:07', NULL, NULL, 0, NULL, NULL),
(1744, 140.00, 'Random Game', 'GAME-336', 'User-472', '20c2ee67-5759-4cf9-9f79-eb43c60bbdbf', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:23:55', NULL, NULL, 0, NULL, NULL),
(1745, 92.00, 'Random Game', 'GAME-76', 'User-50', '1f260159-7a75-435b-8ad8-c168267f6c9d', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:23:55', NULL, NULL, 0, NULL, NULL),
(1746, 116.00, 'Random Game', 'GAME-160', 'User-826', '4771c601-9ff5-45f1-819c-2bc399a5d1d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:24:15', NULL, NULL, 0, NULL, NULL),
(1747, 453.00, 'Random Game', 'GAME-704', 'User-142', '2e191817-1f14-44f9-8241-4a90be29a269', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:24:15', NULL, NULL, 0, NULL, NULL),
(1748, 1036.00, 'Random Game', 'GAME-123', 'User-874', '087912bd-57bb-4764-91e6-374649874f7f', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:24:35', NULL, NULL, 0, NULL, NULL),
(1749, 895.00, 'Random Game', 'GAME-605', 'User-308', '3ac4dcdc-1a02-4c4d-aaac-c183a396535d', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:24:35', NULL, NULL, 0, NULL, NULL),
(1750, 605.00, 'Random Game', 'GAME-379', 'User-88', '17c942cb-2e39-458c-9f64-051ba96b151e', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:24:55', NULL, NULL, 0, NULL, NULL),
(1751, 559.00, 'Random Game', 'GAME-591', 'User-532', '4876fecf-01cd-46b6-acc5-09308432f250', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:24:55', NULL, NULL, 0, NULL, NULL),
(1752, 516.00, 'Random Game', 'GAME-344', 'User-5', 'd69986c7-44fd-4ecf-816a-f2ffd27efdbd', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:25:15', NULL, NULL, 0, NULL, NULL),
(1753, 729.00, 'Random Game', 'GAME-355', 'User-561', 'a9341aeb-e7ae-431a-a3b9-f3cd763da8be', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:25:15', NULL, NULL, 0, NULL, NULL),
(1754, 967.00, 'Random Game', 'GAME-818', 'User-769', '4311aecd-d5c2-4f8d-a897-03e3927e49eb', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:25:35', NULL, NULL, 0, NULL, NULL),
(1755, 196.00, 'Random Game', 'GAME-985', 'User-472', '21773fd1-c9da-4c0a-b4ed-c604dc0c9d6a', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:25:35', NULL, NULL, 0, NULL, NULL),
(1756, 195.00, 'Random Game', 'GAME-542', 'User-870', '34228115-aad2-4b3e-87d3-43f81bd4c20b', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:25:55', NULL, NULL, 0, NULL, NULL),
(1757, 1018.00, 'Random Game', 'GAME-290', 'User-77', '0bba1b63-48f8-4acf-b6ca-508513d01141', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:25:55', NULL, NULL, 0, NULL, NULL),
(1758, 546.00, 'Random Game', 'GAME-930', 'User-633', '535f031a-b822-4367-a220-ad642ad8d1dc', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:26:15', NULL, NULL, 0, NULL, NULL),
(1759, 682.00, 'Random Game', 'GAME-873', 'User-557', '7a5f3291-346e-49f2-98dd-ce90ef64a9cb', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:26:15', NULL, NULL, 0, NULL, NULL),
(1760, 900.00, 'Random Game', 'GAME-688', 'User-540', 'c9541af1-8dfb-425f-8b83-6af30a94efc5', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:26:35', NULL, NULL, 0, NULL, NULL),
(1761, 51.00, 'Random Game', 'GAME-39', 'User-877', 'f5f58de6-edc4-4ed0-82d0-04aa24383d9e', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:26:35', NULL, NULL, 0, NULL, NULL),
(1762, 559.00, 'Random Game', 'GAME-315', 'User-915', '85b1281d-f264-43c7-8de4-3ba1d7d09c6d', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:26:55', NULL, NULL, 0, NULL, NULL),
(1763, 928.00, 'Random Game', 'GAME-443', 'User-136', 'a8e51856-9e95-4f94-913e-16ad9f2f3ccf', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:26:55', NULL, NULL, 0, NULL, NULL),
(1764, 349.00, 'Random Game', 'GAME-465', 'User-629', '674e84eb-3f3e-420f-a6db-2ca2ccff6729', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:27:15', NULL, NULL, 0, NULL, NULL),
(1765, 354.00, 'Random Game', 'GAME-115', 'User-386', '16d9f236-a46d-4c13-91d1-0be2d3c1eb48', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:27:15', NULL, NULL, 0, NULL, NULL),
(1766, 918.00, 'Random Game', 'GAME-615', 'User-596', '58c4d542-a14c-49ef-9e4d-6832808d610c', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:27:35', NULL, NULL, 0, NULL, NULL),
(1767, 687.00, 'Random Game', 'GAME-138', 'User-679', '56fbe4ee-94ed-47ac-9566-aac887ebd78e', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:27:35', NULL, NULL, 0, NULL, NULL),
(1768, 911.00, 'Random Game', 'GAME-372', 'User-62', '1641b035-269d-42d0-a07a-07ebeb3afff8', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:27:55', NULL, NULL, 0, NULL, NULL),
(1769, 587.00, 'Random Game', 'GAME-72', 'User-837', '0eafea1e-d89e-41af-9b8c-305b7a3a7566', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:27:55', NULL, NULL, 0, NULL, NULL),
(1770, 756.00, 'Random Game', 'GAME-582', 'User-53', '8aa31e0b-05ad-4a8a-ab03-1b425dfcc769', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:28:15', NULL, NULL, 0, NULL, NULL),
(1771, 897.00, 'Random Game', 'GAME-301', 'User-963', 'a963acc9-4305-453b-a43e-ac8877e51e05', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:28:15', NULL, NULL, 0, NULL, NULL),
(1772, 854.00, 'Random Game', 'GAME-777', 'User-30', '37937501-050b-4308-8d9a-7fe9ac0670d0', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:28:35', NULL, NULL, 0, NULL, NULL),
(1773, 65.00, 'Random Game', 'GAME-577', 'User-482', '3c48d1ce-bb84-4f0d-863a-c10abe541c3a', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:28:35', NULL, NULL, 0, NULL, NULL),
(1774, 359.00, 'Random Game', 'GAME-177', 'User-833', '2f4018e2-eb6c-42a3-8718-0d763e55db04', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:28:55', NULL, NULL, 0, NULL, NULL),
(1775, 207.00, 'Random Game', 'GAME-722', 'User-650', '1ff871d3-c699-435c-9b15-8d08a44c6099', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:28:55', NULL, NULL, 0, NULL, NULL),
(1776, 1023.00, 'Random Game', 'GAME-234', 'User-339', '33ed8bff-daa3-4483-9cdc-d6a166e4ffa7', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:29:15', NULL, NULL, 0, NULL, NULL),
(1777, 502.00, 'Random Game', 'GAME-799', 'User-26', 'b6785995-fa26-40ab-84f8-f3825c5b791a', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:29:15', NULL, NULL, 0, NULL, NULL),
(1778, 572.00, 'Random Game', 'GAME-216', 'User-9', '7f916f38-e1da-44e1-9b92-8908742811d8', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:29:35', NULL, NULL, 0, NULL, NULL),
(1779, 567.00, 'Random Game', 'GAME-466', 'User-114', 'ed22d01d-3d13-4888-bb40-6f55e3dc5197', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:29:35', NULL, NULL, 0, NULL, NULL),
(1780, 79.00, 'Random Game', 'GAME-479', 'User-682', '8169f9ff-3bd6-46a7-82b3-e5fd54901932', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:29:55', NULL, NULL, 0, NULL, NULL),
(1781, 715.00, 'Random Game', 'GAME-515', 'User-366', '7b1c78c3-9a77-419b-a01a-4262bde6c618', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:29:55', NULL, NULL, 0, NULL, NULL),
(1782, 669.00, 'Random Game', 'GAME-876', 'User-555', '5345f288-4155-4b52-a518-8c6b346ef630', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:30:15', NULL, NULL, 0, NULL, NULL),
(1783, 550.00, 'Random Game', 'GAME-17', 'User-758', 'f7e43c8d-dd84-4cc7-ba6e-12f32af5a249', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:30:15', NULL, NULL, 0, NULL, NULL),
(1784, 356.00, 'Random Game', 'GAME-210', 'User-251', '9eeb4ef0-f75e-49e6-a175-84cd24d3f61c', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:30:35', NULL, NULL, 0, NULL, NULL),
(1785, 123.00, 'Random Game', 'GAME-511', 'User-494', 'c82337cf-8203-4122-9edf-7f0fd9215ff6', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:30:35', NULL, NULL, 0, NULL, NULL),
(1786, 810.00, 'Random Game', 'GAME-298', 'User-405', '6d7b6316-11d9-4f58-a180-45776e423e02', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:30:55', NULL, NULL, 0, NULL, NULL),
(1787, 962.00, 'Random Game', 'GAME-998', 'User-619', 'e8770096-5983-4ebb-8fa3-333faefc088a', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:30:55', NULL, NULL, 0, NULL, NULL),
(1788, 506.00, 'Random Game', 'GAME-46', 'User-978', '45754d16-bef1-44a7-a314-939cf37a6713', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:32:07', NULL, NULL, 0, NULL, NULL),
(1789, 750.00, 'Random Game', 'GAME-925', 'User-414', 'de3c1b36-9a7a-4c01-ab23-f2f2f4bc792c', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:32:07', NULL, NULL, 0, NULL, NULL),
(1790, 581.00, 'Random Game', 'GAME-148', 'User-27', '5b8abdf6-1507-4dcb-80ac-9980bea55cf0', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:33:07', NULL, NULL, 0, NULL, NULL),
(1791, 353.00, 'Random Game', 'GAME-659', 'User-743', '8c364fc4-50ad-4871-ab55-87f8ae617b7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:33:07', NULL, NULL, 0, NULL, NULL),
(1792, 199.00, 'Random Game', 'GAME-230', 'User-805', '6a112525-9056-4e79-8dd0-85c04d9e5c77', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:34:07', NULL, NULL, 0, NULL, NULL),
(1793, 117.00, 'Random Game', 'GAME-565', 'User-954', '63c02c91-a2fc-4009-a1d1-00905f5597a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:34:07', NULL, NULL, 0, NULL, NULL),
(1794, 76.00, 'Random Game', 'GAME-955', 'User-252', 'ae67b470-443b-4f04-beee-fe90953a08f0', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:07', NULL, NULL, 0, NULL, NULL),
(1795, 547.00, 'Random Game', 'GAME-628', 'User-3', '52e926dc-9d26-4200-bd5c-ec0318cade49', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:07', NULL, NULL, 0, NULL, NULL),
(1796, 156.00, 'Random Game', 'GAME-193', 'User-853', '9163ee26-eb05-4fdf-9b44-1efe2b7ae284', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:16', NULL, NULL, 0, NULL, NULL),
(1797, 994.00, 'Random Game', 'GAME-964', 'User-953', 'be98fc5d-6d3c-43ec-a195-9e761bba2a5e', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:16', NULL, NULL, 0, NULL, NULL),
(1798, 80.00, 'Random Game', 'GAME-860', 'User-43', 'e617ee2c-aeb7-48a7-99ed-3f69d47b5b6f', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:21', NULL, NULL, 0, NULL, NULL),
(1799, 702.00, 'Random Game', 'GAME-790', 'User-596', '1e9f6ea4-bbdc-41f4-b9ee-fb49c03e1941', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:21', NULL, NULL, 0, NULL, NULL),
(1800, 916.00, 'Random Game', 'GAME-791', 'User-639', '68bb81e6-7186-4e57-b9ae-c51b9c142cb9', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:26', NULL, NULL, 0, NULL, NULL),
(1801, 582.00, 'Random Game', 'GAME-255', 'User-879', '77e5296f-bff3-4fec-856a-b1853236b2d4', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:26', NULL, NULL, 0, NULL, NULL),
(1802, 410.00, 'Random Game', 'GAME-38', 'User-317', 'd01d7332-fa24-461f-8142-eeaa40a61758', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:35:46', NULL, NULL, 0, NULL, NULL),
(1803, 552.00, 'Random Game', 'GAME-838', 'User-206', 'f9c27a5a-dd74-4038-9284-4214bf0626b6', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:36:06', NULL, NULL, 0, NULL, NULL),
(1804, 1013.00, 'Random Game', 'GAME-551', 'User-323', '0ed8c122-0347-4d95-b6e1-65e036e38b46', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:36:27', NULL, NULL, 0, NULL, NULL),
(1805, 220.00, 'Random Game', 'GAME-300', 'User-185', '97bfbecd-1d5c-43a3-a9a0-5a7c570fadb4', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:36:47', NULL, NULL, 0, NULL, NULL),
(1806, 490.00, 'Random Game', 'GAME-176', 'User-428', 'd14a186b-687c-4fcb-8e24-579ef433da53', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:37:07', NULL, NULL, 0, NULL, NULL),
(1807, 860.00, 'Random Game', 'GAME-127', 'User-501', '7a7d9f49-078d-4780-a86e-9fc392aabe76', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:38:07', NULL, NULL, 0, NULL, NULL),
(1808, 576.00, 'Random Game', 'GAME-534', 'User-690', 'c2687f8a-f28e-430f-99fb-03646bf62243', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:39:07', NULL, NULL, 0, NULL, NULL),
(1809, 437.00, 'Random Game', 'GAME-902', 'User-440', '578c1424-37bf-4259-adc8-0ae3005743d4', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:40:07', NULL, NULL, 0, NULL, NULL),
(1810, 288.00, 'Random Game', 'GAME-448', 'User-871', '24ca2727-60c6-4193-8b8a-aac4947d54ef', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:41:07', NULL, NULL, 0, NULL, NULL),
(1811, 290.00, 'Random Game', 'GAME-66', 'User-224', '7540f96e-a3d3-41bf-9f81-26ccf5d5ba56', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:42:07', NULL, NULL, 0, NULL, NULL),
(1812, 533.00, 'Random Game', 'GAME-827', 'User-422', '165b7e0c-9b8d-487c-b565-a0d37df4e28c', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:43:07', NULL, NULL, 0, NULL, NULL),
(1813, 464.00, 'Random Game', 'GAME-327', 'User-681', '4877f8af-e6eb-4362-870c-309780aae959', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:44:07', NULL, NULL, 0, NULL, NULL),
(1814, 957.00, 'Random Game', 'GAME-321', 'User-353', 'c1ce36a8-ac78-479c-b291-a5c1b60cbeb7', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:45:07', NULL, NULL, 0, NULL, NULL),
(1815, 137.00, 'Random Game', 'GAME-673', 'User-324', '10cc12c6-b213-443b-9f87-8c872a915b1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:46:07', NULL, NULL, 0, NULL, NULL),
(1816, 766.00, 'Random Game', 'GAME-531', 'User-436', '2c5ae570-02d8-4e25-82fa-19e2cba99b5b', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:47:07', NULL, NULL, 0, NULL, NULL),
(1817, 763.00, 'Random Game', 'GAME-506', 'User-597', '677b10a4-b77d-4f5e-b404-71eede89eb05', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:48:07', NULL, NULL, 0, NULL, NULL),
(1818, 601.00, 'Random Game', 'GAME-599', 'User-734', '1e9009bd-19f1-4e5b-9b8c-7c5231451cd2', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:49:07', NULL, NULL, 0, NULL, NULL),
(1819, 93.00, 'Random Game', 'GAME-75', 'User-456', '4aca721c-b5ab-45a4-b0ee-e3753fa01c5e', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:50:07', NULL, NULL, 0, NULL, NULL),
(1820, 730.00, 'Random Game', 'GAME-752', 'User-607', 'f22be061-5771-4e02-909d-fa546df3570b', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:51:07', NULL, NULL, 0, NULL, NULL),
(1821, 317.00, 'Random Game', 'GAME-631', 'User-602', '12306c48-883a-410f-91af-233e025f3851', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:52:07', NULL, NULL, 0, NULL, NULL),
(1822, 990.00, 'Random Game', 'GAME-744', 'User-805', '575b7e3a-de12-418e-9afa-4370678f9d99', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:53:07', NULL, NULL, 0, NULL, NULL),
(1823, 60.00, 'Random Game', 'GAME-62', 'User-73', 'b0d6e636-d8ff-4328-9e0c-f6ebc9d0a483', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:54:07', NULL, NULL, 0, NULL, NULL),
(1824, 551.00, 'Random Game', 'GAME-40', 'User-336', '6cfadd97-9dc4-4105-b788-910ccbbd85df', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:55:07', NULL, NULL, 0, NULL, NULL),
(1825, 783.00, 'Random Game', 'GAME-826', 'User-666', 'c0aa691a-4b52-48fe-a397-749b2af16712', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:56:07', NULL, NULL, 0, NULL, NULL),
(1826, 677.00, 'Random Game', 'GAME-648', 'User-647', '1a775665-d849-43e8-8f35-656a126894da', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:57:07', NULL, NULL, 0, NULL, NULL),
(1827, 467.00, 'Random Game', 'GAME-538', 'User-403', '673c8245-56cf-4e6f-bc39-86725fd0c485', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:58:07', NULL, NULL, 0, NULL, NULL),
(1828, 426.00, 'Random Game', 'GAME-918', 'User-208', 'f82b42a7-c4cf-47b6-9c47-f69c06ee3e4c', 19, 'pending_validation', NULL, NULL, '2025-04-09 15:59:07', NULL, NULL, 0, NULL, NULL),
(1829, 678.00, 'Random Game', 'GAME-306', 'User-843', '5288165c-a42a-49b7-8cd1-71dfea516b5b', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:00:07', NULL, NULL, 0, NULL, NULL),
(1830, 662.00, 'Random Game', 'GAME-505', 'User-477', '20b77a86-5d02-4731-9be8-6993541a9467', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:01:07', NULL, NULL, 0, NULL, NULL),
(1831, 588.00, 'Random Game', 'GAME-106', 'User-602', '0209e805-5107-4212-b077-16bfae52b225', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:02:07', NULL, NULL, 0, NULL, NULL),
(1832, 992.00, 'Random Game', 'GAME-345', 'User-605', 'ed1813b5-d43a-4b42-bb0e-9fbf2cdb87c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:03:07', NULL, NULL, 0, NULL, NULL),
(1833, 394.00, 'Random Game', 'GAME-818', 'User-596', '690745e4-4edd-4591-8713-83d5ba9eac34', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:04:07', NULL, NULL, 0, NULL, NULL),
(1834, 270.00, 'Random Game', 'GAME-145', 'User-486', 'ccaf7733-5c23-49ad-bc88-bfa8a3c654bd', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:05:07', NULL, NULL, 0, NULL, NULL),
(1835, 356.00, 'Random Game', 'GAME-769', 'User-76', '319b5313-7fc0-4bf3-8844-510eababde94', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:06:07', NULL, NULL, 0, NULL, NULL),
(1836, 574.00, 'Random Game', 'GAME-768', 'User-749', '2fba9b04-af5b-4290-8bd9-4e0d5ba9b376', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:07:07', NULL, NULL, 0, NULL, NULL),
(1837, 821.00, 'Random Game', 'GAME-666', 'User-275', '09cd5ab4-fe54-47c7-8440-7b2002ab5e60', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:08:07', NULL, NULL, 0, NULL, NULL),
(1838, 287.00, 'Random Game', 'GAME-776', 'User-444', 'f518a625-9dc0-450e-9e8a-bb6dfdc775cc', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:09:07', NULL, NULL, 0, NULL, NULL),
(1839, 192.00, 'Random Game', 'GAME-605', 'User-271', '01c47c51-c4c0-49e7-ba33-eb58e4735e87', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:10:07', NULL, NULL, 0, NULL, NULL),
(1840, 937.00, 'Random Game', 'GAME-221', 'User-710', '8783e27c-be93-4927-bec5-74da98b0789b', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:11:07', NULL, NULL, 0, NULL, NULL),
(1841, 663.00, 'Random Game', 'GAME-950', 'User-260', '31771491-42a7-403d-9ce1-5175ce90e405', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:12:07', NULL, NULL, 0, NULL, NULL),
(1842, 684.00, 'Random Game', 'GAME-344', 'User-953', 'f2389a53-ec40-40de-a76c-330eaa1c4de3', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:13:07', NULL, NULL, 0, NULL, NULL),
(1843, 55.00, 'Random Game', 'GAME-302', 'User-427', '0c414b82-4e8c-4439-ac07-6a1496947562', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:14:07', NULL, NULL, 0, NULL, NULL),
(1844, 114.00, 'Random Game', 'GAME-252', 'User-885', '537f4c7a-0301-4322-a8ac-986a0073c7eb', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:15:07', NULL, NULL, 0, NULL, NULL),
(1845, 235.00, 'Random Game', 'GAME-655', 'User-170', '620d2eec-dd36-41fc-ac76-5d8da69dd759', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:16:07', NULL, NULL, 0, NULL, NULL),
(1846, 509.00, 'Random Game', 'GAME-749', 'User-547', '84dee52b-e743-4c4e-8c62-68142021ebc1', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:17:07', NULL, NULL, 0, NULL, NULL),
(1847, 574.00, 'Random Game', 'GAME-264', 'User-245', 'd5c8c2a7-08c5-49bc-bc5a-869beaf968ef', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:18:07', NULL, NULL, 0, NULL, NULL),
(1848, 785.00, 'Random Game', 'GAME-797', 'User-816', 'e09541aa-242d-4260-afca-b07f891288d6', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:19:07', NULL, NULL, 0, NULL, NULL),
(1849, 985.00, 'Random Game', 'GAME-856', 'User-676', '9c9c9f9e-a09a-4cb1-8d35-fdccdba3a48e', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:20:07', NULL, NULL, 0, NULL, NULL),
(1850, 959.00, 'Random Game', 'GAME-246', 'User-584', 'fb1e1ba1-0ad8-4329-8a98-80621811bfc5', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:21:07', NULL, NULL, 0, NULL, NULL),
(1851, 83.00, 'Random Game', 'GAME-475', 'User-320', 'b52c83b5-4c31-494e-a124-945038b667b4', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:22:07', NULL, NULL, 0, NULL, NULL),
(1852, 54.00, 'Random Game', 'GAME-617', 'User-820', 'f2bdcaf8-5db2-4b16-accd-9688b2f332ba', 19, 'pending_validation', NULL, NULL, '2025-04-09 16:23:07', NULL, NULL, 0, NULL, NULL),
(1853, 667.00, 'Random Game', 'GAME-261', 'User-930', 'f8f9c266-3749-4513-a7f2-39bb30530871', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:56:13', NULL, NULL, 0, NULL, NULL),
(1854, 360.00, 'Random Game', 'GAME-611', 'User-182', '15cabfa5-6ec9-4a49-96c6-38b972a0e7bc', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:56:13', NULL, NULL, 0, NULL, NULL),
(1855, 612.00, 'Random Game', 'GAME-314', 'User-883', '6fb7d166-99ee-4beb-8658-27e962582b1c', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:56:33', NULL, NULL, 0, NULL, NULL),
(1856, 578.00, 'Random Game', 'GAME-546', 'User-520', '27462ff9-c0bc-4f55-ae2a-3a1f82628eaf', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:56:54', NULL, NULL, 0, NULL, NULL),
(1857, 631.00, 'Random Game', 'GAME-7', 'User-621', 'dfa21472-cfb1-4a86-b862-7a9ada2dd1e4', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:57:14', NULL, NULL, 0, NULL, NULL),
(1858, 586.00, 'Random Game', 'GAME-294', 'User-582', 'cbccee51-e62a-412f-9465-4f9cc4a732ce', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:57:34', NULL, NULL, 0, NULL, NULL),
(1859, 917.00, 'Random Game', 'GAME-725', 'User-686', '1925b736-669d-4930-8e85-8b9d4d25025c', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:57:53', NULL, NULL, 0, NULL, NULL),
(1860, 82.00, 'Random Game', 'GAME-509', 'User-519', '7d252c55-80f0-4ba4-a59a-259c138031a9', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:58:13', NULL, NULL, 0, NULL, NULL),
(1861, 658.00, 'Random Game', 'GAME-65', 'User-132', '15179d10-d491-4351-968c-ab8be4ba04c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:58:33', NULL, NULL, 0, NULL, NULL),
(1862, 466.00, 'Random Game', 'GAME-785', 'User-59', '028bcb09-86a6-472e-bafd-0f7999898341', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:58:53', NULL, NULL, 0, NULL, NULL),
(1863, 826.00, 'Random Game', 'GAME-843', 'User-921', '7a9e2083-6977-4bde-bc7e-1a796fcf549a', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:59:11', NULL, NULL, 0, NULL, NULL),
(1864, 683.00, 'Random Game', 'GAME-598', 'User-178', '9007e798-ee61-4960-8254-f9018ad16429', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:59:31', NULL, NULL, 0, NULL, NULL),
(1865, 631.00, 'Random Game', 'GAME-861', 'User-851', '0cd5aff0-da7c-4df0-96f0-fcb152121bc4', 19, 'pending_validation', NULL, NULL, '2025-04-09 17:59:51', NULL, NULL, 0, NULL, NULL),
(1866, 410.00, 'Random Game', 'GAME-897', 'User-189', 'ac0ff9e6-4344-4ec6-8bbf-6f7b163d16e7', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:00:11', NULL, NULL, 0, NULL, NULL),
(1867, 684.00, 'Random Game', 'GAME-34', 'User-494', '479dd375-583c-47e9-a294-8afece31159d', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:00:30', NULL, NULL, 0, NULL, NULL),
(1868, 259.00, 'Random Game', 'GAME-929', 'User-368', 'f69f83fb-0eed-409e-89d7-0f7528b4460d', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:00:50', NULL, NULL, 0, NULL, NULL),
(1869, 221.00, 'Random Game', 'GAME-220', 'User-941', 'b2ada5c2-5c77-477c-83be-9ba11d1a59b0', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:01:10', NULL, NULL, 0, NULL, NULL),
(1870, 120.00, 'Random Game', 'GAME-723', 'User-111', 'f4edb6bd-4b79-4fab-ac6e-578912bdc278', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:01:30', NULL, NULL, 0, NULL, NULL),
(1871, 512.00, 'Random Game', 'GAME-620', 'User-569', '19106938-a43a-4625-8f5f-9480789a751a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:01:51', NULL, NULL, 0, NULL, NULL),
(1872, 813.00, 'Random Game', 'GAME-458', 'User-52', '224aa149-e26c-4bda-881a-25670f2aefae', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:02:11', NULL, NULL, 0, NULL, NULL),
(1873, 439.00, 'Random Game', 'GAME-332', 'User-392', '26da4d79-157d-4b18-859d-f5d8a06ffcfe', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:02:31', NULL, NULL, 0, NULL, NULL),
(1874, 927.00, 'Random Game', 'GAME-876', 'User-62', '35252606-6271-4398-8adf-78383c1508f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:02:50', NULL, NULL, 0, NULL, NULL),
(1875, 756.00, 'Random Game', 'GAME-471', 'User-693', '9fdfb2fd-5d5f-442e-b6f0-c7d8d0b451f9', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:02:52', NULL, NULL, 0, NULL, NULL),
(1876, 441.00, 'Random Game', 'GAME-852', 'User-704', 'a081dcab-018c-4d7f-9b33-f42689df21d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:02:52', NULL, NULL, 0, NULL, NULL),
(1877, 319.00, 'Random Game', 'GAME-32', 'User-236', 'd0a20bc1-ea36-4f7e-a46f-a97422ad4589', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:02:53', NULL, NULL, 0, NULL, NULL),
(1878, 384.00, 'Random Game', 'GAME-175', 'User-863', 'd786812f-e546-4ac4-9e4e-ca15c4deaebe', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:02:53', NULL, NULL, 0, NULL, NULL),
(1879, 246.00, 'Random Game', 'GAME-164', 'User-52', '62398fcf-9900-4560-9556-db89dc230a8f', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:03:14', NULL, NULL, 0, NULL, NULL),
(1880, 1013.00, 'Random Game', 'GAME-162', 'User-616', '8b99b959-278b-4f53-9877-c061954a9ae6', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:03:33', NULL, NULL, 0, NULL, NULL),
(1881, 184.00, 'Random Game', 'GAME-595', 'User-221', '39d1539e-a052-4f48-9579-1d0b5a11a80e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:03:54', NULL, NULL, 0, NULL, NULL),
(1882, 555.00, 'Random Game', 'GAME-88', 'User-518', '81d6a316-f784-4ddb-8c5e-26af448263b3', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:04:14', NULL, NULL, 0, NULL, NULL),
(1883, 366.00, 'Random Game', 'GAME-818', 'User-914', '8234f545-9056-4316-aa76-677296842863', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:04:34', NULL, NULL, 0, NULL, NULL),
(1884, 174.00, 'Random Game', 'GAME-651', 'User-178', '242a0f36-9098-4e99-9f16-83df70ff6b6f', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:04:56', NULL, NULL, 0, NULL, NULL),
(1885, 955.00, 'Random Game', 'GAME-639', 'User-989', '99ef89cc-d635-4a46-aecd-6f422e6a2495', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:04:58', NULL, NULL, 0, NULL, NULL),
(1886, 211.00, 'Random Game', 'GAME-45', 'User-254', '4a9f89a0-8d0b-41f3-8a2e-ce24901fb6c0', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:04:58', NULL, NULL, 0, NULL, NULL),
(1887, 80.00, 'Random Game', 'GAME-182', 'User-982', 'c28775e7-12bc-431f-ba4f-ac4bfe8bc931', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:04:59', NULL, NULL, 0, NULL, NULL),
(1888, 151.00, 'Random Game', 'GAME-206', 'User-137', 'aeca7df3-52ea-4c67-aa84-6d2c7079d8f5', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:04:59', NULL, NULL, 0, NULL, NULL),
(1889, 204.00, 'Random Game', 'GAME-689', 'User-242', 'ba074f3d-dfcb-44fe-b732-fa83dd3c0d23', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:05:20', NULL, NULL, 0, NULL, NULL),
(1890, 602.00, 'Random Game', 'GAME-470', 'User-940', 'fd463b1c-d28b-4ef9-8fa6-24563696f494', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:05:40', NULL, NULL, 0, NULL, NULL),
(1891, 97.00, 'Random Game', 'GAME-202', 'User-154', 'e9d9302b-fe50-4b4b-8608-596dca751d8d', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:06:00', NULL, NULL, 0, NULL, NULL),
(1892, 678.00, 'Random Game', 'GAME-892', 'User-159', '2426f496-e83b-4e0c-a34a-bc4763846545', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:06:20', NULL, NULL, 0, NULL, NULL),
(1893, 675.00, 'Random Game', 'GAME-883', 'User-720', '89d4cc5a-4e17-46fa-b4d8-c8ceace449a1', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:07:07', NULL, NULL, 0, NULL, NULL),
(1894, 466.00, 'Random Game', 'GAME-295', 'User-255', '6c9a9c02-73fb-4598-813f-8b02e8efecf4', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:07:19', NULL, NULL, 0, NULL, NULL),
(1895, 958.00, 'Random Game', 'GAME-302', 'User-473', '4c5ae380-bcd4-4604-9baf-8e3408bdad4b', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:07:40', NULL, NULL, 0, NULL, NULL),
(1896, 786.00, 'Random Game', 'GAME-705', 'User-839', '919cdac2-bdd9-47d5-aa12-b0eb35faaaf1', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:08:00', NULL, NULL, 0, NULL, NULL),
(1897, 299.00, 'Random Game', 'GAME-766', 'User-521', 'f59ca765-4a6f-418a-8d17-a3f844c56987', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:08:20', NULL, NULL, 0, NULL, NULL),
(1898, 902.00, 'Random Game', 'GAME-505', 'User-525', 'c33a289f-00d6-41e9-9659-34e462ed2d68', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:09:07', NULL, NULL, 0, NULL, NULL),
(1899, 71.00, 'Random Game', 'GAME-953', 'User-46', '7817f25b-6a06-420c-aac1-c2e6adde2e8c', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:10:07', NULL, NULL, 0, NULL, NULL),
(1900, 567.00, 'Random Game', 'GAME-674', 'User-956', '4f194de4-be31-4abe-a7ba-f5d5146cf61e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:11:07', NULL, NULL, 0, NULL, NULL),
(1901, 74.00, 'Random Game', 'GAME-118', 'User-292', '36efcaec-7139-48c2-ab25-b949778719db', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:11:33', NULL, NULL, 0, NULL, NULL),
(1902, 672.00, 'Random Game', 'GAME-775', 'User-33', 'e8340d76-b5cc-44a6-a799-954c590491f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:11:35', NULL, NULL, 0, NULL, NULL),
(1903, 473.00, 'Random Game', 'GAME-941', 'User-583', '2600a5cf-426b-4aa5-aea7-3b40ef499b5a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:11:35', NULL, NULL, 0, NULL, NULL),
(1904, 274.00, 'Random Game', 'GAME-819', 'User-363', '2759d11c-74ec-4e3c-81f7-2f0e6d6829b8', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:11:36', NULL, NULL, 0, NULL, NULL),
(1905, 716.00, 'Random Game', 'GAME-575', 'User-662', 'dde037fc-1798-4685-917d-3c844c410369', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:11:36', NULL, NULL, 0, NULL, NULL),
(1906, 548.00, 'Random Game', 'GAME-345', 'User-262', '2624d585-0e5f-41e7-985e-d19f2f0d6b68', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:11:56', NULL, NULL, 0, NULL, NULL),
(1907, 365.00, 'Random Game', 'GAME-579', 'User-3', '1f362b5d-3d40-4a29-b2c9-9d6ef13aa2ba', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:12:16', NULL, NULL, 0, NULL, NULL),
(1908, 896.00, 'Random Game', 'GAME-184', 'User-427', 'cf648237-7abd-41cd-922e-6be9742db3da', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:12:36', NULL, NULL, 0, NULL, NULL),
(1909, 112.00, 'Random Game', 'GAME-766', 'User-695', '53832172-b854-4b8e-a037-5cc330ffeb78', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:12:56', NULL, NULL, 0, NULL, NULL),
(1910, 587.00, 'Random Game', 'GAME-941', 'User-57', 'a680f767-60f1-4b27-89e4-3c340ad7569a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:13:16', NULL, NULL, 0, NULL, NULL),
(1911, 178.00, 'Random Game', 'GAME-224', 'User-5', '53a99381-c2c1-4f93-84d7-95c25febc956', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:13:36', NULL, NULL, 0, NULL, NULL),
(1912, 923.00, 'Random Game', 'GAME-515', 'User-329', '0386ca9f-dd25-4f42-9e87-92b03d259e7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:13:56', NULL, NULL, 0, NULL, NULL),
(1913, 649.00, 'Random Game', 'GAME-561', 'User-533', 'cfd955fc-5131-46f4-bf42-808f10160198', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:14:16', NULL, NULL, 0, NULL, NULL),
(1914, 775.00, 'Random Game', 'GAME-148', 'User-366', 'eeefb40c-3332-4ac3-9555-a620a2e23744', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:14:31', NULL, NULL, 0, NULL, NULL),
(1915, 307.00, 'Random Game', 'GAME-699', 'User-323', '9edab739-086d-483f-b989-d0eb60fe7497', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:14:31', NULL, NULL, 0, NULL, NULL),
(1916, 868.00, 'Random Game', 'GAME-659', 'User-983', 'c4af6442-cf46-4c9f-94c0-7187d028859c', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:14:33', NULL, NULL, 0, NULL, NULL),
(1917, 359.00, 'Random Game', 'GAME-188', 'User-444', 'ec450519-21e1-4747-978a-56e0ed6c10c2', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:14:33', NULL, NULL, 0, NULL, NULL),
(1918, 708.00, 'Random Game', 'GAME-695', 'User-338', '3c7f7227-8f90-4a9d-b390-c615481793f2', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:14:53', NULL, NULL, 0, NULL, NULL),
(1919, 561.00, 'Random Game', 'GAME-946', 'User-126', '22ad6e20-e6a4-4e80-a567-55d4f85d8c4a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:15:13', NULL, NULL, 0, NULL, NULL),
(1920, 659.00, 'Random Game', 'GAME-616', 'User-580', '2a4ebc29-e13d-460e-a975-10c4068b9e65', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:15:15', NULL, NULL, 0, NULL, NULL),
(1921, 932.00, 'Random Game', 'GAME-754', 'User-84', '6ceba5bf-d1eb-4a5c-8986-cf6cdae64a18', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:15:15', NULL, NULL, 0, NULL, NULL),
(1922, 344.00, 'Random Game', 'GAME-519', 'User-508', 'f268416a-76ad-43ab-a6eb-ff415642276e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:15:16', NULL, NULL, 0, NULL, NULL),
(1923, 751.00, 'Random Game', 'GAME-894', 'User-203', '70c9d13b-85d2-4fc5-bac5-1c708e92b58d', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:15:16', NULL, NULL, 0, NULL, NULL),
(1924, 230.00, 'Random Game', 'GAME-751', 'User-663', '160d3c59-72a3-40f7-8309-568df1d4ba23', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:15:36', NULL, NULL, 0, NULL, NULL),
(1925, 908.00, 'Random Game', 'GAME-299', 'User-361', '6b94fd82-a506-48db-be26-0b525a36a2e5', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:15:57', NULL, NULL, 0, NULL, NULL),
(1926, 535.00, 'Random Game', 'GAME-527', 'User-183', '5deced58-3843-4d0e-9072-e91eb39b1f31', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:16:04', NULL, NULL, 0, NULL, NULL),
(1927, 899.00, 'Random Game', 'GAME-850', 'User-160', 'e6d728a4-f2b2-47af-991e-f907fcf55ec9', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:16:04', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(1928, 961.00, 'Random Game', 'GAME-910', 'User-684', 'a4262f45-0d71-4e0d-933c-1ba807fd7589', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:16:06', NULL, NULL, 0, NULL, NULL),
(1929, 341.00, 'Random Game', 'GAME-441', 'User-186', 'ccbe3bf3-5ee8-4fcb-887b-6ec1ce89ca43', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:16:06', NULL, NULL, 0, NULL, NULL),
(1930, 525.00, 'Random Game', 'GAME-556', 'User-552', '02316876-f38f-4c2c-8131-f62aceaf34a2', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:16:27', NULL, NULL, 0, NULL, NULL),
(1931, 500.00, 'Random Game', 'GAME-730', 'User-935', '105b0868-6b8d-43f4-aebd-5d3f313d53a9', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:16:47', NULL, NULL, 0, NULL, NULL),
(1932, 110.00, 'Random Game', 'GAME-657', 'User-481', '135edbcb-deb0-4182-b02e-cde9dd6647c1', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:17:07', NULL, NULL, 0, NULL, NULL),
(1933, 54.00, 'Random Game', 'GAME-748', 'User-502', '2364cda6-2121-41f5-b6b2-bbd6b7160062', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:17:27', NULL, NULL, 0, NULL, NULL),
(1934, 408.00, 'Random Game', 'GAME-562', 'User-365', 'cd833136-0582-4127-ac4f-bd0715a068d1', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:18:07', NULL, NULL, 0, NULL, NULL),
(1935, 103.00, 'Random Game', 'GAME-327', 'User-148', '3a00363f-b84a-45fc-b7d2-cc90799dbe70', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:19:07', NULL, NULL, 0, NULL, NULL),
(1936, 697.00, 'Random Game', 'GAME-971', 'User-570', '87e3b5c8-2ed1-4e7a-a350-a69067a91765', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:20:07', NULL, NULL, 0, NULL, NULL),
(1937, 283.00, 'Random Game', 'GAME-687', 'User-876', 'c333244f-0cd0-4452-a517-e1aad4492f25', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:21:07', NULL, NULL, 0, NULL, NULL),
(1938, 789.00, 'Random Game', 'GAME-413', 'User-63', '53af5693-ea8a-497f-a59c-03bc9bd449f0', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:22:07', NULL, NULL, 0, NULL, NULL),
(1939, 915.00, 'Random Game', 'GAME-717', 'User-197', 'd8d7e7e9-5712-4138-8b13-27fa3edd97da', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:23:07', NULL, NULL, 0, NULL, NULL),
(1940, 767.00, 'Random Game', 'GAME-182', 'User-30', '2719453c-b775-4374-9427-e0d829ddaa8e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:24:07', NULL, NULL, 0, NULL, NULL),
(1941, 267.00, 'Random Game', 'GAME-717', 'User-740', 'bc0bb16f-fb6d-48d7-b196-821cec440b7a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:25:07', NULL, NULL, 0, NULL, NULL),
(1942, 115.00, 'Random Game', 'GAME-732', 'User-913', '07b1fe59-6ead-4b6d-8f64-9523008b7731', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:25:26', NULL, NULL, 0, NULL, NULL),
(1943, 922.00, 'Random Game', 'GAME-273', 'User-37', '4dc713b0-2b6a-46eb-afd6-cb508b113f3e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:25:47', NULL, NULL, 0, NULL, NULL),
(1944, 911.00, 'Random Game', 'GAME-497', 'User-948', 'c29e724d-09c3-439a-8b51-5e76a99b58aa', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:26:07', NULL, NULL, 0, NULL, NULL),
(1945, 188.00, 'Random Game', 'GAME-892', 'User-705', '1620e7e1-363a-42c0-9d52-19088dfe6bbb', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:26:27', NULL, NULL, 0, NULL, NULL),
(1946, 181.00, 'Random Game', 'GAME-637', 'User-928', 'd427ea11-63c1-4573-bcfa-7237e76efaed', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:26:46', NULL, NULL, 0, NULL, NULL),
(1947, 648.00, 'Random Game', 'GAME-472', 'User-29', '3c671447-714c-4670-8b74-c21f8d3370ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:27:06', NULL, NULL, 0, NULL, NULL),
(1948, 818.00, 'Random Game', 'GAME-586', 'User-132', '031845b9-03aa-495a-b019-f94ed6f7a34b', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:27:26', NULL, NULL, 0, NULL, NULL),
(1949, 750.00, 'Random Game', 'GAME-599', 'User-897', '56c42815-b6c7-4ece-baa8-41d36fe3e437', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:27:46', NULL, NULL, 0, NULL, NULL),
(1950, 984.00, 'Random Game', 'GAME-134', 'User-351', '3e0fe52a-4985-4ea2-b3b3-75629546e43c', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:28:06', NULL, NULL, 0, NULL, NULL),
(1951, 680.00, 'Random Game', 'GAME-146', 'User-968', 'acd10511-a0e0-4bd2-a34d-50c05c4559db', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:28:26', NULL, NULL, 0, NULL, NULL),
(1952, 1036.00, 'Random Game', 'GAME-806', 'User-766', '681b77cf-a3c4-4136-9d9b-5d8efc2b9d29', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:28:41', NULL, NULL, 0, NULL, NULL),
(1953, 620.00, 'Random Game', 'GAME-675', 'User-810', '75ee3697-6826-4020-929d-6104d77dc111', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:29:01', NULL, NULL, 0, NULL, NULL),
(1954, 434.00, 'Random Game', 'GAME-263', 'User-142', 'f43589f8-c4ab-471b-aff1-602ae0ebb1b4', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:29:21', NULL, NULL, 0, NULL, NULL),
(1955, 620.00, 'Random Game', 'GAME-192', 'User-46', '730b58b2-e133-4ba4-9d70-aaef0c77772a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:29:41', NULL, NULL, 0, NULL, NULL),
(1956, 813.00, 'Random Game', 'GAME-607', 'User-367', '29bb608b-4caf-4da0-8a7a-4397aad76c2f', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:30:01', NULL, NULL, 0, NULL, NULL),
(1957, 961.00, 'Random Game', 'GAME-519', 'User-6', 'aca96758-cdc8-4511-a2ae-9a6cbde1fd3d', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:30:21', NULL, NULL, 0, NULL, NULL),
(1958, 222.00, 'Random Game', 'GAME-763', 'User-759', 'bdce797c-5fd7-46f1-9370-b9c17265de61', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:30:41', NULL, NULL, 0, NULL, NULL),
(1959, 1001.00, 'Random Game', 'GAME-132', 'User-953', 'e175512f-5c30-46c8-9d55-d55fc2253db6', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:30:41', NULL, NULL, 0, NULL, NULL),
(1960, 64.00, 'Random Game', 'GAME-455', 'User-183', 'f2d1466e-0142-43f8-8ac4-d7a52c21cf57', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:30:42', NULL, NULL, 0, NULL, NULL),
(1961, 78.00, 'Random Game', 'GAME-97', 'User-655', 'c58eab45-da7b-4a01-a16f-622a0ea928e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:30:42', NULL, NULL, 0, NULL, NULL),
(1962, 1048.00, 'Random Game', 'GAME-307', 'User-285', '83078e97-0f07-49b5-9300-e503953b27e3', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:31:02', NULL, NULL, 0, NULL, NULL),
(1963, 237.00, 'Random Game', 'GAME-765', 'User-577', '00ccc132-1ee2-4bb8-9140-9841e666ce5b', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:31:22', NULL, NULL, 0, NULL, NULL),
(1964, 331.00, 'Random Game', 'GAME-222', 'User-809', '87349fe6-7dd2-4de3-8840-7bac63229050', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:31:42', NULL, NULL, 0, NULL, NULL),
(1965, 96.00, 'Random Game', 'GAME-988', 'User-58', 'b304dce8-357a-4ac1-b72f-d98f9131e18f', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:31:42', NULL, NULL, 0, NULL, NULL),
(1966, 536.00, 'Random Game', 'GAME-952', 'User-970', '7fe43afb-c12d-48cf-9b14-97482b28156a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:31:42', NULL, NULL, 0, NULL, NULL),
(1967, 448.00, 'Random Game', 'GAME-325', 'User-83', '658ea4e8-f997-481d-8e7b-29a5cdd20698', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:31:43', NULL, NULL, 0, NULL, NULL),
(1968, 219.00, 'Random Game', 'GAME-136', 'User-899', 'c85d5924-cc15-4e96-8a59-ad1b3d0bd91b', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:31:43', NULL, NULL, 0, NULL, NULL),
(1969, 131.00, 'Random Game', 'GAME-184', 'User-594', 'd3f95564-7f9d-42ea-a41d-93cd89ad89aa', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:32:03', NULL, NULL, 0, NULL, NULL),
(1970, 755.00, 'Random Game', 'GAME-497', 'User-436', 'ca961199-4442-40c7-8b42-c96b6af498ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:32:23', NULL, NULL, 0, NULL, NULL),
(1971, 772.00, 'Random Game', 'GAME-207', 'User-21', '6f4dc9d1-9716-43a3-9e85-006aa7500df5', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:32:43', NULL, NULL, 0, NULL, NULL),
(1972, 224.00, 'Random Game', 'GAME-272', 'User-389', 'f85bf067-86d3-4a1a-88d6-de5ba93ac693', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:33:03', NULL, NULL, 0, NULL, NULL),
(1973, 1036.00, 'Random Game', 'GAME-60', 'User-96', '0d27bb0e-23c7-419f-afc7-e9973ef71200', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:33:23', NULL, NULL, 0, NULL, NULL),
(1974, 637.00, 'Random Game', 'GAME-157', 'User-144', '059e3c12-d799-4f50-b71d-fea4bbf14752', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:33:43', NULL, NULL, 0, NULL, NULL),
(1975, 269.00, 'Random Game', 'GAME-269', 'User-998', '333d075f-e9ee-4396-90ff-9f9ceccdd91e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:34:03', NULL, NULL, 0, NULL, NULL),
(1976, 208.00, 'Random Game', 'GAME-829', 'User-535', '8a681e0c-9420-4697-b17a-0d684bd98f42', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:34:23', NULL, NULL, 0, NULL, NULL),
(1977, 912.00, 'Random Game', 'GAME-241', 'User-83', '6c7b3eda-914a-48c6-bd19-634301649b3e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:34:43', NULL, NULL, 0, NULL, NULL),
(1978, 574.00, 'Random Game', 'GAME-73', 'User-259', '74023a44-5436-4c46-9716-15e6d51734b2', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:35:03', NULL, NULL, 0, NULL, NULL),
(1979, 683.00, 'Random Game', 'GAME-195', 'User-931', '05f89cc9-10a5-443d-8043-0ff3e6d1944c', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:35:23', NULL, NULL, 0, NULL, NULL),
(1980, 476.00, 'Random Game', 'GAME-903', 'User-813', '362d2ea8-39f1-4a5d-be27-692da7a31216', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:35:43', NULL, NULL, 0, NULL, NULL),
(1981, 124.00, 'Random Game', 'GAME-963', 'User-728', '01f66645-eb2b-4c26-af61-1f282dd85d76', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:36:03', NULL, NULL, 0, NULL, NULL),
(1982, 227.00, 'Random Game', 'GAME-622', 'User-338', 'a4523f6b-e24b-4564-a8ce-63678c78123d', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:36:23', NULL, NULL, 0, NULL, NULL),
(1983, 911.00, 'Random Game', 'GAME-673', 'User-723', 'fa7aab72-d036-4e1e-b9e9-c5e926db304c', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:36:43', NULL, NULL, 0, NULL, NULL),
(1984, 295.00, 'Random Game', 'GAME-478', 'User-215', '3b9b8f5e-1c66-43ce-b43f-e20ce0dbb39e', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:37:03', NULL, NULL, 0, NULL, NULL),
(1985, 725.00, 'Random Game', 'GAME-882', 'User-707', '176c694c-71ee-4382-8fcd-c0ad93e2566c', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:37:24', NULL, NULL, 0, NULL, NULL),
(1986, 103.00, 'Random Game', 'GAME-906', 'User-504', '8b2bf7b5-94a4-4b1a-905c-548cca18dba2', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:37:44', NULL, NULL, 0, NULL, NULL),
(1987, 298.00, 'Random Game', 'GAME-58', 'User-894', 'a6088e6e-ffb4-4e28-b064-374abac59ad4', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:38:04', NULL, NULL, 0, NULL, NULL),
(1988, 284.00, 'Random Game', 'GAME-97', 'User-502', '996c57f7-e76c-4d1b-bfcb-a505e8328aab', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:39:05', NULL, NULL, 0, NULL, NULL),
(1989, 836.00, 'Random Game', 'GAME-244', 'User-375', '7e9fc7e7-14f9-4fe3-988a-d24308b6e0f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:40:06', NULL, NULL, 0, NULL, NULL),
(1990, 708.00, 'Random Game', 'GAME-366', 'User-488', '66df0eef-b28f-4e52-bda1-58d2d62a02d6', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:40:35', NULL, NULL, 0, NULL, NULL),
(1991, 214.00, 'Random Game', 'GAME-368', 'User-319', '6c1efd29-75dd-42b8-acea-1ef684d4d26c', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:40:43', NULL, NULL, 0, NULL, NULL),
(1992, 1028.00, 'Random Game', 'GAME-443', 'User-844', 'bf61a33d-2db0-402a-99ca-5866246a2391', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:41:03', NULL, NULL, 0, NULL, NULL),
(1993, 321.00, 'Random Game', 'GAME-144', 'User-690', '59ce3a1c-b655-434c-a66f-d38d83c0daf8', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:41:23', NULL, NULL, 0, NULL, NULL),
(1994, 566.00, 'Random Game', 'GAME-621', 'User-570', 'c6153c44-267b-428b-a1cb-1442f4b94fd7', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:41:43', NULL, NULL, 0, NULL, NULL),
(1995, 567.00, 'Random Game', 'GAME-540', 'User-41', '3291dfdf-03bf-41f0-9767-4cd6400eba43', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:42:03', NULL, NULL, 0, NULL, NULL),
(1996, 286.00, 'Random Game', 'GAME-142', 'User-381', '6f6f1978-e08d-4502-a381-2c4bd4dda7df', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:42:23', NULL, NULL, 0, NULL, NULL),
(1997, 779.00, 'Random Game', 'GAME-773', 'User-297', 'd821eb24-18ad-4856-90b4-71b67eb921cb', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:42:43', NULL, NULL, 0, NULL, NULL),
(1998, 557.00, 'Random Game', 'GAME-942', 'User-473', '13400859-b5cf-4745-918d-d30c762e10c8', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:43:04', NULL, NULL, 0, NULL, NULL),
(1999, 483.00, 'Random Game', 'GAME-645', 'User-612', '98049edc-354e-4da7-87b5-e6fa36eed0de', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:43:24', NULL, NULL, 0, NULL, NULL),
(2000, 887.00, 'Random Game', 'GAME-680', 'User-345', '4a210993-a32e-4396-a9d2-c2028de26427', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:43:44', NULL, NULL, 0, NULL, NULL),
(2001, 109.00, 'Random Game', 'GAME-438', 'User-423', 'ce9e642a-0b46-4618-aded-83e24c4604c9', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:44:07', NULL, NULL, 0, NULL, NULL),
(2002, 277.00, 'Random Game', 'GAME-723', 'User-858', '05e98b22-8daa-4024-aff8-77f8a210586f', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:45:07', NULL, NULL, 0, NULL, NULL),
(2003, 628.00, 'Random Game', 'GAME-584', 'User-283', '469753e5-b798-479c-897b-1eef691dac8a', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:46:07', NULL, NULL, 0, NULL, NULL),
(2004, 796.00, 'Random Game', 'GAME-776', 'User-885', 'ebad5178-9e2a-44f1-900e-ce44b25bfbe7', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:46:32', NULL, NULL, 0, NULL, NULL),
(2005, 956.00, 'Random Game', 'GAME-166', 'User-205', '2ad5066f-28fd-4f6e-ace1-9015d47b8d8f', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:46:43', NULL, NULL, 0, NULL, NULL),
(2006, 979.00, 'Random Game', 'GAME-644', 'User-991', '594ed31d-06c6-4114-ace5-86fd925adef7', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:47:03', NULL, NULL, 0, NULL, NULL),
(2007, 645.00, 'Random Game', 'GAME-753', 'User-883', 'f7c5e683-9917-4442-b07d-940e9c4b903f', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:47:23', NULL, NULL, 0, NULL, NULL),
(2008, 339.00, 'Random Game', 'GAME-580', 'User-177', 'cc403f09-e4d5-496b-bd06-a52b12b911cb', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:47:44', NULL, NULL, 0, NULL, NULL),
(2009, 780.00, 'Random Game', 'GAME-989', 'User-528', 'd6d23a59-3be4-4b25-9797-cac4ea206084', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:48:04', NULL, NULL, 0, NULL, NULL),
(2010, 951.00, 'Random Game', 'GAME-378', 'User-921', '90b5f6d7-f30b-420e-ba1c-483537a238dd', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:48:24', NULL, NULL, 0, NULL, NULL),
(2011, 437.00, 'Random Game', 'GAME-513', 'User-945', '633f7fff-06ea-478a-bf5c-c7757393ebda', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:49:07', NULL, NULL, 0, NULL, NULL),
(2012, 859.00, 'Random Game', 'GAME-421', 'User-866', '1a324f4f-4a12-4e07-b4b1-7e7d66185194', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:52:07', NULL, NULL, 0, NULL, NULL),
(2013, 824.00, 'Random Game', 'GAME-591', 'User-362', '770ac127-9cca-4f38-8e10-a6fb93e14a43', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:53:07', NULL, NULL, 0, NULL, NULL),
(2014, 767.00, 'Random Game', 'GAME-521', 'User-834', '2a8e2e03-2f4c-4a81-aece-60dec7acbb66', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:54:07', NULL, NULL, 0, NULL, NULL),
(2015, 691.00, 'Random Game', 'GAME-97', 'User-121', 'f886f3ab-a5b9-4fe4-a928-7b930d237cdd', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:55:07', NULL, NULL, 0, NULL, NULL),
(2016, 577.00, 'Random Game', 'GAME-42', 'User-893', '49c4c4fa-b0de-4ff8-b08e-28c34f8838ab', 19, 'pending_validation', NULL, NULL, '2025-04-09 18:56:07', NULL, NULL, 0, NULL, NULL),
(2017, 660.00, 'Random Game', 'GAME-496', 'User-145', '46e6bf78-bacc-4251-b390-05306dc63c08', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:02:23', NULL, NULL, 0, NULL, NULL),
(2018, 785.00, 'Random Game', 'GAME-658', 'User-487', 'cba1108c-1238-48a8-a32b-57dc742e3cf2', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:02:23', NULL, NULL, 0, NULL, NULL),
(2019, 749.00, 'Random Game', 'GAME-742', 'User-33', '00dd82b4-a42f-4c66-8881-8401daea1796', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:02:43', NULL, NULL, 0, NULL, NULL),
(2020, 888.00, 'Random Game', 'GAME-594', 'User-802', '7ace5c83-b8e8-430e-af22-500b07e22226', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:03:03', NULL, NULL, 0, NULL, NULL),
(2021, 134.00, 'Random Game', 'GAME-391', 'User-215', '49612c9c-645a-4699-9a1d-854062447ef4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:03:23', NULL, NULL, 0, NULL, NULL),
(2022, 1034.00, 'Random Game', 'GAME-929', 'User-578', 'ee47ec5c-8a82-4b6b-a2e8-d728359e0cda', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:03:43', NULL, NULL, 0, NULL, NULL),
(2023, 656.00, 'Random Game', 'GAME-119', 'User-916', '6a3a3765-1457-4b33-9a7a-a781dda34b72', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:04:03', NULL, NULL, 0, NULL, NULL),
(2024, 540.00, 'Random Game', 'GAME-915', 'User-376', '9cca8db3-136f-42af-ba53-02066f604923', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:04:23', NULL, NULL, 0, NULL, NULL),
(2025, 594.00, 'Random Game', 'GAME-724', 'User-730', '8afb2500-e35d-4edd-b9a6-c7eb2b09d246', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:04:43', NULL, NULL, 0, NULL, NULL),
(2026, 838.00, 'Random Game', 'GAME-811', 'User-131', 'ef1c86c3-dbb6-49e6-83d6-5cc91fffed6d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:05:03', NULL, NULL, 0, NULL, NULL),
(2027, 132.00, 'Random Game', 'GAME-123', 'User-47', '6a3034a8-6e3c-403a-bcd5-420f8ae359bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:05:23', NULL, NULL, 0, NULL, NULL),
(2028, 98.00, 'Random Game', 'GAME-328', 'User-379', '3aa30be5-1d1b-44e6-882b-1de2e973dcf0', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:05:44', NULL, NULL, 0, NULL, NULL),
(2029, 361.00, 'Random Game', 'GAME-290', 'User-945', '65a8d10b-42d5-4085-8097-6f53a497c9a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:06:04', NULL, NULL, 0, NULL, NULL),
(2030, 686.00, 'Random Game', 'GAME-395', 'User-942', 'c1707166-c30f-4631-9618-8e83dc1d4c49', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:06:24', NULL, NULL, 0, NULL, NULL),
(2031, 657.00, 'Random Game', 'GAME-852', 'User-701', 'fef588d6-0724-42fa-a819-e258508926b4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:07:07', NULL, NULL, 0, NULL, NULL),
(2032, 358.00, 'Random Game', 'GAME-34', 'User-635', '1ca77251-f4eb-4a4e-9163-ebf515f616e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:08:07', NULL, NULL, 0, NULL, NULL),
(2033, 414.00, 'Random Game', 'GAME-525', 'User-376', 'ed1bf0c1-85d9-49fe-aa26-f73874f7065a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:09:07', NULL, NULL, 0, NULL, NULL),
(2034, 850.00, 'Random Game', 'GAME-474', 'User-968', 'bb8a7dad-5f9c-47d2-a056-db69fe57a90c', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:09:31', NULL, NULL, 0, NULL, NULL),
(2035, 75.00, 'Random Game', 'GAME-918', 'User-429', '2a7fee4f-13a1-45ff-8f30-67140d1f7de5', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:09:43', NULL, NULL, 0, NULL, NULL),
(2036, 815.00, 'Random Game', 'GAME-695', 'User-299', '174be5f3-dd74-4758-8256-0c08e68fe5bf', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:10:03', NULL, NULL, 0, NULL, NULL),
(2037, 214.00, 'Random Game', 'GAME-164', 'User-227', '4b182939-39ae-4398-9191-0d6dce9a442c', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:10:23', NULL, NULL, 0, NULL, NULL),
(2038, 166.00, 'Random Game', 'GAME-850', 'User-211', 'e78bbf7b-c280-4356-b30b-969c57d9b2f7', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:10:43', NULL, NULL, 0, NULL, NULL),
(2039, 945.00, 'Random Game', 'GAME-960', 'User-582', 'aead2c8a-67d9-4c09-86e1-d559ff131682', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:11:03', NULL, NULL, 0, NULL, NULL),
(2040, 608.00, 'Random Game', 'GAME-912', 'User-448', '1cd868df-06ec-4d3b-a988-a68ef06817d4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:11:23', NULL, NULL, 0, NULL, NULL),
(2041, 469.00, 'Random Game', 'GAME-885', 'User-172', '1f38232b-c551-4435-b044-f5b1b1f5ac02', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:11:43', NULL, NULL, 0, NULL, NULL),
(2042, 781.00, 'Random Game', 'GAME-689', 'User-961', '7622c2e4-92cd-4264-b754-e5242c826ee6', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:12:03', NULL, NULL, 0, NULL, NULL),
(2043, 432.00, 'Random Game', 'GAME-10', 'User-165', '9a05bb88-0f0a-41f7-94f3-5699758a8f39', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:12:23', NULL, NULL, 0, NULL, NULL),
(2044, 732.00, 'Random Game', 'GAME-789', 'User-33', '0d644707-fa0e-4693-80cf-59abfbe1cb95', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:12:43', NULL, NULL, 0, NULL, NULL),
(2045, 143.00, 'Random Game', 'GAME-445', 'User-62', 'ddbc6752-87a8-4760-9030-f1e31cee30f0', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:13:03', NULL, NULL, 0, NULL, NULL),
(2046, 477.00, 'Random Game', 'GAME-376', 'User-932', '9f8c1cf3-c2c5-4c89-88e3-408307a33ae5', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:13:23', NULL, NULL, 0, NULL, NULL),
(2047, 797.00, 'Random Game', 'GAME-623', 'User-474', '28281ac6-99f7-4bc2-8886-a38fc8399cee', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:13:43', NULL, NULL, 0, NULL, NULL),
(2048, 177.00, 'Random Game', 'GAME-580', 'User-974', 'ddb7ebf5-aa83-4421-8349-8d8cd776d231', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:14:03', NULL, NULL, 0, NULL, NULL),
(2049, 890.00, 'Random Game', 'GAME-597', 'User-791', '4b4df568-1110-48fd-ba8a-6bb04709817a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:14:23', NULL, NULL, 0, NULL, NULL),
(2050, 515.00, 'Random Game', 'GAME-123', 'User-757', '1dbb2255-c012-4e6b-ba6d-84088d1d4e75', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:14:43', NULL, NULL, 0, NULL, NULL),
(2051, 610.00, 'Random Game', 'GAME-649', 'User-853', 'f3ca2ddc-9422-4f9d-b554-004216bd3c5a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:15:01', NULL, NULL, 0, NULL, NULL),
(2052, 688.00, 'Random Game', 'GAME-73', 'User-96', '14e807ae-bcaa-4911-9f9e-8592c2146a37', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:15:21', NULL, NULL, 0, NULL, NULL),
(2053, 64.00, 'Random Game', 'GAME-326', 'User-564', '6ddd78b2-90fc-4125-8feb-43b727b0b69b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:15:41', NULL, NULL, 0, NULL, NULL),
(2054, 488.00, 'Random Game', 'GAME-580', 'User-174', '2aebf967-0aba-4b69-863d-1009ec49a074', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:16:01', NULL, NULL, 0, NULL, NULL),
(2055, 554.00, 'Random Game', 'GAME-163', 'User-982', '12f73a9b-1c0d-48af-ab11-36ceba223f06', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:16:21', NULL, NULL, 0, NULL, NULL),
(2056, 957.00, 'Random Game', 'GAME-583', 'User-484', '01758ab4-6485-4700-8e09-95f50caa110d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:16:41', NULL, NULL, 0, NULL, NULL),
(2057, 209.00, 'Random Game', 'GAME-278', 'User-767', 'e80d8689-d614-4d9a-b8f4-0d35b6610548', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:17:01', NULL, NULL, 0, NULL, NULL),
(2058, 691.00, 'Random Game', 'GAME-478', 'User-587', 'ec840347-fd3a-4a17-a39b-1fad77b0c3dd', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:17:21', NULL, NULL, 0, NULL, NULL),
(2059, 358.00, 'Random Game', 'GAME-433', 'User-729', '68403703-273a-4bde-ae0a-5c66d0372078', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:17:41', NULL, NULL, 0, NULL, NULL),
(2060, 179.00, 'Random Game', 'GAME-79', 'User-366', '918e412f-7ab2-46ab-b07a-ebe43d01cec6', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:18:02', NULL, NULL, 0, NULL, NULL),
(2061, 230.00, 'Random Game', 'GAME-346', 'User-78', 'e79e249b-8780-4b53-b194-5dea26689244', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:18:22', NULL, NULL, 0, NULL, NULL),
(2062, 735.00, 'Random Game', 'GAME-971', 'User-910', '1a723efb-3be6-49d7-b24a-5c50376efc18', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:18:42', NULL, NULL, 0, NULL, NULL),
(2063, 537.00, 'Random Game', 'GAME-259', 'User-458', 'f81d202e-f37e-4dc1-910a-f0af478bcccc', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:19:07', NULL, NULL, 0, NULL, NULL),
(2064, 127.00, 'Random Game', 'GAME-908', 'User-424', '92c98d96-420a-43ee-af89-8c2de73dc4eb', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:20:07', NULL, NULL, 0, NULL, NULL),
(2065, 610.00, 'Random Game', 'GAME-142', 'User-575', '76bac394-4814-47af-877b-ef93b6624e40', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:21:07', NULL, NULL, 0, NULL, NULL),
(2066, 505.00, 'Random Game', 'GAME-375', 'User-522', '343245db-553a-4ce7-826c-f7b8c47a43a8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:21:38', NULL, NULL, 0, NULL, NULL),
(2067, 974.00, 'Random Game', 'GAME-964', 'User-100', '1e67c33b-c2f7-42e1-b282-352be2c04eb1', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:21:40', NULL, NULL, 0, NULL, NULL),
(2068, 54.00, 'Random Game', 'GAME-341', 'User-409', '59101c5b-b4da-4adc-b83e-2fd110c690c4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:21:40', NULL, NULL, 0, NULL, NULL),
(2069, 208.00, 'Random Game', 'GAME-671', 'User-44', '7900e9db-7206-4e99-82fa-3e609bfd1b05', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:21:43', NULL, NULL, 0, NULL, NULL),
(2070, 505.00, 'Random Game', 'GAME-184', 'User-675', '15e16e9a-3ace-460b-9067-5ecd7c2c9ced', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:21:43', NULL, NULL, 0, NULL, NULL),
(2071, 384.00, 'Random Game', 'GAME-848', 'User-254', '5041aab2-aa37-4555-a110-27fbf5c7aa90', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:22:04', NULL, NULL, 0, NULL, NULL),
(2072, 976.00, 'Random Game', 'GAME-550', 'User-523', '17a07b91-d971-4e95-8259-df1fc72ded07', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:22:24', NULL, NULL, 0, NULL, NULL),
(2073, 105.00, 'Random Game', 'GAME-525', 'User-191', 'd327374a-d58c-4beb-9591-7ac7bcbca62a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:22:44', NULL, NULL, 0, NULL, NULL),
(2074, 1018.00, 'Random Game', 'GAME-506', 'User-294', '8510c6ff-29fb-4b23-9245-318fcf382fac', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:23:04', NULL, NULL, 0, NULL, NULL),
(2075, 893.00, 'Random Game', 'GAME-477', 'User-862', '8bd9821c-71a0-4219-a94f-4db4ed1983ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:23:24', NULL, NULL, 0, NULL, NULL),
(2076, 707.00, 'Random Game', 'GAME-331', 'User-386', 'ae8cc984-24ec-410f-8667-21bc3fce6006', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:23:50', NULL, NULL, 0, NULL, NULL),
(2077, 900.00, 'Random Game', 'GAME-949', 'User-205', '26d45f05-14d4-4fbc-a151-e7e2b2235663', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:23:54', NULL, NULL, 0, NULL, NULL),
(2078, 1007.00, 'Random Game', 'GAME-461', 'User-879', 'bb2f89e8-5bc7-40a8-aca3-ba53efa5cac0', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:23:54', NULL, NULL, 0, NULL, NULL),
(2079, 882.00, 'Random Game', 'GAME-145', 'User-664', 'b453b282-fcb5-4a7f-81c3-eec5279a475f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:23:56', NULL, NULL, 0, NULL, NULL),
(2080, 760.00, 'Random Game', 'GAME-462', 'User-572', '8aecc901-426f-499c-93d3-4d53158f860d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:23:56', NULL, NULL, 0, NULL, NULL),
(2081, 71.00, 'Random Game', 'GAME-84', 'User-130', 'a8723e26-a600-4b67-8f0b-d2e99d342112', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:24:17', NULL, NULL, 0, NULL, NULL),
(2082, 1003.00, 'Random Game', 'GAME-19', 'User-466', 'f8f0da37-25f6-45f9-908a-463387144228', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:24:37', NULL, NULL, 0, NULL, NULL),
(2083, 230.00, 'Random Game', 'GAME-771', 'User-69', 'f1cad147-ab21-42cf-b5bb-b67f069e1df3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:24:57', NULL, NULL, 0, NULL, NULL),
(2084, 773.00, 'Random Game', 'GAME-424', 'User-883', '9c1a9316-7961-4509-a0fa-5a3711e2ef0c', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:25:17', NULL, NULL, 0, NULL, NULL),
(2085, 837.00, 'Random Game', 'GAME-939', 'User-222', '88916f6f-c161-40c3-ab82-852d6551f572', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:26:07', NULL, NULL, 0, NULL, NULL),
(2086, 889.00, 'Random Game', 'GAME-658', 'User-877', 'e2def871-db30-4953-8527-172e1556c153', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:26:18', NULL, NULL, 0, NULL, NULL),
(2087, 155.00, 'Random Game', 'GAME-209', 'User-411', '6470f5b2-cc41-4c19-93a6-33ef1c1d4479', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:26:36', NULL, NULL, 0, NULL, NULL),
(2088, 844.00, 'Random Game', 'GAME-182', 'User-972', '29c5ff09-79d5-477f-9197-a23fec35e179', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:26:56', NULL, NULL, 0, NULL, NULL),
(2089, 712.00, 'Random Game', 'GAME-221', 'User-33', '7a16911e-12f6-4526-a7c5-37fed30c1e5d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:27:16', NULL, NULL, 0, NULL, NULL),
(2090, 838.00, 'Random Game', 'GAME-601', 'User-208', '33e8d794-b81c-44da-a28e-d79811e76965', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:27:37', NULL, NULL, 0, NULL, NULL),
(2091, 499.00, 'Random Game', 'GAME-949', 'User-290', '356a6610-cbd1-4587-abf0-2fc494f682fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:27:57', NULL, NULL, 0, NULL, NULL),
(2092, 895.00, 'Random Game', 'GAME-788', 'User-579', '4f742c98-7e21-422c-b947-ff37a1feb9b9', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:28:17', NULL, NULL, 0, NULL, NULL),
(2093, 235.00, 'Random Game', 'GAME-838', 'User-706', 'ca14b79c-e98e-447a-a8c4-ec2490cac038', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:29:07', NULL, NULL, 0, NULL, NULL),
(2094, 1028.00, 'Random Game', 'GAME-928', 'User-781', '419653ff-6d8b-4ae3-84d5-abaee9954ae3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:30:07', NULL, NULL, 0, NULL, NULL),
(2095, 542.00, 'Random Game', 'GAME-690', 'User-144', 'beeed3c1-16d3-490a-b98f-6a7893fc5abb', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:31:07', NULL, NULL, 0, NULL, NULL),
(2096, 444.00, 'Random Game', 'GAME-198', 'User-107', '24e72c7c-f7b1-4481-9201-558a0a3957ff', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:31:39', NULL, NULL, 0, NULL, NULL),
(2097, 883.00, 'Random Game', 'GAME-288', 'User-482', '33d9025b-cbdb-48ed-8e97-7e3436fcb1ea', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:31:39', NULL, NULL, 0, NULL, NULL),
(2098, 490.00, 'Random Game', 'GAME-311', 'User-686', '023b2625-f9a6-4224-b888-5f938128b7c0', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:32:00', NULL, NULL, 0, NULL, NULL),
(2099, 502.00, 'Random Game', 'GAME-997', 'User-919', '01dd50d4-8df5-4d61-a63d-de61fc9b791f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:32:09', NULL, NULL, 0, NULL, NULL),
(2100, 201.00, 'Random Game', 'GAME-447', 'User-258', '88f68251-39e2-4a7c-814c-0b51188d3415', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:32:29', NULL, NULL, 0, NULL, NULL),
(2101, 420.00, 'Random Game', 'GAME-454', 'User-143', '90314c28-f893-44be-a95a-fddab2ff0757', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:32:49', NULL, NULL, 0, NULL, NULL),
(2102, 780.00, 'Random Game', 'GAME-816', 'User-356', '59a2227d-7eac-4ae3-86fc-7cf26916d3ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:33:09', NULL, NULL, 0, NULL, NULL),
(2103, 179.00, 'Random Game', 'GAME-847', 'User-86', '70c896b6-4b8e-40b9-b5eb-0e897b2ea3a3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:33:12', NULL, NULL, 0, NULL, NULL),
(2104, 818.00, 'Random Game', 'GAME-607', 'User-760', 'dce7a1fe-1198-41cf-bac9-e6789f4b08b3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:33:30', NULL, NULL, 0, NULL, NULL),
(2105, 447.00, 'Random Game', 'GAME-54', 'User-968', '1c5dc338-2450-4687-a342-3a6e37a1c325', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:33:52', NULL, NULL, 0, NULL, NULL),
(2106, 438.00, 'Random Game', 'GAME-944', 'User-661', '63776353-d286-4988-ae16-1cc750dfd250', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:33:52', NULL, NULL, 0, NULL, NULL),
(2107, 239.00, 'Random Game', 'GAME-220', 'User-658', '9c1c1ac6-6c95-46d4-a2fd-d50eb12f4c69', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:34:02', NULL, NULL, 0, NULL, NULL),
(2108, 437.00, 'Random Game', 'GAME-815', 'User-847', '07ea819c-0e47-437a-a860-b87d97b343e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:34:02', NULL, NULL, 0, NULL, NULL),
(2109, 575.00, 'Random Game', 'GAME-914', 'User-752', '1ac17aa4-2c9c-48fd-9810-819748d96da8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:34:22', NULL, NULL, 0, NULL, NULL),
(2110, 435.00, 'Random Game', 'GAME-14', 'User-302', 'a90ddb28-5914-4f32-9d9e-d6a73c23e8c7', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:34:42', NULL, NULL, 0, NULL, NULL),
(2111, 349.00, 'Random Game', 'GAME-295', 'User-926', '6fe95f14-4352-47a4-ac1f-1177baf120d3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:35:02', NULL, NULL, 0, NULL, NULL),
(2112, 437.00, 'Random Game', 'GAME-372', 'User-860', '8333c93e-38f0-43ca-a1bf-f2a2469f61c4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:35:22', NULL, NULL, 0, NULL, NULL),
(2113, 243.00, 'Random Game', 'GAME-754', 'User-557', '5571c8f3-721e-43ad-9fa9-20b4fc1e9e33', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:35:33', NULL, NULL, 0, NULL, NULL),
(2114, 245.00, 'Random Game', 'GAME-383', 'User-468', 'd335ec2e-3d8f-4be4-b2af-c550b91a1464', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:35:33', NULL, NULL, 0, NULL, NULL),
(2115, 934.00, 'Random Game', 'GAME-309', 'User-189', '7a55122d-e0dc-402a-807e-28a6b67df6ed', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:35:34', NULL, NULL, 0, NULL, NULL),
(2116, 357.00, 'Random Game', 'GAME-510', 'User-436', '21f28b75-a4a5-43b9-b8f6-e2e0d1d43a9b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:35:34', NULL, NULL, 0, NULL, NULL),
(2117, 70.00, 'Random Game', 'GAME-216', 'User-505', 'd423ed0d-2cab-49dc-a913-de21f02bc843', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:35:54', NULL, NULL, 0, NULL, NULL),
(2118, 513.00, 'Random Game', 'GAME-934', 'User-966', '511941ed-510d-4c3e-ac2f-50166dd64542', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:36:14', NULL, NULL, 0, NULL, NULL),
(2119, 271.00, 'Random Game', 'GAME-212', 'User-162', '1f6620b7-d0a0-4123-adcc-e65ed0b31280', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:36:20', NULL, NULL, 0, NULL, NULL),
(2120, 1025.00, 'Random Game', 'GAME-530', 'User-639', '5c1cdc43-74f7-461a-ac8d-9c31ae85f5a2', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:36:20', NULL, NULL, 0, NULL, NULL),
(2121, 686.00, 'Random Game', 'GAME-782', 'User-143', '9ec1aae7-ee8e-405d-84aa-c1cc5d3ffe86', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:36:40', NULL, NULL, 0, NULL, NULL),
(2122, 839.00, 'Random Game', 'GAME-816', 'User-201', 'bf7ac004-c7bb-4c83-92f1-09af6a9a4300', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:37:00', NULL, NULL, 0, NULL, NULL),
(2123, 914.00, 'Random Game', 'GAME-453', 'User-495', '5a6925d1-cc8c-4fab-85e6-ffa2a175c69a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:37:20', NULL, NULL, 0, NULL, NULL),
(2124, 842.00, 'Random Game', 'GAME-183', 'User-862', '67c08111-2c71-4f51-9e4a-4fd22e0ae924', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:37:33', NULL, NULL, 0, NULL, NULL),
(2125, 381.00, 'Random Game', 'GAME-945', 'User-501', 'e9c7afac-6b34-474f-9ba4-33dace41e48d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:37:53', NULL, NULL, 0, NULL, NULL),
(2126, 961.00, 'Random Game', 'GAME-898', 'User-824', '738e7f3f-4037-4daa-89ef-ba76adef4c7b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:38:13', NULL, NULL, 0, NULL, NULL),
(2127, 173.00, 'Random Game', 'GAME-90', 'User-207', '39218f2c-c34c-4b28-9048-6af3511c9649', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:38:33', NULL, NULL, 0, NULL, NULL),
(2128, 895.00, 'Random Game', 'GAME-755', 'User-300', 'e2a474cf-3f8a-44d6-a72b-aa7847b2a391', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:38:53', NULL, NULL, 0, NULL, NULL),
(2129, 814.00, 'Random Game', 'GAME-98', 'User-359', '962b0bac-0da0-4130-a554-76a697dbfdde', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:39:02', NULL, NULL, 0, NULL, NULL),
(2130, 557.00, 'Random Game', 'GAME-596', 'User-21', '2ad21f3a-6f97-4b3e-b34b-8479eaa56583', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:39:02', NULL, NULL, 0, NULL, NULL),
(2131, 975.00, 'Random Game', 'GAME-55', 'User-811', '61c97d22-1c63-42a1-ae9c-8101df3681e8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:39:03', NULL, NULL, 0, NULL, NULL),
(2132, 432.00, 'Random Game', 'GAME-676', 'User-781', '060067be-bac6-4918-8b07-9a3d8c929f64', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:39:03', NULL, NULL, 0, NULL, NULL),
(2133, 216.00, 'Random Game', 'GAME-55', 'User-930', 'a89ac1d4-9550-425f-a8e1-81f42121fce8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:39:23', NULL, NULL, 0, NULL, NULL),
(2134, 250.00, 'Random Game', 'GAME-887', 'User-953', 'ed69bfde-e4d7-46bd-9c98-50ff203fa077', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:39:43', NULL, NULL, 0, NULL, NULL),
(2135, 661.00, 'Random Game', 'GAME-129', 'User-28', '9624d8e0-d1bf-4856-83af-69f6f016115f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:03', NULL, NULL, 0, NULL, NULL),
(2136, 695.00, 'Random Game', 'GAME-626', 'User-961', '6a882b97-fa51-4f28-af42-a88e27c1fb8e', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:12', NULL, NULL, 0, NULL, NULL),
(2137, 1024.00, 'Random Game', 'GAME-163', 'User-886', '6f9b3ff4-3542-4357-9844-f7a95673144b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:12', NULL, NULL, 0, NULL, NULL),
(2138, 531.00, 'Random Game', 'GAME-294', 'User-788', '8921773c-27c4-4b82-ac8e-0a8f0d20b81b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:13', NULL, NULL, 0, NULL, NULL),
(2139, 864.00, 'Random Game', 'GAME-777', 'User-567', '6cdebbf0-7e33-4143-9474-a1b28840c1cd', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:13', NULL, NULL, 0, NULL, NULL),
(2140, 969.00, 'Random Game', 'GAME-385', 'User-991', 'd535970e-226b-426c-a33b-3e6944936eba', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:33', NULL, NULL, 0, NULL, NULL),
(2141, 507.00, 'Random Game', 'GAME-923', 'User-401', '2bbb2bca-161d-41af-9a2b-f29ba1857b35', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:48', NULL, NULL, 0, NULL, NULL),
(2142, 346.00, 'Random Game', 'GAME-888', 'User-932', '18eeeafa-893c-44c0-9d2a-8d6a481a543c', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:48', NULL, NULL, 0, NULL, NULL),
(2143, 735.00, 'Random Game', 'GAME-874', 'User-416', 'dde149bf-447d-4693-9472-d5cb14e0f2ec', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:50', NULL, NULL, 0, NULL, NULL),
(2144, 191.00, 'Random Game', 'GAME-90', 'User-555', '2d4c6995-3e56-4d1c-89f8-2b394cae12e9', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:40:50', NULL, NULL, 0, NULL, NULL),
(2145, 112.00, 'Random Game', 'GAME-658', 'User-417', '72ae4a62-2ce2-4f48-8b97-350e9eb61089', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:41:10', NULL, NULL, 0, NULL, NULL),
(2146, 203.00, 'Random Game', 'GAME-512', 'User-145', '176d3ed0-64a7-407f-80cd-284d68e7136f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:41:11', NULL, NULL, 0, NULL, NULL),
(2147, 685.00, 'Random Game', 'GAME-59', 'User-931', '330f22e2-fd67-4fe5-b3e8-7440cbcce022', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:41:11', NULL, NULL, 0, NULL, NULL),
(2148, 569.00, 'Random Game', 'GAME-404', 'User-484', '76dd2f43-baaf-4654-a330-1bc82b0ec3e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:41:37', NULL, NULL, 0, NULL, NULL),
(2149, 164.00, 'Random Game', 'GAME-102', 'User-929', 'ccd33740-21e7-40d7-8c8a-9f35531275cf', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:41:37', NULL, NULL, 0, NULL, NULL),
(2150, 325.00, 'Random Game', 'GAME-190', 'User-632', '6818c785-d6db-416e-8c68-54d656310da6', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:41:57', NULL, NULL, 0, NULL, NULL),
(2151, 515.00, 'Random Game', 'GAME-178', 'User-390', 'fa74a3e9-2fe2-4f64-a907-409f946185fe', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:42:17', NULL, NULL, 0, NULL, NULL),
(2152, 852.00, 'Random Game', 'GAME-482', 'User-327', 'eadc3cce-e465-4c0c-8cf8-a97eaa348671', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:42:17', NULL, NULL, 0, NULL, NULL),
(2153, 423.00, 'Random Game', 'GAME-916', 'User-670', '260cfccc-64f3-40e6-a19a-25951637bf10', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:42:20', NULL, NULL, 0, NULL, NULL),
(2154, 979.00, 'Random Game', 'GAME-374', 'User-678', '3b90572b-ab3f-47f6-8fe2-f20f02e60ef5', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:42:20', NULL, NULL, 0, NULL, NULL),
(2155, 133.00, 'Random Game', 'GAME-941', 'User-537', '080778a9-7a4a-4af8-a468-986f784b8594', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:42:43', NULL, NULL, 0, NULL, NULL),
(2156, 381.00, 'Random Game', 'GAME-855', 'User-516', '21cf6cfb-ba2b-4299-935b-13933e9a2c7b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:42:43', NULL, NULL, 0, NULL, NULL),
(2157, 205.00, 'Random Game', 'GAME-542', 'User-980', '6c5ccc11-3679-4eef-8ddb-05a26b579174', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:43:03', NULL, NULL, 0, NULL, NULL),
(2158, 130.00, 'Random Game', 'GAME-564', 'User-384', '60c25c23-ca72-4cae-b865-29c844139cf4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:43:23', NULL, NULL, 0, NULL, NULL),
(2159, 627.00, 'Random Game', 'GAME-361', 'User-677', 'c9e5526b-bb33-4e75-bd24-e6ff1b947d14', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:43:43', NULL, NULL, 0, NULL, NULL),
(2160, 135.00, 'Random Game', 'GAME-168', 'User-977', 'f4090328-a919-46f3-96ec-695296dea6ca', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:44:03', NULL, NULL, 0, NULL, NULL),
(2161, 121.00, 'Random Game', 'GAME-586', 'User-839', '315c2a36-045b-4271-b2e3-db9ac0cabed3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:44:23', NULL, NULL, 0, NULL, NULL),
(2162, 940.00, 'Random Game', 'GAME-264', 'User-884', '5215cf21-a196-4a39-afd3-3ac1fb0e83c8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:44:30', NULL, NULL, 0, NULL, NULL),
(2163, 522.00, 'Random Game', 'GAME-834', 'User-857', '4ac1aba5-036c-4f03-94de-1c28ab1a0b81', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:44:30', NULL, NULL, 0, NULL, NULL),
(2164, 856.00, 'Random Game', 'GAME-719', 'User-53', 'ee46d336-a6fb-406c-88dd-d79038c5ec39', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:44:50', NULL, NULL, 0, NULL, NULL),
(2165, 205.00, 'Random Game', 'GAME-341', 'User-438', '72bd86db-4f05-428a-91ff-ac4dade02542', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:45:10', NULL, NULL, 0, NULL, NULL),
(2166, 627.00, 'Random Game', 'GAME-420', 'User-749', '9ce9fc6f-dc02-45b4-af9c-f9dc049e452f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:46:14', NULL, NULL, 0, NULL, NULL),
(2167, 912.00, 'Random Game', 'GAME-64', 'User-69', '45119b9b-824d-4afd-a506-19fa7a26792b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:46:14', NULL, NULL, 0, NULL, NULL),
(2168, 751.00, 'Random Game', 'GAME-921', 'User-714', 'edd0d088-25a9-4d6a-9f68-9462cfa134da', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:46:34', NULL, NULL, 0, NULL, NULL),
(2169, 72.00, 'Random Game', 'GAME-161', 'User-705', '8c9f5f24-a367-468e-ab67-6db13755e6a5', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:46:54', NULL, NULL, 0, NULL, NULL),
(2170, 712.00, 'Random Game', 'GAME-289', 'User-21', '6d58dfe0-da84-4513-94e1-b0581f610b5d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:46:56', NULL, NULL, 0, NULL, NULL),
(2171, 711.00, 'Random Game', 'GAME-81', 'User-262', '55e6251c-feaa-47d5-af0a-65786a7fb4ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:46:56', NULL, NULL, 0, NULL, NULL),
(2172, 729.00, 'Random Game', 'GAME-807', 'User-364', '9e4dd17d-fb13-4568-979c-52cb3e1ea176', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:03', NULL, NULL, 0, NULL, NULL),
(2173, 421.00, 'Random Game', 'GAME-15', 'User-702', 'cb273568-15be-4fef-90d1-03ce67e5dc3f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:03', NULL, NULL, 0, NULL, NULL),
(2174, 846.00, 'Random Game', 'GAME-454', 'User-912', '42a8fff1-6735-47eb-9be6-933bd69ca533', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:08', NULL, NULL, 0, NULL, NULL),
(2175, 1039.00, 'Random Game', 'GAME-956', 'User-274', 'cadfb9f1-2f73-4e34-b355-f8fb1b10717f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:08', NULL, NULL, 0, NULL, NULL),
(2176, 410.00, 'Random Game', 'GAME-813', 'User-570', '2b0a344f-b024-4ae5-bb67-c676989bfb0d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:10', NULL, NULL, 0, NULL, NULL),
(2177, 690.00, 'Random Game', 'GAME-12', 'User-416', '7c82537e-ec9c-48bf-a7ef-12058471214a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:10', NULL, NULL, 0, NULL, NULL),
(2178, 709.00, 'Random Game', 'GAME-971', 'User-956', '18a3677e-662b-4301-b43e-eff86199cf31', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:30', NULL, NULL, 0, NULL, NULL),
(2179, 353.00, 'Random Game', 'GAME-788', 'User-2', '24de2d9f-5fe8-4c23-a217-9604e9440c96', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:50', NULL, NULL, 0, NULL, NULL),
(2180, 353.00, 'Random Game', 'GAME-920', 'User-331', '974fe5e2-25c1-4a56-b38b-8de987a0bc11', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:58', NULL, NULL, 0, NULL, NULL),
(2181, 620.00, 'Random Game', 'GAME-522', 'User-885', '1be689ec-2e35-48f9-9be6-4403227bfe9a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:58', NULL, NULL, 0, NULL, NULL),
(2182, 338.00, 'Random Game', 'GAME-158', 'User-241', '14b13355-e830-41e3-8ea2-6a01ba7908be', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:59', NULL, NULL, 0, NULL, NULL),
(2183, 184.00, 'Random Game', 'GAME-876', 'User-318', '41cd3da7-7b2d-4c0a-805b-96139ed5ddd5', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:47:59', NULL, NULL, 0, NULL, NULL),
(2184, 836.00, 'Random Game', 'GAME-258', 'User-976', '2c6772ed-d307-4e5a-92dc-2afd456e69f6', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:19', NULL, NULL, 0, NULL, NULL),
(2185, 463.00, 'Random Game', 'GAME-864', 'User-16', '00826397-db74-47dc-944e-9a8664e949af', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:22', NULL, NULL, 0, NULL, NULL),
(2186, 1021.00, 'Random Game', 'GAME-120', 'User-997', 'a51432ad-e48c-470e-8c16-6cd501acd90f', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:22', NULL, NULL, 0, NULL, NULL),
(2187, 762.00, 'Random Game', 'GAME-527', 'User-877', 'b1724575-951c-4500-9e10-b089a51f20b4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:28', NULL, NULL, 0, NULL, NULL),
(2188, 999.00, 'Random Game', 'GAME-951', 'User-637', '5aab755c-5b66-46fa-a9b1-ec83ba030dca', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:28', NULL, NULL, 0, NULL, NULL),
(2189, 160.00, 'Random Game', 'GAME-665', 'User-668', 'f343ba27-1e8b-4db1-b758-2fd235e11986', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:31', NULL, NULL, 0, NULL, NULL),
(2190, 586.00, 'Random Game', 'GAME-392', 'User-176', '0fce171f-8902-4b13-99ae-8a40d53743b2', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:31', NULL, NULL, 0, NULL, NULL),
(2191, 819.00, 'Random Game', 'GAME-858', 'User-663', '9bb5f676-0fec-433c-8fdb-319730782226', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:35', NULL, NULL, 0, NULL, NULL),
(2192, 812.00, 'Random Game', 'GAME-855', 'User-147', '113ff072-cd63-4b86-9c16-162ad79a13c3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:35', NULL, NULL, 0, NULL, NULL),
(2193, 596.00, 'Random Game', 'GAME-140', 'User-838', 'aa6ab24e-484e-403e-8df8-cb0094e93491', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:48:55', NULL, NULL, 0, NULL, NULL),
(2194, 471.00, 'Random Game', 'GAME-310', 'User-218', 'bd2551e4-cbcc-4518-9a80-9d4c5eb71cdd', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:49:15', NULL, NULL, 0, NULL, NULL),
(2195, 556.00, 'Random Game', 'GAME-688', 'User-33', 'fb1f7ee5-fa45-4d5b-9764-5849bbab98ae', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:49:35', NULL, NULL, 0, NULL, NULL),
(2196, 656.00, 'Random Game', 'GAME-638', 'User-847', '927e53c6-5aeb-410d-b4f2-236924e15215', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:49:45', NULL, NULL, 0, NULL, NULL),
(2197, 178.00, 'Random Game', 'GAME-871', 'User-568', '5eeb0107-3e6b-4619-8a01-d12e7e73b85a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:49:49', NULL, NULL, 0, NULL, NULL),
(2198, 1031.00, 'Random Game', 'GAME-24', 'User-518', 'f4b81d24-4565-4d14-895b-29cf6850d08e', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:49:49', NULL, NULL, 0, NULL, NULL),
(2199, 65.00, 'Random Game', 'GAME-388', 'User-703', '434fe4fc-506e-4914-84f9-49400ae54403', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:49:51', NULL, NULL, 0, NULL, NULL),
(2200, 427.00, 'Random Game', 'GAME-645', 'User-47', '66e28001-3a47-47dd-a6bc-76101e0261ce', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:49:51', NULL, NULL, 0, NULL, NULL),
(2201, 873.00, 'Random Game', 'GAME-791', 'User-76', 'ce0b93a1-345b-494c-a20b-89e12e24cfcb', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:50:11', NULL, NULL, 0, NULL, NULL);
INSERT INTO `form_submissions` (`id`, `amount`, `game`, `game_id`, `facebook_name`, `transaction_number`, `group_id`, `status`, `validator_id`, `fulfiller_id`, `created_at`, `validated_at`, `completed_at`, `telegram_notification_sent`, `telegram_message_id`, `telegram_chat_id`) VALUES
(2202, 98.00, 'Random Game', 'GAME-700', 'User-12', 'ac69996f-3f83-4954-9283-f2ca0cc4593e', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:50:31', NULL, NULL, 0, NULL, NULL),
(2203, 695.00, 'Random Game', 'GAME-26', 'User-566', 'd454a5a5-3b34-46d1-877f-8b5443afbaeb', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:50:49', NULL, NULL, 0, NULL, NULL),
(2204, 1029.00, 'Random Game', 'GAME-476', 'User-332', '95a47188-84ad-4f1d-ace5-3ef6bcd4f306', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:50:49', NULL, NULL, 0, NULL, NULL),
(2205, 785.00, 'Random Game', 'GAME-940', 'User-233', '79210835-455a-4501-afe2-e7c998e12b1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:50:51', NULL, NULL, 0, NULL, NULL),
(2206, 406.00, 'Random Game', 'GAME-135', 'User-301', '6d75e3bc-ae2d-4544-bdd4-4301d7e4d0a3', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:50:51', NULL, NULL, 0, NULL, NULL),
(2207, 486.00, 'Random Game', 'GAME-473', 'User-703', 'd4072229-f0ee-4220-927a-9f203b3dfa10', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:51:11', NULL, NULL, 0, NULL, NULL),
(2208, 211.00, 'Random Game', 'GAME-170', 'User-618', '23ad27d0-4a39-45ed-99ce-daff0bb263a2', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:51:31', NULL, NULL, 0, NULL, NULL),
(2209, 594.00, 'Random Game', 'GAME-78', 'User-891', 'f26486f0-c826-42bb-9361-bf4d873234d7', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:51:42', NULL, NULL, 0, NULL, NULL),
(2210, 858.00, 'Random Game', 'GAME-981', 'User-164', 'b948473e-caa9-451e-9a5a-0ca0a2ac5139', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:51:42', NULL, NULL, 0, NULL, NULL),
(2211, 756.00, 'Random Game', 'GAME-673', 'User-245', 'f7635055-ad43-4e18-b6f8-6651c3fbde4e', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:51:43', NULL, NULL, 0, NULL, NULL),
(2212, 835.00, 'Random Game', 'GAME-230', 'User-862', '523d5c4b-4d77-4952-a106-968beab94674', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:51:43', NULL, NULL, 0, NULL, NULL),
(2213, 297.00, 'Random Game', 'GAME-544', 'User-685', 'c8fcb2fc-caeb-454b-bcd8-c4504aa1413b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:52:03', NULL, NULL, 0, NULL, NULL),
(2214, 375.00, 'Random Game', 'GAME-607', 'User-600', '9107fb2f-d41f-4318-a14c-7e5090be6ad1', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:52:23', NULL, NULL, 0, NULL, NULL),
(2215, 931.00, 'Random Game', 'GAME-163', 'User-915', '6affd180-1b1b-4ed2-95b6-703eec4d68f5', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:52:43', NULL, NULL, 0, NULL, NULL),
(2216, 128.00, 'Random Game', 'GAME-711', 'User-534', 'cd8c2930-036b-4037-a8e9-f657a2178d58', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:53:03', NULL, NULL, 0, NULL, NULL),
(2217, 495.00, 'Random Game', 'GAME-252', 'User-919', '4e10e757-483c-47b2-8cb5-72ecaa335421', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:53:23', NULL, NULL, 0, NULL, NULL),
(2218, 149.00, 'Random Game', 'GAME-651', 'User-908', 'f327ad62-585a-486d-9d01-e8fd9d6396b5', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:53:43', NULL, NULL, 0, NULL, NULL),
(2219, 324.00, 'Random Game', 'GAME-840', 'User-469', '0f24f446-001f-443c-a333-770acbed2e5a', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:53:50', NULL, NULL, 0, NULL, NULL),
(2220, 628.00, 'Random Game', 'GAME-718', 'User-739', 'c2d02e75-6496-4c8a-9943-9a9058a8320d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:53:50', NULL, NULL, 0, NULL, NULL),
(2221, 382.00, 'Random Game', 'GAME-343', 'User-472', '5bbfe426-b9cb-492a-ae6a-9ba7a9be02dd', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:53:52', NULL, NULL, 0, NULL, NULL),
(2222, 465.00, 'Random Game', 'GAME-310', 'User-874', '08042779-dab9-42ea-945f-b3a941774b72', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:53:52', NULL, NULL, 0, NULL, NULL),
(2223, 817.00, 'Random Game', 'GAME-838', 'User-40', 'c59d9042-7e06-41be-8516-4df08d3e8d95', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:54:12', NULL, NULL, 0, NULL, NULL),
(2224, 728.00, 'Random Game', 'GAME-352', 'User-293', '12311860-c4bb-4263-8b87-39e5d188092e', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:54:32', NULL, NULL, 0, NULL, NULL),
(2225, 500.00, 'Random Game', 'GAME-284', 'User-840', 'cb14b190-af2c-44f7-b274-b5a6260c7416', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:54:52', NULL, NULL, 0, NULL, NULL),
(2226, 641.00, 'Random Game', 'GAME-479', 'User-854', 'bed8a4fc-0fd0-41e8-807c-b20324776ebd', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:55:12', NULL, NULL, 0, NULL, NULL),
(2227, 586.00, 'Random Game', 'GAME-401', 'User-514', '753c6755-ccc4-4fc0-a305-2c4a3008f10d', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:55:32', NULL, NULL, 0, NULL, NULL),
(2228, 842.00, 'Random Game', 'GAME-299', 'User-316', '634e43ef-a886-4ef3-8b31-17b3a83de9fc', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:55:52', NULL, NULL, 0, NULL, NULL),
(2229, 830.00, 'Random Game', 'GAME-984', 'User-742', 'cf6acb21-b31a-4d1f-ae98-c1f6df8596d2', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:56:12', NULL, NULL, 0, NULL, NULL),
(2230, 135.00, 'Random Game', 'GAME-190', 'User-597', 'ca968a3a-ec20-426d-84d4-178b7da979f4', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:56:32', NULL, NULL, 0, NULL, NULL),
(2231, 358.00, 'Random Game', 'GAME-402', 'User-279', 'e3f15f0c-c89b-4b31-8883-46c34eb82333', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:56:52', NULL, NULL, 0, NULL, NULL),
(2232, 966.00, 'Random Game', 'GAME-131', 'User-681', 'b64bb747-b30f-495b-9711-886d023cf0c6', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:57:12', NULL, NULL, 0, NULL, NULL),
(2233, 1046.00, 'Random Game', 'GAME-321', 'User-865', '2f6f66f5-e049-42f5-bc4a-8f4bdb169b94', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:57:32', NULL, NULL, 0, NULL, NULL),
(2234, 272.00, 'Random Game', 'GAME-400', 'User-568', 'bc780638-7206-499e-9ec9-b7fd3815b93e', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:57:52', NULL, NULL, 0, NULL, NULL),
(2235, 379.00, 'Random Game', 'GAME-703', 'User-390', '2a0b8075-c760-4ee1-b96e-5b8816cbd8de', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:58:12', NULL, NULL, 0, NULL, NULL),
(2236, 828.00, 'Random Game', 'GAME-443', 'User-580', '133b421b-3e79-43ed-9926-85b00bde4feb', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:58:32', NULL, NULL, 0, NULL, NULL),
(2237, 677.00, 'Random Game', 'GAME-21', 'User-661', '10324fe5-4427-4869-b51a-245dab7aa000', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:58:37', NULL, NULL, 0, NULL, NULL),
(2238, 659.00, 'Random Game', 'GAME-751', 'User-626', '06a9f90d-411f-43c1-aad1-81d4e43b7308', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:58:37', NULL, NULL, 0, NULL, NULL),
(2239, 988.00, 'Random Game', 'GAME-554', 'User-468', '33055f47-9215-40bd-b1aa-efefbc2a1fb1', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:58:57', NULL, NULL, 0, NULL, NULL),
(2240, 695.00, 'Random Game', 'GAME-117', 'User-833', 'd919c77c-41e0-4f4f-b2ca-5c3f56bb18b8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:58:59', NULL, NULL, 0, NULL, NULL),
(2241, 506.00, 'Random Game', 'GAME-702', 'User-272', '2c97812d-7597-4f5d-8542-feb0dfad8884', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:58:59', NULL, NULL, 0, NULL, NULL),
(2242, 984.00, 'Random Game', 'GAME-357', 'User-675', '8a7ee988-8d8f-47d3-81dd-49d057e5de35', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:59:01', NULL, NULL, 0, NULL, NULL),
(2243, 798.00, 'Random Game', 'GAME-323', 'User-565', '041d01bf-c04a-4b03-b43e-2f097771c23b', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:59:01', NULL, NULL, 0, NULL, NULL),
(2244, 493.00, 'Random Game', 'GAME-74', 'User-571', 'e73cd028-a1ce-4b34-aa41-4f324b5cb877', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:59:11', NULL, NULL, 0, NULL, NULL),
(2245, 1027.00, 'Random Game', 'GAME-348', 'User-178', '1d6d1e5d-9d2d-42e9-ae71-6273a095fe72', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:59:11', NULL, NULL, 0, NULL, NULL),
(2246, 154.00, 'Random Game', 'GAME-251', 'User-161', 'f2b72417-e5c0-49e7-b2b7-cddc91cf0362', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:59:31', NULL, NULL, 0, NULL, NULL),
(2247, 947.00, 'Random Game', 'GAME-417', 'User-533', '2e891fd7-286d-4ce4-8d30-e25b8c92d3d8', 19, 'pending_validation', NULL, NULL, '2025-04-09 19:59:50', NULL, NULL, 0, NULL, NULL),
(2248, 773.00, 'Random Game', 'GAME-162', 'User-472', '9e510e16-7ae8-4d29-87ba-89c2d6f30f52', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:11', NULL, NULL, 0, NULL, NULL),
(2249, 459.00, 'Random Game', 'GAME-731', 'User-816', '0edb9666-e789-478b-9649-0b8a2c899c0b', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:28', NULL, NULL, 0, NULL, NULL),
(2250, 550.00, 'Random Game', 'GAME-490', 'User-838', '4a139237-1357-4b46-a213-843350ad6536', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:28', NULL, NULL, 0, NULL, NULL),
(2251, 811.00, 'Random Game', 'GAME-955', 'User-844', '1591d618-8c9f-4b29-b75c-b5e020dc0859', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:30', NULL, NULL, 0, NULL, NULL),
(2252, 398.00, 'Random Game', 'GAME-589', 'User-853', 'e513aab3-9664-44a3-a86d-d8baa41832ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:30', NULL, NULL, 0, NULL, NULL),
(2253, 280.00, 'Random Game', 'GAME-547', 'User-296', '791c5985-35ae-4856-bf12-6d02bde85b67', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:34', NULL, NULL, 0, NULL, NULL),
(2254, 742.00, 'Random Game', 'GAME-498', 'User-356', '2d57a656-6d33-4c7e-88a5-18fbb1c76b64', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:34', NULL, NULL, 0, NULL, NULL),
(2255, 256.00, 'Random Game', 'GAME-405', 'User-90', 'dabef7b4-0881-428c-8259-996d80da4ef6', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:52', NULL, NULL, 0, NULL, NULL),
(2256, 943.00, 'Random Game', 'GAME-241', 'User-375', 'a8fee39b-36a3-4f7a-8df0-f415aa09146a', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:00:52', NULL, NULL, 0, NULL, NULL),
(2257, 412.00, 'Random Game', 'GAME-357', 'User-235', 'e9247d24-e1c7-4a5e-a691-19fa414cd6ee', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:12', NULL, NULL, 0, NULL, NULL),
(2258, 624.00, 'Random Game', 'GAME-343', 'User-840', '4647e6e1-5cb5-4034-8911-ad0276896eef', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:16', NULL, NULL, 0, NULL, NULL),
(2259, 337.00, 'Random Game', 'GAME-28', 'User-331', '0dfe0092-9df7-4cf1-8359-b2424bf66d4d', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:16', NULL, NULL, 0, NULL, NULL),
(2260, 536.00, 'Random Game', 'GAME-743', 'User-488', 'c9c06c4e-6565-4660-8272-0e65d3d1c0a4', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:21', NULL, NULL, 0, NULL, NULL),
(2261, 162.00, 'Random Game', 'GAME-197', 'User-180', '2f987490-0ce3-4e73-ab3a-33d5245bfd69', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:21', NULL, NULL, 0, NULL, NULL),
(2262, 378.00, 'Random Game', 'GAME-108', 'User-982', 'ed980df0-5b2b-49e1-ae7f-bf173bbc4dea', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:23', NULL, NULL, 0, NULL, NULL),
(2263, 932.00, 'Random Game', 'GAME-273', 'User-119', '54ea9e05-2e66-4d66-9fb4-d2812904f896', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:23', NULL, NULL, 0, NULL, NULL),
(2264, 73.00, 'Random Game', 'GAME-599', 'User-220', '29648204-e3d4-41c2-b804-0df4ad8cc0c7', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:01:43', NULL, NULL, 0, NULL, NULL),
(2265, 770.00, 'Random Game', 'GAME-462', 'User-878', 'b7e8053d-0fd4-4b6d-8b77-3c8f95f9fcb0', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:02:03', NULL, NULL, 0, NULL, NULL),
(2266, 228.00, 'Random Game', 'GAME-146', 'User-688', '723e2050-001d-4497-9dd4-605cd8f2a000', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:03:25', NULL, NULL, 0, NULL, NULL),
(2267, 850.00, 'Random Game', 'GAME-277', 'User-154', 'eac799ff-e5f8-482e-af07-a944c686f27b', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:03:25', NULL, NULL, 0, NULL, NULL),
(2268, 393.00, 'Random Game', 'GAME-126', 'User-68', 'c8eb730f-7dfe-45ad-8eae-adae2257d3c4', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:03:45', NULL, NULL, 0, NULL, NULL),
(2269, 59.00, 'Random Game', 'GAME-332', 'User-325', '2cd9f416-5626-4c47-a936-0efc2d66e986', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:04:05', NULL, NULL, 0, NULL, NULL),
(2270, 401.00, 'Random Game', 'GAME-205', 'User-396', 'ce9721e2-fae3-49a1-8760-5eed6cea0fe2', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:04:25', NULL, NULL, 0, NULL, NULL),
(2271, 427.00, 'Random Game', 'GAME-286', 'User-872', '73ddf35e-5bcb-40a3-ae6d-df0a722dfe7d', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:04:45', NULL, NULL, 0, NULL, NULL),
(2272, 855.00, 'Random Game', 'GAME-885', 'User-124', 'a05f7a27-863c-4ae1-a5e4-65ef000da017', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:05:05', NULL, NULL, 0, NULL, NULL),
(2273, 149.00, 'Random Game', 'GAME-488', 'User-194', 'b54be96c-f900-48e0-ba06-6413b252838d', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:05:25', NULL, NULL, 0, NULL, NULL),
(2274, 929.00, 'Random Game', 'GAME-788', 'User-72', '484b41d3-74fb-4b22-892d-d92f9d3bc5be', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:05:45', NULL, NULL, 0, NULL, NULL),
(2275, 392.00, 'Random Game', 'GAME-212', 'User-805', '5bf29984-9072-4783-8426-9c37cc7f5d61', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:06:05', NULL, NULL, 0, NULL, NULL),
(2276, 184.00, 'Random Game', 'GAME-506', 'User-536', 'e1e20287-fa3f-499d-9d60-315d100b768e', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:06:25', NULL, NULL, 0, NULL, NULL),
(2277, 62.00, 'Random Game', 'GAME-867', 'User-820', '7b6e1caf-aa97-4883-a828-214e582b9a40', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:06:45', NULL, NULL, 0, NULL, NULL),
(2278, 736.00, 'Random Game', 'GAME-252', 'User-955', '479ee41b-6e8b-4ce1-b0df-adfe4d85fe93', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:07:05', NULL, NULL, 0, NULL, NULL),
(2279, 52.00, 'Random Game', 'GAME-194', 'User-826', 'ef6b01ff-950b-4023-8b28-3125c81ffcf8', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:07:25', NULL, NULL, 0, NULL, NULL),
(2280, 641.00, 'Random Game', 'GAME-572', 'User-736', '74f538e2-af17-4017-a551-f9b8dea4994d', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:07:46', NULL, NULL, 0, NULL, NULL),
(2281, 724.00, 'Random Game', 'GAME-242', 'User-160', '3bf685aa-ba2f-4aa2-a8ea-2321eff22950', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:08:06', NULL, NULL, 0, NULL, NULL),
(2282, 287.00, 'Random Game', 'GAME-954', 'User-401', '95b36a8f-bcdb-47bd-9830-8d5d1379b263', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:08:25', NULL, NULL, 0, NULL, NULL),
(2283, 640.00, 'Random Game', 'GAME-199', 'User-859', '2cbcfa23-e9ab-42f0-bb4c-4703cf3a5020', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:08:45', NULL, NULL, 0, NULL, NULL),
(2284, 768.00, 'Random Game', 'GAME-853', 'User-234', '7f45f690-703b-4570-9df5-142c10ecc4ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:09:06', NULL, NULL, 0, NULL, NULL),
(2285, 179.00, 'Random Game', 'GAME-305', 'User-410', 'f933a018-c22f-4c04-a0fb-de7f33909805', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:09:26', NULL, NULL, 0, NULL, NULL),
(2286, 718.00, 'Random Game', 'GAME-727', 'User-820', 'c74db228-385d-404b-8d1f-4af3ca0be875', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:09:45', NULL, NULL, 0, NULL, NULL),
(2287, 724.00, 'Random Game', 'GAME-218', 'User-918', 'dafa53ba-d519-4a13-a06e-a87eac5ed327', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:10:05', NULL, NULL, 0, NULL, NULL),
(2288, 509.00, 'Random Game', 'GAME-94', 'User-455', 'ee4f17fd-1ce4-4f8d-a810-cc452771a8ae', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:10:25', NULL, NULL, 0, NULL, NULL),
(2289, 767.00, 'Random Game', 'GAME-817', 'User-16', '4a595f30-3921-44ad-badd-39c68e91e536', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:10:45', NULL, NULL, 0, NULL, NULL),
(2290, 445.00, 'Random Game', 'GAME-864', 'User-21', '86a555a5-fb6c-4fa9-9d66-f3c6a586a1a0', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:11:05', NULL, NULL, 0, NULL, NULL),
(2291, 514.00, 'Random Game', 'GAME-222', 'User-328', '856c8b72-2f45-4e84-bd35-e37db36e0eeb', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:11:18', NULL, NULL, 0, NULL, NULL),
(2292, 127.00, 'Random Game', 'GAME-247', 'User-528', '01d61734-bdca-4dc7-b89d-08c13eeec0e5', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:11:18', NULL, NULL, 0, NULL, NULL),
(2293, 481.00, 'Random Game', 'GAME-210', 'User-178', 'd2516d50-e70d-4610-b3df-e7078a2fe17e', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:11:20', NULL, NULL, 0, NULL, NULL),
(2294, 579.00, 'Random Game', 'GAME-704', 'User-813', '5999b20c-2d4f-4dcf-84ec-76a5db680561', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:11:20', NULL, NULL, 0, NULL, NULL),
(2295, 693.00, 'Random Game', 'GAME-979', 'User-728', '3fd7a5ea-54af-4ef4-8340-5d2a4a2b9387', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:11:40', NULL, NULL, 0, NULL, NULL),
(2296, 388.00, 'Random Game', 'GAME-839', 'User-746', 'a4ebc433-5ca3-45d2-acf4-6a47112d4690', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:12:00', NULL, NULL, 0, NULL, NULL),
(2297, 54.00, 'Random Game', 'GAME-521', 'User-481', 'c59c50c2-3f09-4abb-a4aa-957edb6fdf07', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:12:20', NULL, NULL, 0, NULL, NULL),
(2298, 521.00, 'Random Game', 'GAME-765', 'User-333', '7d5ccbd4-e107-479c-8feb-ef7091286d1b', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:12:40', NULL, NULL, 0, NULL, NULL),
(2299, 439.00, 'Random Game', 'GAME-220', 'User-410', '7da11ede-1048-40db-ac36-a7fcfafc5ce7', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:13:07', NULL, NULL, 0, NULL, NULL),
(2300, 835.00, 'Random Game', 'GAME-412', 'User-848', '36250110-4047-4195-a37d-547e124364e2', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:13:34', NULL, NULL, 0, NULL, NULL),
(2301, 363.00, 'Random Game', 'GAME-907', 'User-234', 'ee916329-60b3-493e-9e21-8649e97ba912', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:13:40', NULL, NULL, 0, NULL, NULL),
(2302, 476.00, 'Random Game', 'GAME-115', 'User-203', '617983a3-980f-4173-bebd-ed9dfad70082', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:14:00', NULL, NULL, 0, NULL, NULL),
(2303, 998.00, 'Random Game', 'GAME-43', 'User-161', 'a6fb0782-18ce-453a-9169-4dd5e2082a4d', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:14:20', NULL, NULL, 0, NULL, NULL),
(2304, 228.00, 'Random Game', 'GAME-568', 'User-942', '19274b3d-d93b-4d7a-96a1-28c68150eec7', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:14:40', NULL, NULL, 0, NULL, NULL),
(2305, 294.00, 'Random Game', 'GAME-696', 'User-2', '8dff283f-9b75-444b-b4f6-3da90e868fe7', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:15:00', NULL, NULL, 0, NULL, NULL),
(2306, 731.00, 'Random Game', 'GAME-490', 'User-633', '063a4be2-1af3-4072-8ab7-486d375044e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:15:20', NULL, NULL, 0, NULL, NULL),
(2307, 268.00, 'Random Game', 'GAME-578', 'User-761', '7a9fc227-20f4-440f-8117-180e8b968a6d', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:16:07', NULL, NULL, 0, NULL, NULL),
(2308, 842.00, 'Random Game', 'GAME-83', 'User-937', '5e0f044a-fde7-4c29-a944-64862c103912', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:17:07', NULL, NULL, 0, NULL, NULL),
(2309, 519.00, 'Random Game', 'GAME-270', 'User-174', '1f884b83-eb65-4563-b3bf-5c3d80166473', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:17:20', NULL, NULL, 0, NULL, NULL),
(2310, 700.00, 'Random Game', 'GAME-690', 'User-348', '3db45b5a-ad0d-4b53-b9ee-f71f92ec813e', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:17:40', NULL, NULL, 0, NULL, NULL),
(2311, 212.00, 'Random Game', 'GAME-964', 'User-513', '970e9467-3ea8-42b7-8abd-d0f0156d0781', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:18:00', NULL, NULL, 0, NULL, NULL),
(2312, 702.00, 'Random Game', 'GAME-434', 'User-448', '8a71192c-1331-4816-81ab-d5ae0b07cf1a', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:18:20', NULL, NULL, 0, NULL, NULL),
(2313, 968.00, 'Random Game', 'GAME-999', 'User-411', 'b52a40f1-023c-4ac8-a445-febf7ec1eed7', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:18:40', NULL, NULL, 0, NULL, NULL),
(2314, 617.00, 'Random Game', 'GAME-902', 'User-283', '2cb4fb7b-29c2-4ab3-8a06-6b1248bcdff5', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:19:07', NULL, NULL, 0, NULL, NULL),
(2315, 366.00, 'Random Game', 'GAME-355', 'User-452', '36c6a8e1-3ae1-47a5-9010-2c27e9cd09ff', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:20:07', NULL, NULL, 0, NULL, NULL),
(2316, 469.00, 'Random Game', 'GAME-107', 'User-809', '9c00e8f2-015c-49d9-bb99-ccfe167034d7', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:21:07', NULL, NULL, 0, NULL, NULL),
(2317, 369.00, 'Random Game', 'GAME-717', 'User-115', '06ebbab3-8cb5-4479-bf40-8618e8f53bd5', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:22:07', NULL, NULL, 0, NULL, NULL),
(2318, 1006.00, 'Random Game', 'GAME-399', 'User-941', 'f4245d82-ccd4-46ea-9217-bec15fb46387', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:23:07', NULL, NULL, 0, NULL, NULL),
(2319, 318.00, 'Random Game', 'GAME-244', 'User-445', '5e3f124d-25d2-46ca-a25a-95133f718011', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:24:07', NULL, NULL, 0, NULL, NULL),
(2320, 563.00, 'Random Game', 'GAME-814', 'User-657', 'df023f49-a77d-4192-9369-473782a693a9', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:25:07', NULL, NULL, 0, NULL, NULL),
(2321, 708.00, 'Random Game', 'GAME-383', 'User-966', '612fd672-8d36-4a3c-9d52-e5790a6608f3', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:26:07', NULL, NULL, 0, NULL, NULL),
(2322, 488.00, 'Random Game', 'GAME-946', 'User-875', '144ad259-d2d4-410f-905f-20ff1ce99262', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:27:07', NULL, NULL, 0, NULL, NULL),
(2323, 193.00, 'Random Game', 'GAME-10', 'User-829', '7580bb64-8aa3-4be3-90a1-328f4c4debb6', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:28:07', NULL, NULL, 0, NULL, NULL),
(2324, 689.00, 'Random Game', 'GAME-987', 'User-877', 'a4bcb6e4-f102-4d17-87fc-7efa8e4acaf4', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:29:07', NULL, NULL, 0, NULL, NULL),
(2325, 873.00, 'Random Game', 'GAME-297', 'User-503', '1fd46412-28b7-4a8e-88f0-25bb598ce4d5', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:30:07', NULL, NULL, 0, NULL, NULL),
(2326, 479.00, 'Random Game', 'GAME-410', 'User-676', '7e91ef8d-4f67-4e4a-953c-c8ccfba36d11', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:31:07', NULL, NULL, 0, NULL, NULL),
(2327, 182.00, 'Random Game', 'GAME-455', 'User-160', '75975ccc-1915-4f95-b703-e1e17b365831', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:32:07', NULL, NULL, 0, NULL, NULL),
(2328, 337.00, 'Random Game', 'GAME-0', 'User-255', '29e339c5-750d-4d7b-b601-ee919b0c587d', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:33:07', NULL, NULL, 0, NULL, NULL),
(2329, 361.00, 'Random Game', 'GAME-46', 'User-846', '6dd58267-27af-4b93-9d12-04c683a3f38c', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:34:07', NULL, NULL, 0, NULL, NULL),
(2330, 271.00, 'Random Game', 'GAME-942', 'User-467', '6e0f17f3-dabd-4803-9abd-471bd027d2ac', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:35:07', NULL, NULL, 0, NULL, NULL),
(2331, 341.00, 'Random Game', 'GAME-717', 'User-84', '19bbe58b-dfa1-4de5-a70b-9994d61b72a7', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:36:07', NULL, NULL, 0, NULL, NULL),
(2332, 694.00, 'Random Game', 'GAME-603', 'User-231', '006c89c0-b3e6-4331-82db-dc74769aba0a', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:37:07', NULL, NULL, 0, NULL, NULL),
(2333, 741.00, 'Random Game', 'GAME-541', 'User-519', 'd907970e-756d-4681-bb98-6d529153d2b9', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:38:07', NULL, NULL, 0, NULL, NULL),
(2334, 747.00, 'Random Game', 'GAME-196', 'User-995', '4f664653-85be-471d-bf39-53a36813fb52', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:39:07', NULL, NULL, 0, NULL, NULL),
(2335, 867.00, 'Random Game', 'GAME-881', 'User-868', '8f4f353c-c009-4c63-8989-7ad8c2051ee9', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:40:07', NULL, NULL, 0, NULL, NULL),
(2336, 472.00, 'Random Game', 'GAME-74', 'User-219', '7646ee6c-18a5-48b9-bce0-42b285e75afc', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:41:07', NULL, NULL, 0, NULL, NULL),
(2337, 274.00, 'Random Game', 'GAME-801', 'User-57', '6bc2313b-b31a-4727-bbd9-29b80a3779b8', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:42:07', NULL, NULL, 0, NULL, NULL),
(2338, 897.00, 'Random Game', 'GAME-692', 'User-938', '735024a9-52f0-4f2c-b6d6-14de227c9adb', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:43:07', NULL, NULL, 0, NULL, NULL),
(2339, 57.00, 'Random Game', 'GAME-429', 'User-815', '10ba0332-a718-4947-8c29-730eeef616e6', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:44:07', NULL, NULL, 0, NULL, NULL),
(2340, 161.00, 'Random Game', 'GAME-375', 'User-618', 'f405ab79-3f3d-4c42-b499-0b187580f889', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:45:07', NULL, NULL, 0, NULL, NULL),
(2341, 854.00, 'Random Game', 'GAME-473', 'User-412', '23c428f7-ecf2-4d30-985d-73ee5bfca232', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:46:07', NULL, NULL, 0, NULL, NULL),
(2342, 800.00, 'Random Game', 'GAME-941', 'User-30', '60c82213-b04e-4e74-9c46-d2d938042595', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:47:07', NULL, NULL, 0, NULL, NULL),
(2343, 565.00, 'Random Game', 'GAME-734', 'User-736', '9aa0ea13-2553-4f27-82ff-e1c184617d38', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:48:07', NULL, NULL, 0, NULL, NULL),
(2344, 969.00, 'Random Game', 'GAME-171', 'User-821', '4f757592-a971-4fc5-87f2-51e854447ab4', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:49:07', NULL, NULL, 0, NULL, NULL),
(2345, 702.00, 'Random Game', 'GAME-917', 'User-685', '5f08d5de-23d2-47a9-afd1-d06064816acf', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:50:07', NULL, NULL, 0, NULL, NULL),
(2346, 628.00, 'Random Game', 'GAME-225', 'User-302', '162da0ca-aa80-4199-908d-7653c4d3338a', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:51:07', NULL, NULL, 0, NULL, NULL),
(2347, 562.00, 'Random Game', 'GAME-743', 'User-673', '27d4f2ab-156c-4b07-a7e8-ea77e046a2ef', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:52:07', NULL, NULL, 0, NULL, NULL),
(2348, 817.00, 'Random Game', 'GAME-778', 'User-517', 'f0f1d033-b248-4e5a-9be0-c3a44a9ad81a', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:53:07', NULL, NULL, 0, NULL, NULL),
(2349, 222.00, 'Random Game', 'GAME-830', 'User-465', 'c2d651ec-773c-425d-9029-d8d1833ab36b', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:54:07', NULL, NULL, 0, NULL, NULL),
(2350, 439.00, 'Random Game', 'GAME-185', 'User-721', 'c9480abc-24d0-4430-8dd2-e014eeb7dba4', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:55:07', NULL, NULL, 0, NULL, NULL),
(2351, 636.00, 'Random Game', 'GAME-888', 'User-890', '3a682eb9-8498-4222-89de-95f2acefc838', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:56:07', NULL, NULL, 0, NULL, NULL),
(2352, 71.00, 'Random Game', 'GAME-989', 'User-177', '6a7c2f85-d507-440a-b0c9-21dfb00f6cca', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:57:07', NULL, NULL, 0, NULL, NULL),
(2353, 298.00, 'Random Game', 'GAME-915', 'User-211', '59f86fad-83c7-4a2e-b578-7bd42cd8893a', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:58:07', NULL, NULL, 0, NULL, NULL),
(2354, 458.00, 'Random Game', 'GAME-55', 'User-106', '0acfaa54-5c1b-4635-8f20-d4ad732d53e0', 19, 'pending_validation', NULL, NULL, '2025-04-09 20:59:07', NULL, NULL, 0, NULL, NULL),
(2355, 245.00, 'Random Game', 'GAME-975', 'User-922', '0a9b0cff-5297-423f-8b83-84103c4f5225', 19, 'pending_validation', NULL, NULL, '2025-04-09 21:00:07', NULL, NULL, 0, NULL, NULL),
(2356, 1041.00, 'Random Game', 'GAME-306', 'User-338', '5f77daac-e48f-45bc-9357-45b53db9a5d8', 19, 'pending_validation', NULL, NULL, '2025-04-09 21:01:07', NULL, NULL, 0, NULL, NULL),
(2357, 127.00, 'Random Game', 'GAME-177', 'User-818', '58f6c153-966d-4503-bcf6-059074b7cc2e', 19, 'pending_validation', NULL, NULL, '2025-04-09 21:02:07', NULL, NULL, 0, NULL, NULL),
(2358, 373.00, 'Random Game', 'GAME-930', 'User-22', '57832563-aa24-42f5-b437-d337c608c5ff', 19, 'pending_validation', NULL, NULL, '2025-04-09 21:03:07', NULL, NULL, 0, NULL, NULL),
(2359, 936.00, 'Random Game', 'GAME-733', 'User-494', '8946b7cc-6dfb-4db8-91e7-a32668710a64', 19, 'pending_validation', NULL, NULL, '2025-04-10 06:35:26', NULL, NULL, 0, NULL, NULL),
(2360, 351.00, 'Random Game', 'GAME-486', 'User-317', '64d1df99-3107-4a4c-80be-ee12cc64f09f', 19, 'pending_validation', NULL, NULL, '2025-04-10 06:35:26', NULL, NULL, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fulfillers`
--

CREATE TABLE `fulfillers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `payment_methods` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fulfiller_metrics`
--

CREATE TABLE `fulfiller_metrics` (
  `id` int(11) NOT NULL,
  `fulfiller_id` int(11) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `tickets_completed` int(11) DEFAULT 0,
  `average_completion_time` int(11) DEFAULT 0,
  `error_rate` decimal(5,2) DEFAULT 0.00,
  `timestamp` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fulfillment_groups`
--

CREATE TABLE `fulfillment_groups` (
  `id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `capacity` int(11) NOT NULL DEFAULT 10,
  `status` varchar(20) DEFAULT 'active'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_history`
--

CREATE TABLE `password_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_policy`
--

CREATE TABLE `password_policy` (
  `id` int(11) NOT NULL DEFAULT 1,
  `min_length` int(11) NOT NULL DEFAULT 8,
  `require_uppercase` tinyint(1) NOT NULL DEFAULT 1,
  `require_lowercase` tinyint(1) NOT NULL DEFAULT 1,
  `require_number` tinyint(1) NOT NULL DEFAULT 1,
  `require_special` tinyint(1) NOT NULL DEFAULT 1,
  `expiry_days` int(11) NOT NULL DEFAULT 90,
  `password_history` int(11) NOT NULL DEFAULT 3,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_requests`
--

CREATE TABLE `password_reset_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `request_date` timestamp NULL DEFAULT current_timestamp(),
  `reset_expiry` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'account_creation', 'Can create new user accounts', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(2, 'group_capacity_settings', 'Can manage fulfillment group capacity', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(3, 'dynamic_slot_allocation', 'Can manage dynamic slot allocation', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(4, 'telegram_bot_admin', 'Can administer Telegram bot settings', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(5, 'account_balance_credit', 'Can load credit to user accounts', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(6, 'user_group_troubleshooting', 'Can troubleshoot user group issues', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(7, 'fulfillment_group_manager', 'Can manage fulfillment groups', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(8, 'status_reporter', 'Can access status reports', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(9, 'message_dispatcher', 'Can dispatch messages', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(10, 'alert_management', 'Can manage system alerts', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(11, 'fulfiller_analytics', 'Can access fulfiller analytics', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(12, 'order_queue_view', 'Can view order queue', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(13, 'batch_quantities', 'Can manage batch quantities', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(14, 'image_upload', 'Can upload images', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(15, 'ticket_completion', 'Can complete tickets', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(16, 'transaction_history', 'Can view own transaction history', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(17, 'account_balance', 'Can view own account balance', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(18, 'reset_own_password', 'Can reset own password', '2025-02-28 03:47:57', '2025-02-28 03:47:57'),
(19, 'reset_user_password', 'Can reset user passwords', '2025-02-28 03:47:57', '2025-02-28 03:47:57'),
(20, 'reset_fulfiller_password', 'Can reset fulfiller passwords', '2025-02-28 03:47:57', '2025-02-28 03:47:57');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'master_admin', 'Master administrator with full system access', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(2, 'admin', 'Administrator with management access', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(3, 'fulfiller', 'Ticket fulfillment staff', '2025-02-28 01:12:25', '2025-02-28 01:12:25'),
(4, 'user', 'Regular system user', '2025-02-28 01:12:25', '2025-02-28 01:12:25');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`, `created_at`) VALUES
(1, 1, '2025-02-28 01:12:25'),
(1, 2, '2025-02-28 01:12:25'),
(1, 3, '2025-02-28 01:12:25'),
(1, 4, '2025-02-28 01:12:25'),
(1, 5, '2025-02-28 01:12:25'),
(1, 6, '2025-02-28 01:12:25'),
(1, 7, '2025-02-28 01:12:25'),
(1, 8, '2025-02-28 01:12:25'),
(1, 9, '2025-02-28 01:12:25'),
(1, 10, '2025-02-28 01:12:25'),
(1, 11, '2025-02-28 01:12:25'),
(1, 12, '2025-02-28 01:12:25'),
(1, 13, '2025-02-28 01:12:25'),
(1, 14, '2025-02-28 01:12:25'),
(1, 15, '2025-02-28 01:12:25'),
(1, 16, '2025-02-28 01:12:25'),
(1, 17, '2025-02-28 01:12:25'),
(2, 5, '2025-02-28 01:12:25'),
(2, 6, '2025-02-28 01:12:25'),
(2, 7, '2025-02-28 01:12:25'),
(2, 8, '2025-02-28 01:12:25'),
(2, 9, '2025-02-28 01:12:25'),
(2, 10, '2025-02-28 01:12:25'),
(2, 11, '2025-02-28 01:12:25'),
(2, 12, '2025-02-28 01:12:25'),
(2, 13, '2025-02-28 01:12:25'),
(2, 14, '2025-02-28 01:12:25'),
(2, 15, '2025-02-28 01:12:25'),
(2, 16, '2025-02-28 01:12:25'),
(2, 17, '2025-02-28 01:12:25'),
(3, 17, '2025-02-28 01:12:25'),
(3, 13, '2025-02-28 01:12:25'),
(3, 14, '2025-02-28 01:12:25'),
(3, 12, '2025-02-28 01:12:25'),
(3, 15, '2025-02-28 01:12:25'),
(3, 16, '2025-02-28 01:12:25'),
(4, 17, '2025-02-28 01:12:25'),
(4, 16, '2025-02-28 01:12:25'),
(3, 18, '2025-02-28 03:47:57'),
(4, 18, '2025-02-28 03:47:57'),
(1, 20, '2025-02-28 03:47:57'),
(2, 20, '2025-02-28 03:47:57'),
(1, 18, '2025-02-28 03:47:57'),
(2, 18, '2025-02-28 03:47:57'),
(1, 19, '2025-02-28 03:47:57'),
(2, 19, '2025-02-28 03:47:57');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` text NOT NULL,
  `last_activity` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_metrics`
--

CREATE TABLE `system_metrics` (
  `id` int(11) NOT NULL,
  `metric_name` varchar(50) NOT NULL,
  `metric_value` decimal(10,2) NOT NULL,
  `timestamp` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `domain_id` int(11) DEFAULT NULL,
  `facebook_name` varchar(255) DEFAULT NULL,
  `ticket_id` varchar(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `payment_tag` varchar(255) DEFAULT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `game` varchar(255) DEFAULT NULL,
  `game_id` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'new',
  `chat_group_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `completion_time` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `completed_by` int(11) DEFAULT NULL,
  `error_type` varchar(50) DEFAULT NULL,
  `error_details` text DEFAULT NULL,
  `error_reported_at` timestamp NULL DEFAULT NULL,
  `error_reported_by` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `domain_id`, `facebook_name`, `ticket_id`, `user_id`, `payment_method`, `payment_tag`, `account_name`, `amount`, `game`, `game_id`, `image_path`, `status`, `chat_group_id`, `created_at`, `completion_time`, `completed_at`, `completed_by`, `error_type`, `error_details`, `error_reported_at`, `error_reported_by`) VALUES
(1, 1, 'do you see this david hyung', '11-1741415084-2G65', 0, 'CashApp', '@bootymuncher', 'booty muncher', 100.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741415084-2G65_1741415084.jpg', 'sent', '-1002324697837', '2025-03-08 06:24:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 1, 'do you see this david hyung', '11-1741415593-XRWO', 0, 'CashApp', '@bootymuncher', 'im cookin', 2.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741415593-XRWO_1741415593.jpg', 'sent', '-1002324697837', '2025-03-08 06:33:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 1, 'DO YOU SEE THIS', '11-1741417086-HZBR', 0, 'CashApp', 'AAAAAAAAAH', 'IM COOKIN', 12312.00, 'Golden Dragon', 'aaaaaaa', '/uploads/tickets/11s_tapsndr_com/11-1741417086-HZBR_1741417086.png', 'new', '-1002324697837', '2025-03-08 06:58:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 1, 'do you see this david hyung', '11-1741417144-NXY6', 0, 'CashApp', '@bootymuncher', 'booty muncher', 100.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741417144-NXY6_1741417144.png', 'new', '-1002324697837', '2025-03-08 06:59:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 1, 'do you see this david hyung', '11-1741418728-X17V', 0, 'CashApp', '@bootymuncher', 'booty muncher', 2.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741418728-X17V_1741418728.png', 'new', '-1002324697837', '2025-03-08 07:25:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 1, 'do you see this david hyung', '11-1741419051-WGR6', 0, 'CashApp', '@bootymuncher', 'booty muncher', 100.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741419051-WGR6_1741419051.png', 'new', '-1002324697837', '2025-03-08 07:30:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 1, 'adgasdgasdg', '11-1741419629-KEQS', 0, 'CashApp', '@bootymuncher', 'booty muncher', 123123.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741419629-KEQS_1741419629.png', 'new', '-1002324697837', '2025-03-08 07:40:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, 1, 'a', '11-1741420051-MQIN', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741420051-MQIN_1741420051.png', 'declined', '-1002324697837', '2025-03-08 07:47:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 1, 'a', '11-1741420054-NR6A', 18, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', 'https://example.com/payment/123456.jpg', 'completed', '-1002324697837', '2025-03-08 07:47:34', NULL, '2025-04-03 18:31:04', 19, NULL, NULL, NULL, NULL),
(10, 1, 'a', '11-1741420574-5ZHX', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', '1', '/uploads/tickets/11s_tapsndr_com/11-1741420574-5ZHX_1741420574.jpg', 'validated', '-1002324697837', '2025-03-08 07:56:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 1, 'a', '11-1741420788-AUFX', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741420788-AUFX_1741420788.png', 'declined', '-1002324697837', '2025-03-08 07:59:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 1, 'a', '11-1741421314-OYUR', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741421314-OYUR_1741421314.png', 'validated', '-1002324697837', '2025-03-08 08:08:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 1, 'a', '11-1741421754-4276', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741421754-4276_1741421754.png', 'declined', '-1002324697837', '2025-03-08 08:15:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 1, 'a', '11-1741422746-H4CR', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741422746-H4CR_1741422746.png', 'declined', '-1002324697837', '2025-03-08 08:32:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 1, 'a', '11-1741423112-67HE', 0, 'Zelle', 'a', 'a', 2.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741423112-67HE_1741423112.png', 'new', '-1002324697837', '2025-03-08 08:38:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 1, 'a', '11-1741424065-CSIO', 0, 'CashApp', 'a', 'a', 3.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741424065-CSIO_1741424065.png', 'validated', '-1002324697837', '2025-03-08 08:54:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 1, 'test test', '11-1741427776-UDFT', 0, 'Venmo', '@bootymuncher', 'booty muncher', 50.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741427776-UDFT_1741427776.png', 'new', '-1002324697837', '2025-03-08 09:56:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(18, 1, 'test test', '11-1741481315-AI01', 0, 'Venmo', '@bootymuncher', 'booty muncher', 50.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741481315-AI01_1741481315.png', 'completed', '-1002324697837', '2025-03-09 00:48:36', NULL, '2025-03-10 06:41:30', 16, NULL, NULL, NULL, NULL),
(19, 1, 'testing new api #1', '11-1741482859-ZU2S', 0, 'CashApp', 'testing new api #1', 'testing new api #1', 123.00, 'Golden Dragon', 'testing new api #1', '/uploads/tickets/11s_tapsndr_com/11-1741482859-ZU2S_1741482859.png', 'declined', '-1002324697837', '2025-03-09 01:14:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 1, 'testing new api #2', '11-1741484366-3OKU', 0, 'CashApp', 'testing new api #2', 'testing new api #2', 456.00, 'Golden Dragon', 'testing new api #2', '/uploads/tickets/11s_tapsndr_com/11-1741484366-3OKU_1741484366.png', 'error', '-1002324697837', '2025-03-09 01:39:26', NULL, NULL, NULL, 'INVALID_PAYMENT', 'Payment details don\'t match', '2025-03-10 06:41:47', 16),
(33, 3, 'c', 'DD-1741584554-F6TA', 0, 'Venmo', 'c', 'c', 3.00, 'Golden Dragon', 'c', '/uploads/tickets/dds_tapsndr_com/DD-1741584554-F6TA_1741584554.jpg', 'error', '-4750875832', '2025-03-10 05:29:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32, 3, 'b', 'DD-1741584486-QU6W', 0, 'CashApp', 'b', 'b', 2.00, 'Golden Dragon', 'b', '/uploads/tickets/dds_tapsndr_com/DD-1741584486-QU6W_1741584486.jpg', 'error', '-4750875832', '2025-03-10 05:28:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31, 1, 'a', '11-1741584436-7ZXL', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741584436-7ZXL_1741584436.jpg', 'completed', '-1002324697837', '2025-03-10 05:27:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 3, 'a', 'DD-1741591197-2P7G', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/dds_tapsndr_com/DD-1741591197-2P7G_1741591197.jpg', 'completed', '-4750875832', '2025-03-10 07:19:57', NULL, '2025-03-10 07:20:20', 16, NULL, NULL, NULL, NULL),
(35, 3, 'a', 'DD-1741591380-CWK6', 0, 'Venmo', 'a', 'a', 1.00, 'Magic City', 'a', '/uploads/tickets/dds_tapsndr_com/DD-1741591380-CWK6_1741591380.jpg', 'completed', '-4750875832', '2025-03-10 07:23:00', NULL, '2025-03-10 07:23:28', 16, NULL, NULL, NULL, NULL),
(36, 3, 'a', 'DD-1741593582-8GDN', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/dds_tapsndr_com/DD-1741593582-8GDN_1741593582.jpg', 'completed', '-4750875832', '2025-03-10 07:59:42', NULL, '2025-03-10 08:00:07', 16, NULL, NULL, NULL, NULL),
(37, 18, 'John Doe', 'c64ff434-7f35-4cff-9', 18, 'GCash', 'GCASH123', 'aaa', 100.50, 'Mobile Legends', 'ML123456', 'https://example.com/payment/123456.jpg', 'completed', '18', '2025-04-04 00:08:58', NULL, '2025-04-03 18:18:19', 19, NULL, NULL, NULL, NULL),
(38, 19, 'Test User', 'a7091215-7729-41cc-8', 19, 'CashApp', 'RICCKH', 'Test Account', 627.00, 'Test Game', 'RICCKH', 'https://example.com/qr.jpg', 'new', '19', '2025-04-09 04:20:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `transaction_type` enum('credit','debit') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `reference_id` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `user_id`, `transaction_type`, `amount`, `description`, `reference_id`, `created_at`) VALUES
(7, 19, 'credit', 3.01, 'Fulfiller fee', 'c64ff434-7f35-4cff-9', '2025-04-04 03:18:19'),
(8, 18, '', 1.01, 'Owner fee', 'c64ff434-7f35-4cff-9', '2025-04-04 03:18:19'),
(15, 19, 'credit', 0.03, 'Fulfiller fee', '11-1741420054-NR6A', '2025-04-04 03:31:04'),
(16, 18, '', 0.01, 'Owner fee', '11-1741420054-NR6A', '2025-04-04 03:31:04'),
(21, 19, '', 345.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:20:32'),
(22, 19, '', 345.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:20:32'),
(23, 19, '', 123.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:22:15'),
(24, 19, '', 123.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:22:15'),
(25, 19, '', 45.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:23:15'),
(26, 19, '', 44.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:23:28'),
(27, 19, '', 34.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:25:43'),
(28, 18, '', 433.00, 'Withdrawal from USDT wallet', NULL, '2025-04-04 14:29:33'),
(29, 19, 'credit', 3.93, 'Fulfiller fee', 'd3f95564-7f9d-42ea-a', '2025-04-09 18:35:13'),
(30, 19, '', 1.31, 'Owner fee', 'd3f95564-7f9d-42ea-a', '2025-04-09 18:35:13'),
(31, 19, 'credit', 31.08, 'Fulfiller fee', '0d27bb0e-23c7-419f-a', '2025-04-09 18:52:38'),
(32, 19, '', 10.36, 'Owner fee', '0d27bb0e-23c7-419f-a', '2025-04-09 18:52:38'),
(33, 19, 'credit', 19.80, 'Fulfiller fee', '46e6bf78-bacc-4251-b', '2025-04-09 19:02:28'),
(34, 19, '', 6.60, 'Owner fee', '46e6bf78-bacc-4251-b', '2025-04-09 19:02:28'),
(35, 19, 'credit', 23.55, 'Fulfiller fee', 'cba1108c-1238-48a8-a', '2025-04-09 19:02:56'),
(36, 19, '', 7.85, 'Owner fee', 'cba1108c-1238-48a8-a', '2025-04-09 19:02:56'),
(37, 19, 'credit', 22.47, 'Fulfiller fee', '00dd82b4-a42f-4c66-8', '2025-04-09 19:03:53'),
(38, 19, '', 7.49, 'Owner fee', '00dd82b4-a42f-4c66-8', '2025-04-09 19:03:53'),
(39, 19, 'credit', 26.64, 'Fulfiller fee', '7ace5c83-b8e8-430e-a', '2025-04-09 19:04:39'),
(40, 19, '', 8.88, 'Owner fee', '7ace5c83-b8e8-430e-a', '2025-04-09 19:04:39'),
(41, 19, 'credit', 4.02, 'Fulfiller fee', '49612c9c-645a-4699-9', '2025-04-09 19:10:03'),
(42, 19, '', 1.34, 'Owner fee', '49612c9c-645a-4699-9', '2025-04-09 19:10:03'),
(43, 19, 'credit', 31.02, 'Fulfiller fee', 'ee47ec5c-8a82-4b6b-a', '2025-04-09 19:13:54'),
(44, 19, '', 10.34, 'Owner fee', 'ee47ec5c-8a82-4b6b-a', '2025-04-09 19:13:54'),
(45, 19, 'credit', 18.30, 'Fulfiller fee', 'f3ca2ddc-9422-4f9d-b', '2025-04-09 19:15:31'),
(46, 19, '', 6.10, 'Owner fee', 'f3ca2ddc-9422-4f9d-b', '2025-04-09 19:15:31'),
(47, 19, 'credit', 20.64, 'Fulfiller fee', '14e807ae-bcaa-4911-9', '2025-04-09 19:17:52'),
(48, 19, '', 6.88, 'Owner fee', '14e807ae-bcaa-4911-9', '2025-04-09 19:17:52'),
(49, 19, 'credit', 6.24, 'Fulfiller fee', '7900e9db-7206-4e99-8', '2025-04-09 19:21:46'),
(50, 19, '', 2.08, 'Owner fee', '7900e9db-7206-4e99-8', '2025-04-09 19:21:46'),
(51, 19, 'credit', 15.15, 'Fulfiller fee', '15e16e9a-3ace-460b-9', '2025-04-09 19:21:52'),
(52, 19, '', 5.05, 'Owner fee', '15e16e9a-3ace-460b-9', '2025-04-09 19:21:52'),
(53, 19, 'credit', 3.15, 'Fulfiller fee', 'd327374a-d58c-4beb-9', '2025-04-09 19:23:15'),
(54, 19, '', 1.05, 'Owner fee', 'd327374a-d58c-4beb-9', '2025-04-09 19:23:15'),
(55, 19, 'credit', 29.28, 'Fulfiller fee', '17a07b91-d971-4e95-8', '2025-04-09 19:23:51'),
(56, 19, '', 9.76, 'Owner fee', '17a07b91-d971-4e95-8', '2025-04-09 19:23:51'),
(57, 19, 'credit', 11.52, 'Fulfiller fee', '5041aab2-aa37-4555-a', '2025-04-09 19:23:52'),
(58, 19, '', 3.84, 'Owner fee', '5041aab2-aa37-4555-a', '2025-04-09 19:23:52'),
(59, 19, 'credit', 22.80, 'Fulfiller fee', '8aecc901-426f-499c-9', '2025-04-09 19:24:01'),
(60, 19, '', 7.60, 'Owner fee', '8aecc901-426f-499c-9', '2025-04-09 19:24:01'),
(61, 19, 'credit', 26.46, 'Fulfiller fee', 'b453b282-fcb5-4a7f-8', '2025-04-09 19:24:28'),
(62, 19, '', 8.82, 'Owner fee', 'b453b282-fcb5-4a7f-8', '2025-04-09 19:24:28'),
(63, 19, 'credit', 15.06, 'Fulfiller fee', '01dd50d4-8df5-4d61-a', '2025-04-09 19:32:15'),
(64, 19, '', 5.02, 'Owner fee', '01dd50d4-8df5-4d61-a', '2025-04-09 19:32:15'),
(65, 19, 'credit', 26.49, 'Fulfiller fee', '33d9025b-cbdb-48ed-8', '2025-04-09 19:32:30'),
(66, 19, '', 8.83, 'Owner fee', '33d9025b-cbdb-48ed-8', '2025-04-09 19:32:30'),
(67, 19, 'credit', 12.60, 'Fulfiller fee', '90314c28-f893-44be-a', '2025-04-09 19:33:39'),
(68, 19, '', 4.20, 'Owner fee', '90314c28-f893-44be-a', '2025-04-09 19:33:39'),
(69, 19, 'credit', 5.37, 'Fulfiller fee', '70c896b6-4b8e-40b9-b', '2025-04-09 19:33:42'),
(70, 19, '', 1.79, 'Owner fee', '70c896b6-4b8e-40b9-b', '2025-04-09 19:33:42'),
(71, 19, 'credit', 13.11, 'Fulfiller fee', '07ea819c-0e47-437a-a', '2025-04-09 19:34:36'),
(72, 19, '', 4.37, 'Owner fee', '07ea819c-0e47-437a-a', '2025-04-09 19:34:36'),
(73, 19, 'credit', 10.71, 'Fulfiller fee', '21f28b75-a4a5-43b9-b', '2025-04-09 19:36:05'),
(74, 19, '', 3.57, 'Owner fee', '21f28b75-a4a5-43b9-b', '2025-04-09 19:36:05'),
(75, 19, 'credit', 30.75, 'Fulfiller fee', '5c1cdc43-74f7-461a-a', '2025-04-09 19:36:50'),
(76, 19, '', 10.25, 'Owner fee', '5c1cdc43-74f7-461a-a', '2025-04-09 19:36:50'),
(77, 19, 'credit', 25.26, 'Fulfiller fee', '67c08111-2c71-4f51-9', '2025-04-09 19:38:03'),
(78, 19, '', 8.42, 'Owner fee', '67c08111-2c71-4f51-9', '2025-04-09 19:38:03'),
(79, 19, 'credit', 11.43, 'Fulfiller fee', 'e9c7afac-6b34-474f-9', '2025-04-09 19:38:48'),
(80, 19, '', 3.81, 'Owner fee', 'e9c7afac-6b34-474f-9', '2025-04-09 19:38:48'),
(81, 19, 'credit', 6.48, 'Fulfiller fee', 'a89ac1d4-9550-425f-a', '2025-04-09 19:39:53'),
(82, 19, '', 2.16, 'Owner fee', 'a89ac1d4-9550-425f-a', '2025-04-09 19:39:53'),
(83, 19, 'credit', 25.92, 'Fulfiller fee', '6cdebbf0-7e33-4143-9', '2025-04-09 19:40:44'),
(84, 19, '', 8.64, 'Owner fee', '6cdebbf0-7e33-4143-9', '2025-04-09 19:40:44'),
(85, 19, 'credit', 17.07, 'Fulfiller fee', '76dd2f43-baaf-4654-a', '2025-04-09 19:42:09'),
(86, 19, '', 5.69, 'Owner fee', '76dd2f43-baaf-4654-a', '2025-04-09 19:42:09'),
(87, 19, 'credit', 3.99, 'Fulfiller fee', '080778a9-7a4a-4af8-a', '2025-04-09 19:43:13'),
(88, 19, '', 1.33, 'Owner fee', '080778a9-7a4a-4af8-a', '2025-04-09 19:43:13'),
(89, 19, 'credit', 28.20, 'Fulfiller fee', '5215cf21-a196-4a39-a', '2025-04-09 19:45:00'),
(90, 19, '', 9.40, 'Owner fee', '5215cf21-a196-4a39-a', '2025-04-09 19:45:00'),
(91, 19, 'credit', 27.36, 'Fulfiller fee', '45119b9b-824d-4afd-a', '2025-04-09 19:46:46'),
(92, 19, '', 9.12, 'Owner fee', '45119b9b-824d-4afd-a', '2025-04-09 19:46:46'),
(93, 19, 'credit', 20.70, 'Fulfiller fee', '7c82537e-ec9c-48bf-a', '2025-04-09 19:47:43'),
(94, 19, '', 6.90, 'Owner fee', '7c82537e-ec9c-48bf-a', '2025-04-09 19:47:43'),
(95, 19, 'credit', 12.30, 'Fulfiller fee', '2b0a344f-b024-4ae5-b', '2025-04-09 19:47:43'),
(96, 19, '', 4.10, 'Owner fee', '2b0a344f-b024-4ae5-b', '2025-04-09 19:47:43'),
(97, 19, 'credit', 5.52, 'Fulfiller fee', '41cd3da7-7b2d-4c0a-8', '2025-04-09 19:48:49'),
(98, 19, '', 1.84, 'Owner fee', '41cd3da7-7b2d-4c0a-8', '2025-04-09 19:48:49'),
(99, 19, 'credit', 13.89, 'Fulfiller fee', '00826397-db74-47dc-9', '2025-04-09 19:48:52'),
(100, 19, '', 4.63, 'Owner fee', '00826397-db74-47dc-9', '2025-04-09 19:48:52'),
(101, 19, 'credit', 22.86, 'Fulfiller fee', 'b1724575-951c-4500-9', '2025-04-09 19:48:58'),
(102, 19, '', 7.62, 'Owner fee', 'b1724575-951c-4500-9', '2025-04-09 19:48:58'),
(103, 19, 'credit', 4.80, 'Fulfiller fee', 'f343ba27-1e8b-4db1-b', '2025-04-09 19:49:01'),
(104, 19, '', 1.60, 'Owner fee', 'f343ba27-1e8b-4db1-b', '2025-04-09 19:49:01'),
(105, 19, 'credit', 24.36, 'Fulfiller fee', '113ff072-cd63-4b86-9', '2025-04-09 19:49:07'),
(106, 19, '', 8.12, 'Owner fee', '113ff072-cd63-4b86-9', '2025-04-09 19:49:07'),
(107, 19, 'credit', 12.81, 'Fulfiller fee', '66e28001-3a47-47dd-a', '2025-04-09 19:50:04'),
(108, 19, '', 4.27, 'Owner fee', '66e28001-3a47-47dd-a', '2025-04-09 19:50:04'),
(109, 19, 'credit', 1.95, 'Fulfiller fee', '434fe4fc-506e-4914-8', '2025-04-09 19:50:22'),
(110, 19, '', 0.65, 'Owner fee', '434fe4fc-506e-4914-8', '2025-04-09 19:50:22'),
(111, 19, 'credit', 23.55, 'Fulfiller fee', '79210835-455a-4501-a', '2025-04-09 19:51:04'),
(112, 19, '', 7.85, 'Owner fee', '79210835-455a-4501-a', '2025-04-09 19:51:04'),
(113, 19, 'credit', 12.18, 'Fulfiller fee', '6d75e3bc-ae2d-4544-b', '2025-04-09 19:51:22'),
(114, 19, '', 4.06, 'Owner fee', '6d75e3bc-ae2d-4544-b', '2025-04-09 19:51:22'),
(115, 19, 'credit', 22.68, 'Fulfiller fee', 'f7635055-ad43-4e18-b', '2025-04-09 19:51:46'),
(116, 19, '', 7.56, 'Owner fee', 'f7635055-ad43-4e18-b', '2025-04-09 19:51:46'),
(117, 19, 'credit', 25.05, 'Fulfiller fee', '523d5c4b-4d77-4952-a', '2025-04-09 19:51:53'),
(118, 19, '', 8.35, 'Owner fee', '523d5c4b-4d77-4952-a', '2025-04-09 19:51:53'),
(119, 19, 'credit', 14.58, 'Fulfiller fee', 'd4072229-f0ee-4220-9', '2025-04-09 19:52:01'),
(120, 19, '', 4.86, 'Owner fee', 'd4072229-f0ee-4220-9', '2025-04-09 19:52:01'),
(121, 19, 'credit', 17.82, 'Fulfiller fee', 'f26486f0-c826-42bb-9', '2025-04-09 19:52:12'),
(122, 19, '', 5.94, 'Owner fee', 'f26486f0-c826-42bb-9', '2025-04-09 19:52:12'),
(123, 19, 'credit', 8.91, 'Fulfiller fee', 'c8fcb2fc-caeb-454b-b', '2025-04-09 19:52:33'),
(124, 19, '', 2.97, 'Owner fee', 'c8fcb2fc-caeb-454b-b', '2025-04-09 19:52:33'),
(125, 19, 'credit', 11.46, 'Fulfiller fee', '5bbfe426-b9cb-492a-a', '2025-04-09 19:53:56'),
(126, 19, '', 3.82, 'Owner fee', '5bbfe426-b9cb-492a-a', '2025-04-09 19:53:56'),
(127, 19, 'credit', 13.95, 'Fulfiller fee', '08042779-dab9-42ea-9', '2025-04-09 19:54:23'),
(128, 19, '', 4.65, 'Owner fee', '08042779-dab9-42ea-9', '2025-04-09 19:54:23'),
(129, 19, 'credit', 20.31, 'Fulfiller fee', '10324fe5-4427-4869-b', '2025-04-09 19:59:27'),
(130, 19, '', 6.77, 'Owner fee', '10324fe5-4427-4869-b', '2025-04-09 19:59:27'),
(131, 19, 'credit', 20.85, 'Fulfiller fee', 'd919c77c-41e0-4f4f-b', '2025-04-09 19:59:29'),
(132, 19, '', 6.95, 'Owner fee', 'd919c77c-41e0-4f4f-b', '2025-04-09 19:59:29'),
(133, 19, 'credit', 29.52, 'Fulfiller fee', '8a7ee988-8d8f-47d3-8', '2025-04-09 19:59:31'),
(134, 19, '', 9.84, 'Owner fee', '8a7ee988-8d8f-47d3-8', '2025-04-09 19:59:31'),
(135, 19, 'credit', 30.81, 'Fulfiller fee', '1d6d1e5d-9d2d-42e9-a', '2025-04-09 19:59:41'),
(136, 19, '', 10.27, 'Owner fee', '1d6d1e5d-9d2d-42e9-a', '2025-04-09 19:59:41'),
(137, 19, 'credit', 13.77, 'Fulfiller fee', '0edb9666-e789-478b-9', '2025-04-09 20:00:58'),
(138, 19, '', 4.59, 'Owner fee', '0edb9666-e789-478b-9', '2025-04-09 20:00:58'),
(139, 19, 'credit', 24.33, 'Fulfiller fee', '1591d618-8c9f-4b29-b', '2025-04-09 20:01:00'),
(140, 19, '', 8.11, 'Owner fee', '1591d618-8c9f-4b29-b', '2025-04-09 20:01:00'),
(141, 19, 'credit', 8.40, 'Fulfiller fee', '791c5985-35ae-4856-b', '2025-04-09 20:01:04'),
(142, 19, '', 2.80, 'Owner fee', '791c5985-35ae-4856-b', '2025-04-09 20:01:04'),
(143, 19, 'credit', 18.72, 'Fulfiller fee', '4647e6e1-5cb5-4034-8', '2025-04-09 20:01:18'),
(144, 19, '', 6.24, 'Owner fee', '4647e6e1-5cb5-4034-8', '2025-04-09 20:01:18'),
(145, 19, 'credit', 11.34, 'Fulfiller fee', 'ed980df0-5b2b-49e1-a', '2025-04-09 20:01:48'),
(146, 19, '', 3.78, 'Owner fee', 'ed980df0-5b2b-49e1-a', '2025-04-09 20:01:48'),
(147, 19, 'credit', 27.96, 'Fulfiller fee', '54ea9e05-2e66-4d66-9', '2025-04-09 20:02:08'),
(148, 19, '', 9.32, 'Owner fee', '54ea9e05-2e66-4d66-9', '2025-04-09 20:02:08'),
(149, 19, 'credit', 2.19, 'Fulfiller fee', '29648204-e3d4-41c2-b', '2025-04-09 20:02:13'),
(150, 19, '', 0.73, 'Owner fee', '29648204-e3d4-41c2-b', '2025-04-09 20:02:13'),
(151, 19, 'credit', 25.50, 'Fulfiller fee', 'eac799ff-e5f8-482e-a', '2025-04-09 20:03:48'),
(152, 19, '', 8.50, 'Owner fee', 'eac799ff-e5f8-482e-a', '2025-04-09 20:03:48'),
(153, 19, 'credit', 6.84, 'Fulfiller fee', '723e2050-001d-4497-9', '2025-04-09 20:03:54'),
(154, 19, '', 2.28, 'Owner fee', '723e2050-001d-4497-9', '2025-04-09 20:03:54'),
(155, 19, 'credit', 11.79, 'Fulfiller fee', 'c8eb730f-7dfe-45ad-8', '2025-04-09 20:04:20'),
(156, 19, '', 3.93, 'Owner fee', 'c8eb730f-7dfe-45ad-8', '2025-04-09 20:04:20'),
(157, 19, 'credit', 12.03, 'Fulfiller fee', 'ce9721e2-fae3-49a1-8', '2025-04-09 20:08:38'),
(158, 19, '', 4.01, 'Owner fee', 'ce9721e2-fae3-49a1-8', '2025-04-09 20:08:38'),
(159, 19, 'credit', 1.77, 'Fulfiller fee', '2cd9f416-5626-4c47-a', '2025-04-09 20:10:53'),
(160, 19, '', 0.59, 'Owner fee', '2cd9f416-5626-4c47-a', '2025-04-09 20:10:53'),
(161, 19, 'credit', 12.81, 'Fulfiller fee', '73ddf35e-5bcb-40a3-a', '2025-04-09 20:10:59'),
(162, 19, '', 4.27, 'Owner fee', '73ddf35e-5bcb-40a3-a', '2025-04-09 20:10:59'),
(163, 19, 'credit', 25.65, 'Fulfiller fee', 'a05f7a27-863c-4ae1-a', '2025-04-09 20:11:01'),
(164, 19, '', 8.55, 'Owner fee', 'a05f7a27-863c-4ae1-a', '2025-04-09 20:11:01'),
(165, 19, 'credit', 17.37, 'Fulfiller fee', '5999b20c-2d4f-4dcf-8', '2025-04-09 20:11:23'),
(166, 19, '', 5.79, 'Owner fee', '5999b20c-2d4f-4dcf-8', '2025-04-09 20:11:23'),
(167, 19, 'credit', 14.43, 'Fulfiller fee', 'd2516d50-e70d-4610-b', '2025-04-09 20:11:52'),
(168, 19, '', 4.81, 'Owner fee', 'd2516d50-e70d-4610-b', '2025-04-09 20:11:52'),
(169, 19, 'credit', 28.08, 'Fulfiller fee', '8946b7cc-6dfb-4db8-9', '2025-04-10 06:35:57'),
(170, 19, '', 9.36, 'Owner fee', '8946b7cc-6dfb-4db8-9', '2025-04-10 06:35:57');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_activity` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `failed_login_attempts` int(11) DEFAULT 0,
  `last_login_attempt` timestamp NULL DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `created_at`, `status`, `last_login`, `updated_at`, `last_activity`, `deleted_at`, `phone`, `failed_login_attempts`, `last_login_attempt`, `password_changed_at`) VALUES
(3, 'dbdma', '', '$2y$10$g/xSffivIoqIg/IPJDRkOeHgpNyj0NEPlTIky2hc1D3mKPHd36hOC', '2025-02-28 23:47:10', 'active', '2025-03-10 13:35:18', '2025-03-10 05:35:18', NULL, NULL, NULL, 0, NULL, NULL),
(11, 'tapsndr', NULL, '$2y$10$2MekgItGYQtO.7G.F6itreJvdGX0s8jQY71dB/JgZSjOEHzwghonG', '2025-03-06 06:38:22', 'active', NULL, '2025-03-10 05:36:08', NULL, NULL, NULL, 0, NULL, NULL),
(12, 'fulfillertest', NULL, '$2y$10$1fztm5fp6BwkKBsCXXAHxO6nshOCVHRN8BydQV2I38qs78tEbu1nG', '2025-03-10 03:52:09', 'active', '2025-03-10 13:28:42', '2025-03-10 05:28:42', NULL, NULL, NULL, 0, NULL, NULL),
(13, '11snight', NULL, '$2y$10$0QE4oiiIWIW7d7Wj8QSFseu3f6Axukf2awdFzP7FL/OtwCVp7x6ri', '2025-03-10 04:39:22', 'active', NULL, '2025-03-10 04:39:22', NULL, NULL, NULL, 0, NULL, NULL),
(14, 'ddsrodeo', NULL, '$2y$10$/RDPRPnznnPsmAkCJgIl2.LfU5ocBNFGy2/1TYanuyp.aPJkrVo7m', '2025-03-10 04:39:31', 'active', NULL, '2025-03-10 04:39:31', NULL, NULL, NULL, 0, NULL, NULL),
(15, 'victoryvalley', NULL, '$2y$10$opJM/babmD4nPOgn3wbe3OP6UhjWPCdo7C2/.1fMz91/Mdry1KNFy', '2025-03-10 04:39:43', 'active', NULL, '2025-03-10 04:39:43', NULL, NULL, NULL, 0, NULL, NULL),
(16, 'fulfillertest2', NULL, '$2y$10$3Pvo.MQcGQ64xX0hhIw2He788fSLBbtNn9fAKmEIGsQCCzRKknYpS', '2025-03-10 05:37:33', 'active', '2025-03-10 13:37:52', '2025-03-10 05:37:52', NULL, NULL, NULL, 0, NULL, NULL),
(17, 'john_doed', 'john.doed@example.com', '$2b$10$cHPBOtd.fYPosOcoCCgGVet3YxEqagHVkZz6mEvb7KRHn9rnj2vR.', '2025-04-02 09:57:20', 'active', NULL, '2025-04-02 09:57:20', NULL, NULL, '+1234567890', 0, NULL, NULL),
(18, 'aaa', 'aaa@gmail.com', '$2b$10$1W9FzvuG/eM2JREaZvO.S.eqDyGHEfMle1.YTE5wY83XAnzUXAJNC', '2025-04-02 10:04:54', 'active', '2025-04-09 03:19:36', '2025-04-09 03:20:32', '2025-04-08 18:20:32', NULL, '+48727516980', 0, '2025-04-08 09:59:04', NULL),
(19, 'f', 'f@gmail.com', '$2b$10$ZFIUmxIElodT/CwQMzwNN.CpNIFe5ji8vEVuKBygWUT/c7o8Rt15S', '2025-04-02 20:20:29', 'active', '2025-04-10 06:35:21', '2025-04-10 06:35:21', '2025-04-09 21:35:21', NULL, '+48727516980', 0, '2025-04-08 18:07:40', NULL),
(20, 'test', 'test1@gmail.com', '$2b$10$3YnxVdJcKrTdDu40yo89oumSgoE4LM8bOxGZtCOtd6KoAWNbjGcXK', '2025-04-06 16:52:35', 'active', '2025-04-06 16:52:58', '2025-04-06 16:52:58', '2025-04-06 07:52:58', NULL, 'test', 0, NULL, NULL),
(21, 'admin', 'admin@gmail.com', '$2b$10$kFHMJnX.CB2Qtcshi9uDmuEKzGv12RVBz0gQkcBOGFIZC6GGpJseK', '2025-04-07 20:26:26', 'active', '2025-04-07 20:26:58', '2025-04-07 20:26:58', '2025-04-07 11:26:58', NULL, '+1234567890', 0, NULL, NULL),
(22, 'user2', 'user2@gmail.com', '$2b$10$IABH5joVYdC5pzOPrhWOSe/X8wDYgZ0QxFLem8sJvEXW8AC5aiZJW', '2025-04-07 20:28:45', 'active', '2025-04-07 20:29:49', '2025-04-07 20:29:49', '2025-04-07 11:29:49', NULL, '+1234567890', 0, NULL, NULL),
(23, 'fulfiller2', 'fulfiller2@gmail.com', '$2b$10$TPjzBNojA.JHbOAXSZesR.v0NLS6jXFgWYRV.Gs3kc8euSlZ5MBCm', '2025-04-07 20:29:02', 'active', '2025-04-07 20:29:14', '2025-04-07 20:29:14', '2025-04-07 11:29:14', NULL, '+1234567890', 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_activity_logs`
--

CREATE TABLE `user_activity_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `activity_type` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `user_activity_logs`
--
DELIMITER $$
CREATE TRIGGER `after_user_activity_insert` AFTER INSERT ON `user_activity_logs` FOR EACH ROW BEGIN
    UPDATE users 
    SET last_activity = NOW()
    WHERE id = NEW.user_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_balances`
--

CREATE TABLE `user_balances` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `balance` decimal(10,2) DEFAULT 0.00,
  `last_transaction_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`, `created_at`) VALUES
(3, 1, '2025-02-28 23:47:11'),
(11, 1, '2025-03-06 06:38:22'),
(0, 1, '2025-03-06 01:47:58'),
(16, 3, '2025-03-10 05:37:33'),
(12, 3, '2025-03-10 03:52:09'),
(13, 4, '2025-03-10 04:39:22'),
(14, 4, '2025-03-10 04:39:31'),
(15, 4, '2025-03-10 04:39:43'),
(17, 4, '2025-04-02 09:57:20'),
(18, 4, '2025-04-02 10:04:54'),
(19, 3, '2025-04-02 20:20:29'),
(20, 3, '2025-04-06 16:52:36'),
(21, 2, '2025-04-07 20:26:26'),
(22, 4, '2025-04-07 20:28:45'),
(23, 3, '2025-04-07 20:29:02');

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `private_key` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `balance` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('active','inactive','pending') NOT NULL DEFAULT 'active',
  `last_connected_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `token_type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `type`, `private_key`, `address`, `balance`, `status`, `last_connected_at`, `created_at`, `updated_at`, `token_type`) VALUES
(11, 18, 'ETH', 'fgJndfVTLwJqUcK25llyEg==:EPWB6MOKn39Uv6QW6KKl0j8GascggzDVAqQ/C1ww85R6NsaE6H6u3SsRZZIVixMxAzcpiSb1YCKw0pevsY3hbdKo:YFmgO086+QbeXh9x3ivewQ==', '0xD5a648aA624be0B84FC5Fec45A755FCD1a41A1d7', 206.50, 'active', '2025-04-05 11:20:43', '2025-04-05 20:20:43', '2025-04-09 03:20:24', 'USDT'),
(12, 19, 'ETH', 'K+eeUJ0BYeZCedT/HLa/qw==:R4p/kny85tdD+LNwkb3x2WEgPOGQ548iW7wNcu84AYQlQn81N02CTkQ0QKt9xImroc/lvzJ6PXVFedHVojxr+Mmz:J8vMx2uLXWg34/ngnWDjVA==', '0xec179A0D7b043e05b352ce9E5a1acCECE14Fdc80', 18.00, 'active', '2025-04-05 19:55:38', '2025-04-06 04:55:38', '2025-04-09 03:50:35', 'USDT'),
(13, 21, 'ETH', '0MYM727MFx35uvkMmK+KDw==:MW7yv8LDs/kXy5psp8vwJaGSDhF3frecrhiFG6iMqKE2YDiSKoLfNfVE+q4keBoybHlTw5QQvzXUhlrSw5XPPSNL:FZwB1gB5bTyBHcj/gPsuDA==', '0xf2f4fD9c41F501b79867EEE829aF5B55071659e0', 59.00, 'active', '2025-04-07 11:27:14', '2025-04-07 20:27:14', '2025-04-09 03:50:35', 'USDT'),
(14, 23, 'ETH', 'pj9vbQcFPrFlT2Q4qWefxQ==:HAPypADinhrCY12sP2g+i/z1vaqeuEAvS3ioagy5N9SJC+fvd4IPLO4NLViQaAJfCoesICTnfrdHvoCyAl2OZPQr:UoIH0OWU1M0wtlL5/kPPxw==', '0x291BFF89aDCAFdbC0BEF256F340B120613C592F1', 0.00, 'active', '2025-04-07 11:29:29', '2025-04-07 20:29:29', '2025-04-07 20:29:29', 'USDT'),
(15, 22, 'ETH', 'GVUHEnWDOunKVrX4dOo9Dg==:onkP3mUWbK6BQPzhkWr/bm5KlOiUq0DoGkxnm9dho5VKFrixOXcPW/aEANhBFiEIwwYAX+0uaQXt743LlDxT2NE9:OtCO29qwOdsiEqNwWyVMJw==', '0x8ba7A974eDee0522f6Ed124465a3FF2874572878', 0.00, 'active', '2025-04-07 11:30:03', '2025-04-07 20:30:03', '2025-04-07 20:30:03', 'USDT');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `batches`
--
ALTER TABLE `batches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_batch_id` (`batch_id`),
  ADD KEY `idx_batch_status` (`status`),
  ADD KEY `idx_batch_fulfiller` (`fulfiller_id`),
  ADD KEY `idx_batch_payment` (`payment_method`),
  ADD KEY `idx_batch_dates` (`created_at`,`completed_at`);

--
-- Indexes for table `batch_tickets`
--
ALTER TABLE `batch_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_id` (`ticket_id`),
  ADD KEY `idx_ticket_status` (`status`),
  ADD KEY `idx_ticket_batch` (`batch_id`),
  ADD KEY `idx_ticket_dates` (`assigned_at`,`completed_at`);

--
-- Indexes for table `bot_settings`
--
ALTER TABLE `bot_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `completion_images`
--
ALTER TABLE `completion_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `form_id` (`form_id`);

--
-- Indexes for table `crypto_transactions`
--
ALTER TABLE `crypto_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_transactions` (`user_id`),
  ADD KEY `idx_transaction_date` (`created_at`);

--
-- Indexes for table `csrf_tokens`
--
ALTER TABLE `csrf_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_token` (`token`),
  ADD KEY `idx_user_token` (`user_id`,`token`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `form_configurations`
--
ALTER TABLE `form_configurations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `domain_id` (`domain_id`);

--
-- Indexes for table `form_domains`
--
ALTER TABLE `form_domains`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `domain` (`domain`);

--
-- Indexes for table `form_game_options`
--
ALTER TABLE `form_game_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `domain_id` (`domain_id`);

--
-- Indexes for table `form_payment_methods`
--
ALTER TABLE `form_payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD KEY `domain_id` (`domain_id`);

--
-- Indexes for table `form_submissions`
--
ALTER TABLE `form_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status_notification` (`status`,`telegram_notification_sent`);

--
-- Indexes for table `fulfillers`
--
ALTER TABLE `fulfillers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `fulfiller_metrics`
--
ALTER TABLE `fulfiller_metrics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_fulfiller_performance` (`fulfiller_id`,`timestamp`),
  ADD KEY `idx_batch_metrics` (`batch_id`);

--
-- Indexes for table `fulfillment_groups`
--
ALTER TABLE `fulfillment_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_history`
--
ALTER TABLE `password_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `password_policy`
--
ALTER TABLE `password_policy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_requests`
--
ALTER TABLE `password_reset_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_permission_name` (`name`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_role_name` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `idx_role_permission` (`role_id`,`permission_id`),
  ADD KEY `fk_role_permissions_permission` (`permission_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_session_active` (`is_active`,`last_activity`);

--
-- Indexes for table `system_metrics`
--
ALTER TABLE `system_metrics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_metric_name` (`metric_name`),
  ADD KEY `idx_metric_date` (`timestamp`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticket_id` (`ticket_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `domain_id` (`domain_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_transactions` (`user_id`,`transaction_type`),
  ADD KEY `idx_transaction_date` (`created_at`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `idx_username` (`username`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_last_activity` (`last_activity`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- Indexes for table `user_activity_logs`
--
ALTER TABLE `user_activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_activity` (`user_id`,`activity_type`),
  ADD KEY `idx_activity_date` (`created_at`);

--
-- Indexes for table `user_balances`
--
ALTER TABLE `user_balances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_user_balance` (`user_id`),
  ADD KEY `idx_balance_update` (`updated_at`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `idx_user_role` (`user_id`,`role_id`),
  ADD KEY `fk_user_roles_role` (`role_id`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `batches`
--
ALTER TABLE `batches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `batch_tickets`
--
ALTER TABLE `batch_tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `bot_settings`
--
ALTER TABLE `bot_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `completion_images`
--
ALTER TABLE `completion_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crypto_transactions`
--
ALTER TABLE `crypto_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `csrf_tokens`
--
ALTER TABLE `csrf_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_configurations`
--
ALTER TABLE `form_configurations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_domains`
--
ALTER TABLE `form_domains`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `form_game_options`
--
ALTER TABLE `form_game_options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `form_payment_methods`
--
ALTER TABLE `form_payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `form_submissions`
--
ALTER TABLE `form_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2361;

--
-- AUTO_INCREMENT for table `fulfillers`
--
ALTER TABLE `fulfillers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fulfiller_metrics`
--
ALTER TABLE `fulfiller_metrics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fulfillment_groups`
--
ALTER TABLE `fulfillment_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_history`
--
ALTER TABLE `password_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_reset_requests`
--
ALTER TABLE `password_reset_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `system_metrics`
--
ALTER TABLE `system_metrics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2394;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=171;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `user_activity_logs`
--
ALTER TABLE `user_activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_balances`
--
ALTER TABLE `user_balances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `crypto_transactions`
--
ALTER TABLE `crypto_transactions`
  ADD CONSTRAINT `crypto_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `csrf_tokens`
--
ALTER TABLE `csrf_tokens`
  ADD CONSTRAINT `fk_csrf_tokens_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fulfiller_metrics`
--
ALTER TABLE `fulfiller_metrics`
  ADD CONSTRAINT `fk_fulfiller_metrics_batch` FOREIGN KEY (`batch_id`) REFERENCES `batches` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `password_history`
--
ALTER TABLE `password_history`
  ADD CONSTRAINT `password_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `password_reset_requests`
--
ALTER TABLE `password_reset_requests`
  ADD CONSTRAINT `password_reset_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_activity_logs`
--
ALTER TABLE `user_activity_logs`
  ADD CONSTRAINT `fk_user_activity_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_balances`
--
ALTER TABLE `user_balances`
  ADD CONSTRAINT `fk_user_balances_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
