--------------------------------------------------------
--  File created - Tuesday-December-26-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GETAVERAGETRANSACTIONAMOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER20"."GETAVERAGETRANSACTIONAMOUNT" (p_state VARCHAR2) AS
    v_total_amount NUMBER := 0;
    v_customer_count NUMBER := 0;
    v_average_amount NUMBER;
BEGIN
    -- Calculate the total transaction amount and count of customers in the given state
    FOR c IN (
        SELECT t.Amount
        FROM Transaction t
        JOIN Account a ON t.Account# = a.Account#
        JOIN Customer c ON a.Customer_id = c.Customer_id
        WHERE c.Address LIKE '%' || p_state || '%'
    ) LOOP
        v_total_amount := v_total_amount + c.Amount;
        v_customer_count := v_customer_count + 1;
    END LOOP;

    -- Calculate the average amount
    IF v_customer_count > 0 THEN
        v_average_amount := v_total_amount / v_customer_count;
        DBMS_OUTPUT.PUT_LINE('Average Transaction Amount for customers in ' || p_state || ': $' || TO_CHAR(v_average_amount, '999,999.99'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('No customers found in ' || p_state);
    END IF;
END;

/
