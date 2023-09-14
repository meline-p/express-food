DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS expeditions;
DROP TABLE IF EXISTS delivery_people;
DROP TABLE IF EXISTS delivery_status;
DROP TABLE IF EXISTS order_lines;
DROP TABLE IF EXISTS menus_products;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  last_name varchar(255) NOT NULL,
  first_name varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  phone_number varchar(255) NOT NULL
);

CREATE TABLE addresses (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  address_number varchar(255),
  address_route varchar(255),
  address_zip_code varchar(255) NOT NULL,
  address_city varchar(255) NOT NULL,
  customer_id int(11) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE orders (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  order_number varchar(255),
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  customer_id int(11) NOT NULL,
  address_id int(11) NOT NULL,
  UNIQUE (order_number),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE categories (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name varchar(255) NOT NULL
);

CREATE TABLE products (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  description TEXT,
  unit_price float NOT NULL,
  category_id int(11) NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE menus (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  date DATE,
  UNIQUE (date)
);

CREATE TABLE menus_products (
  menu_id int(11) NOT NULL,
  product_id int(11) NOT NULL,
  FOREIGN KEY (menu_id) REFERENCES menus(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  PRIMARY KEY (menu_id, product_id)
);

CREATE TABLE order_lines (
  order_id int(11) NOT NULL,
  product_id int(11) NOT NULL,
  quantity int(11) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  PRIMARY KEY (product_id, order_id)
);

CREATE TABLE delivery_status (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name varchar(255) NOT NULL
);

CREATE TABLE delivery_people (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  last_name varchar(255) NOT NULL,
  first_name varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  phone_number varchar(255) NOT NULL,
  latitude float NOT NULL,
  longitude float NOT NULL,
  is_available boolean NOT NULL
);

CREATE TABLE expeditions (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  order_id int(11) NOT NULL,
  delivery_status_id int(11) DEFAULT 1,
  shipping_date DATETIME DEFAULT NULL,
  delivery_date DATETIME DEFAULT NULL,
  delivery_people_id int(11),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (delivery_status_id) REFERENCES delivery_status(id),
  FOREIGN KEY (delivery_people_id) REFERENCES delivery_people(id)
);

CREATE TABLE invoices (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  invoice_number varchar(255),
  expedition_id int(11) NOT NULL,
  FOREIGN KEY (expedition_id) REFERENCES expeditions(id)
);

-- CUSTOMERS
INSERT INTO customers (id, last_name, first_name, email, password, phone_number) VALUES
(1, 'DOE', 'John', 'john@doe.com', SHA2('123zdzd456', 256), '0606060606'),
(2, 'SMITH', 'Jack', 'jack@smith.com', SHA2('098pkf73579', 256), '0607080901'),
(3, 'CHABRIO', 'Jenny', 'jenny@chabrio.com', SHA2('098pkjozdsih3579', 256), '0616263646'),
(4, 'THOMPSON', 'Mike', 'mike@thompson.com', SHA2('0p7643dsihOK9', 256), '0696867666'),
(5, 'FOREST', 'Vanessa', 'vanessa@forest.com', SHA2('ndfbd98757jbkqjds', 256), '0690817263');

-- ADDRESSES
INSERT INTO addresses (id, address_number, address_route, address_zip_code, address_city, customer_id) VALUES
(1, '23', 'Rue des Lilas', '75000', 'Paris', 1),
(2, '50', 'Avenue du Moulin', '13000', 'Marseille', 2),
(3, '3', 'Avenue du Square', '13100', 'Aix-en-Provence', 3),
(4, '312', 'Impasse des Fleurs', '69000', 'Lyon', 4),
(5, '87', 'Rue Diderot', '31000', 'Toulouse', 4),
(6, '62', 'Boulevard Giraud', '63000', 'Clermont-Ferrand', 5);

-- ORDERS
INSERT INTO orders (order_date, customer_id, address_id)
VALUES (CURRENT_TIMESTAMP, 1, 1);

SET @order_1 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_1 )
WHERE id = @order_1;

-- 

INSERT INTO orders (order_date, customer_id, address_id)
VALUES (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 4 MINUTE), 2, 2);

SET @order_2 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_2 )
WHERE id = @order_2;

--

INSERT INTO orders (order_date, customer_id, address_id)
VALUES (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 5 MINUTE), 3, 3);

