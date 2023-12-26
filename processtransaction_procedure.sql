--------------------------------------------------------
--  File created - Tuesday-December-26-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROCESSTRANSACTION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER20"."PROCESSTRANSACTION" (
    p_account_id IN INT,
    p_amount IN NUMBER,
    p_location IN VARCHAR2,
    p_transaction_type IN VARCHAR2
) AS
    v_balance NUMBER;
BEGIN
    -- Get the current balance of the account
    SELECT Balance INTO v_balance
    FROM Account
    WHERE Account# = p_account_id;

    -- Check if there is sufficient balance for withdrawals and transfers
    IF (p_transaction_type = 'Withdrawal' OR p_transaction_type = 'Transfer') AND (v_balance - p_amount) < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insufficient funds for ' || p_transaction_type);
        RETURN;
    END IF;

    -- Update the account balance based on the transaction type
    CASE p_transaction_type
        WHEN 'Deposit' THEN
            v_balance := v_balance + p_amount;
        WHEN 'Withdrawal' THEN
            v_balance := v_balance - p_amount;
        WHEN 'Transfer' THEN
            -- Assuming the transfer involves two accounts
            -- You would need to specify the target account for the transfer
            -- For simplicity, I'm subtracting the amount from the source account
            v_balance := v_balance - p_amount;
    END CASE;

    -- Update the account balance
    UPDATE Account
    SET Balance = v_balance
    WHERE Account# = p_account_id;

    -- Insert the transaction record
    INSERT INTO Transaction (Account#, Amount, IssueDate, Location, Type)
    VALUES (p_account_id, p_amount, CURRENT_TIMESTAMP, p_location, p_transaction_type);

    DBMS_OUTPUT.PUT_LINE(p_transaction_type || ' successful. New balance: ' || v_balance);
END;

/
