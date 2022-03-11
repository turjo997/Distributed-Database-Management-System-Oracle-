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


create or replace view CompensationView as (select * from Compensation@server1 union select * from Compensation3);
create or replace view DeductionView as (select * from Deduction@server1 union select * from Deduction3);
create or replace view ManagerView as (select * from Manager@server1 union select * from Manager3);
create or replace view DepartmentView as (select * from Department@server1 union select * from Department3);
create or replace view EmployeeView as (select * from Employee@server1 union select * from Employee3);
create or replace view OvertimeView as (select * from Overtime@server1 union select * from Overtime3);
create or replace view TransactionView as (select * from tran1@server1 union select * from tran3);
create or replace view AuditView as (select * from audit1@server1 union select * from audit3);
create or replace view LeaveView as (select * from Leave@server1 union select * from Leave3);
create or replace view GradeView as (select * from Grade@server1 union select * from Grade3);
create or replace view EmpView as (select * from Emp@server1 union select * from Emp3);



create or replace package mypack as

procedure Employee_Yearly_Salary(A in EmployeeView.EmployeeID%type);
procedure Employee_Total_Deduction(A in EmployeeView.EmployeeID%type);
procedure Allocate_Manager_For_Employee(A in EmployeeView.EmployeeID%type);
function Employee_Overtime_Salary(A in EmployeeView.EmployeeID%type)
return number;
function TrantypeTransaction_Employee(A in EmployeeView.EmployeeID%type)
return number;



procedure EmoloyeeLeaveForWhy(A in EmployeeView.EmployeeID%type);


procedure maxTypeTran_TypeWise(A in EmployeeView.EmployeeID%type);

function empl_totalLoan_Bear(A in EmployeeView.EmployeeID%type)
return number;

function calculate_compensation(D in number , A out number , B out number , C out number)
return number;


function calculate_Deduction(D in number , A out number , B out number , C out number)
return number;

end mypack;
/


create or replace package body mypack as

----------1
procedure Employee_Yearly_Salary(A in EmployeeView.EmployeeID%type)
is 
B  CompensationView.Basic%type;
C  CompensationView.TravelAllowance%type;
D  CompensationView.DearnessAllowance%type;
E  CompensationView.HouseRentAllowance%type;
F  CompensationView.MedicalAllowance%type;
G  CompensationView.Bonus%type;
Tot_SAl number;
Y number;
SalCount number;
myException exception;
Flag number;
begin 

   Flag := 0;
   
    select count(SalaryID) into SalCount from CompensationView;
   
   
      IF SalCount = 0 THEN
	    
		raise myException;
	  
      ELSE 
	  
	  

    For R in (select distinct(Year_) from CompensationView where EmployeeID = A )LOOP
	      
		  Y := R.Year_;
		  Tot_SAl := 0;
		  
		  For X in (select * from CompensationView where EmployeeID = A  and Year_ = Y) LOOP
		       
			   B := X.Basic;
			   C := X.TravelAllowance;
			   D := X.DearnessAllowance;
			   E := X.HouseRentAllowance;
			   F := X.MedicalAllowance;
			   G := X.Bonus;
			   
			   Tot_SAl := Tot_SAl +  B + C + D + E + F + G;
		       
			   Flag := 1;
			   
		  END LOOP;
	   
	               DBMS_OUTPUT.PUT_LINE('Salary in ' || Y || ' is ' || Tot_SAl);
	   END LOOP;
	   
	    END IF;	
		
		if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
    

     EXCEPTION
	
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
		   
end Employee_Yearly_Salary;



----------2

procedure Employee_Total_Deduction(A in EmployeeView.EmployeeID%type)
is 

B DeductionView.IncomeTax%type;
C DeductionView.ChildSupportPayment%type;
D DeductionView.SocialSecurity%type;
E DeductionView.Loan%type;
Tot_Ded number;
Y number;
empCount number;
myException exception;
Flag number;

