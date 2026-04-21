-- Tạo bảng
CREATE TABLE Product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(15,2),
    stock INT
);

-- Thêm 5 sản phẩm
INSERT INTO Product (name, category, price, stock) VALUES
('iPhone 15 Pro', 'Điện tử', 28000000, 15),
('Tai nghe Bluetooth', 'Điện tử', 1500000, 50),
('Tủ lạnh Samsung', 'Điện lạnh', 12000000, 5),
('Bàn làm việc', 'Nội thất', 2000000, 20),
('Sạc dự phòng', 'Điện tử', 800000, 100);

SELECT * FROM Product;

SELECT * FROM Product 
ORDER BY price DESC 
LIMIT 3;

SELECT * FROM Product 
WHERE category = 'Điện tử' AND price < 10000000;

SELECT * FROM Product 
ORDER BY stock ASC;