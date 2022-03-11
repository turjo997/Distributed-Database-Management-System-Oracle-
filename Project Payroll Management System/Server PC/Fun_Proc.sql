clear screen;

set serveroutput on;
set verify off;

drop view CompensationView;
drop view DeductionView;
drop view ManagerView;
drop view DepartmentView;
drop view EmployeeView;
drop view OvertimeView;
drop view TransactionView;
drop view AuditView;
drop view LeaveView;
drop view GradeView;
drop view IncreView;


create or replace view CompensationView as (select * from Compensation union select * from Compensation3@site);
create or replace view DeductionView as (select * from Deduction union select * from Deduction3@site);
create or replace view ManagerView as (select * from Manager union select * from Manager3@site);
create or replace view DepartmentView as (select * from Department union select * from Department3@site);
create or replace view EmployeeView as (select * from Employee union select * from Employee3@site);
create or replace view OvertimeView as (select * from Overtime union select * from Overtime3@site);
create or replace view TransactionView as (select * from tran1 union select * from tran3@site);
create or replace view AuditView as (select * from audit1 union select * from audit3@site);
create or replace view LeaveView as (select * from Leave union select * from Leave3@site);
create or replace view GradeView as (select * from Grade union select * from Grade3@site);
create or replace view EmpView as (select * from Emp union select * from Emp3@site);
create or replace view IncreView as (select * from Incre union select * from Incre3@site);


create or replace package mypack as

procedure Allocated_Department_Employee;
procedure Department_Wise_SalaryBear;
procedure Find_MaxMin_Sal;
procedure Employee_Works_Under_Manager;

function Tran_type_wise_transaction
return number;
procedure empl_Wise_maxLoan_bear_year;
procedure SubDepartmentAllocatedEmployee;
procedure Part_FullTImeInfo;

procedure Promotion_Employee;
procedure Promotion_Manager;

end mypack;
/


create or replace package body mypack as

-----1
procedure Allocated_Department_Employee

is 
Y DepartmentView.DeptName%type;
TotalCount number;
DeptCount number;
myException exception;

begin 

     select count(EmployeeID) into TotalCount from EmployeeView;
	   
	 select count(DeptID) into DeptCount from DepartmentView;
   
   
      IF TotalCount = 0 or DeptCount = 0 THEN
	    
		raise myException;
	  
      ELSE 
	 
       FOR R in (select DeptName from DepartmentView) LOOP
		  
		  Y := R.DeptName; 
		  TotalCount := 0;
		  
		  For X in (select count(EmployeeID) as TotalCount from EmployeeView
		  where DeptID in (select DeptID from DepartmentView where DeptName = Y))LOOP
		  
		    DBMS_OUTPUT.PUT_LINE(Y || '  Department has total employes of  ' || X.TotalCount);
			
		  END LOOP;
		 
		 end loop;
		 
      END IF;	
    

     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');	  

end Allocated_Department_Employee;


-----2
procedure Department_Wise_SalaryBear

is

B  CompensationView.Basic%type;
C  CompensationView.TravelAllowance%type;
D  CompensationView.DearnessAllowance%type;
E  CompensationView.HouseRentAllowance%type;
F  CompensationView.MedicalAllowance%type;
G  CompensationView.Bonus%type;
Y  DepartmentView.DeptName%type;
Total number;
TotalCount number;
DeptCount number;
myException exception;

begin

       select count(SalaryID) into TotalCount from CompensationView;
	   
	   select count(DeptID) into DeptCount from DepartmentView;
	   
       
	   IF TotalCount = 0 or DeptCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE 
	   
       For R in (select DeptName from DepartmentView)loop
		  Y := R.DeptName; 
		  --Total := 0; 
		  For Z in (select distinct(Year_) from CompensationView)LOOP
		    Total := 0; 
		    For X in(select * from CompensationView where Year_ = Z.Year_ and DeptID
				  in (select DeptID from DepartmentView where DeptName = Y))LOOP
				  
					   B := X.Basic;
					   C := X.TravelAllowance;
					   D := X.DearnessAllowance;
					   E := X.HouseRentAllowance;
					   F := X.MedicalAllowance;
					   G := X.Bonus;
					   
					   Total := Total + B + C + D + E + F + G;
					 
				  END LOOP;
				  
				  
				  IF Total != 0 THEN
				  
				  DBMS_OUTPUT.PUT_LINE(Y || '  Department bears total salary of  ' || Total || ' in the year of ' || Z.Year_);
				  
				  END IF;
		  
		 end loop;
		 
		end loop;
		
		END IF;
		
		EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
		
