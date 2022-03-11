
drop database link server1;

create database link server1
 connect to system identified by "123456"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.0.102)
		 (PORT = 1620))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
;  
