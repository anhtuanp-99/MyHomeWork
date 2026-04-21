CREATE TABLE OrderInfo (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total NUMERIC(15,2),
    status VARCHAR(20)
);

INSERT INTO OrderInfo (customer_id, order_date, total, status) VALUES
(1, '2024-10-05', 650000, 'Completed'),
(2, '2024-10-15', 300000, 'Pending'),
(3, '2024-11-01', 1200000, 'Completed'),
(1, '2024-10-25', 450000, 'Cancelled'),
(4, '2024-12-10', 800000, 'Shipping');

SELECT * FROM OrderInfo 
WHERE total > 500000;

SELECT * FROM OrderInfo 
WHERE order_date BETWEEN '2024-10-01' AND '2024-10-31';

SELECT * FROM OrderInfo 
WHERE status <> 'Completed';

SELECT * FROM OrderInfo 
ORDER BY order_date DESC 
LIMIT 2;