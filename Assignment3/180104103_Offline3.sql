set serveroutput on;
set verify off;

drop table track;
drop table album;
drop table artist;


create table artist
(
    artistID number,
	name     varchar2(100),
	age      number,
	gender   varchar2(100),
	PRIMARY KEY (artistID)
);

create table album
(   
    albumID     number,
	artistID    number,
	albumTitle  varchar2(100),
	certification varchar2(100),
	numberOfTracks number,
	PRIMARY KEY (albumID) ,
	FOREIGN KEY (artistID) REFERENCES artist(artistID)
);

create table track
(
   trackID     number,
   albumID     number,
   trackTitle  varchar2(100),
   genre       varchar2(100),
   released    date,
   PRIMARY KEY (trackID) ,
   FOREIGN KEY (albumID) REFERENCES album(albumID)
);

create or replace procedure insertDataArtist
(    
	inartistID artist.artistID%type,
	inname     artist.name%type,
	inage      artist.age%type,
	ingender   artist.gender%type
 ) 
as
begin
      insert into artist(artistID , name , age ,gender) values(inartistID , inname , inage , ingender);
end;
/

create or replace procedure insertDataTrack  
(	
	intrackID       track.trackID%type,
	inalbumID       track.albumID%type,
	intrackTitle    track.trackTitle%type,
	ingenre         track.genre%type,
    inreleased      track.released%type
)
as
begin
      insert into track(trackID , albumID , trackTitle , genre ,released) values(intrackID, inalbumID , intrackTitle , ingenre , inreleased);
end;
/

create or replace procedure insertDataAlbum
( 
	inalbumID         album.albumID%type,
	inartistID        album.artistID%type,
	inalbumTitle      album.albumTitle%type,
	incertification   album.certification%type,
	innumberOfTracks  album.numberOfTracks%type
)
as
begin
      insert into album(albumID , artistID , albumTitle , certification , numberOfTracks) values(inalbumID , inartistID , inalbumTitle , incertification , innumberOfTracks);
end;
/
create or replace trigger myTrigger1

after insert 
on artist
declare

begin
      DBMS_OUTPUT.PUT_LINE('My artist data are inserted');
end;
/

create or replace trigger myTrigger2

after insert 
on album
declare

begin
      DBMS_OUTPUT.PUT_LINE('My album data are inserted');
end;
/

create or replace trigger myTrigger3
after insert 
on artist
declare

begin
      DBMS_OUTPUT.PUT_LINE('My track data are inserted');
end;
/

exec insertDataArtist (1 , 'A' , 20 , 'M');
exec insertDataArtist (2 , 'B' , 30 , 'F');
exec insertDataArtist (3 , 'C' , 35 , 'M');
exec insertDataArtist (4 , 'D' , 32 , 'F');
exec insertDataArtist (5 , 'E' , 46 , 'F');
exec insertDataArtist (6 , 'F' , 48 , 'M');


exec insertDataAlbum  (1 , 2 , 'PONM' , 'GOLD' , 7);
exec insertDataAlbum  (2 , 5 , 'TSRQ' , 'PLATINUM' , 14);
exec insertDataAlbum  (3 , 3 , 'DCBA' , 'SILVER' , 12);
exec insertDataAlbum  (4 , 1 , 'HGFE' , 'GOLD' , 10);
exec insertDataAlbum  (5 , 2 , 'LKJI' , 'PLATINUM' , 9);


exec insertDataTrack  (1  , 1 , 'title1', 'rock' , '22-jun-1992');
exec insertDataTrack  (2 , 1 , 'title2' , 'rock' , '12-jul-1992');
exec insertDataTrack  (3 , 4 , 'title3' , 'country' , '02-feb-1972');
exec insertDataTrack  (4 , 1 , 'title4' , 'rock'  , '12-jul-1992');
exec insertDataTrack  (5 , 2 , 'title5' , 'country' , '25-mar-1997');
exec insertDataTrack  (6 , 2 , 'title6' , 'country' , '25-mar-1997');
exec insertDataTrack  (7 , 3 , 'title7' , 'pop'  ,'26-jun-2010');
exec insertDataTrack  (8 , 5 , 'title8' , 'pop'  ,'22-may-1982');

commit;


create or replace package mypack as

procedure searching(A in artist.artistID%type,
B out artist.artistID%type,C out artist.name%type);

function finding(ID in album.artistID%type , 
B out album.albumTitle%type ,D out track.genre%type)
return album.numberOfTracks%type;

end mypack;
/

create or replace package body mypack as

procedure searching(A in artist.artistID%type , B out artist.artistID%type  , C out artist.name%type)
is 

Name    artist.name%type;
Age     artist.age%type;
Gender  artist.gender%type;
Gender1  artist.gender%type;

begin 
     select name into Name from artist where artistID = A;
	 
	 select age  , gender into Age , Gender from artist where artistID = A;

    DBMS_OUTPUT.PUT_LINE('Age of ' || Name || ': ' || Age);
    DBMS_OUTPUT.PUT_LINE('Gender of ' || Name || ': ' || Gender);
	
	Gender1 := Gender;
	 
	 for R in ( select name , artistID from artist where gender = Gender1 and 
     artistID in(select artistID from album where certification = 'PLATINUM' 
	 or certification = 'GOLD') )loop
	    
	 
	      DBMS_OUTPUT.PUT_LINE('Other Artist of ' || Gender || ' gender : '|| R.Name);
		  --DBMS_OUTPUT.PUT_LINE('ID of Other Artist ' || R.artistID);
		  
		  B := R.artistID;
		  C := R.Name;
	 
	 end loop;
	 
	

end searching;

function finding(ID in album.artistID%type , B out album.albumTitle%type ,D out track.genre%type)

return album.numberOfTracks%type
is
C album.numberOfTracks%type;

begin
       C := 0;
	   
      for R in (select albumTitle , numberOfTracks , genre from album inner join track 
      on album.albumID = track.albumID where artistID = ID ) loop 
	    --DBMS_OUTPUT.PUT_LINE(R.albumTitle);
		--DBMS_OUTPUT.PUT_LINE(R.numberOfTracks);
		--DBMS_OUTPUT.PUT_LINE(R.genre);
		
		B := R.albumTitle;
		C := R.numberOfTracks;
		D := R.genre;
	  
	  end loop;

    return C;
	
end finding;

end mypack;
/


Accept X NUMBER prompt "Enter Artist ID= ";

declare 
       A number;
	   B artist.artistID%type;
	   C artist.name%type;
	   num1 album.albumTitle%type;
	   res album.numberOfTracks%type;
	   num3 track.genre%type;
	   
	   check_val number;
	   
       myException exception;
begin
      A :=&X;
	  
	  
	  select count(artistID) into check_val from artist;
	  
	  if(A > check_val or A <= 0) then
	   raise myException;
	  else 
	      mypack.searching(A , B , C);  
	      res := mypack.finding(B , num1 , num3);
	
	  DBMS_OUTPUT.PUT_LINE('Album of ' || C || ': ' || num1);
	  DBMS_OUTPUT.PUT_LINE('Genre of ' || num1 || ' : ' || num3);
	  DBMS_OUTPUT.PUT_LINE('Number of tracks in ' || num1 || ' : ' || res);
      end if;
	  
exception
	
    	 
	    when myException THEN
		   DBMS_OUTPUT.PUT_LINE('Artist does not exist');
     
end;
/

