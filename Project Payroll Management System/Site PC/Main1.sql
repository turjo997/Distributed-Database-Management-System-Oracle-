clear screen;

SET SERVEROUTPUT ON;
SET VERIFY OFF;


BEGIN

DBMS_OUTPUT.PUT_LINE('1 = Employee_Yearly_Salary , 2 = Employee_Total_Deduction , 3 = Allocate_Manager_For_Employee 4 = Employee_Overtime_Salary 5 = TrantypeTransaction_Employee 6 = EmoloyeeLeaveForWhy 7 = maxTypeTran_TypeWise 8 = empl_totalLoan_Bear 9 = calculate_compensation 10 = calculate_Deduction');


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
	   S := &Y;
       mypack.Employee_Yearly_Salary(S);	
	   
	ELSIF N = 2 THEN  
       S := &Y;
       mypack.Employee_Total_Deduction(S);
	   
    ELSIF N = 3 THEN	
	    S := &Y;
        mypack.Allocate_Manager_For_Employee(S);
	   
	ELSIF N = 4 THEN 
	
      S := &Y;
	  res := mypack.Employee_Overtime_Salary(S);
	  
	  if res = 0 THEN
	  
	  DBMS_OUTPUT.PUT_LINE('Overtime salary not found');
	  
	  ELSE 
	  
	  DBMS_OUTPUT.PUT_LINE('Total Overtime Salary ' || res);
	  
	  END IF;
	  
    ELSIF N = 5 THEN
     S := &Y;
     res := mypack.TrantypeTransaction_Employee(S);	
	
	  if res = 0 THEN
	  
	  DBMS_OUTPUT.PUT_LINE('Total transactions not found');
	  
	  ELSE 
	  
	  DBMS_OUTPUT.PUT_LINE('Total Transactions ' || res);
	  
	  END IF;

	ELSIF N = 6 THEN
      S := &Y;
      mypack.EmoloyeeLeaveForWhy(S);
	 
	ELSIF N = 7 THEN
      S := &Y;
      mypack.maxTypeTran_TypeWise(S);	
	 
	ELSIF N = 8 THEN
	 S := &Y;
	 
     res := mypack.empl_totalLoan_Bear(S);

   
	 if res = 0 THEN
	  
	  DBMS_OUTPUT.PUT_LINE('No loan taking not found');
	  
	  ELSE 
	  
	  DBMS_OUTPUT.PUT_LINE('Total Loan Bear till now ' || res);
	  
	  END IF;

    ELSIF N = 9 THEN
     
	 S := &Y;
	 res := mypack.calculate_compensation(S , B , C , D);
	 
	 if res = 0 THEN
	  
	  DBMS_OUTPUT.PUT_LINE('Not found');
	  
	  ELSE 
	  
	 DBMS_OUTPUT.PUT_LINE(res || ' ' || B || ' ' || C || ' ' || D);
	  
	  END IF;
	 

    ELSIF N = 10 THEN	
	 
	 S := &Y;
	 res := mypack.calculate_Deduction(S , B , C , D);
	
	  if res = 0 THEN
	  
	  DBMS_OUTPUT.PUT_LINE('Not found');
	  
	  ELSE 
	  
	  DBMS_OUTPUT.PUT_LINE(res || ' ' || B || ' ' || C || ' ' || D);
	  
	  END IF;
    
	ELSE RAISE myException;
	
	END IF;


	EXCEPTION 
		When myException THEN
		DBMS_OUTPUT.PUT_LINE('Invalid Option');  
	   
END;
/