end Department_Wise_SalaryBear;


------3
procedure Find_MaxMin_Sal

is
maxBasicSal number;
minBasicSal number;
TotalCount number;
DeptCount number;
myException exception;

begin

       select count(SalaryID) into TotalCount from CompensationView;
	   
	   select count(DeptID) into DeptCount from DepartmentView;
	   
       
	   IF TotalCount = 0 or DeptCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE 
	   

      FOR R in (select max(Basic) as maxBasicSal,DeptID  from CompensationView GROUP BY DeptID ORDER BY maxBasicSal ASC)LOOP
	   
	     FOR X in (select DeptName from DepartmentView where DeptID = R.DeptID) LOOP
	
	         DBMS_OUTPUT.PUT_LINE(X.DeptName || ' Maximum Basic Salary ' || R.maxBasicSal); 
	
         END LOOP;
   
      END LOOP;


   FOR R in (select min(Basic) as minBasicSal, DeptID  from CompensationView GROUP BY DeptID ORDER BY minBasicSal ASC)LOOP
	   
	    FOR X in (select DeptName from DepartmentView where DeptID = R.DeptID) LOOP

	       DBMS_OUTPUT.PUT_LINE(X.DeptName || ' Minimum Basic Salary ' || R.minBasicSal);
	   
        END LOOP;
   
   END LOOP;
   
    END IF;
	
	EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
	

end Find_MaxMin_Sal;

--------4
procedure Employee_Works_Under_Manager

IS 
total number;
manCount number;
empCount number;

myException exception;
BEGIN

       select count(ManagerID) into manCount from ManagerView;
	   
	   select count(EmployeeID) into empCount from EmployeeView;
	   
       
	   IF manCount = 0 or empCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE 
	   

	For R in (SELECT * from ManagerView)LOOP
		
	  For X in (SELECT count(EmployeeID) as total from EmployeeView where ManagerID = R.ManagerID)LOOP
	 
		 For Y in (SELECT ManagerName from ManagerView where ManagerID = R.ManagerID)LOOP
			
			DBMS_OUTPUT.PUT_LINE(X.total || ' numbers of Employee works under ' || Y.ManagerName);
		  
		  END LOOP;
		  
	  END LOOP;

	END LOOP;
	
	END IF;
	
	EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');

end Employee_Works_Under_Manager;

-------5
function Tran_type_wise_transaction
return number

is
total number;
totaltran number;
check_val number;
	   
myException exception;

begin

    totaltran := -1;
	
    select count(TranID) into check_val from TransactionView; 
    
	IF check_val != 0 THEN

    totaltran := 0;
     
	FOR R in (select * from TransactionView) LOOP
     
     total := 0;
     
	 FOR X in(select * from AuditView where TranID in (select TranID from TransactionView where Trantype = R.Trantype))LOOP
		   		
			total := total + X.amount;	   
	 END LOOP;
	        totaltran := totaltran + total;

	 
	 DBMS_OUTPUT.PUT_LINE(R.Trantype || ' transactions ' || total || ' taka');
	  
	END LOOP;
	
	ELSE raise myException;
	
	END IF ;
    
	return totaltran;
	
	EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');

     
	 
end Tran_type_wise_transaction;



--------6
procedure empl_Wise_maxLoan_bear_year 
is
ID number;
TotalCount number;
myException exception;
BEGIN

   select count(EmployeeID) into TotalCount from DeductionView;
	   
	   IF TotalCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE 

	 FOR X in (Select distinct(EmployeeID) as ID from DeductionView)LOOP
	 
	  FOR R in (Select max(Loan) as loan, Year_  from DeductionView where EmployeeID = X.ID GROUP BY Year_ ORDER BY loan ASC)LOOP
	 
		 IF R.loan != 0 Then
		 
		 DBMS_OUTPUT.PUT_LINE(X.ID || ' ' || R.loan || ' in the year of ' || R.Year_);
		
		 END IF;
		 
		END LOOP;
		
	 END LOOP;
 
  FOR X in (Select distinct(EmployeeID) as ID from DeductionView)LOOP
 
  FOR R in (Select max(Loan) as loan from DeductionView where EmployeeID = X.ID ORDER BY loan ASC)LOOP
 
     IF R.loan != 0 Then
	 
     DBMS_OUTPUT.PUT_LINE(X.ID || ' bears maximum loan of ' || R.loan);
	
	 END IF;
	 
    END LOOP;
	
 END LOOP;
 
 END IF;
 
 EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
 