begin

    Flag := 0 ; 
    
     select count(EmployeeID) into empCount from DeductionView;
   
   
      IF empCount = 0 THEN
	    
		raise myException;
	  
      ELSE 
	  
	     For R in (select distinct(Year_) from DeductionView where EmployeeID = A )LOOP
		  Y := R.Year_;
		  Tot_Ded := 0;
		  
		  FOR X in (select * from DeductionView where EmployeeID = A and Year_ = Y)LOOP
		       
			   B := X.IncomeTax;
			   C := X.ChildSupportPayment;
			   D := X.SocialSecurity;
			   E := X.Loan;
			   Tot_Ded := Tot_Ded +  B + C + D + E;
		
		       Flag := 1;
			   
		  END LOOP;
	   
	               DBMS_OUTPUT.PUT_LINE('Deduction in ' || Y || ' is ' || Tot_Ded);
		 
	   END LOOP;
	   
	    END IF;	
    
     if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
		
     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
      
end Employee_Total_Deduction;

----------3


procedure Allocate_Manager_For_Employee(A in EmployeeView.EmployeeID%type)
IS
empCount number;
manCount number;
deptCount number;
myException exception;

Flag number;

BEGIN

    Flag := 0;
	
    select count(EmployeeID) into empCount from EmployeeView;
	select count(ManagerID) into manCount from ManagerView;
	select count(DeptID) into deptCount from DepartmentView;
   
   
      IF empCount = 0 or manCount = 0 or deptCount = 0 THEN
	    
		raise myException;
	  
      ELSE 
	
	For R in (select ManagerName , BranchAddress , Employee_name , Employee_title , EmployeeView.DeptID from ManagerView inner join EmployeeView on ManagerView.ManagerID = EmployeeView.ManagerID and EmployeeID = 1001) LOOP

		For X in (Select DeptName from DepartmentView where DeptID = R.DeptID)LOOP  
	
			DBMS_OUTPUT.PUT_LINE('Department Name ' || X.DeptName);
			DBMS_OUTPUT.PUT_LINE('Manager Name ' || R.ManagerName);
			DBMS_OUTPUT.PUT_LINE('Branch Address ' || R.BranchAddress);
			DBMS_OUTPUT.PUT_LINE('Employee Name ' || R.Employee_name);
			DBMS_OUTPUT.PUT_LINE('Employee Title ' || R.Employee_title);
            
			Flag := 1;
			
		END LOOP;
   
	END LOOP; 

     END IF;	
    if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;

     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');

end Allocate_Manager_For_Employee;


---------------4


function Employee_Overtime_Salary(A in EmployeeView.EmployeeID%type)
return number
is 
Total number;
TotalOvertimeSal number;
empCount number;
myException exception;
Flag number;

begin 
    TotalOvertimeSal := -1;
    Flag := 0;
	
	select count(EmployeeID) into empCount from OvertimeView;

      IF empCount = 0 THEN
	    
		raise myException;
	  
      ELSE 
    
  
    --TotalOvertimeSal := 0;
	
    FOR X in (Select DateOfOvertime from OvertimeView where EmployeeID = A)LOOP
	
	Total := 0;
	
		FOR R in (select * from OvertimeView where EmployeeID = A and DateOfOvertime = X.DateOfOvertime) LOOP
		
		Total := R.NumberOfHours * 60 + R.NumberOfMinutes;
		
		Total := Total * R.Rate;
		
		TotalOvertimeSal := TotalOvertimeSal + Total; 
	 
        Flag := 1;
		
		END LOOP;	
	
	DBMS_OUTPUT.PUT_LINE(X.DateOfOvertime || ' ' || Total);
	
  END LOOP;
   
    END IF;	
    
	if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
		
    return TotalOvertimeSal + 1;
	
     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
    

end Employee_Overtime_Salary;

-----------5

function TrantypeTransaction_Employee(A in EmployeeView.EmployeeID%type)
return number

is
total number; 
name varchar2(100);
totaltran number;
tranCount number;
audCount number;
empCount number;
myException exception;
Flag number;

begin
    Flag := 0;
    totaltran := -1;
	
    select count(TranID) into tranCount from TransactionView;
	select count(TranID) into audCount from AuditView;
	select count(EmployeeID) into empCount from EmployeeView;
   
   
      IF tranCount = 0 or audCount = 0 or empCount = 0 THEN
	    
		raise myException;
	  
      ELSE 
	  
   --totaltran := 0;
   
    FOR R in (select * from TransactionView) LOOP
	
     total := 0;
	
	 FOR X in(select * from AuditView where TranID in (select TranID from TransactionView where Trantype = R.Trantype) and EmployeeID = A)LOOP
	 
	    Select Employee_name into name from EmployeeView where EmployeeID = A;
		   		
			total :=  total + X.amount;			
		    Flag := 1;
			
	 END LOOP;
	 
	       totaltran := totaltran + total;
	 
	 DBMS_OUTPUT.PUT_LINE(name || ' ' || R.Trantype || ' transactions ' || total || ' taka');
	  
	END LOOP;
	
	  END IF;	
	  
    if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
		
    return totaltran + 1; 
     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
	
