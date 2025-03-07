CREATE DATABASE IF NOT EXISTS dbtest;
USE dbtest;

CREATE TABLE IF NOT EXISTS cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL,
    state_name VARCHAR(255) NOT NULL,
    tax_rate DECIMAL(5, 2) DEFAULT 0.00
);

CREATE TABLE IF NOT EXISTS stores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

INSERT INTO cities (city_name, state_name, tax_rate) VALUES
('Anchorage', 'Alaska', 0.00),
('Juneau', 'Alaska', 0.00),
('Fairbanks', 'Alaska', 0.00),
('Los Angeles', 'California', 7.25),
('San Diego', 'California', 7.25),
('San Francisco', 'California', 7.25),
('Houston', 'Texas', 6.25),
('Dallas', 'Texas', 6.25),
('Austin', 'Texas', 6.25);

INSERT INTO stores (store_name, city_id) VALUES
('Store1', 1), ('Store2', 1), ('Store3', 1),
('Store1', 4), ('Store2', 4), ('Store3', 4),
('Store1', 7), ('Store2', 7), ('Store3', 7);

INSERT INTO products (product_name, price) VALUES
('Product A', 10.00),
('Product B', 20.00),
('Product C', 30.00);