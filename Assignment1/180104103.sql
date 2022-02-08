drop table Borrows;
drop table Book;
drop table Author;
drop table Student;

create table Student(
     studentID number,
	 name      varchar2(100),
	 phone     varchar2(100),
	 age       number,
	 PRIMARY KEY (studentID)
);

create table Author(
    authorID  number,
	name      varchar2(100),
	age       number,
	PRIMARY KEY (authorID)
);

create table Book(
	 bookID      number,
	 authorID    number,
	 title       varchar2(100),
	 genre       varchar2(100),  
	 PRIMARY KEY (bookID), 
	 FOREIGN KEY (authorID) REFERENCES Author(authorID)
);

create table Borrows(
     studentID     number,
	 bookID        number,
	 dateBorrowed  date,
	 FOREIGN KEY (bookID) REFERENCES Book(bookID),
	 FOREIGN KEY (studentID) REFERENCES Student(studentID)
);



insert into Student values(101 , 'John' , '01312787388' , 22);
insert into Student values(102 , 'Gary' , '01356787388' , 22);
insert into Student values(103 , 'Lia' , '01312727388' , 23);
insert into Student values(104 , 'Richard' , '01312787399' , 21);
insert into Student values(105 , 'Lucifer' , '01354687388' , 23);
insert into Student values(106 , 'Hercules' , '01666787388' , 22);
insert into Student values(107 , 'Prima' , '01312777388' , 24);
insert into Student values(108 , 'Jesica' , '01312557388' , 24);
insert into Student values(109 , 'Robert' , '01314477388' , 20);
insert into Student values(110 , 'Jane' , '013127875488' , 20);



insert into Author values(501 , 'Xenia' , 45);
insert into Author values(502 , 'Tom' , 55);
insert into Author values(503 , 'Jerry' , 48);
insert into Author values(504 , 'Wangsu' , 42);
insert into Author values(505 , 'David' , 65);
insert into Author values(506 , 'Nicholas' , 38);


insert into Book values(9600 , '502' , 'Gullivers Travels' , 'Fiction');
insert into Book values(3660 , '503' , 'A Gentle Man In A Moscow' , 'Fiction');
insert into Book values(5679 , '503' , 'Walden' , 'Non-Fiction');
insert into Book values(9601 , '502' , 'Crime and Punishment' , 'Detective');
insert into Book values(9560 , '501' , 'Confessions' , 'Non-Fiction');
insert into Book values(7810 , '501' , 'Gitanjali' , 'Novel');
insert into Book values(8601 , '501' , 'The Haunting Of Hill House' , 'Horror');
insert into Book values(7668 , '504' , 'The Prince' , 'Non-Fiction');
insert into Book values(9719 , '505' , 'Invisble Man' , 'Fiction');
insert into Book values(3330 , '505' , 'Alexander Hamilton' , 'Biography');
ins ert into Book values(7811 , '504' , 'The Big Short' , 'Economics');
insert into Book values(1383 , '504' , 'Beloved' , 'Fiction');
insert into Book values(8881 , '501' , 'Cosmology ' , 'Science');


insert into Borrows values(102 , 7810 , '21-APR-21');
insert into Borrows values(102 , 7810 , '27-APR-21');
insert into Borrows values(102 , 9600 , '20-APR-21');
insert into Borrows values(103 , 1383 , '27-JUN-21');
insert into Borrows values(102 , 7810 , '13-JUN-21');
insert into Borrows values(104 , 7810 , '17-MAY-21');
insert into Borrows values(105 , 3330 , '11-MAR-21');
insert into Borrows values(105 , 9600 , '09-MAR-21');
insert into Borrows values(104 , 7810 , '29-SEP-21');
insert into Borrows values(104 , 7810 , '29-OCT-21');
insert into Borrows values(101 , 7668 , '09-FEB-21');
insert into Borrows values(110 , 7810 , '21-MAY-21');
insert into Borrows values(107 , 7810 , '22-JAN-21');
insert into Borrows values(108 , 7810 , '24-FEB-21');
insert into Borrows values(101 , 8881 , '12-OCT-21');
insert into Borrows values(106 , 7810 , '13-NOV-21');
insert into Borrows values(103 , 7810 , '06-JUN-21');
insert into Borrows values(103 , 7810 , '28-JUN-21');

--a
select name from Student where 
studentId IN (select studentID from Borrows 
where bookID = (select bookID from Book 
where title = 'Gullivers Travels'));

--b
select max(age) from Author where
authorID IN (select authorID from Book where
genre = 'Non-Fiction');

--c
select phone from Student where 
studentId IN (select studentID from Borrows 
where bookID = (select bookID from Book 
where title = 'Gitanjali')group by studentID having count(studentID)>2);


commit;