SET @order_3 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_3 )
WHERE id = @order_3;

--

INSERT INTO orders (order_date, customer_id, address_id)
VALUES (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 6 MINUTE), 4, 4);

SET @order_4 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_4 )
WHERE id = @order_4;

--

INSERT INTO orders (order_date, customer_id, address_id)
VALUES (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 15 MINUTE), 4, 5);

SET @order_5 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_5 )
WHERE id = @order_5;

--

INSERT INTO orders (order_date, customer_id, address_id)
VALUES (DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 30 MINUTE), 5, 6);

SET @order_6 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_6 )
WHERE id = @order_6;


-- CATEGORIES
INSERT INTO categories (name) VALUES ('plat'),('dessert');

-- PRODUCTS 
INSERT INTO products (name, description, unit_price, category_id) VALUES
('Poke Bowl Teriyaki', 'Boulgour bio, poulet tériyaki, carotte, fève, avocat, ananas et tomates cerises.', 9.10, 1),
('Cookie', 'Pépites de chocolat, chocolat blanc noix de pécan', 3.10, 2),
('Pâtes Carbonara', 'Lardon, oignon, crème fraîche', 7.50, 1),
('Fromage Blanc', 'Miel muesli, crème de marron, mangue passion ', 2.90, 2),
('Muffin', "Petits gâteaux individuels s'apparentant aux madeleines", 3.50, 2),
('Pâtes Bolognaises', "A base de bœuf haché, sauce tomate, oignon, céleri, carottes, et d'huile d'olive", 8.90, 1),
("Souris d'agneau", "Morceau de viande constitué par le muscle qui entoure le tibia de la patte arrière de l'agneau, en bas de la cuisse", 10.50, 1),
('Tiramisu', 'Le tiramisu est une pâtisserie et un dessert traditionnel de la cuisine italienne', 5.50, 2),
('Lasagnes', "A base de couches alternées de pâtes lasagnes, parmesan, mozzarella, ou ricotta, et de sauce bolognaise ou sauce béchamel", 7.90, 1),
('Blanquette de veau', "A base de viande de veau cuite dans un bouillon avec carotte, poireau, oignon et bouquet garni", 10.50, 1),
('Brownie', 'Le brownie est un gâteau au chocolat, fondant par endroits, cuit au four', 4.50, 2),
('Salade de fruits', "La salade de fruits est un dessert composé d'un mélange de fruits", 3.10, 2);


-- MENUS
INSERT INTO menus (date) VALUES (CURRENT_DATE);
INSERT INTO menus (date) VALUES (CURRENT_DATE + INTERVAL 1 DAY);
INSERT INTO menus (date) VALUES (CURRENT_DATE + INTERVAL 2 DAY);
INSERT INTO menus (date) VALUES (CURRENT_DATE + INTERVAL 3 DAY);

-- MENUS PRODUCTS
INSERT INTO menus_products (menu_id, product_id) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 6),
(2, 7),
(2, 5),
(2, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12),
(4, 1),
(4, 6),
(4, 12),
(4, 2);

-- ORDER LINES
INSERT INTO order_lines (order_id, product_id, quantity) VALUES 
(@order_1, 3, 2),
(@order_1, 1, 1),
(@order_2, 2, 3),
(@order_3, 1, 2),
(@order_4, 3, 1),
(@order_4, 4, 1),
(@order_5, 4, 3),
(@order_6, 1, 6),
(@order_6, 2, 2),
(@order_6, 4, 4);

-- DELIVERY STATUS
INSERT INTO delivery_status (name) VALUES 
('is_confirmed'),
('is_shipped'),
('is_delivered');

