CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    balance NUMERIC(12,2)
);

CREATE TABLE transactions (
    trans_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    amount NUMERIC(12,2),
    trans_type VARCHAR(20) CHECK (trans_type IN ('WITHDRAW','DEPOSIT')),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO accounts (customer_name, balance) VALUES
('Nguyen Van A', 1000.00),
('Tran Thi B',   2000.00);

DO $$
DECLARE
    v_balance NUMERIC(12,2);
    v_withdraw_amount NUMERIC := 300.00;   -- Số tiền muốn rút
    v_account_id INT := 1;                 -- Tài khoản của 'Nguyen Van A'
BEGIN
    -- 1. Lấy số dư hiện tại, kiểm tra tài khoản tồn tại
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = v_account_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tài khoản % không tồn tại', v_account_id;
    END IF;

    -- 2. Kiểm tra đủ tiền
    IF v_balance < v_withdraw_amount THEN
        RAISE EXCEPTION 'Số dư không đủ. Hiện có: %, cần rút: %', v_balance, v_withdraw_amount;
    END IF;

    -- 3. Trừ số dư
    UPDATE accounts
    SET balance = balance - v_withdraw_amount
    WHERE account_id = v_account_id;

    -- 4. Ghi log giao dịch
    INSERT INTO transactions (account_id, amount, trans_type)
    VALUES (v_account_id, v_withdraw_amount, 'WITHDRAW');

    COMMIT;
    RAISE NOTICE 'Rút tiền thành công. Số dư mới: %', v_balance - v_withdraw_amount;
END;
$$;

SELECT * FROM accounts;       -- balance của account 1 giảm còn 700
SELECT * FROM transactions;   -- có 1 dòng WITHDRAW 300


DO $$
DECLARE
    v_balance NUMERIC(12,2);
    v_withdraw_amount NUMERIC := 200.00;
    v_account_id INT := 1;          -- tài khoản hợp lệ
    v_bad_account_id INT := 999;    -- tài khoản không tồn tại để gây lỗi
BEGIN
    -- Lấy số dư
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = v_account_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tài khoản % không tồn tại', v_account_id;
    END IF;

    IF v_balance < v_withdraw_amount THEN
        RAISE EXCEPTION 'Số dư không đủ';
    END IF;

    -- Trừ tiền (tạm thời)
    UPDATE accounts
    SET balance = balance - v_withdraw_amount
    WHERE account_id = v_account_id;

    -- Ghi log sai account_id để tạo lỗi
    INSERT INTO transactions (account_id, amount, trans_type)
    VALUES (v_bad_account_id, v_withdraw_amount, 'WITHDRAW');

    COMMIT;
END;
$$;