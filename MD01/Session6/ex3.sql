CREATE TABLE Customer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    points INT
);

INSERT INTO Customer (name, email, phone, points) VALUES
('Nguyễn Văn An', 'an.nguyen@gmail.com', '0901234567', 500),
('Trần Thị Bình', 'binh.tran@gmail.com', '0912345678', 1200),
('Lê Văn Cường', 'cuong.le@gmail.com', '0923456789', 850),
('Nguyễn Văn An', 'an.copy@gmail.com', '0934567890', 300), -- Trùng tên để test DISTINCT
('Hoàng Nam', NULL, '0945678901', 900),                 -- Không có email
('Phạm Diệu Linh', 'linh.pham@gmail.com', '0956789012', 2000),
('Vũ Hoàng Long', 'long.vu@gmail.com', '0967890123', 1500);

SELECT DISTINCT name FROM Customer;

SELECT * FROM Customer 
WHERE email IS NULL;

SELECT * FROM Customer 
ORDER BY points DESC 
LIMIT 3 OFFSET 1;

SELECT * FROM Customer 
ORDER BY name DESC;