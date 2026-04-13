CREATE DATABASE LibraryDB;
--tao schemas
CREATE SCHEMA library;

--tao bang Books
CREATE TABLE library.Books(
	book_id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	author VARCHAR(50) NOT NULL,
	published_year INT,
	price NUMERIC(10, 2)
);

--xem tat ca cac data base
SELECT datname FROM pg_database;

--xem tat ca cac schema trong database hien tai
SELECT schema_name FROM information_schema.schemata;

--xem cau truc bang Books
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'library' and table_name = 'books';

--them du lieu
INSERT INTO library.Books(title, author, published_year, price)
VALUES 
('Clean Code', 'Robert', 2008, 15.5),
('Habits', 'James', 2015, 12.34);

--xem du lieu
SELECT * FROM library.Books;
