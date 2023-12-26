--------------------------------------------------------
--  File created - Tuesday-December-26-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure UPDATE_EMP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER20"."UPDATE_EMP" 
(new_emp_id int, new_sal number)
IS
--USED FOR ERROR CHECKING
v_ErrorCode number; v_ErrorMsg Varchar2(200); v_CurrentUser Varchar2(100);
BEGIN
   -- update employee's salary
   UPDATE emp
   SET salary = salary + 1000
   WHERE emp_id = new_emp_id;

END;

/
