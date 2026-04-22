CREATE TABLE post (
post_id SERIAL PRIMARY KEY,
user_id INT NOT NULL,
content TEXT,
tags TEXT[],
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
is_public BOOLEAN DEFAULT TRUE
);


CREATE TABLE post_like (
user_id INT NOT NULL,
post_id INT NOT NULL,
liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (user_id, post_id)
);

-- Tạo dữ liệu mẫu cho post
INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT
    (random() * 1000 + 1)::INT,
    CASE
        WHEN i % 100 = 0 THEN 'Bài viết về du lịch: Khám phá Phú Quốc, du lịch biển'
        WHEN i % 50 = 0 THEN 'Chia sẻ kinh nghiệm du lịch Đà Lạt mùa hoa dã quỳ'
        ELSE 'Nội dung bài viết số ' || i
    END,
    CASE
        WHEN i % 10 = 0 THEN ARRAY['travel', 'adventure']
        WHEN i % 7 = 0 THEN ARRAY['food', 'travel']
        ELSE ARRAY['life', 'daily']
    END,
    NOW() - (random() * INTERVAL '60 days'),
    random() > 0.2   -- 80% bài đăng là public
FROM generate_series(1, 100000) i;

SELECT * FROM post;
SELECT * FROM post_like;

-- Yêu cầu 1: Tối ưu tìm kiếm bài đăng công khai theo từ khóa trong content
SELECT * FROM post
WHERE is_public = TRUE AND content ILIKE '%du lịch%';

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM post
WHERE is_public = TRUE AND content ILIKE '%du lịch%'; -- 136.050ms

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_post_content_trgm ON post USING GIN( content gin_trgm_ops);

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM post
WHERE is_public = TRUE AND content ILIKE '%du lịch%'; -- 10.531ms --> tốc độ truy vấn nhanh hơn

-- Yêu cầu 2: Tìm kiếm bài đăng theo tags với toán tử @>
SELECT * FROM post WHERE tags @> ARRAY['travel'];

EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM post WHERE tags @> ARRAY['travel']; -- 35.67ms

CREATE INDEX idx_post_tags_gin ON post USING GIN (tags);

EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM post WHERE tags @> ARRAY['travel']; -- 9.296ms -->  tốc độ truy vấn nhanh hơn

-- Yêu cầu 3: Tối ưu truy vấn bài đăng công khai trong 7 ngày gần nhất
SELECT * FROM post
WHERE is_public = TRUE 
  AND created_at >= NOW() - INTERVAL '7 days';

CREATE INDEX idx_post_recent_public ON post(created_at DESC)
WHERE is_public = TRUE;

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM post
WHERE is_public = TRUE 
  AND created_at >= NOW() - INTERVAL '7 days'
ORDER BY created_at DESC; -- chỉ Scan 9442 bản ghi gần nhất

-- Yêu cầu 4: Composite Index (user_id, created_at DESC)
SELECT * FROM post
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 20;

CREATE INDEX idx_post_user_created ON post(user_id, created_at DESC);

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM post
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 20; --> dữ liệu được sca trong 99 bản ghi phù hợp

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'post';


DROP INDEX IF EXISTS idx_post_content_trgm;
DROP INDEX IF EXISTS idx_post_tags_gin;
DROP INDEX IF EXISTS idx_post_recent_public;
DROP INDEX IF EXISTS idx_post_user_created;
