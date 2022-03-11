set serveroutput on;
set verify off;


clear screen;


drop table Overtime3;
drop table Deduction3;
drop table Compensation3;
drop table Grade3;

drop table audit3;
drop table tran3;
drop table Leave3;
drop table Emp3;


drop table Employee3;
drop table Manager3;
drop table Department3;
drop table Incre3;



create table Department3(
	 DeptID   number,
	 DeptName varchar2(100),
	 PRIMARY KEY (DeptID)
);

create table Grade3(
	 DeptID            number,
	 DeptName           varchar2(100),
     GradeName          varchar2(100),
	 Basic              number(8 , 2),
	 TravelAllowance    number(8 , 2),
	 DearnessAllowance  number(8 , 2),
	 HouseRentAllowance number(8 , 2),
	 MedicalAllowance   number(8 , 2),
	 Bonus              number(8 , 2),
	 FOREIGN KEY (DeptID) REFERENCES Department3(DeptID)
);
create or replace procedure insertDataGrade3
(
   indeptID              Department3.DeptID%type,
   inGradeName           Grade3.GradeName%type,
   inBasic               Grade3.Basic%type
)
as

indeptname            Department3.DeptName%type;
inTravelAllowance     Grade3.TravelAllowance%type;
inDearnessAllowance   Grade3.DearnessAllowance%type;
inHouseRentAllowance  Grade3.HouseRentAllowance%type;
inMedicalAllowance    Grade3.MedicalAllowance%type;
inBonus               Grade3.Bonus%type;

begin

if inBasic > 40000 then

    inTravelAllowance  := inBasic * 0.15;
	inDearnessAllowance := inBasic * 0.8;
	inHouseRentAllowance := inBasic * .1;
	inMedicalAllowance   := inBasic * 0.15;
	inBonus  	:= inBasic * 0.7;
	
elsif inBasic > 30000 then 
    inTravelAllowance  := inBasic * 0.1;
	inDearnessAllowance := inBasic * 0.5;
	inHouseRentAllowance := inBasic * .09;
	inMedicalAllowance   := inBasic * 0.1;
	inBonus              := inBasic * 0.6;	
else  
    inTravelAllowance  := inBasic * 0.1;
	inDearnessAllowance := inBasic * 0.05;
	inHouseRentAllowance := inBasic * .05;
	inMedicalAllowance   := inBasic * 0.1;
	inBonus              := inBasic * 0.4;     
end if;

	  
select DeptName into indeptname from Department3 where DeptID = indeptID;

insert into Grade3 values(indeptID , indeptname , inGradeName , 
inBasic , inTravelAllowance,inDearnessAllowance , inHouseRentAllowance , 
inMedicalAllowance , inBonus);

end;
/

create table Manager3(
     ManagerID number,
	 ManagerName varchar2(100),
	 DeptID    number,
	 GrossSal  number,
	 BranchAddress varchar2(100),
	 PRIMARY KEY (ManagerID),
	 FOREIGN KEY (DeptID) REFERENCES Department3(DeptID)
);

create table Employee3(
	 EmployeeID     number,
	 DeptID         number,
	 ManagerID      number,
	 Employee_title varchar2(100),
	 Employee_name  varchar2(100),
	 Date_Of_Birth  date,
	 JoiningDate    date,
	 Address        varchar2(100),
	 City           varchar2(100),
	 Mbl_no         number,
	 Email          varchar2(100),
     PRIMARY KEY (EmployeeID),
	 FOREIGN KEY (DeptID) REFERENCES Department3(DeptID),
	 FOREIGN KEY (ManagerID) REFERENCES Manager3(ManagerID)
);


