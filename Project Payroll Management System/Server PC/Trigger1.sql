create or replace trigger OvertimeData

after insert 
on Overtime
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Overtime data are inserted');
end;
/

create or replace trigger DeductionData

after insert 
on Deduction
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Deduction data are inserted');
end;
/
create or replace trigger CompensationData

after insert 
on Compensation
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Compensation data are inserted');
end;
/
create or replace trigger GradeData

after insert 
on Grade
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Grade data are inserted');
end;
/
create or replace trigger audit1Data

after insert 
on audit1
declare

begin
      DBMS_OUTPUT.PUT_LINE('My audit1 data are inserted');
end;
/
create or replace trigger tran1Data

after insert 
on tran1
declare

begin
      DBMS_OUTPUT.PUT_LINE('My tran1 data are inserted');
end;
/
create or replace trigger LeaveData

after insert 
on Leave
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Leave data are inserted');
end;
/
create or replace trigger EmpData

after insert 
on Emp
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Emp data are inserted');
end;
/
create or replace trigger EmployeeData

after insert 
on Employee
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Employee data are inserted');
end;
/
create or replace trigger ManagerData

after insert 
on Manager
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Manager data are inserted');
end;
/
create or replace trigger DepartmentData

after insert 
on Department
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Department data are inserted');
end;
/
create or replace trigger IncreData

after insert 
on Incre
declare

begin
      DBMS_OUTPUT.PUT_LINE('My Incre data are inserted');
end;
/
