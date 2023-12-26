--------------------------------------------------------
--  File created - Tuesday-December-26-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure DELETECUSTOMER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER20"."DELETECUSTOMER" (
    p_full_name VARCHAR2
) AS
    v_customer_id INT;
    v_success_message VARCHAR2(100);
BEGIN
    -- Find the customer ID based on the full name
    SELECT Customer_id
    INTO v_customer_id
    FROM Customer
    WHERE Lname || ', ' || Fname = p_full_name;

    -- Check if the customer exists
    IF v_customer_id IS NULL THEN
        v_success_message := 'Customer with full name ' || p_full_name || ' not found.';
    ELSE
        -- Delete transactions associated with the customer's accounts
        DELETE FROM Transaction
        WHERE Account# IN (SELECT Account# FROM Account WHERE Customer_id = v_customer_id);

        -- Delete the customer's accounts
        DELETE FROM Account WHERE Customer_id = v_customer_id;

        -- Delete the customer
        DELETE FROM Customer WHERE Customer_id = v_customer_id;

        v_success_message := 'Customer ' || p_full_name || ' and related information deleted successfully.';
    END IF;

    -- Print the result message
    DBMS_OUTPUT.PUT_LINE(v_success_message);
END;

/