create or replace procedure insertDataEmployee3
(    
	inEmployeeID       Employee3.EmployeeID%type,
	inDeptID           Employee3.DeptID%type,
	inManagerID        Employee3.ManagerID%type, 
	inEmployee_title   Employee3.Employee_title%type,
	inEmployee_name    Employee3.Employee_name%type,
	inDate_Of_Birth    Employee3.Date_Of_Birth%type,
	inJoiningDate      Employee3.JoiningDate%type,
	inAddress          Employee3.Address%type,
	inCity             Employee3.City%type,
	inMbl_No           Employee3.Mbl_no%type,
	inEmail            Employee3.Email%type
 ) 
as

begin
      
insert into Employee3 values(inEmployeeID , indeptID , inManagerID , inEmployee_title , inEmployee_name , inDate_Of_Birth ,inJoiningDate , inAddress , inCity , inMbl_No , inEmail);

end;
/

create table Compensation3(
       SalaryID       number,
       EmployeeID     number,
	   Month_         varchar2(100),
	   Year_          number,
	   DeptID         number,
	   DeptName       varchar2(100),
       GradeName      varchar2(100),
	   Basic              number(8 , 2),
	   TravelAllowance    number(8 , 2),
	   DearnessAllowance  number(8 , 2),
	   HouseRentAllowance number(8 , 2),
	   MedicalAllowance   number(8 , 2),
	   Bonus              number(8 , 2),
	   PRIMARY KEY (SalaryID),
	   FOREIGN KEY (DeptID) REFERENCES Department3(DeptID),
	   FOREIGN KEY (EmployeeID) REFERENCES Employee3(EmployeeID)
);

create or replace procedure insertDataCompensation3
(  
   inSalaryID    Compensation3.SalaryID%type,
   inEmployeeID  Compensation3.EmployeeID%type,
   inMonth_      Compensation3.Month_%type,
   inYear_       Compensation3.Year_%type,
   inGradeName   Compensation3.GradeName%type
)
as
inDeptID               Compensation3.DeptID%type;
inDeptName             Compensation3.DeptName%type;
inBasic                Compensation3.Basic%type;
inTravelAllowance      Compensation3.TravelAllowance%type;
inDearnessAllowance    Compensation3.DearnessAllowance%type;
inHouseRentAllowance   Compensation3.HouseRentAllowance%type;
inMedicalAllowance     Compensation3.MedicalAllowance%type;
inBonus                Compensation3.Bonus%type;

begin

select DeptID into inDeptID from Employee3 where EmployeeID = inEmployeeID;


select DeptName,Basic,TravelAllowance,DearnessAllowance,
HouseRentAllowance,MedicalAllowance,Bonus 
into inDeptName,inBasic,inTravelAllowance,inDearnessAllowance,
inHouseRentAllowance,inMedicalAllowance,
inBonus from Grade3 where DeptID = inDeptID and GradeName = inGradeName;


insert into Compensation3 values(inSalaryID , inEmployeeID , inMonth_ , inYear_ , inDeptID,inDeptName,inGradeName,inBasic,inTravelAllowance,inDearnessAllowance,inHouseRentAllowance,inMedicalAllowance,inBonus);

		 
end;
/
create table Overtime3(
	   EmployeeID       number,
	   NumberOfHours    number,
	   NumberOfMinutes  number,
	   Rate             number,
	   DateOfOvertime   date,
	   FOREIGN KEY (EmployeeID) REFERENCES Employee3(EmployeeID)
);



create table Deduction3(
       EmployeeID     number,
	   Month_         varchar2(100),
	   Year_          number,
	   IncomeTax           number(8 , 2),
	   ChildSupportPayment number(8 , 2),
	   SocialSecurity      number(8 , 2),
	   Loan                number,
	   FOREIGN KEY (EmployeeID) REFERENCES Employee3(EmployeeID)
);

create or replace procedure insertDeduction3
(
inEmployeeID  number,
inYear    number,
inLoan   number,
inMonth  Deduction3.Month_%type
)
as
inIncomeTax           number(8 , 2);
inChildSupportPayment number(8 , 2);
inSocialSecurity      number(8 , 2);
A number(8 , 2);
B number(8 , 2);
C number(8 , 2);
D number(8 , 2);
E number(8 , 2);
TotalGross number(8 , 2);

