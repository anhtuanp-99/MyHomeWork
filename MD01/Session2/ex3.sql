CREATE SCHEMA sales;

CREATE TABLE sales.Customers(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	phone VARCHAR(20) NULL
);

CREATE TABLE sales.Products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL UNIQUE,
	price NUMERIC(10,2) NOT NULL,
	stock_quantity INT NOT NULL
);

CREATE TABLE sales.Orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL REFERENCES sales.Customers(customer_id),
	order_date DATE NOT NULL
);

CREATE TABLE sales.OrderItems(
	order_item_id SERIAL PRIMARY KEY,
	order_id INT NOT NULL REFERENCES sales.Orders(order_id),
	product_id INT NOT NULL REFERENCES sales.Products(product_id),
	quantity INT NOT NULL CHECK(quantity >= 1)
);

