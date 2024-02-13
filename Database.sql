/*  DROP DATABASE `project`;  */

CREATE DATABASE IF NOT EXISTS `project`;
USE `project`;

CREATE TABLE IF NOT EXISTS `roles` (
  `idRole` int AUTO_INCREMENT PRIMARY KEY,
  `roleName` varchar(20) NOT NULL,
  `permission` boolean
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `policy` (
  `idPolicy` int(11) PRIMARY KEY,
  `policy` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `cms` (
  `idCms` int(11) PRIMARY KEY,
  `idPolicy` int(11) NOT NULL,
  `policyValue` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `country` (
  `idCountry` int AUTO_INCREMENT PRIMARY KEY,
  `countryName` varchar(50) NOT NULL,
  `countryCode` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `languages` (
  `idLanguage` int(11) PRIMARY KEY,
  `language` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `clients` (
  `idClient` int AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(50),
  `surnames` varchar(50),
  `username` varchar(50) UNIQUE NOT NULL,
  `password` varchar(255) NOT NULL,
  `mail` varchar(150) UNIQUE,
  `phone` int,
  `address` varchar(100),
  `postcode` int,
  `idCountry` int,
  `membershipDate` datetime,
  `clientStatus` ENUM ('Active', 'Inactive', 'Banned', 'Deleted')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `idUser` int AUTO_INCREMENT PRIMARY KEY,
  `idRole` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `user` varchar(30) NOT NULL,
  `password` varchar(400) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `orders` (
  `idOrder` int AUTO_INCREMENT PRIMARY KEY,
  `idClient` int NOT NULL,
  `datetime` datetime,
  `orderStatus` ENUM ('Pending', 'Accepted', 'Processing', 'Sent', 'Delivered')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `products` (
  `idProduct` int PRIMARY KEY,
  `productName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `productImage` (
  `idPI` int ,
  `idProduct` int,
  `thumb` varchar(300),
  `original` varchar(300),
  PRIMARY KEY (`idPI`, `idProduct`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `productVariant` (
  `idVariant` int,
  `idProduct` int,
  `size` varchar(50),
  `variantName` varchar(200),
  `marginPercentage` decimal(6,2),
  `format_width` int,
  `format_height` int,
  `currency` varchar(3),
  `showProduct` boolean,
  PRIMARY KEY (`idVariant`, `idProduct`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `options` (
  `idOption` int,
  `idVariant` int,
  `is_required` boolean,
  PRIMARY KEY (`idOption`, `idVariant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `values` (
  `idValue` int NOT NULL,
  `idOption` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`idValue`, `idOption`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `generatedImages` (
  `idGI` integer PRIMARY KEY,
  `idClient` int NOT NULL,
  `prompt` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `cost` decimal(6,2) NOT NULL,
  `is_saved` boolean
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `orderDetails` (
  `idOD` int AUTO_INCREMENT PRIMARY KEY,
  `idOrder` int NOT NULL,
  `idProduct` int NOT NULL,
  `idGI` int NOT NULL,
  `idVariant` int NOT NULL,
  `quantity` int NOT NULL,
  `priceEach` decimal(6,2) NOT NULL,
  `shippingPrice` decimal(6,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `accounting` (
  `idMonth` int PRIMARY KEY,
  `month` varchar(20) NOT NULL,
  `income` decimal(6, 2) NOT NULL,
  `expense` decimal(6, 2) NOT NULL,
  `profit` decimal(7, 2) AS (`income` - `expense`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `refunds` (
  `idRefund` int AUTO_INCREMENT PRIMARY KEY,
  `idOrder` int NOT NULL,
  `idClient` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `dateRefund` datetime,
  `desc` varchar(999) NOT NULL,
  `refundStatus` ENUM ('Pending', 'Done', 'Processing')

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `configurations` (
  `idConfig` int(11) AUTO_INCREMENT PRIMARY KEY,
  `config` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `originals` (
  `idOriginal` int(11) AUTO_INCREMENT PRIMARY KEY,
  `originalText` varchar(255) NOT NULL,
  `site` varchar(40)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `translations` (
  `idTranslation` int(11) AUTO_INCREMENT PRIMARY KEY,
  `idOriginal` int(11) NOT NULL,
  `idLanguage` int(11) NOT NULL,
  `translation` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `shoppingCart` (
  `idCart` int PRIMARY KEY,
  `idClient` int NOT NULL,
  `date` datetime,
  `total` decimal(6,2) AS (SELECT SUM(sci.price * sci.quantity) FROM shoppingCartItems sci WHERE sci.idCart = idCart)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS `shoppingCartItems` (
  `idCI` int PRIMARY KEY,
  `idCart` int NOT NULL,
  `idGI` int NOT NULL,
  `idProduct` int NOT NULL,
  `idVariant` int NOT NULL,
  `idOption` int NOT NULL,
  `idValue` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(6,2),
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

ALTER TABLE `cms` ADD FOREIGN KEY (`idPolicy`) REFERENCES `policy` (`idPolicy`);

ALTER TABLE `translations` ADD FOREIGN KEY (`idOriginal`) REFERENCES `originals` (`idOriginal`);

ALTER TABLE `translations` ADD FOREIGN KEY (`idLanguage`) REFERENCES `languages` (`idLanguage`);

ALTER TABLE `users` ADD FOREIGN KEY (`idRole`) REFERENCES `roles` (`idRole`);

ALTER TABLE `clients` ADD FOREIGN KEY (`idCountry`) REFERENCES `country` (`idCountry`);

ALTER TABLE `clients` CHANGE `membershipDate` `membershipDate` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `orders` ADD FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`);

ALTER TABLE `orders` CHANGE `datetime` `datetime` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `refunds` ADD FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`);

ALTER TABLE `refunds` ADD FOREIGN KEY (`idOrder`) REFERENCES `orders` (`idOrder`);

ALTER TABLE `refunds` CHANGE `dateRefund` `dateRefund` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `productImage` ADD FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

ALTER TABLE `orderDetails` ADD FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

ALTER TABLE `orderDetails` ADD FOREIGN KEY (`idOrder`) REFERENCES `orders` (`idOrder`);

ALTER TABLE `orderDetails` ADD FOREIGN KEY (`idVariant`) REFERENCES `productVariant` (`idVariant`);

ALTER TABLE `orderDetails` ADD FOREIGN KEY (`idGI`) REFERENCES `generatedImages` (`idGI`);

ALTER TABLE `productVariant` ADD FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

ALTER TABLE `values` ADD FOREIGN KEY (`idOption`) REFERENCES `options` (`idOption`);

ALTER TABLE `options` ADD FOREIGN KEY (`idVariant`) REFERENCES `productVariant` (`idVariant`);

ALTER TABLE `generatedImages` ADD FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`);

ALTER TABLE `shoppingCart` ADD FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`);

ALTER TABLE `shoppingCart` ADD FOREIGN KEY (`idGI`) REFERENCES `generatedImages` (`idGI`);

ALTER TABLE `shoppingCart` ADD FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

ALTER TABLE `shoppingCart` ADD FOREIGN KEY (`idVariant`) REFERENCES `productVariant` (`idVariant`);

ALTER TABLE `shoppingCart` ADD FOREIGN KEY (`idOption`) REFERENCES `options` (`idOption`);

ALTER TABLE `shoppingCart` ADD FOREIGN KEY (`idValue`) REFERENCES `values` (`idValue`);

ALTER TABLE `shoppingCart` CHANGE `total` `total` DECIMAL(6,2) DEFAULT '0.00';

ALTER TABLE `shoppingCartItems` ADD FOREIGN KEY (`idCart`) REFERENCES `shoppingCart` (`idCart`);

ALTER TABLE `shoppingCartItems` ADD FOREIGN KEY (`idGI`) REFERENCES `generatedImages` (`idGI`);

ALTER TABLE `shoppingCartItems` ADD FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProduct`);

ALTER TABLE `shoppingCartItems` ADD FOREIGN KEY (`idVariant`) REFERENCES `productVariant` (`idVariant`);

ALTER TABLE `shoppingCartItems` ADD FOREIGN KEY (`idOption`) REFERENCES `options` (`idOption`);

ALTER TABLE `shoppingCartItems` ADD FOREIGN KEY (`idValue`) REFERENCES `values` (`idValue`);

ALTER TABLE `shoppingCartItems` CHANGE `price` `price` DECIMAL(6,2) DEFAULT '0.00';

CREATE VIEW infoProducts AS SELECT P.idProduct, PV.idVariant, P.productName, PV.variantName, PV.size 
FROM products AS P, productVariant AS PV 
WHERE P.idProduct = PV.idProduct 
ORDER BY idProduct;

CREATE VIEW infoClients AS SELECT idClient, name, surnames, mail, address 
FROM clients 
ORDER BY idClient;

CREATE VIEW infoUsers AS SELECT U.idUser, U.idRole, U.name, U.surname, U.user
FROM users AS U, roles AS R
WHERE U.idRole = R.idRole
ORDER BY idRole;

CREATE VIEW infoOrders AS SELECT OD.idOrder, O.datetime, OD.idProduct, OD.idVariant, P.productName, PV.variantName, OD.quantity, C.name
FROM orderDetails AS OD, orders AS O, products AS P, productVariant AS PV, clients AS C
WHERE OD.idOrder = O.idOrder AND OD.idProduct = P.idProduct AND OD.idVariant = PV.idVariant AND O.idClient = C.idClient
ORDER BY idOrder;

CREATE VIEW infoRefunds AS SELECT DISTINCT R.idRefund, CONCAT(C.name,' ', C.surnames) AS name, R.dateRefund, R.desc, R.refundStatus
FROM refunds AS R, clients AS C, orders AS O
WHERE O.idClient = C.idClient AND O.idOrder = R.idOrder;

CREATE VIEW showSellingProducts AS SELECT *
FROM productVariant
WHERE showProduct = 1;

CREATE VIEW showNonSellingProducts AS SELECT *
FROM productVariant
WHERE showProduct = 0;

CREATE VIEW viewCMS AS SELECT cms.idCms, P.policy, cms.policyValue 
FROM policy AS P, cms
WHERE cms.idPolicy = P.idPolicy;

CREATE VIEW viewTranslations AS SELECT T.idTranslation, T.translation, O.originalText, O.site, L.language
FROM languages AS L, translations AS T, originals AS O
WHERE L.idLanguage = T.idLanguage AND T.idOriginal = O.idOriginal;

DELIMITER //
CREATE TRIGGER autoNameRefund
BEFORE INSERT ON refunds
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SET NEW.name = (
            SELECT CONCAT(c.name, ' ', c.surnames)
            FROM clients c
            INNER JOIN orders o ON c.idClient = o.idClient
            WHERE o.idOrder = NEW.idOrder
            LIMIT 1
        );
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER autoOrderStatus
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    SET NEW.orderStatus = ('Pending');
END;
//
DELIMITER ;