begin

    TotalGross := 0;
	
	For R in (select * from Compensation3 where EmployeeID = inEmployeeID 
	and Month_ = inMonth and Year_ = inYear) LOOP
   
    A := R.Basic;
    B := R.TravelAllowance;
    C := R.DearnessAllowance;
    D := R.MedicalAllowance;
    E := R.Bonus;

    TotalGross := A + B + C + D + E;	
   
   END LOOP;
   
  
   IF TotalGross  >= 50000 THEN
   
   inIncomeTax := TotalGross * 0.5;
   inChildSupportPayment := TotalGross * 0.2;
   inSocialSecurity      := TotalGross * 0.2;

   ELSIF TotalGross >= 60000 THEN	
   
   inIncomeTax := TotalGross * 0.4;
   inChildSupportPayment := TotalGross * 0.3;
   inSocialSecurity      := TotalGross * 0.3;
   
   ELSE
   
   inIncomeTax := TotalGross * 0.2;
   inChildSupportPayment := TotalGross * 0.1;
   inSocialSecurity      := TotalGross * 0.1;
   
   END IF;
   
   
insert into Deduction3 values(inEmployeeID ,inMonth, inYear , inIncomeTax,inChildSupportPayment,inSocialSecurity ,inLoan);
    
end;
/

create table tran3(
    TranID     number,
	Trantype   varchar2(100),
	PRIMARY KEY (TranID)
);

create table audit3(
   TranID     number,
   EmployeeID number,
   AccNo      number,
   amount     number,
   FOREIGN KEY (TranID) REFERENCES tran3(TranID),
   FOREIGN KEY (EmployeeID) REFERENCES Employee3(EmployeeID)   
);

create table Leave3(
   LeaveID number,
   EmployeeID number,
   LeaveDate date,
   Reason varchar2(100),
   PRIMARY KEY (LeaveID),
   FOREIGN KEY (EmployeeID) REFERENCES Employee3(EmployeeID)
);

create table Emp3(
  EmployeeID     number,
  WorkType       varchar2(100),
  DurationHours  number,
  FOREIGN KEY (EmployeeID) REFERENCES Employee3(EmployeeID)
);

create table Incre3(
  StaffID     number,
  Amount      number,
  Promoted_to  varchar2(100)
);


@"C:\Users\Ullash\Downloads\Payroll Management System\Trigger2.sql"

insert into Department3 values(1 , 'Cash');
insert into Department3 values(2 , 'Card');
insert into Department3 values(3 , 'Human Resource');
insert into Department3 values(4 , 'Accounts');
insert into Department3 values(5 , 'Loan');
insert into Department3 values(6 , 'LC');
insert into Department3 values(7 , 'Foreign Exchange');
insert into Department3 values(8 , 'Deposit Insurance');
insert into Department3 values(9 , 'Internal Audit');
insert into Department3 values(10 , 'Monetary Policy');


exec insertDataGrade3(1 , 'Officer' , 18000);


exec insertDataGrade3(1,'Senior Officer', 35000);
exec insertDataGrade3(1,'Principal Officer', 48000);
exec insertDataGrade3(1,'Senior Principal Officer', 62000);


exec insertDataGrade3(2,'Officer', 20000);
exec insertDataGrade3(2,'Senior Officer', 32000);
exec insertDataGrade3(2,'Principal Officer', 45000);
exec insertDataGrade3(2,'Senior Principal Officer', 55000);

exec insertDataGrade3(3,'Officer', 24000);
exec insertDataGrade3(3,'Senior Officer', 28000);
exec insertDataGrade3(3,'Principal Officer', 40000);
exec insertDataGrade3(3,'Senior Principal Officer', 52000);

