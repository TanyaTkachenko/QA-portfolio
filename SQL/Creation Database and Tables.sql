CREATE DATABASE EXAM
GO

USE EXAM
GO

CREATE TABLE makers(
    id integer NOT NULL,
	name varchar(64) NOT NULL,
	country varchar(64) NOT NULL,
 CONSTRAINT PK_makers PRIMARY KEY (id)
)
GO

CREATE TABLE orders(
    id integer NOT NULL,
	client_id integer NOT NULL,
	order_date datetime NOT NULL,
	done_date datetime,
	ship_type varchar(4) NOT NULL,
	ship_city varchar(40) NOT NULL,
 CONSTRAINT PK_orders PRIMARY KEY (id)
)
GO

CREATE TABLE products(
    id integer NOT NULL,
	name varchar(32) NOT NULL,
	price decimal(18,2) NOT NULL,
	maker_id integer NOT NULL,
CONSTRAINT PK_products PRIMARY KEY (id)
)
GO

CREATE TABLE clients(
    id integer NOT NULL,
	name varchar(20) NOT NULL,
	surname varchar(20) NOT NULL,
	city varchar(40) NOT NULL,
	gender char,
	birthday datetime,
	phone varchar(12) NOT NULL,
	discount integer,
CONSTRAINT PK_clients PRIMARY KEY (id)
)
GO

CREATE TABLE order_basket(
    order_id integer NOT NULL,
	product_id integer NOT NULL,
	quantity integer NOT NULL,
	discount integer,
CONSTRAINT PK_order_basket PRIMARY KEY (order_id, product_id)
)
GO




ALTER TABLE products ADD CONSTRAINT FK_products_makers 
    FOREIGN KEY(maker_id)
        REFERENCES makers (id)
GO

ALTER TABLE orders ADD CONSTRAINT FK_orders_clients 
    FOREIGN KEY(client_id)
        REFERENCES clients (id)
GO

ALTER TABLE order_basket ADD CONSTRAINT FK_order_basket_orders 
    FOREIGN KEY(order_id)
        REFERENCES orders (id)
GO

ALTER TABLE order_basket ADD CONSTRAINT FK_order_basket_products
    FOREIGN KEY(product_id)
        REFERENCES products (id)
GO