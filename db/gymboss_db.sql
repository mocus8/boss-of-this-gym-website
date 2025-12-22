-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Дек 22 2025 г., 19:14
-- Версия сервера: 8.0.43-34
-- Версия PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `cw187549_botg`
--

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Грифы'),
(2, 'Блины'),
(3, 'Гантели'),
(4, 'Стойки'),
(5, 'Лавки'),
(6, 'Блоки'),
(7, 'Экипировка'),
(8, 'Спортпит');

-- --------------------------------------------------------

--
-- Структура таблицы `delivery_addresses`
--

CREATE TABLE IF NOT EXISTS `delivery_addresses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `address_line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `postal_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `delivery_addresses`
--

INSERT INTO `delivery_addresses` (`id`, `user_id`, `address_line`, `postal_code`) VALUES
(40, 84, 'Москва, улица Головачёва, 5к2, подъезд 1, этаж 2, кв. 9', '109380'),
(41, 84, 'Москва, улица Головачёва', ''),
(42, 84, 'Москва, улица Головачёва, 2', '109380'),
(43, 84, 'Москва, улица Головачёва, вл3', '109380'),
(44, 84, 'Москва, улица Головачёва, 5к2, подъезд 1, этаж 1, кв. 2', '109380');

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `delivery_type` enum('delivery','pickup') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `delivery_cost` decimal(10,2) NOT NULL DEFAULT '0.00',
  `delivery_address_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'cart',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `paid_at` timestamp NULL DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `yookassa_payment_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payment_expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `delivery_address_id` (`delivery_address_id`),
  KEY `orders_ibfk_1` (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `session_id`, `total_price`, `delivery_type`, `delivery_cost`, `delivery_address_id`, `store_id`, `status`, `created_at`, `updated_at`, `paid_at`, `cancelled_at`, `yookassa_payment_id`, `payment_expires_at`) VALUES
(39, 84, NULL, 4750.00, 'delivery', 750.00, 40, NULL, 'paid', '2025-12-03 17:51:59', '2025-12-03 17:52:48', '2025-12-03 17:52:48', NULL, '30c28ca7-000f-5000-b000-15cd1f3ddcde', '2025-12-03 21:22:39'),
(40, 84, NULL, 4000.00, 'pickup', 0.00, NULL, 3, 'paid', '2025-12-03 17:56:23', '2025-12-03 17:57:15', '2025-12-03 17:57:15', NULL, '30c28da0-000f-5000-8000-187844c81aab', '2025-12-03 21:26:48'),
(41, 84, NULL, 1000.00, 'pickup', 0.00, NULL, 3, 'paid', '2025-12-04 14:40:17', '2025-12-04 15:20:03', '2025-12-04 15:20:03', NULL, '30c3b12b-000f-5000-8000-1ddf8e8a1d62', '2025-12-04 18:10:43'),
(42, 84, NULL, 4500.00, 'delivery', 750.00, 42, NULL, 'paid', '2025-12-04 18:47:14', '2025-12-04 18:48:13', '2025-12-04 18:48:13', NULL, '30c3eb24-000f-5000-b000-16c541f517d0', '2025-12-04 22:18:04'),
(43, 84, NULL, 3750.00, 'delivery', 750.00, 43, NULL, 'paid', '2025-12-05 12:14:31', '2025-12-05 12:15:00', '2025-12-05 12:15:00', NULL, '30c4e074-000f-5000-b000-1e81b100633b', '2025-12-05 15:44:44'),
(44, NULL, 'cart_69386953c16d74.68407669', 1000.00, NULL, 0.00, NULL, NULL, 'cart', '2025-12-09 18:24:20', '2025-12-09 18:24:20', NULL, NULL, NULL, NULL),
(45, 84, NULL, 1750.00, 'delivery', 750.00, 43, NULL, 'paid', '2025-12-09 18:25:51', '2025-12-13 07:57:14', '2025-12-13 07:57:14', NULL, '30cf3010-000f-5001-8000-1cd07444ee97', '2025-12-13 11:27:04'),
(46, 84, NULL, 3000.00, 'pickup', 0.00, NULL, 1, 'cancelled', '2025-12-13 07:57:33', '2025-12-13 08:09:45', NULL, '2025-12-13 08:09:45', '30cf3037-000f-5001-8000-1d3b634b3cd0', '2025-12-13 11:27:43'),
(47, 84, NULL, 1750.00, 'delivery', 750.00, 42, NULL, 'paid', '2025-12-13 08:09:13', '2025-12-14 09:22:21', '2025-12-14 09:22:21', NULL, '30d09585-000f-5000-b000-15ef316c932a', '2025-12-14 12:52:13'),
(48, 84, NULL, 2750.00, 'delivery', 750.00, 40, NULL, 'paid', '2025-12-16 14:46:13', '2025-12-16 14:46:33', '2025-12-16 14:46:33', NULL, '30d38481-000f-5001-9000-10ce1a98714c', '2025-12-16 18:16:25'),
(49, 84, NULL, 1000.00, 'pickup', 0.00, NULL, 3, 'cancelled', '2025-12-16 14:46:48', '2025-12-16 15:49:08', NULL, '2025-12-16 15:49:08', '30d384ab-000f-5001-8000-15c9bb304632', '2025-12-16 18:17:07'),
(50, 84, NULL, 1000.00, 'pickup', 0.00, NULL, 3, 'paid', '2025-12-16 14:47:28', '2025-12-16 14:47:50', '2025-12-16 14:47:50', NULL, '30d384c7-000f-5000-b000-1465f9df5000', '2025-12-16 18:17:35'),
(51, 84, NULL, 6500.00, 'delivery', 0.00, 40, NULL, 'paid', '2025-12-17 15:56:15', '2025-12-17 15:58:31', '2025-12-17 15:58:31', NULL, '30d4e6dd-000f-5001-8000-1d6a4df5b91f', '2025-12-17 19:28:21'),
(52, 84, NULL, 1000.00, 'pickup', 0.00, NULL, 2, 'paid', '2025-12-17 15:58:50', '2025-12-17 15:59:09', '2025-12-17 15:59:09', NULL, '30d4e707-000f-5001-9000-100ef8eff328', '2025-12-17 19:29:03'),
(53, 84, NULL, 1000.00, 'pickup', 0.00, NULL, 1, 'paid', '2025-12-17 15:59:23', '2025-12-17 15:59:55', '2025-12-17 15:59:55', NULL, '30d4e725-000f-5000-8000-1a807ad08e44', '2025-12-17 19:29:33'),
(54, 84, NULL, 3000.00, 'pickup', 0.00, NULL, 2, 'paid', '2025-12-17 16:00:18', '2025-12-17 16:00:47', '2025-12-17 16:00:47', NULL, '30d4e767-000f-5001-9000-1a6602224303', '2025-12-17 19:30:39');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE IF NOT EXISTS `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price` int NOT NULL,
  `vat_code` tinyint NOT NULL DEFAULT '4',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`product_id`, `category_id`, `slug`, `name`, `price`, `vat_code`, `description`) VALUES
(1, 1, 'bar-20kg-griff-20-1', 'Гриф для штанги 20 кг GriFF-20', 5000, 4, 'Гриф для штанги 20 кг GriFF-20 – надёжная основа ваших тренировок\r\n                        <br><br>\r\n                        Гриф для штанги GriFF-20 – это профессиональный спортивный снаряд, созданный для интенсивных силовых тренировок в зале и дома. Изготовленный из высококачественной стали с антикоррозийным покрытием, гриф обладает исключительной прочностью и долговечностью, выдерживая серьёзные нагрузки.\r\n                        <br><br>\r\n                        Идеально подходит для базовых упражнений: жима лёжа, становой тяги, приседаний и других силовых элементов.\r\n                        <br><br>\r\n                        Ключевые особенности:<br>\r\n                        Вес: 20 кг – оптимальный вариант для тренировок с серьёзными весами<br>\r\n                        Длина: 220 см (стандартный олимпийский размер)<br>\r\n                        Диаметр грифа: 28-30 мм (удобный хват для большинства спортсменов)<br>\r\n                        Нагрузка: выдерживает до 300 кг (подходит для пауэрлифтинга и кроссфита)<br>\r\n                        Покрытие: матовая антискользящая обработка для надёжного хвата<br>\r\n                        Резьба на концах: надёжно фиксирует диски, предотвращая их соскальзывание<br>\r\n                        Совместимость: подходит для стандартных олимпийских блинов (диаметр посадочного отверстия 50 мм)\r\n                        <br><br>\r\n                        Преимущества:<br>\r\n                        Универсальность – подходит для различных упражнений и программ тренировок<br>\r\n                        Прочность – усиленная конструкция гарантирует безопасность при работе с большими весами<br>\r\n                        Комфортный хват – рифлёные участки в зоне захвата улучшают сцепление с ладонями<br>\r\n                        Долгий срок службы – устойчивость к износу и деформации\r\n                        <br><br>\r\n                        Для кого:<br>\r\n                        Гриф GriFF-20 предназначен для спортсменов разного уровня подготовки – от любителей до профессионалов. Он отлично подходит для пауэрлифтеров, кроссфитеров, тяжелоатлетов, фитнес-энтузиастов, а также для тренеров и спортивных залов.\r\n                        <br><br>\r\n                        Комплектация:<br>\r\n                        Гриф для штанги GriFF-20 – 1 шт.\r\n                        <br><br>\r\n                        Дополнительно:<br>\r\n                        Для максимальной эффективности тренировок рекомендуем использовать гриф вместе с качественными дисками и замками.\r\n                        <br><br>\r\n                        Улучшите свои силовые показатели с GriFF-20 – стальным стержнем вашего прогресса!'),
(2, 2, 'plate-d10cm-10kg-griff-20-2', 'Блин D 10 см 10 кг GriFF-20', 1000, 4, 'Блин для штанги 10 кг GriFF-20 – идеальный утяжелитель для силовых тренировок\r\n                        <br><br>\r\n                        Олимпийский блин GriFF-20 – это профессиональный спортивный снаряд, созданный для интенсивных силовых тренировок в зале и дома. Изготовленный из высококачественного чугуна с защитным покрытием, блин обладает исключительной прочностью и долговечностью, выдерживая серьёзные нагрузки.\r\n                        <br><br>\r\n                        Идеально подходит для базовых упражнений: жима лёжа, становой тяги, приседаний и других силовых элементов.\r\n                        <br><br>\r\n                        Ключевые особенности:<br>\r\n                        Вес: 10 кг – оптимальный вариант для прогрессивного увеличения нагрузки<br>\r\n                        Диаметр: 45 см (стандартный олимпийский размер)<br>\r\n                        Посадочное отверстие: 50 мм (стандартный олимпийский размер)<br>\r\n                        Материал: высокопрочный чугун с антикоррозийным покрытием<br>\r\n                        Покрытие: износостойкая краска с чёткой маркировкой веса<br>\r\n                        Точность веса: калибровка согласно международным стандартам\r\n                        <br><br>\r\n                        Преимущества:<br>\r\n                        Универсальность – подходит для различных упражнений и программ тренировок<br>\r\n                        Прочность – усиленная конструкция гарантирует безопасность при работе с большими весами<br>\r\n                        Компактность – удобное хранение и транспортировка<br>\r\n                        Долгий срок службы – устойчивость к износу и деформации<br>\r\n                        Чёткая маркировка – легко идентифицировать вес среди других блинов\r\n                        <br><br>\r\n                        Для кого:<br>\r\n                        Блин GriFF-20 предназначен для спортсменов разного уровня подготовки – от любителей до профессионалов. Он отлично подходит для пауэрлифтеров, кроссфитеров, тяжелоатлетов, фитнес-энтузиастов, а также для тренеров и спортивных залов.\r\n                        <br><br>\r\n                        Комплектация:<br>\r\n                        Блин для штанги GriFF-20 – 1 шт.\r\n                        <br><br>\r\n                        Дополнительно:<br>\r\n                        Для максимальной эффективности тренировок рекомендуем использовать блины вместе с качественным олимпийским грифом и надёжными замками.\r\n                        <br><br>\r\n                        Улучшите свои силовые показатели с GriFF-20 – надёжным партнёром вашего прогресса!'),
(3, 2, 'plate-d10cm-5kg-griff-20-3', 'Блин D 10 см 5 кг GriFF-20', 750, 4, NULL),
(4, 4, 'stand-for-bar-griff-stand-4', 'Стойка для штанги GriFF-Stand', 7000, 4, NULL),
(5, 5, 'adjustable-bench-layxxl-5', 'Скамья регулируемая LayXXL', 6000, 4, NULL),
(6, 8, 'whey-protein-breero-2-5kg-6', 'Сывороточный протеин Breero 2.5 кг', 750, 3, NULL),
(7, 7, 'lifting-belt-gachi-power-xl-7', 'Лифтёрский пояс Gachi-Power XL', 750, 4, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `product_images`
--

CREATE TABLE IF NOT EXISTS `product_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `product_images`
--