exec insertDataGrade3(4,'Officer', 27000);
exec insertDataGrade3(4,'Senior Officer', 36000);
exec insertDataGrade3(4,'Principal Officer', 46000);
exec insertDataGrade3(4,'Senior Principal Officer', 58000);

exec insertDataGrade3(5,'Officer', 27000);
exec insertDataGrade3(5,'Senior Officer', 40000);
exec insertDataGrade3(5,'Principal Officer', 52000);
exec insertDataGrade3(5,'Senior Principal Officer', 66000);

exec insertDataGrade3(6,'Officer', 32000);
exec insertDataGrade3(6,'Senior Officer', 40000);
exec insertDataGrade3(6,'Principal Officer', 50000);
exec insertDataGrade3(6,'Senior Principal Officer', 70000);

exec insertDataGrade3(7,'Officer', 24000);
exec insertDataGrade3(7,'Senior Officer', 35000);
exec insertDataGrade3(7,'Principal Officer', 50000);
exec insertDataGrade3(7,'Senior Principal Officer', 70000);

exec insertDataGrade3(8,'Officer',35000);
exec insertDataGrade3(8,'Senior Officer', 45000);
exec insertDataGrade3(8,'Principal Officer', 75000);
exec insertDataGrade3(8,'Senior Principal Officer', 110000);

exec insertDataGrade3(9,'Officer',38000);
exec insertDataGrade3(9,'Senior Officer', 55000);
exec insertDataGrade3(9,'Principal Officer', 70000);
exec insertDataGrade3(9,'Senior Principal Officer',120000);

exec insertDataGrade3(10,'Officer', 40000);
exec insertDataGrade3(10,'Senior Officer',60000);
exec insertDataGrade3(10,'Principal Officer',90000);
exec insertDataGrade3(10,'Senior Principal Officer',130000);


insert into Manager3 values(2001 , 'Khandakar Mustak' , 1 , 130000 , 'Mirpur');
insert into Manager3 values(2002 , 'Ripon Hasan' , 2 , 150000 , 'Rampura');
insert into Manager3 values(2003 , 'Razia Begum' , 3 , 160000 , 'Mirpr');
insert into Manager3 values(2004 , 'Arnold Gomes' , 4 , 170000 , 'Malibag');
insert into Manager3 values(2005 , 'Siham Kader' , 10 , 180000 , 'Modhibag');
insert into Manager3 values(2006 , 'Jakaria Rahim' , 10 , 135000 , 'Niketon');
insert into Manager3 values(2007 , 'Hasin Ishrak' , 10 , 140000 , 'Rajarbag');
insert into Manager3 values(2008 , 'Sohaib Ahmed' , 8 , 135000 , 'Mothijheel');
insert into Manager3 values(2009 , 'Tushar Ahmed' , 9 , 155000 , 'Kakrail');
insert into Manager3 values(2010 , 'Sazia Tonni' , 10 , 1366000 , 'Kakrail');




exec insertDataEmployee3(1035 , 1 , 2001 , 'Officer' , 'Manik Ahmed' , '22-Jun-1992','1-Jan-2018', 'Rampura' , 'Dhaka' , 84092348 , 'mustak98@gmail.com');
exec insertDataEmployee3(1036 , 2 , 2001, 'Officer' , 'Mazlish Ahmed' , '25-July-1996','5-Sep-2019', 'Rajarbag' , 'Dhaka' , 8403434348 , 'manik98@gmail.com');
exec insertDataEmployee3(1037 , 3 , 2002 , 'Senior Officer' , 'Razon Ahmed' , '7-Dec-1992','28-Jan-2018', 'Rampura' , 'Dhaka' , 2384092348 , 'robin98@gmail.com');
exec insertDataEmployee3(1038 , 4 , 2003 , 'Principal Officer' , 'Kamal Ahmed' , '22-Jun-1990','10-Jan-2018', 'Malibag' , 'Dhaka' , 7784092348 , 'kaiser98@gmail.com');
exec insertDataEmployee3(1039 , 5 , 2004 , 'Senior Principal Officer' , 'Jamal Ahmed' , '27-Feb-1992','1-Jan-2018', 'Kallyanpur' , 'Dhaka' , 9984092348 , 'jamil8@gmail.com');
exec insertDataEmployee3(1040 , 1 , 2005 , 'Senior Principal Officer' , 'zenon Ahmed' , '27-Feb-1992','1-Jan-2018', 'Kallyanpur' , 'Dhaka' , 9984092348 , 'jamil8@gmail.com');


