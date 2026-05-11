CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE customer_log (
    log_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    action_time TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION log_new_customer()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO customer_log (customer_name, action_time)
    VALUES (NEW.name, NOW());
    RETURN NEW; 
END;
$$;

CREATE TRIGGER trg_log_new_customer
    AFTER INSERT ON customers
    FOR EACH ROW
    EXECUTE FUNCTION log_new_customer();

INSERT INTO customers (name, email) VALUES
('Nguyễn Văn A', 'a@example.com'),
('Trần Thị B',   'b@example.com');

SELECT * FROM customers;
SELECT * FROM customer_log;