end TrantypeTransaction_Employee;


-----------6

procedure EmoloyeeLeaveForWhy(A in EmployeeView.EmployeeID%type)
is 
empCount number;
levCount number;
myException exception;
Flag number;

begin

    Flag := 0;
    select count(EmployeeID) into empCount from EmployeeView;
	select count(EmployeeID) into levCount from LeaveView;
	
   
      IF empCount = 0 or levCount = 0 THEN
	    
		raise myException;
	  
      ELSE 
	  
    FOR R in (select Employee_name , LeaveDate , Reason from EmployeeView inner join Leaveview on EmployeeView.EmployeeID = LeaveView.EmployeeID where EmployeeView.EmployeeID = A)LOOP
	     
	DBMS_OUTPUT.PUT_LINE(R.Employee_name || ' ' || R.LeaveDate || ' ' || R.Reason);
		  
		  Flag := 1;
		  
	END LOOP;
	
	 END IF;	
    
     if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
		
     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');


end EmoloyeeLeaveForWhy;


-------------7

procedure maxTypeTran_TypeWise(A in EmployeeView.EmployeeID%type)
is
audCount number;
tranCount number;
myException exception;
Flag number;

BEGIN
     
	 Flag := 0;
    select count(TranID) into audCount from AuditView;
	select count(TranID) into tranCount from TransactionView;
	
   
      IF audCount = 0 or tranCount = 0  THEN
	    
		raise myException;
	  
      ELSE 
      	  
	FOR R in(Select max(amount) As Amount , TranID from AuditView WHERE EmployeeID = A GROUP BY TranID ORDER BY Amount ASC)LOOP
  
		FOR X in (Select Trantype from TransactionView where TranID = R.TranID)LOOP
	     
			DBMS_OUTPUT.PUT_LINE(X.Trantype || ' ' || R.Amount);
		    Flag := 1;
		END LOOP;
	
	END LOOP;	
	
	 END IF;	
    
	if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;

     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');
		   
END maxTypeTran_TypeWise;


----------8

function empl_totalLoan_Bear(A in EmployeeView.EmployeeID%type)
return number
is
total number;
empCount number;
myException exception;
Flag number;

begin

    total := -1;
    Flag := 0;	
    select count(EmployeeID) into empCount from DeductionView;
	
      IF empCount = 0  THEN
	    
		raise myException;
	  
      ELSE 
	  
    --total := 0;
	
    FOR R in (Select Loan from DeductionView where EmployeeID = A)LOOP
	     
		  total := total + R.Loan;
	      Flag := 1;
		  
	END LOOP;
	
	 END IF;	
	 
	 if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
		
    return total + 1;
	
     EXCEPTION
		 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');



end empl_totalLoan_Bear;


--------9

function calculate_compensation(D in number , A out number , B out number , C out number)
return number

is
tot_travel number;
tot_Dearness number;
tot_Medical number;
tot_Bonus number;
tot_travel1 number;
tot_Dearness1 number;
tot_Medical1 number;
tot_Bonus1 number;
empCount number;
comCount number;
myException exception;
Flag number;
begin
    tot_travel1 := -1;
	tot_Dearness1 := -1;
    tot_Medical1 := -1;
    tot_Bonus1 := -1;
	Flag := 0;
	
    select count(EmployeeID) into empCount from EmployeeView;
	select count(SalaryID) into comCount from CompensationView;
   
      IF empCount = 0 or comCount = 0 THEN
	    
		raise myException;
	  
      ELSE 

	--tot_travel1 := 0;
    tot_Dearness1 := 0;
    tot_Medical1 := 0;
    tot_Bonus1 := 0;
    
FOR X in (Select distinct(Year_) as year_ from CompensationView)LOOP	
	
	tot_travel := 0;
    tot_Dearness := 0;
    tot_Medical := 0;
    tot_Bonus := 0;