INSERT INTO `product_images` (`image_id`, `product_id`, `image_path`) VALUES
(1, 1, 'img_products\\1\\bar-20kg-griff-20-1-1.png'),
(2, 1, 'img_products\\1\\bar-20kg-griff-20-1-2.png'),
(3, 1, 'img_products\\1\\bar-20kg-griff-20-1-3.png'),
(4, 1, 'img_products\\1\\bar-20kg-griff-20-1-4.png'),
(5, 2, 'img_products\\2\\plate-d10cm-10kg-griff-20-2-1.png'),
(6, 2, 'img_products\\2\\plate-d10cm-10kg-griff-20-2-2.png'),
(7, 2, 'img_products\\2\\plate-d10cm-10kg-griff-20-2-3.png'),
(8, 2, 'img_products\\2\\plate-d10cm-10kg-griff-20-2-4.png'),
(9, 1, 'img_products\\1\\bar-20kg-griff-20-1-5.png');

-- --------------------------------------------------------

--
-- Структура таблицы `product_order`
--

CREATE TABLE IF NOT EXISTS `product_order` (
  `product_id` int NOT NULL,
  `order_id` int NOT NULL,
  `amount` int NOT NULL,
  PRIMARY KEY (`product_id`,`order_id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `product_order`
--

INSERT INTO `product_order` (`product_id`, `order_id`, `amount`) VALUES
(2, 39, 4),
(2, 40, 4),
(2, 41, 1),
(2, 42, 3),
(2, 43, 3),
(2, 44, 1),
(2, 45, 1),
(2, 46, 3),
(2, 47, 1),
(2, 48, 2),
(2, 49, 1),
(2, 50, 1),
(2, 51, 5),
(2, 52, 1),
(2, 53, 1),
(2, 54, 3),
(3, 51, 1),
(6, 42, 1),
(6, 51, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `stores`
--

CREATE TABLE IF NOT EXISTS `stores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `work_hours` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `coordinates` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `stores`
--

INSERT INTO `stores` (`id`, `name`, `address`, `phone`, `work_hours`, `coordinates`) VALUES
(1, 'Р-н Люблино', 'Москва, Ул. Головачёва, вл8с1', '+7 000 000 00 00', '10:00 - 23:00 (будние дни)<br>10:00 - 21:00 (выходные и праздники)', '55.666208, 37.816980'),
(2, 'Р-н Отрадное', 'Москва, Ул. Станционная, 11', '+7 000 000 00 00', '10:00 - 22:00 (будние дни)<br>10:00 - 21:00 (выходные и праздники)', '55.846623, 37.600648'),
(3, 'Г. Дмитров', 'Дмитров, Историческая площадь, 5', '+7 000 000 00 00', '10:00 - 23:00 (будние дни)<br>10:00 - 21:00 (выходные и праздники)', '56.345304, 37.520384');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login (phone number)` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `login`, `password`, `name`) VALUES
(84, '+79778743115', '$2y$10$.6TM1llZYiT8w5lUFMoYPeBpojdUdpImfbZnkubOPvIJcPfVXCTp2', 'Илья Сладков');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `products`
--
ALTER TABLE `products` ADD FULLTEXT KEY `name` (`name`,`description`);

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `delivery_addresses`
--
ALTER TABLE `delivery_addresses`
  ADD CONSTRAINT `delivery_addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `product_order`
--
ALTER TABLE `product_order`
  ADD CONSTRAINT `product_order_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `product_order_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
