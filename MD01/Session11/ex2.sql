CREATE TABLE accounts(
	account_id SERIAL PRIMARY KEY,
	owner_name VARCHAR(100),
	balance NUMERIC(10,2)
);

INSERT INTO accounts(owner_name, balance) VALUES
('A', 500.00),
('B', 300.00);

SELECT * FROM accounts;

-- Thực hiện giao dịch chuyển tiền hợp lệ
-- Dùng BEGIN; để bắt đầu transaction
-- Cập nhật giảm số dư của A, tăng số dư của B
-- Dùng COMMIT; để hoàn tất
-- Kiểm tra số dư mới của cả hai tài khoản
DO $$
BEGIN
	UPDATE accounts
	SET balance = balance - 100
	WHERE owner_name = 'A';

	UPDATE accounts
	SET balance = balance + 100
	WHERE owner_name = 'B';

	COMMIT;
END;
$$;

-- Thử mô phỏng lỗi và Rollback
-- Lặp lại quy trình trên, nhưng cố ý nhập sai account_id của người nhận
-- Gọi ROLLBACK; khi xảy ra lỗi
-- Kiểm tra lại số dư, đảm bảo không có thay đổi
DO $$
BEGIN
	UPDATE accounts
	SET balance = balance - 100
	WHERE owner_name = 'A';

	UPDATE accounts
	SET balance = balance + 100
	WHERE owner_name = 'C';

	COMMIT;
END;
$$;