END empl_Wise_maxLoan_bear_year;


-------7
procedure SubDepartmentAllocatedEmployee

is 
Y DepartmentView.DeptName%type;
TotalCount number; 
DeptCount number;
GradeCount number;
myException exception;
begin 
   
   
    select count(DeptID) into DeptCount from DepartmentView;
	select count(DeptID) into GradeCount from GradeView;
	   
	   IF DeptCount = 0 or GradeCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE
	   
    FOR R in(select DeptID , DeptName from DepartmentView)LOOP
		  
	  TotalCount := 0;
		  
	  For Z in (select GradeName from GradeView where DeptID = R.DeptID)LOOP
	
     	For X in(select count(EmployeeID) as TotalCount from EmployeeView where DeptID = R.DeptID and 
   	     Employee_title = Z.GradeName)LOOP
		  
         DBMS_OUTPUT.PUT_LINE(R.DeptName || '  Department of ' || Z.GradeName || ' sub dept has ' || X.TotalCount || ' Employees');
			
			
        END LOOP;	 
	
	END loop;
   
   END LOOP;
   
   END IF;

  EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');   

end SubDepartmentAllocatedEmployee;


------8
procedure Part_FullTImeInfo

IS

empCount number;
emplCount number;
myException exception;

BEGIN
  
    select count(EmployeeID) into empCount from EmpView;
	select count(EmployeeID) into emplCount from EmployeeView;
	   
	   IF empCount = 0 or emplCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE  
   
   
FOR R in (select distinct(WorkType) as worktype from EmpView)LOOP
     
 FOR X in (select EmployeeView.Employee_name as name,EmployeeView.ManagerID as manid , EmployeeView.Employee_title as title, EmpView.WorkType as wtype , EmpView.DurationHours as hours from EmployeeView inner join EmpView on EmployeeView.EmployeeID = EmpView.EmployeeID  where EmpView.WorkType = R.worktype)LOOP
	 
	 DBMS_OUTPUT.PUT_LINE('Name : ' || X.name || ' ' || 'Manager ID : ' || X.manID || ' ' || 'Employee Title : ' || X.title || ' ' || 'Work Type: ' || X.wtype || ' ' || 'Time Duration : ' || X.hours);
	 END LOOP;
	 
  END LOOP;
   END IF;

   EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found'); 

END Part_FullTImeInfo;


-------9

procedure Promotion_Employee

is
incCount number;
emplCount number;
myException exception;

begin
    select count(StaffID) into incCount from IncreView;
	select count(EmployeeID) into emplCount from EmployeeView;
	   
	   IF incCount = 0 or emplCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE

    FOR R in(select Employee_name , Employee_title , Amount , Promoted_to from EmployeeView inner join IncreView on EmployeeView.EmployeeID = IncreView.StaffID)LOOP

    DBMS_OUTPUT.PUT_LINE(R.Employee_name || ' ' || R.Employee_title || ' ' || R.Amount || ' ' || R.Promoted_to);

	END LOOP;
    END IF;
    EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');

end Promotion_Employee;


----10


procedure Promotion_Manager

is
incCount number;
manCount number;
myException exception;
begin

    select count(StaffID) into incCount from IncreView;
	select count(ManagerID) into manCount from ManagerView;
	   
	   IF incCount = 0 or manCount = 0 THEN
	   
	   raise myException;
	   
	   ELSE

    FOR R in(select ManagerName , Amount , Promoted_to from ManagerView inner join IncreView on ManagerView.ManagerID = IncreView.StaffID)LOOP

    DBMS_OUTPUT.PUT_LINE(R.ManagerName || ' ' || R.Amount || ' ' || R.Promoted_to);

	END LOOP;

   END IF;
   
   EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');

end Promotion_Manager;


end mypack;
/