FOR R in (Select Employee_name , TravelAllowance , DearnessAllowance , MedicalAllowance , Bonus from EmployeeView inner join CompensationView on EmployeeView.EmployeeID = CompensationView.EmployeeID
	where CompensationView.EmployeeID = D and CompensationView.Year_ = X.year_) LOOP
	
     tot_travel := tot_travel + R.TravelAllowance;
	 tot_Dearness := tot_Dearness + R.DearnessAllowance;
	 tot_Medical := tot_Medical + R.MedicalAllowance;
	 tot_Bonus := tot_Bonus + R.Bonus;
	 Flag := 1;
	 
	END LOOP;
	tot_travel1 := tot_travel1 + tot_travel;
	tot_Medical1 := tot_Medical1 + tot_Medical;
	tot_Dearness1 := tot_Dearness1 + tot_Dearness;
	tot_Bonus1  := tot_Bonus1 + tot_Bonus;
	
	
	 if tot_travel = 0 and tot_Dearness = 0 and tot_Medical = 0 and tot_Bonus = 0 then
	   
	   Flag := 0;
		
     else 
	 Flag := 1;
	 DBMS_OUTPUT.PUT_LINE(tot_travel || ' ' || tot_Dearness || ' ' || tot_Medical || ' ' || tot_Bonus || ' ' || ' in the year '|| X.year_);
	  
	 end if;
	 
 END LOOP;
 
   A := tot_Dearness1;
   B := tot_Medical1;
   C := tot_Bonus1;
 
    END IF;	
    
	return tot_travel1 + 1;
	if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
		
    EXCEPTION
	
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('No Data Found');

end calculate_compensation;


---------10

function calculate_Deduction(D in number , A out number , B out number , C out number)
return number

is
tot_IncomeTax number;
tot_ChildSupportPayment number;
tot_SocialSecurity number;
tot_Loan number;
tot_IncomeTax1 number;
tot_ChildSupportPayment1 number;
tot_SocialSecurity1 number;
tot_Loan1 number;
Flag number;

empCount number;
dedCount number;
myException exception;

begin
        Flag := 0;
		tot_IncomeTax1 := -1;
		tot_ChildSupportPayment1 := 0;
		tot_SocialSecurity1 := 0;
		tot_Loan1 := 0;
    
FOR X in (Select distinct(Year_) as year_ from DeductionView)LOOP	
	
	tot_IncomeTax := 0;
    tot_ChildSupportPayment :=0;
    tot_SocialSecurity :=0;
    tot_Loan :=0;

FOR R in (Select Employee_name, IncomeTax, ChildSupportPayment, SocialSecurity, Loan from EmployeeView inner join DeductionView on EmployeeView.EmployeeID = DeductionView.EmployeeID
	where DeductionView.EmployeeID = D and DeductionView.Year_ = X.year_) LOOP
	
     tot_IncomeTax := tot_IncomeTax + R.IncomeTax;
	 tot_ChildSupportPayment := tot_ChildSupportPayment + R.ChildSupportPayment;
	 tot_SocialSecurity := tot_SocialSecurity + R.SocialSecurity;
	 tot_Loan := tot_Loan + R.Loan;
	
	END LOOP;
     tot_IncomeTax1 := tot_IncomeTax1 + tot_IncomeTax;
	 tot_ChildSupportPayment1 := tot_ChildSupportPayment1 + tot_ChildSupportPayment;
	 tot_SocialSecurity1 := tot_SocialSecurity1 + tot_SocialSecurity;
	 tot_Loan1 := tot_Loan1 + tot_Loan;
	 
	 if tot_IncomeTax = 0 and tot_ChildSupportPayment = 0 and tot_SocialSecurity = 0 and tot_Loan =0  then
	    Flag := 0;
		
      else    		
	  Flag := 1;
	  DBMS_OUTPUT.PUT_LINE(tot_IncomeTax || ' ' || tot_ChildSupportPayment || ' ' || tot_SocialSecurity || ' ' || tot_Loan || ' ' || ' in the year ' || X.year_);
	
	  end if;
 END LOOP;	
 
   A := tot_ChildSupportPayment1;
   B := tot_SocialSecurity1;
   C := tot_Loan1;
   	
    if Flag = 0 then
		DBMS_OUTPUT.PUT_LINE('Data not found');
		end if;
		 
    return tot_IncomeTax1 + 1;
	
	   
end calculate_Deduction;


end mypack;
/


