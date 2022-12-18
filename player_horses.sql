CREATE TABLE IF NOT EXISTS `player_horses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `horse` varchar(50) DEFAULT NULL,
  `components` varchar(50) DEFAULT NULL,
  `saddle` varchar(50) DEFAULT NULL,
  `blanket` varchar(50) DEFAULT NULL,
  `bag` varchar(50) DEFAULT NULL,
  `luggage` varchar(50) DEFAULT NULL,
  `horn` varchar(50) DEFAULT NULL,
  `stirrup` varchar(50) DEFAULT NULL,
  `mane` varchar(50) DEFAULT NULL,
  `tail` varchar(50) DEFAULT NULL,
  `mask` varchar(50) DEFAULT NULL,
  `active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;