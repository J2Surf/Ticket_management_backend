-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 10, 2025 at 04:04 PM
-- Server version: 8.0.37
-- PHP Version: 8.3.15

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
  `id` int NOT NULL,
  `batch_id` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('pending','processing','completed','failed') COLLATE utf8mb3_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `fulfiller_id` int DEFAULT NULL,
  `payment_method` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `total_tickets` int DEFAULT '0',
  `completed_tickets` int DEFAULT '0',
  `batch_amount` decimal(10,2) DEFAULT '0.00',
  `processing_started_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `batch_tickets`
--

CREATE TABLE `batch_tickets` (
  `id` int NOT NULL,
  `batch_id` int NOT NULL,
  `ticket_id` int NOT NULL,
  `status` varchar(20) COLLATE utf8mb3_unicode_ci DEFAULT 'pending',
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT '0.00',
  `processing_time` int DEFAULT '0',
  `error_count` int DEFAULT '0',
  `last_error` text COLLATE utf8mb3_unicode_ci,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `id` int NOT NULL,
  `validation_group_id` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `notification_group_id` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `id` int NOT NULL,
  `form_id` int NOT NULL,
  `image_path` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csrf_tokens`
--

CREATE TABLE `csrf_tokens` (
  `id` int NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int NOT NULL,
  `event_type` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb3_unicode_ci,
  `timestamp` datetime DEFAULT NULL,
  `user_id` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_configurations`
--

CREATE TABLE `form_configurations` (
  `id` int NOT NULL,
  `domain_id` int DEFAULT NULL,
  `header_text` text COLLATE utf8mb3_unicode_ci,
  `footer_text` text COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_domains`
--

CREATE TABLE `form_domains` (
  `id` int NOT NULL,
  `domain` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `group_name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `telegram_chat_id` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `id` int NOT NULL,
  `game_name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `domain_id` int DEFAULT NULL,
  `display_order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `id` int NOT NULL,
  `method_name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `domain_id` int DEFAULT NULL,
  `display_order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `game` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `game_id` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `facebook_name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `transaction_number` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `group_id` bigint NOT NULL,
  `status` enum('pending_validation','validated','declined','completed') COLLATE utf8mb3_unicode_ci NOT NULL,
  `validator_id` bigint DEFAULT NULL,
  `fulfiller_id` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `validated_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `telegram_notification_sent` tinyint(1) DEFAULT '0',
  `telegram_message_id` bigint DEFAULT NULL,
  `telegram_chat_id` bigint DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fulfillers`
--

CREATE TABLE `fulfillers` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  `payment_methods` text COLLATE utf8mb3_unicode_ci,
  `status` varchar(20) COLLATE utf8mb3_unicode_ci DEFAULT 'active'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fulfiller_metrics`
--

CREATE TABLE `fulfiller_metrics` (
  `id` int NOT NULL,
  `fulfiller_id` int NOT NULL,
  `batch_id` int NOT NULL,
  `tickets_completed` int DEFAULT '0',
  `average_completion_time` int DEFAULT '0',
  `error_rate` decimal(5,2) DEFAULT '0.00',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fulfillment_groups`
--

CREATE TABLE `fulfillment_groups` (
  `id` int NOT NULL,
  `name` varchar(80) COLLATE utf8mb3_unicode_ci NOT NULL,
  `capacity` int NOT NULL DEFAULT '10',
  `status` varchar(20) COLLATE utf8mb3_unicode_ci DEFAULT 'active'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_history`
--

CREATE TABLE `password_history` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_policy`
--

CREATE TABLE `password_policy` (
  `id` int NOT NULL DEFAULT '1',
  `min_length` int NOT NULL DEFAULT '8',
  `require_uppercase` tinyint(1) NOT NULL DEFAULT '1',
  `require_lowercase` tinyint(1) NOT NULL DEFAULT '1',
  `require_number` tinyint(1) NOT NULL DEFAULT '1',
  `require_special` tinyint(1) NOT NULL DEFAULT '1',
  `expiry_days` int NOT NULL DEFAULT '90',
  `password_history` int NOT NULL DEFAULT '3',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_requests`
--

CREATE TABLE `password_reset_requests` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `request_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reset_expiry` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `id` int NOT NULL,
  `name` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `role_id` int NOT NULL,
  `permission_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
  `id` varchar(128) COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` int NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_agent` text COLLATE utf8mb3_unicode_ci,
  `payload` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_metrics`
--

CREATE TABLE `system_metrics` (
  `id` int NOT NULL,
  `metric_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `metric_value` decimal(10,2) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` int NOT NULL,
  `domain_id` int DEFAULT NULL,
  `facebook_name` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ticket_id` varchar(20) COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` int NOT NULL,
  `payment_method` varchar(20) COLLATE utf8mb3_unicode_ci NOT NULL,
  `payment_tag` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `account_name` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `game` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `game_id` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb3_unicode_ci DEFAULT 'new',
  `chat_group_id` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completion_time` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `completed_by` int DEFAULT NULL,
  `error_type` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `error_details` text COLLATE utf8mb3_unicode_ci,
  `error_reported_at` timestamp NULL DEFAULT NULL,
  `error_reported_by` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
(8, 1, 'a', '11-1741420051-MQIN', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741420051-MQIN_1741420051.png', 'new', '-1002324697837', '2025-03-08 07:47:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, 1, 'a', '11-1741420054-NR6A', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741420054-NR6A_1741420054.png', 'new', '-1002324697837', '2025-03-08 07:47:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(10, 1, 'a', '11-1741420574-5ZHX', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', '1', '/uploads/tickets/11s_tapsndr_com/11-1741420574-5ZHX_1741420574.jpg', 'new', '-1002324697837', '2025-03-08 07:56:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 1, 'a', '11-1741420788-AUFX', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741420788-AUFX_1741420788.png', 'new', '-1002324697837', '2025-03-08 07:59:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 1, 'a', '11-1741421314-OYUR', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741421314-OYUR_1741421314.png', 'new', '-1002324697837', '2025-03-08 08:08:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 1, 'a', '11-1741421754-4276', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741421754-4276_1741421754.png', 'new', '-1002324697837', '2025-03-08 08:15:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 1, 'a', '11-1741422746-H4CR', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741422746-H4CR_1741422746.png', 'new', '-1002324697837', '2025-03-08 08:32:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 1, 'a', '11-1741423112-67HE', 0, 'Zelle', 'a', 'a', 2.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741423112-67HE_1741423112.png', 'new', '-1002324697837', '2025-03-08 08:38:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 1, 'a', '11-1741424065-CSIO', 0, 'CashApp', 'a', 'a', 3.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741424065-CSIO_1741424065.png', 'new', '-1002324697837', '2025-03-08 08:54:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 1, 'test test', '11-1741427776-UDFT', 0, 'Venmo', '@bootymuncher', 'booty muncher', 50.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741427776-UDFT_1741427776.png', 'new', '-1002324697837', '2025-03-08 09:56:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(18, 1, 'test test', '11-1741481315-AI01', 0, 'Venmo', '@bootymuncher', 'booty muncher', 50.00, 'Golden Dragon', 'm-123-456-789', '/uploads/tickets/11s_tapsndr_com/11-1741481315-AI01_1741481315.png', 'completed', '-1002324697837', '2025-03-09 00:48:36', NULL, '2025-03-10 06:41:30', 16, NULL, NULL, NULL, NULL),
(19, 1, 'testing new api #1', '11-1741482859-ZU2S', 0, 'CashApp', 'testing new api #1', 'testing new api #1', 123.00, 'Golden Dragon', 'testing new api #1', '/uploads/tickets/11s_tapsndr_com/11-1741482859-ZU2S_1741482859.png', 'declined', '-1002324697837', '2025-03-09 01:14:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 1, 'testing new api #2', '11-1741484366-3OKU', 0, 'CashApp', 'testing new api #2', 'testing new api #2', 456.00, 'Golden Dragon', 'testing new api #2', '/uploads/tickets/11s_tapsndr_com/11-1741484366-3OKU_1741484366.png', 'error', '-1002324697837', '2025-03-09 01:39:26', NULL, NULL, NULL, 'INVALID_PAYMENT', 'Payment details don\'t match', '2025-03-10 06:41:47', 16),
(33, 3, 'c', 'DD-1741584554-F6TA', 0, 'Venmo', 'c', 'c', 3.00, 'Golden Dragon', 'c', '/uploads/tickets/dds_tapsndr_com/DD-1741584554-F6TA_1741584554.jpg', 'error', '-4750875832', '2025-03-10 05:29:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32, 3, 'b', 'DD-1741584486-QU6W', 0, 'CashApp', 'b', 'b', 2.00, 'Golden Dragon', 'b', '/uploads/tickets/dds_tapsndr_com/DD-1741584486-QU6W_1741584486.jpg', 'error', '-4750875832', '2025-03-10 05:28:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31, 1, 'a', '11-1741584436-7ZXL', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/11s_tapsndr_com/11-1741584436-7ZXL_1741584436.jpg', 'completed', '-1002324697837', '2025-03-10 05:27:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 3, 'a', 'DD-1741591197-2P7G', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/dds_tapsndr_com/DD-1741591197-2P7G_1741591197.jpg', 'completed', '-4750875832', '2025-03-10 07:19:57', NULL, '2025-03-10 07:20:20', 16, NULL, NULL, NULL, NULL),
(35, 3, 'a', 'DD-1741591380-CWK6', 0, 'Venmo', 'a', 'a', 1.00, 'Magic City', 'a', '/uploads/tickets/dds_tapsndr_com/DD-1741591380-CWK6_1741591380.jpg', 'completed', '-4750875832', '2025-03-10 07:23:00', NULL, '2025-03-10 07:23:28', 16, NULL, NULL, NULL, NULL),
(36, 3, 'a', 'DD-1741593582-8GDN', 0, 'CashApp', 'a', 'a', 1.00, 'Golden Dragon', 'a', '/uploads/tickets/dds_tapsndr_com/DD-1741593582-8GDN_1741593582.jpg', 'completed', '-4750875832', '2025-03-10 07:59:42', NULL, '2025-03-10 08:00:07', 16, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `transaction_type` enum('credit','debit') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `reference_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','inactive','suspended') COLLATE utf8mb3_unicode_ci DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_activity` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `failed_login_attempts` int DEFAULT '0',
  `last_login_attempt` timestamp NULL DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
(16, 'fulfillertest2', NULL, '$2y$10$3Pvo.MQcGQ64xX0hhIw2He788fSLBbtNn9fAKmEIGsQCCzRKknYpS', '2025-03-10 05:37:33', 'active', '2025-03-10 13:37:52', '2025-03-10 05:37:52', NULL, NULL, NULL, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_activity_logs`
--

CREATE TABLE `user_activity_logs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `activity_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
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
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `balance` decimal(10,2) DEFAULT '0.00',
  `last_transaction_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

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
(15, 4, '2025-03-10 04:39:43');

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('active','inactive','pending') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'active',
  `last_connected_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
