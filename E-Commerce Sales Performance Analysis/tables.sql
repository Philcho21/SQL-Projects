-- Create Tables

CREATE TABLE customers();
CREATE TABLE pruducts();
CREATE TABLE orders();
CREATE TABLE order_items();

ALTER TABLE customers
ADD COLUMN customer_id INT PRIMARY KEY,
ADD COLUMN email VARCHAR(150) UNIQUE,
ADD COLUMN country VARCHAR(100),
ADD COLUMN signup_date DATE;

ALTER TABLE customers
ADD COLUMN first_name VARCHAR(150),
ADD COLUMN last_name VARCHAR(150);

select * from customers

ALTER TABLE order_items
ADD COLUMN item_id INT PRIMARY KEY,
ADD COLUMN order_id INT,
ADD COLUMN product_id INT,
ADD COLUMN quantity INT,
ADD COLUMN unit_price BIGINT;

ALTER TABLE order_items
ALTER COLUMN unit_price TYPE DECIMAL(10,2);

select * from order_items;

ALTER TABLE orders
ADD COLUMN order_id INT PRIMARY KEY,
ADD COLUMN customer_id INT,
ADD COLUMN order_date DATE,
ADD COLUMN status TEXT;
select * from orders;

ALTER TABLE products
ADD COLUMN product_id INT PRIMARY KEY,
ADD COLUMN name VARCHAR(150),
ADD COLUMN category VARCHAR(100),
ADD COLUMN price NUMERIC(10,2),
ADD COLUMN stock_quantity INT;

select * from products;
