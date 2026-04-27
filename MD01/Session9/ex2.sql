CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	email VARCHAR(255) NOT NULL,
	user_name VARCHAR(100) NOT NULL
);

-- Yêu cầu:

-- 		Tạo Hash Index trên cột email
-- 		Viết truy vấn SELECT * FROM Users WHERE email = 'example@example.com'; và kiểm tra kế hoạch thực hiện bằng EXPLAIN

INSERT INTO users(email, user_name)
SELECT
	'user_' || i || '@gmail.com',
	'user_' || i
FROM generate_series(1, 500000) AS i;

SELECT * FROM users;

UPDATE users
SET email = 'A@gmail.com'
WHERE user_id = 1234;

-- Kiểm tra hiệu suất trước khi tạo index
EXPLAIN(ANALYZE, BUFFERS)
SELECT * FROM users WHERE email = 'A@gmail.com'; 
-- Seq Scan on users, Rows Removed by Filter: 166666	Buffers: shared hit=4166	Execution Time: 108.954 ms

CREATE INDEX idx_users_email_hash ON users USING HASH (email);

-- Kiểm tra lại hiệu suất sau khi tạo index
EXPLAIN(ANALYZE, BUFFERS)
SELECT * FROM users WHERE email = 'A@gmail.com'; 
-- Index Scan using idx_users_email_hash on users   Buffers: shared hit=15	Execution Time: 4.809 ms --> truy vấn nhanh hơn

DROP INDEX IF EXISTS idx_users_email_hash;