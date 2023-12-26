--------------------------------------------------------
--  File created - Tuesday-December-26-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table ACCOUNT
--------------------------------------------------------

  CREATE TABLE "USER20"."ACCOUNT" 
   (	"ACCOUNT#" NUMBER(*,0) GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"CUSTOMER_ID" NUMBER(*,0), 
	"BALANCE" NUMBER(19,4), 
	"DATEOPENED" TIMESTAMP (6), 
	"ACCOUNTTYPE" VARCHAR2(255 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USER02" ;
REM INSERTING into USER20.ACCOUNT
SET DEFINE OFF;
Insert into USER20.ACCOUNT (ACCOUNT#,CUSTOMER_ID,BALANCE,DATEOPENED,ACCOUNTTYPE) values (3,2,600,to_timestamp('10-DEC-23 09.19.50.262000000 PM','DD-MON-RR HH.MI.SSXFF AM'),'Savings');
Insert into USER20.ACCOUNT (ACCOUNT#,CUSTOMER_ID,BALANCE,DATEOPENED,ACCOUNTTYPE) values (4,3,25000.75,to_timestamp('10-DEC-23 09.19.50.309000000 PM','DD-MON-RR HH.MI.SSXFF AM'),'Checking');
Insert into USER20.ACCOUNT (ACCOUNT#,CUSTOMER_ID,BALANCE,DATEOPENED,ACCOUNTTYPE) values (5,4,10000,to_timestamp('10-DEC-23 09.19.50.403000000 PM','DD-MON-RR HH.MI.SSXFF AM'),'Savings');
Insert into USER20.ACCOUNT (ACCOUNT#,CUSTOMER_ID,BALANCE,DATEOPENED,ACCOUNTTYPE) values (6,4,7500.25,to_timestamp('10-DEC-23 09.19.50.466000000 PM','DD-MON-RR HH.MI.SSXFF AM'),'Checking');
Insert into USER20.ACCOUNT (ACCOUNT#,CUSTOMER_ID,BALANCE,DATEOPENED,ACCOUNTTYPE) values (7,5,3000,to_timestamp('10-DEC-23 09.19.50.512000000 PM','DD-MON-RR HH.MI.SSXFF AM'),'Savings');
--------------------------------------------------------
--  DDL for Index SYS_C0016577
--------------------------------------------------------

  CREATE UNIQUE INDEX "USER20"."SYS_C0016577" ON "USER20"."ACCOUNT" ("ACCOUNT#") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USER02" ;
--------------------------------------------------------
--  DDL for Trigger MAINTAINBALANCETRIGGER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "USER20"."MAINTAINBALANCETRIGGER" 
BEFORE INSERT OR UPDATE ON Account
FOR EACH ROW
DECLARE
    v_balance NUMBER;
BEGIN
    -- Get the current balance
    SELECT Balance INTO v_balance
    FROM Account
    WHERE Account# = :NEW.Account#;

    -- Update the balance based on the transaction type
    IF INSERTING THEN
        :NEW.Balance := v_balance + :NEW.Balance;
    ELSIF UPDATING THEN
        :NEW.Balance := :NEW.Balance - v_balance + :OLD.Balance;
    END IF;
END;

/
ALTER TRIGGER "USER20"."MAINTAINBALANCETRIGGER" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VALIDATIONTRIGGER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "USER20"."VALIDATIONTRIGGER" 
BEFORE INSERT OR UPDATE ON Account
FOR EACH ROW
DECLARE
    v_customer_type VARCHAR2(255);
BEGIN
    -- Get the customer type associated with the account
    SELECT CustomerType INTO v_customer_type
    FROM Customer
    WHERE Customer_id = :NEW.Customer_id;

    -- Validate account and customer types
    IF :NEW.AccountType NOT IN ('Savings', 'Checking') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid account type');
    END IF;

    IF v_customer_type NOT IN ('Personal', 'Business', 'Joint') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid customer type');
    END IF;

    -- Check if balance is not going below zero
    IF :NEW.Balance < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Balance cannot go below zero');
    END IF;

    -- Add other validation checks as needed
END;

/
ALTER TRIGGER "USER20"."VALIDATIONTRIGGER" ENABLE;
--------------------------------------------------------
--  Constraints for Table ACCOUNT
--------------------------------------------------------

  ALTER TABLE "USER20"."ACCOUNT" MODIFY ("ACCOUNT#" NOT NULL ENABLE);
  ALTER TABLE "USER20"."ACCOUNT" MODIFY ("CUSTOMER_ID" NOT NULL ENABLE);
  ALTER TABLE "USER20"."ACCOUNT" ADD PRIMARY KEY ("ACCOUNT#")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USER02"  ENABLE;
  ALTER TABLE "USER20"."ACCOUNT" ADD CONSTRAINT "CHECKBALANCENOTBELOWZERO" CHECK (Balance >= 0) ENABLE;
  ALTER TABLE "USER20"."ACCOUNT" ADD CONSTRAINT "CHECKACCOUNTTYPE" CHECK (AccountType IN ('Savings', 'Checking')) ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ACCOUNT
--------------------------------------------------------

  ALTER TABLE "USER20"."ACCOUNT" ADD FOREIGN KEY ("CUSTOMER_ID")
	  REFERENCES "USER20"."CUSTOMER" ("CUSTOMER_ID") ENABLE;