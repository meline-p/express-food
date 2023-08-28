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
  delivery_date2 TIMESTAMP DEFAULT NULL,
  delivery_people_id int(11),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (delivery_status_id) REFERENCES delivery_status(id),
  FOREIGN KEY (delivery_people_id) REFERENCES delivery_people(id)
);

CREATE TABLE invoices (
  id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  invoice_number varchar(255) NOT NULL,
  expedition_id int(11) NOT NULL,
  FOREIGN KEY (expedition_id) REFERENCES expeditions(id)
);

-- CUSTOMERS
INSERT INTO customers (id, last_name, first_name, email, password, phone_number) VALUES
(1, 'Doe', 'John', 'john@doe.com', SHA2('123zdzd456', 256), '0606060606'),
(2, 'Smith', 'Jack', 'jack@smith.com', SHA2('098pkf73579', 256), '0606060606');

-- ADDRESSES
INSERT INTO addresses (id, address_number, address_route, address_zip_code, address_city, customer_id) VALUES
(1, '23', 'Rue des Lilas', '75000', 'Paris', 1),
(2, '50', 'Avenue du Moulin', '13000', 'Marseille', 2);

-- ORDERS
INSERT INTO orders (order_date, customer_id, address_id)
VALUES (CURRENT_TIMESTAMP, 1, 1);

SET @order_1 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_1 )
WHERE id = @order_1;

INSERT INTO orders (order_date, customer_id, address_id)
VALUES (CURRENT_TIMESTAMP, 2, 2);

SET @order_2 = LAST_INSERT_ID();

UPDATE orders
SET order_number = CONCAT(DATE_FORMAT(order_date, '%Y%m%d%H%i%s'), @order_2 )
WHERE id = @order_2;

-- CATEGORIES
INSERT INTO categories (name) VALUES ('plat'),('dessert');

-- PRODUCTS 
INSERT INTO products (name, description, unit_price, category_id) VALUES
('Poke Bowl Teriyaki', 'Boulgour bio, poulet tériyaki, carotte, fève, avocat, ananas et tomates cerises.', 9.10, 1),
('Cookie', 'Pépites de chocolat, chocolat blanc noix de pécan', 3.10, 2),
('Pâtes Carbonara', 'Lardon, oignon, crème fraîche', 7.50, 1),
('Fromage Blanc', 'Miel muesli, crème de marron, mangue passion ', 2.90, 2);

-- MENUS
INSERT INTO menus (date) VALUES (CURRENT_DATE);

-- MENUS PRODUCTS
INSERT INTO menus_products (menu_id, product_id) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4);

-- ORDER LINES
INSERT INTO order_lines (order_id, product_id, quantity) VALUES 
(@order_1, 3, 2),
(@order_1, 1, 1),
(@order_2, 2, 3);

-- DELIVERY STATUS
INSERT INTO delivery_status (name) VALUES 
('is_confirmed'),
('is_shipped'),
('is_delivered');

-- DELIVERY PEOPLE
INSERT INTO delivery_people (last_name, first_name, email, password, phone_number, latitude, longitude, is_available) VALUES
('MARTIN', 'Michel', 'michel@martin.com', SHA2('12lojd56', 256), '0606060606', 48.862725, 2.287592, 1),
('JANE', 'Mary', 'mary@jane.com', SHA2('1mk!plfkva6', 256), '0606060606', 43.2961743, 5.3699525, 0);

-- EXPEDITIONS
INSERT INTO expeditions (order_id, delivery_status_id, shipping_date, delivery_date, delivery_people_id) VALUES 
(1, 3, NOW(), NOW() + INTERVAL 10 MINUTE, 1);

-- INVOICES
INSERT INTO invoices (invoice_number, expedition_id) VALUES
('11F20230811', 1);