exec insertDataCompensation3(1, 1035 , 'Jan', 2018 , 'Officer');
exec insertDataCompensation3(2 , 1036 , 'Sep',2019 , 'Officer');
exec insertDataCompensation3(3 , 1037 , 'Jan', 2018, 'Senior Officer');
exec insertDataCompensation3(4 , 1038 , 'Jan', 2018, 'Principal Officer');
exec insertDataCompensation3(5 , 1039 , 'Jan', 2018, 'Senior Principal Officer');
exec insertDataCompensation3(6 , 1040 , 'Jan', 2018, 'Senior Principal Officer');




insert into Overtime3 values(1035 , 2 , 50 , 15 , '21-Mar-2018');
insert into Overtime3 values(1036 , 1 , 10 , 15 , '28-Mar-2018');
insert into Overtime3 values(1037 , 0 , 30 , 15 , '6-Apr-2018');
insert into Overtime3 values(1038 , 0 , 40 , 15 , '7-Jun-2018');
insert into Overtime3 values(1039 , 1 , 50 , 15 , '10-Jun-2018');
insert into Overtime3 values(1040 , 2 , 50 , 15 , '20-Mar-2020');


exec insertDeduction3(1035 , 2018 , 32000  , 'Jan');
exec insertDeduction3(1036 , 2018 , 12000  , 'Feb');
exec insertDeduction3(1037 , 2018 , 13000  , 'Mar');
exec insertDeduction3(1038 , 2018 , 15600  , 'Apr');
exec insertDeduction3(1039 , 2018 , 15000  , 'May');
exec insertDeduction3(1040 , 2018 , 20000  , 'Jun');



insert into tran3 values(1, 'Cash');
insert into tran3 values(2, 'Credit');
insert into tran3 values(3, 'Business');
insert into tran3 values(4, 'Personal');


insert into audit3 values(1, 1035 , 592 , 2000);
insert into audit3 values(1, 1036 , 592 , 2500);
insert into audit3 values(2, 1037 , 592 , 3500);
insert into audit3 values(3, 1038 , 592 , 2200);
insert into audit3 values(4, 1039 , 592 , 2100);
insert into audit3 values(4, 1040 , 592 , 2100);



insert into Leave3 values (1 , 1035 , '22-Jan-2018' , 'Due to sickness');
insert into Leave3 values (2 , 1036 , '11-Sep-2019' , 'Due to sickness');
insert into Leave3 values (3 , 1037 , '19-Feb-2018' , 'Going Abroad');
insert into Leave3 values (4 , 1038 , '15-Jan-2018' , 'Marriage Ceremony');
insert into Leave3 values (5 , 1039 , '10-Jan-2018' , 'Atteding Personal Program');

insert into Emp3 values (1035 , 'Full Time' , 8);
insert into Emp3 values (1036 , 'Full Time' , 8);
insert into Emp3 values (1037 , 'Full Time' , 7);
insert into Emp3 values (1038 , 'Full Time' , 7);
insert into Emp3 values (1039 , 'Part Time' , 3);
insert into Emp3 values (1040 , 'Part Time' , 3);



insert into Incre3 values(1035 , 6000 , 'Senior Officer');
insert into Incre3 values(1036 , 10000 , 'Senior Officer');
insert into Incre3 values(1037 , 12000 , 'Principal Officer');


commit;

