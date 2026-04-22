CREATE TABLE book(
	book_id SERIAL PRIMARY KEY,
	title VARCHAR(255),
	author VARCHAR(100),
	genre VARCHAR(50),
	price DECIMAL(10,2),
	description TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS book CASCADE;

INSERT INTO book(title, author, genre, price, description)
SELECT
	'Book Title ' || i,
	CASE WHEN i % 1000 = 0 THEN 'J.K Rowling'
		 WHEN i % 500 = 0 THEN 'George R.R Martin'
		 else 'Author ' || (i % 100)
	END,
	CASE WHEN i % 3 = 0 THEN 'Fantasy'
		 WHEN i % 5 = 0 THEN 'Science Fiction'
		 else 'Mystery'
	END,
	(random() * 50 + 10 ) :: DECIMAL(10, 2),
	'Description ' || i || '. This is a sample text with keywords like magic, dragon, space.'
FROM generate_series(1, 500000) i;

SELECT * FROM book;

--kiem tra truy van
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM book WHERE author ILIKE '%Rowling%';

EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM book WHERE genre = 'Fantasy';
-- kết quả: cả 2 đều sử dụng Seq Scan(quét toàn bộ bảng) và có thời gian thực thi lớn: 228.650ms và 88.196ms

-- a. tạo chỉ mục cho cột genre
CREATE INDEX idx_book_genre on book(genre);
-- đo lại
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM book WHERE genre = 'Fantasy';
-- kết quả: chuyển thành Bitmap Index Scan, thời gian giảm rõ rệt: 54.637ms

-- b. Gin index hỗ trợ tìm kiếm
create extension if not exists pg_trgm; -- bat extension
CREATE INDEX idx_book_author_trgm ON book USING gin (author gin_trgm_ops) -- tao GIN index tren cot author

EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM book WHERE author ILIKE '%Rowling%';
-- kết quả: truy vấn sử dụng Bitmap Index Scan trên idx_book_author_trgm, thời gian giảm còn 2.020ms, giảm mạnh so với Seq Scan

-- c. GIN index cho Full‑Text Search trên title và description
CREATE INDEX index_book_title_trgm ON book USING gin(title gin_trgm_ops); 
CREATE INDEX idx_book_description_trgm ON book USING gin(description gin_trgm_ops);

SELECT * FROM book WHERE title ILIKE '%magic%' OR description ILIKE '%dragon%';

SELECT 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE TABLEname = 'book';

SELECT ctid, book_id, genre FROM book ORDER BY ctid;

CREATE INDEX idx_book_genre_cluster ON book(genre);

CLUSTER book USING idx_book_genre_cluster;

-- Truy vấn lấy tất cả sách thể loại Fantasy (có thể nằm liền kề nhau trên đĩa)
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM book WHERE genre = 'Fantasy';
-- kết quả: Số lần đọc khối (buffers read) giảm do các dòng cùng genre được lưu gần nhau, thời gian thực thi giảm