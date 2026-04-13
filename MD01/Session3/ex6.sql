CREATE SCHEMA library;

CREATE TABLE library.Books(
	book_id INT PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	author VARCHAR(255) NOT NULL,
	published_year INT,
	available BOOLEAN DEFAULT TRUE
);

CREATE TABLE library.Members(
	member_id INT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	join_date DATE DEFAULT CURRENT_DATE
);

SELECT * FROM library.Books;
SELECT * FROM library.Members;