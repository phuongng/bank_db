--------------------------------------------------------
--  File created - Tuesday-December-26-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure UPDATECUSTOMERADDRESS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER20"."UPDATECUSTOMERADDRESS" (
    p_customer_id INT,
    p_new_address VARCHAR2
) AS
    v_customer_count INT;
    v_success_message VARCHAR2(100);
BEGIN
    -- Check if the customer exists
    SELECT COUNT(*)
    INTO v_customer_count
    FROM Customer
    WHERE Customer_id = p_customer_id;

    IF v_customer_count = 0 THEN
        v_success_message := 'Customer with ID ' || p_customer_id || ' does not exist.';
    ELSE
        -- Update the customer's address
        UPDATE Customer
        SET Address = p_new_address
        WHERE Customer_id = p_customer_id;

        v_success_message := 'Address updated successfully for customer with ID ' || p_customer_id;
    END IF;

    -- Print the result message
    DBMS_OUTPUT.PUT_LINE(v_success_message);
END;

/
