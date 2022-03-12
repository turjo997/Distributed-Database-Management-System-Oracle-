clear screen;

SET SERVEROUTPUT ON;
SET VERIFY OFF;


BEGIN

DBMS_OUTPUT.PUT_LINE('1 = Allocated_Department_Employee , 2 = Department_Wise_SalaryBear , 3 = Find_MaxMin_Sal 
4 = Employee_Works_Under_Manager 5 = Tran_type_wise_transaction 6 = empl_Wise_maxLoan_bear_year 
7 = SubDepartmentAllocatedEmployee 8 = Part_FullTImeInfo 9 = Promotion_Employee 10 = Promotion_Manager'
 
);


END;
/

ACCEPT X NUMBER PROMPT "Choose option = "
ACCEPT Y NUMBER PROMPT "Enter Employee ID = "

DECLARE
   
   N number;
   S number;
   B number;
   C number;
   D number;
   res number;
   
   myException EXCEPTION;
   

BEGIN

    N := &X;
	
	IF N = 1 THEN
	   mypack.Allocated_Department_Employee;
	   
	ELSIF N = 2 THEN  
       mypack.Department_Wise_SalaryBear;
	   
    ELSIF N = 3 THEN	
	   mypack.Find_MaxMin_Sal;
	   
	ELSIF N = 4 THEN 
	
      mypack.Employee_Works_Under_Manager;
	  
  	ELSIF N = 5 THEN
	  res := mypack.Tran_type_wise_transaction;
	   
	  IF res = -1 THEN
        
		DBMS_OUTPUT.PUT_LINE('No transaction Occurs');
		
	  ELSE
  	  
	     DBMS_OUTPUT.PUT_LINE('Total Transaction appears ' || res);
		 
	  END IF;
	  
    ELSIF N = 6 THEN
     mypack.empl_Wise_maxLoan_bear_year;

	ELSIF N = 7 THEN
      mypack.SubDepartmentAllocatedEmployee;
	 
	ELSIF N = 8 THEN
     mypack.Part_FullTImeInfo;	
	 
	ELSIF N = 9 THEN
     mypack.Promotion_Employee;

    ELSIF N = 10 THEN
     mypack.Promotion_Manager;

	ELSE RAISE myException;
	
	END IF;

	EXCEPTION 
		When myException THEN
		DBMS_OUTPUT.PUT_LINE('Invalid Option');  
	   
END;
/