-- DELIVERY PEOPLE
INSERT INTO delivery_people (last_name, first_name, email, password, phone_number, latitude, longitude, is_available) VALUES
('MARTIN', 'Michel', 'michel@martin.com', SHA2('12lojd56', 256), '0697856490', 48.862725, 2.287592, 0),
('JANE', 'Mary', 'mary@jane.com', SHA2('1mk!plfkva6', 256), '0608625785', 43.2961743, 5.3699525, 0),
('DENIS', 'Samuel', 'samuel@denis.com', SHA2('1m077Tfkva6', 256), '0653801487', 43.2961743, 5.3699525, 1),
('PENAULT', 'Pierre', 'pierre@penault.com', SHA2('1mOIHIU87Tfkva6', 256), '0676238856', 43.5298424, 5.4474738, 1),
('CARREAU', 'Nicolas', 'nicolas@carreau.com', SHA2('1m0POU43456a6', 256), '0609547899', 43.6044622, 1.4442469, 0),
('PORTA', 'Emmanuella', 'emmanuella@porta.com', SHA2('1m45678JGF6', 256), '0634678054', 45.7774551, 3.0819427, 0),
('ROSEFIELD', 'Brittany', 'brittany@rosefield.com', SHA2('1m0LFYT356', 256), '0698542835', 43.2961743, 5.3699525, 1),
('FARRET', 'Eric', 'eric@farret.com', SHA2('1m07UHGFD567a6', 256), '0609674563', 45.7578137, 4.8320114, 0);

-- EXPEDITIONS
INSERT INTO expeditions (order_id, delivery_status_id, shipping_date, delivery_date, delivery_people_id) VALUES 
(1, 3, NOW() + INTERVAL 2 MINUTE, NOW() + INTERVAL 10 MINUTE, 1),
(2, 2, NOW() + INTERVAL 6 MINUTE, NULL, 2),
(3, 1, NULL, NULL, NULL),
(4, 3, NOW() + INTERVAL 7 MINUTE, NOW() + INTERVAL 12 MINUTE, 8),
(5, 3, NOW() + INTERVAL 20 MINUTE, NOW() + INTERVAL 28 MINUTE, 5),
(6, 3, NOW() + INTERVAL 35 MINUTE, NOW() + INTERVAL 50 MINUTE, 6);

-- INVOICES

INSERT INTO invoices (expedition_id)
VALUES (1);

SET @invoice_1 = LAST_INSERT_ID();

UPDATE invoices i
JOIN expeditions e ON i.expedition_id = e.id
SET i.invoice_number = CONCAT(@invoice_1, 'F', DATE_FORMAT(e.delivery_date, '%Y%m%d'), e.order_id)
WHERE i.id = @invoice_1;

--

INSERT INTO invoices (expedition_id)
VALUES (4);

SET @invoice_2 = LAST_INSERT_ID();

UPDATE invoices i
JOIN expeditions e ON i.expedition_id = e.id
SET i.invoice_number = CONCAT(@invoice_2, 'F', DATE_FORMAT(e.delivery_date, '%Y%m%d'), e.order_id)
WHERE i.id = @invoice_2;

--

INSERT INTO invoices (expedition_id)
VALUES (5);

SET @invoice_3 = LAST_INSERT_ID();

UPDATE invoices i
JOIN expeditions e ON i.expedition_id = e.id
SET i.invoice_number = CONCAT(@invoice_3, 'F', DATE_FORMAT(e.delivery_date, '%Y%m%d'), e.order_id)
WHERE i.id = @invoice_3;
--

INSERT INTO invoices (expedition_id)
VALUES (6);

SET @invoice_4 = LAST_INSERT_ID();

UPDATE invoices i
JOIN expeditions e ON i.expedition_id = e.id
SET i.invoice_number = CONCAT(@invoice_4, 'F', DATE_FORMAT(e.delivery_date, '%Y%m%d'), e.order_id)
WHERE i.id = @invoice_4;