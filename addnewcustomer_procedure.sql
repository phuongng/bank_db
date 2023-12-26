--------------------------------------------------------
--  File created - Tuesday-December-26-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADDNEWCUSTOMER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER20"."ADDNEWCUSTOMER" (
    p_SSN INT,
    p_Lname VARCHAR2,
    p_Fname VARCHAR2,
    p_DOB DATE,
    p_Address VARCHAR2,
    p_CustomerType VARCHAR2,
    p_Result OUT VARCHAR2
) AS
    v_CustomerCount INT;

BEGIN
    -- Check if the customer already exists
    SELECT COUNT(*) INTO v_CustomerCount
    FROM Customer
    WHERE SSN = p_SSN;

    IF v_CustomerCount = 0 THEN
        -- Check if the customer type is valid
        IF p_CustomerType IN ('Personal', 'Business', 'Joint') THEN
            -- Insert the new customer
            INSERT INTO Customer (SSN, Lname, Fname, DOB, Address, CustomerType)
            VALUES (p_SSN, p_Lname, p_Fname, p_DOB, p_Address, p_CustomerType);

            p_Result := 'Success: Customer added successfully.';
        ELSE
            p_Result := 'Error: Invalid customer type.';
        END IF;
    ELSE
        p_Result := 'Error: Customer with the same SSN already exists.';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_Result := 'Error: An unexpected error occurred. Please try again.';
END AddNewCustomer;

/
