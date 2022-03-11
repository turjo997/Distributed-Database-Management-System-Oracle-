set serveroutput on;
set verify off;

clear screen;

drop table Overtime;
drop table Deduction;
drop table Compensation;
drop table Grade;
drop table audit1;
drop table tran1;
drop table Leave;
drop table Emp;
drop table Employee;
drop table Manager;
drop table Department;
drop table Incre;


create table Department(
	 DeptID   number,
	 DeptName varchar2(100),
	 PRIMARY KEY (DeptID)
);

create table Grade(
	 DeptID             number,
	 DeptName           varchar2(100),
     GradeName          varchar2(100),
	 Basic              number(8 , 2),
	 TravelAllowance    number(8 , 2),
	 DearnessAllowance  number(8 , 2),
	 HouseRentAllowance number(8 , 2),
	 MedicalAllowance   number(8 , 2),
	 Bonus              number(8 , 2),
	 FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

create table Manager(
     ManagerID number,
	 ManagerName varchar2(100),
	 DeptID    number,
	 GrossSal  number,
	 BranchAddress varchar2(100),
	 PRIMARY KEY (ManagerID),
	 FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

create table Employee(
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
	 FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
	 FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID)
);

create or replace procedure insertDataGrade
(
   indeptID              Department.DeptID%type,
   inGradeName           Grade.GradeName%type,
   inBasic               Grade.Basic%type
)
as

indeptname            Department.DeptName%type;
inTravelAllowance     Grade.TravelAllowance%type;
inDearnessAllowance   Grade.DearnessAllowance%type;
inHouseRentAllowance  Grade.HouseRentAllowance%type;
inMedicalAllowance    Grade.MedicalAllowance%type;
inBonus               Grade.Bonus%type;

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

	  
select DeptName into indeptname from Department where DeptID = indeptID;

insert into Grade values(indeptID , indeptname , inGradeName , inBasic , inTravelAllowance,inDearnessAllowance , inHouseRentAllowance , inMedicalAllowance , inBonus);

end;
/

create or replace procedure insertDataEmployee
(    
	inEmployeeID       Employee.EmployeeID%type,
	inDeptID           Employee.DeptID%type,
	inManagerID        Employee.ManagerID%type, 
	inEmployee_title   Employee.Employee_title%type,
	inEmployee_name    Employee.Employee_name%type,
	inDate_Of_Birth    Employee.Date_Of_Birth%type,
	inJoiningDate      Employee.JoiningDate%type,
	inAddress          Employee.Address%type,
	inCity             Employee.City%type,
	inMbl_No           Employee.Mbl_no%type,
	inEmail            Employee.Email%type
 ) 
as

begin
      
insert into Employee values(inEmployeeID , indeptID , inManagerID , inEmployee_title , inEmployee_name , inDate_Of_Birth ,inJoiningDate , inAddress , inCity , inMbl_No , inEmail);

end;
/

create table Compensation(
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
	   FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
	   FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

create or replace procedure insertDataCompensation
(  
   inSalaryID    Compensation.SalaryID%type,
   inEmployeeID  Compensation.EmployeeID%type,
   inMonth_      Compensation.Month_%type,
   inYear_       Compensation.Year_%type,
   inGradeName   Compensation.GradeName%type
)
as
inDeptID               Compensation.DeptID%type;
inDeptName             Compensation.DeptName%type;
inBasic                Compensation.Basic%type;
inTravelAllowance      Compensation.TravelAllowance%type;
inDearnessAllowance    Compensation.DearnessAllowance%type;
inHouseRentAllowance   Compensation.HouseRentAllowance%type;
inMedicalAllowance     Compensation.MedicalAllowance%type;
inBonus                Compensation.Bonus%type;

begin
        
select DeptID into inDeptID from Employee where EmployeeID = inEmployeeID;


select DeptName,Basic,TravelAllowance,DearnessAllowance,HouseRentAllowance,MedicalAllowance,Bonus into inDeptName,inBasic,inTravelAllowance,inDearnessAllowance,inHouseRentAllowance,inMedicalAllowance,inBonus from Grade where DeptID = inDeptID and GradeName = inGradeName;


insert into Compensation values(inSalaryID , inEmployeeID , inMonth_ , inYear_ , inDeptID,inDeptName,inGradeName,inBasic,inTravelAllowance,inDearnessAllowance,inHouseRentAllowance,inMedicalAllowance,inBonus);

		 
end;
/

create table Overtime(
	   EmployeeID       number,
	   NumberOfHours    number,
	   NumberOfMinutes  number,
	   Rate             number,
	   DateOfOvertime   date,
	   FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

create table Deduction(
       EmployeeID     number,
	   Month_         varchar2(100),
	   Year_          number,
	   IncomeTax           number(8 , 2),
	   ChildSupportPayment number(8 , 2),
	   SocialSecurity      number(8 , 2),
	   Loan                number,
	   FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

create or replace procedure insertDeduction
(
inEmployeeID  number,
inYear    number,
inLoan   number,
inMonth  Deduction.Month_%type
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
	
	For R in (select * from Compensation where EmployeeID = inEmployeeID 
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
   
   
insert into Deduction values(inEmployeeID ,inMonth, inYear , inIncomeTax,inChildSupportPayment,inSocialSecurity ,inLoan);
    
end;
/

create table tran1(
    TranID     number,
	Trantype   varchar2(100),
	PRIMARY KEY (TranID)
);

create table audit1(
   TranID     number,
   EmployeeID number,
   AccNo      number,
   amount     number,
   FOREIGN KEY (TranID) REFERENCES tran1(TranID),
   FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)   
);

create table Leave(
   LeaveID number,
   EmployeeID number,
   LeaveDate date,
   Reason varchar2(100),
   PRIMARY KEY (LeaveID),
   FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

create table Emp(
  EmployeeID     number,
  WorkType       varchar2(100),
  DurationHours  number,
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

create table Incre(
  StaffID     number,
  Amount      number,
  Promoted_to  varchar2(100)
);

@"G:\Oracle_Software\Payroll Management System1\Trigger1.sql"



insert into Department values(1 , 'Cash');
insert into Department values(2 , 'Card');
insert into Department values(3 , 'Human Resource');
insert into Department values(4 , 'Accounts');
insert into Department values(5 , 'Loan');
insert into Department values(6 , 'LC');
insert into Department values(7 , 'Foreign Exchange');
insert into Department values(8 , 'Deposit Insurance');
insert into Department values(9 , 'Internal Audit');
insert into Department values(10 , 'Monetary Policy');



insert into Manager values(2001 , 'Khandakar Mustak' , 1 , 130000 , 'Mirpur');
insert into Manager values(2002 , 'Ripon Hasan' , 2 , 150000 , 'Rampura');
insert into Manager values(2003 , 'Razia Begum' , 3 , 160000 , 'Mirpr');
insert into Manager values(2004 , 'Arnold Gomes' , 4 , 170000 , 'Malibag');
insert into Manager values(2005 , 'Siham Kader' , 10 , 180000 , 'Modhibag');
insert into Manager values(2006 , 'Jakaria Rahim' , 10 , 135000 , 'Niketon');
insert into Manager values(2007 , 'Hasin Ishrak' , 10 , 140000 , 'Rajarbag');
insert into Manager values(2008 , 'Sohaib Ahmed' , 8 , 135000 , 'Mothijheel');
insert into Manager values(2009 , 'Tushar Ahmed' , 9 , 155000 , 'Kakrail');
insert into Manager values(2010 , 'Sazia Tonni' , 10 , 1366000 , 'Kakrail');




exec insertDataGrade(1 , 'Officer' , 18000);


exec insertDataGrade(1,'Senior Officer', 35000);
exec insertDataGrade(1,'Principal Officer', 48000);
exec insertDataGrade(1,'Senior Principal Officer', 62000);


exec insertDataGrade(2,'Officer', 20000);
exec insertDataGrade(2,'Senior Officer', 32000);
exec insertDataGrade(2,'Principal Officer', 45000);
exec insertDataGrade(2,'Senior Principal Officer', 55000);

exec insertDataGrade(3,'Officer', 24000);
exec insertDataGrade(3,'Senior Officer', 28000);
exec insertDataGrade(3,'Principal Officer', 40000);
exec insertDataGrade(3,'Senior Principal Officer', 52000);

exec insertDataGrade(4,'Officer', 27000);
exec insertDataGrade(4,'Senior Officer', 36000);
exec insertDataGrade(4,'Principal Officer', 46000);
exec insertDataGrade(4,'Senior Principal Officer', 58000);

exec insertDataGrade(5,'Officer', 27000);
exec insertDataGrade(5,'Senior Officer', 40000);
exec insertDataGrade(5,'Principal Officer', 52000);
exec insertDataGrade(5,'Senior Principal Officer', 66000);

exec insertDataGrade(6,'Officer', 32000);
exec insertDataGrade(6,'Senior Officer', 40000);
exec insertDataGrade(6,'Principal Officer', 50000);
exec insertDataGrade(6,'Senior Principal Officer', 70000);

exec insertDataGrade(7,'Officer', 24000);
exec insertDataGrade(7,'Senior Officer', 35000);
exec insertDataGrade(7,'Principal Officer', 50000);
exec insertDataGrade(7,'Senior Principal Officer', 70000);

exec insertDataGrade(8,'Officer',35000);
exec insertDataGrade(8,'Senior Officer', 45000);
exec insertDataGrade(8,'Principal Officer', 75000);
exec insertDataGrade(8,'Senior Principal Officer', 110000);

exec insertDataGrade(9,'Officer',38000);
exec insertDataGrade(9,'Senior Officer', 55000);
exec insertDataGrade(9,'Principal Officer', 70000);
exec insertDataGrade(9,'Senior Principal Officer',120000);

exec insertDataGrade(10,'Officer', 40000);
exec insertDataGrade(10,'Senior Officer',60000);
exec insertDataGrade(10,'Principal Officer',90000);
exec insertDataGrade(10,'Senior Principal Officer',130000);


exec insertDataEmployee(1001 , 1 , 2001 , 'Officer' , 'Mustak Ahmed' , '22-Jun-1992','1-Jan-2018', 'Rampura' , 'Dhaka' , 84092348 , 'mustak98@gmail.com');
exec insertDataEmployee(1002 , 1 , 2001, 'Officer' , 'Manik Ahmed' , '25-July-1996','5-Sep-2019', 'Rajarbag' , 'Dhaka' , 8403434348 , 'manik98@gmail.com');
exec insertDataEmployee(1003 , 1 , 2001 , 'Senior Officer' , 'Robin Ahmed' , '7-Dec-1992','28-Jan-2018', 'Rampura' , 'Dhaka' , 2384092348 , 'robin98@gmail.com');
exec insertDataEmployee(1004 , 1 , 2001 , 'Principal Officer' , 'Kaiser Ahmed' , '22-Jun-1990','10-Jan-2018', 'Malibag' , 'Dhaka' , 7784092348 , 'kaiser98@gmail.com');
exec insertDataEmployee(1005 , 1 , 2001 , 'Senior Principal Officer' , 'Jamil Ahmed' , '27-Feb-1992','1-Jan-2018', 'Kallyanpur' , 'Dhaka' , 9984092348 , 'jamil8@gmail.com');


exec insertDataEmployee(1006 , 2 , 2002 , 'Officer' , 'Karim Hasan' , '22-Jun-1990','16-Jan-2019', 'Modhubag' , 'Dhaka' , 13384092348 , 'karim34@gmail.com');
exec insertDataEmployee(1007 , 2 , 2002 , 'Senior Officer' , 'Redowan Ahmed' , '29-Mar-1996','5-Sep-2018', 'Niketon' , 'Dhaka' , 238403434348 , 'redowan98@gmail.com');
exec insertDataEmployee(1008 , 2 , 2002 ,'Senior Officer' , 'Sohag Hasan' , '7-Apr-1992','28-Sep-2018', 'Bakshibazar' , 'Dhaka' , 322384092348 , 'sohag56@gmail.com');
exec insertDataEmployee(1009 , 2 ,2002 , 'Principal Officer' , 'Tutul Ahmed' , '12-Jun-1990','10-Jan-2020', 'Malibag' , 'Dhaka' , 57784092348 , 'tutul89@gmail.com');
exec insertDataEmployee(1010 , 2 , 2002 ,'Senior Principal Officer' , 'Meena Begum' , '21-Feb-1994','1-Jan-2018', 'Kallyanpur' , 'Dhaka' , 69984092348 , 'meena@gmail.com');


exec insertDataEmployee(1011 , 3 , 2003 ,'Officer' , 'Zunayed Hasan' , '16-July-1993','20-Jan-2019', 'Modhubag' , 'Dhaka' , 84092348 , 'Zunayed34@gmail.com');
exec insertDataEmployee(1012 , 3 ,2003 , 'Senior Officer' , 'Shakil Ahmed' , '21-Apr-1997','5-May-2019', 'Mouchak' , 'Dhaka' , 4033234348 , 'shakil98@gmail.com');
exec insertDataEmployee(1013 , 3 , 2003 ,'Senior Officer' , 'Mamun Hasan' , '10-Apr-1992','28-Sep-2018', 'Bakshibazar' , 'Dhaka' , 34384092348 , 'mamun56@gmail.com');
exec insertDataEmployee(1014 , 3 ,2003 , 'Principal Officer' , 'Fahim Ahmed' , '12-Aug-1991','20-Jan-2020', 'Malibag' , 'Dhaka' , 13184092348 , 'fahim89@gmail.com');
exec insertDataEmployee(1015 , 3 , 2003,'Principal Officer' , 'Moina Begum' , '21-Feb-1994','1-Jan-2018', 'Sahajanpur' , 'Dhaka' , 58984092348 , 'moina@gmail.com');


exec insertDataEmployee(1016 , 4 , 2004,'Senior Officer' , 'Iqbal Hasan' , '13-July-1993','22-Jan-2019', 'Rupnagar' , 'Dhaka' , 9234843 , 'iqbal34@gmail.com');
exec insertDataEmployee(1017 , 4 , 2004,'Senior Officer' , 'Jerin Ahmed' , '14-Apr-1997','15-Apr-2019', 'Ashuganj' , 'Dhaka' , 23434812 , 'jerin8@gmail.com');
exec insertDataEmployee(1018 , 4 , 2004,'Senior Officer' , 'Mamudur Hasan' , '8-Mar-1992','28-Sep-2018', 'Savar' , 'Dhaka' , 4092348123 , 'mamudur56@gmail.com');
exec insertDataEmployee(1019 , 4 , 2004,'Principal Officer' , 'Ashiq Ahmed' , '12-Jan-1991','20-Aug-2020', 'Malibag' , 'Dhaka' , 409234823 , 'ashiq@gmail.com');
exec insertDataEmployee(1020 , 4 ,2004, 'Principal Officer' , 'Nabila Kabir' , '28-Feb-1994','8-Dec-2018', 'Mothijheel' , 'Dhaka' , 5812392348 , 'nabila@gmail.com');


exec insertDataEmployee(1021 , 5 , 2005,'Officer' , 'Siham Hasan' , '8-May-1995','28-Sep-2018', 'Sahbagh' , 'Dhaka' , 34092348123 , 'siham56@gmail.com');
exec insertDataEmployee(1022 , 5 ,2005, 'Principal Officer' , 'Seum Ahmed' , '12-Jan-1996','20-Aug-2021', 'Malibag' , 'Dhaka' , 4109234823 , 'seum@gmail.com');
exec insertDataEmployee(1023 , 5 , 2005,'Senior Principal Officer' , 'Josna Kabir' , '28-Mar-1994','8-Dec-2019', 'Tikatuli' , 'Dhaka' , 15812392348 , 'josna@gmail.com');

exec insertDataEmployee(1024 , 6 , 2006,'Officer' , 'Sayem Ahmed' , '10-Aug-1992','21-Sep-2019', 'Sahbagh' , 'Dhaka' , 34092348123 , 'sayem56@gmail.com');
exec insertDataEmployee(1025 , 6 , 2006,'Officer' , 'Akbar Ahmed' , '12-Jan-1996','15-Aug-2020', 'Malibag' , 'Dhaka' , 4109234823 , 'akbar@gmail.com');
exec insertDataEmployee(1026 , 6 , 2006,'Senior Officer' , 'Fulpori Kabir' , '28-Mar-1994','18-Dec-2019', 'Tikatuli' , 'Dhaka' , 15812392348 , 'fuli@gmail.com');


exec insertDataEmployee(1029 , 7 , 2007,'Senior Officer' , 'Nilima Ahmed' , '12-Jan-1996','15-Aug-2020', 'Malibag' , 'Dhaka' , 04109234823 , 'nilima@gmail.com');
exec insertDataEmployee(1030 , 7 , 2007,'Senior Officer' , 'Amena Kabir' , '28-May-1994','17-Dec-2019', 'Tikatuli' , 'Dhaka' , 062315812392348 , 'amena@gmail.com');

exec insertDataEmployee(1031 , 8 , 2008,'Officer' , 'Sathi Ahmed' , '17-Jan-1996','15-Aug-2020', 'Malibag' , 'Dhaka' , 564109234823 , 'sathi@gmail.com');
exec insertDataEmployee(1032 , 8 , 2008,'Senior Principal Officer' , 'Rupa Chowdhury' , '21-Mar-1994','18-Dec-2019', 'Tikatuli' , 'Dhaka' , 015812392348 , 'rupa@gmail.com');

exec insertDataEmployee(1033 , 9 ,2009, 'Officer' , 'Titas Ahmed' , '12-Jan-1996','15-Aug-2020', 'Malibag' , 'Dhaka' , 24109234823 , 'titas@gmail.com');
exec insertDataEmployee(1034 , 9 ,2009, 'Senior Officer' , 'Arman Ahmed' , '28-Mar-1994','18-Dec-2019', 'Tikatuli' , 'Dhaka' , 12421392348 , 'arman@gmail.com');

exec insertDataEmployee(1027 , 10 , 2010, 'Principal Officer' , 'Rajon Hasan' , '12-Jan-1996','15-Aug-2020', 'Malibag' , 'Dhaka' , 4109234823 , 'rajan@gmail.com');
exec insertDataEmployee(1028 , 10 , 2010, 'Senior Principal Officer' , 'Jshim Kabir' , '28-Mar-1994','18-Dec-2019', 'Tikatuli' , 'Dhaka' , 015812392348 , 'jashim@gmail.com');


exec insertDataCompensation(1, 1001 , 'Jan', 2018 , 'Officer');
exec insertDataCompensation(2 , 1001 , 'Feb',2018 , 'Officer');
exec insertDataCompensation(3 , 1001 , 'Mar', 2018, 'Officer');
exec insertDataCompensation(4 , 1001 , 'Apr', 2018, 'Officer');
exec insertDataCompensation(5 , 1001 , 'May', 2018, 'Officer');
exec insertDataCompensation(6,1001 , 'Jun', 2018, 'Officer');
exec insertDataCompensation(7,1001 , 'July', 2018, 'Officer');
exec insertDataCompensation(8,1001 , 'Aug', 2018, 'Officer');
exec insertDataCompensation(9,1001 , 'Sep', 2018, 'Officer');
exec insertDataCompensation(10 , 1001 , 'Oct', 2018, 'Officer');
exec insertDataCompensation(11 , 1001 , 'Nov', 2018, 'Officer');
exec insertDataCompensation(12 , 1001 , 'Dec', 2018, 'Officer');
exec insertDataCompensation(13 , 1001 , 'Jan', 2019, 'Officer');
exec insertDataCompensation(14 , 1001 , 'Feb', 2019, 'Officer');
exec insertDataCompensation(15 , 1001 , 'Mar', 2019, 'Officer');
exec insertDataCompensation(16 , 1001 , 'Apr', 2019, 'Officer');
exec insertDataCompensation(17 , 1001 , 'May', 2019, 'Officer');
exec insertDataCompensation(18 , 1001 , 'Jun', 2019, 'Officer');
exec insertDataCompensation(19 , 1001 , 'July', 2019, 'Officer');
exec insertDataCompensation(20 , 1001 , 'Aug', 2019, 'Officer');
exec insertDataCompensation(21 , 1001 , 'Sep', 2019, 'Officer');
exec insertDataCompensation(22 , 1001 , 'Oct', 2019, 'Officer');
exec insertDataCompensation(23 , 1001 , 'Nov', 2019, 'Officer');
exec insertDataCompensation(24 , 1001 , 'Dec', 2019, 'Officer');
exec insertDataCompensation(25 , 1002 , 'Sep', 2019, 'Officer');
exec insertDataCompensation(26 , 1002 , 'Oct', 2019, 'Officer');
exec insertDataCompensation(27 , 1002 , 'Nov', 2019, 'Officer');
exec insertDataCompensation(28 , 1002 , 'Dec', 2019, 'Officer');
exec insertDataCompensation(29 , 1002 , 'Jan', 2020, 'Officer');
exec insertDataCompensation(30 , 1002 , 'Feb', 2020, 'Officer');
exec insertDataCompensation(31 , 1002 , 'Mar', 2020, 'Officer');
exec insertDataCompensation(32 , 1002 , 'Apr', 2020, 'Officer');
exec insertDataCompensation(33 , 1002 , 'May', 2020, 'Officer');
exec insertDataCompensation(34, 1002 , 'Jun', 2020, 'Officer');
exec insertDataCompensation(35 , 1002 , 'July', 2020, 'Officer');
exec insertDataCompensation(36 , 1002 , 'Aug', 2020, 'Officer');
exec insertDataCompensation(37 , 1002 , 'Sep', 2020, 'Officer');
exec insertDataCompensation(38 , 1002 , 'Oct', 2020, 'Officer');
exec insertDataCompensation(39 , 1002 , 'Nov', 2020, 'Officer');
exec insertDataCompensation(40 , 1002 , 'Dec', 2020, 'Officer');
exec insertDataCompensation(41 , 1003 , 'Feb', 2018,'Senior Officer');
exec insertDataCompensation(42 , 1003 , 'Mar', 2018,'Senior Officer');
exec insertDataCompensation(43 , 1003 , 'Apr', 2018,'Senior Officer');
exec insertDataCompensation(44 , 1003 , 'May', 2018,'Senior Officer');
exec insertDataCompensation(45 , 1003 , 'Jun', 2018,'Senior Officer');
exec insertDataCompensation(46 , 1004 , 'Jan', 2018, 'Principal Officer');
exec insertDataCompensation(47 , 1004 , 'Feb', 2018, 'Principal Officer');
exec insertDataCompensation(48 , 1004 , 'Mar', 2018, 'Principal Officer');
exec insertDataCompensation(49 , 1004 , 'Apr', 2018, 'Principal Officer');
exec insertDataCompensation(50 , 1004 , 'May', 2018, 'Principal Officer');
exec insertDataCompensation(51 , 1004 , 'Jun', 2018, 'Principal Officer');
exec insertDataCompensation(52 , 1005 , 'Jan', 2018 , 'Senior Principal Officer');
exec insertDataCompensation(53 , 1005 , 'Feb', 2018, 'Senior Principal Officer');
exec insertDataCompensation(54 , 1005 , 'Mar', 2018, 'Senior Principal Officer');
exec insertDataCompensation(55 , 1005 , 'Apr', 2018, 'Senior Principal Officer');
exec insertDataCompensation(56 , 1005 , 'May', 2018, 'Senior Principal Officer');
exec insertDataCompensation(57 , 1005 , 'Jun', 2018, 'Senior Principal Officer');
exec insertDataCompensation(58 , 1007 , 'Sep', 2018, 'Senior Officer');
exec insertDataCompensation(59 , 1007 , 'Oct', 2018, 'Senior Officer');
exec insertDataCompensation(60 , 1007 , 'Nov', 2018, 'Senior Officer');
exec insertDataCompensation(61 , 1007 , 'Dec', 2018, 'Senior Officer');
exec insertDataCompensation(62 , 1008 , 'Sep', 2018, 'Senior Officer');
exec insertDataCompensation(63 , 1008 , 'Oct', 2018, 'Senior Officer');
exec insertDataCompensation(64 , 1008 , 'Nov', 2018, 'Senior Officer');
exec insertDataCompensation(65 , 1008 , 'Dec', 2018, 'Senior Officer');
exec insertDataCompensation(66 ,1011 , 'Jan', 2019, 'Officer');


insert into Overtime values(1001 , 2 , 50 , 15 , '21-Mar-2018');
insert into Overtime values(1001 , 1 , 10 , 15 , '28-Mar-2018');
insert into Overtime values(1001 , 0 , 30 , 15 , '6-Apr-2018');
insert into Overtime values(1001 , 0 , 40 , 15 , '7-Jun-2018');
insert into Overtime values(1001 , 1 , 50 , 15 , '10-Jun-2018');

insert into Overtime values(1002 , 2 , 50 , 15 , '20-Mar-2020');
insert into Overtime values(1002 , 1 , 10 , 15 , '28-Mar-2020');
insert into Overtime values(1002 , 1 , 30 , 15 , '16-Apr-2020');
insert into Overtime values(1002 , 1 , 40 , 15 , '17-Jun-2020');
insert into Overtime values(1002 , 1 , 50 , 15 , '20-Jun-2020');

insert into Overtime values(1003 , 1 , 40 , 15 , '20-Feb-2018');
insert into Overtime values(1003 , 1 , 0 , 15 , '28-Feb-2018');
insert into Overtime values(1003 , 1 , 0 , 15 , '16-Mar-2018');
insert into Overtime values(1003 , 1 , 30 , 15 , '17-Apr-2018');
insert into Overtime values(1003 , 2 , 50 , 15 , '20-Apr-2018');

insert into Overtime values(1008 , 1 , 40 , 15 , '12-Sep-2018');
insert into Overtime values(1008 , 1 , 40 , 15 , '17-Sep-2018');
insert into Overtime values(1008 , 1 , 10 , 15 , '16-Oct-2018');
insert into Overtime values(1008 , 1 ,  30 , 15 , '20-Nov-2018');
insert into Overtime values(1008 , 2 , 50 , 15 , '22-Nov-2018');

exec insertDeduction(1001 , 2018 , 30000  , 'Jan');
exec insertDeduction(1001 , 2018 , 0  , 'Feb');
exec insertDeduction(1001 , 2018 , 0  , 'Mar');
exec insertDeduction(1001 , 2018 , 0  , 'Apr');
exec insertDeduction(1001 , 2018 , 15000  , 'May');
exec insertDeduction(1001 , 2018 , 0  , 'Jun');
exec insertDeduction(1001 , 2018 , 20000  , 'Sep');


exec insertDeduction(1002 , 2020 , 30000  , 'Mar');
exec insertDeduction(1002 , 2020 , 10000  , 'Apr');
exec insertDeduction(1002 , 2020 , 0  , 'May');
exec insertDeduction(1002 , 2020 , 15000  , 'Jun');

exec insertDeduction(1003 , 2018 , 25000  , 'Feb');
exec insertDeduction(1003 , 2018 , 0  , 'Mar');
exec insertDeduction(1003 , 2018 , 0  , 'Apr');


exec insertDeduction(1008 , 2018 , 0  , 'Sep');
exec insertDeduction(1008 , 2018 , 0  , 'Oct');
exec insertDeduction(1008 , 2018 , 0  , 'Nov');


insert into Leave values (1 , 1001 , '22-Jan-2018' , 'Due to sickness');
insert into Leave values (2 , 1002 , '11-Sep-2019' , 'Due to sickness');
insert into Leave values (3 , 1003 , '19-Feb-2018' , 'Going Abroad');
insert into Leave values (4 , 1004 , '15-Jan-2018' , 'Marriage Ceremony');
insert into Leave values (5 , 1005 , '10-Jan-2018' , 'Atteding Personal Program');




insert into tran1 values(1, 'Cash');
insert into tran1 values(2, 'Credit');
insert into tran1 values(3, 'Business');
insert into tran1 values(4, 'Personal');


insert into audit1 values(1, 1001 , 672 , 2000);
insert into audit1 values(1, 1001 , 672 , 2500);
insert into audit1 values(2, 1001 , 672 , 3500);
insert into audit1 values(3, 1001 , 672 , 2200);
insert into audit1 values(4, 1001 , 672 , 2100);

insert into audit1 values(1, 1002 , 512 , 2800);
insert into audit1 values(2, 1002 , 512 , 3800);
insert into audit1 values(3, 1002 , 512 , 2300);
insert into audit1 values(4, 1002 , 512 , 2100);

insert into audit1 values(1, 1003 , 513 , 3000);
insert into audit1 values(2, 1003 , 513 , 3500);
insert into audit1 values(3, 1003 , 513 , 2400);
insert into audit1 values(4, 1003 , 513 , 2200);

insert into Emp values (1001 , 'Full Time' , 8);
insert into Emp values (1002 , 'Full Time' , 8);
insert into Emp values (1003 , 'Full Time' , 7);
insert into Emp values (1004 , 'Full Time' , 7);
insert into Emp values (1005 , 'Full Time' , 7);
insert into Emp values (1006 , 'Full Time' , 7);
insert into Emp values (1007 , 'Full Time' , 8);
insert into Emp values (1008 , 'Full Time' , 8);
insert into Emp values (1009 , 'Full Time' , 8);
insert into Emp values (1010 , 'Full Time' , 7);

insert into Emp values (1025 , 'Part Time' , 4);
insert into Emp values (1026 , 'Part Time' , 4);
insert into Emp values (1027 , 'Part Time' , 4);
insert into Emp values (1028 , 'Part Time' , 4);
insert into Emp values (1029 , 'Part Time' , 4);
insert into Emp values (1030 , 'Part Time' , 4);
insert into Emp values (1031 , 'Part Time' , 3);
insert into Emp values (1032 , 'Part Time' , 3);
insert into Emp values (1033 , 'Part Time' , 3);
insert into Emp values (1034 , 'Part Time' , 3);


insert into Incre values(1001 , 6000 , 'Senior Officer');
insert into Incre values(1002 , 10000 , 'Senior Officer');
insert into Incre values(1003 , 12000 , 'Principal Officer');
insert into Incre values(1004 , 15000 , 'Senior Principal Officer');
insert into Incre values(1005 , 8000 , 'Manager');


insert into Incre values(2001 , 20000 , 'Deputy Manager');
insert into Incre values(2002 , 20000 , 'Deputy Manager');
