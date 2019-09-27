/* Reikia suimportuoti iš pateikto csv failo actors.csv į actors lentelę. Aprašykite kaip tai darysite.


Sakila database --> Tables --> actor table --> right click --> Data import wizard --> chosing location of saved 'actors' file
--> use existing table --> check if columns in file match columns in the actor table in sakila database --> import done.alter
OR, using the script (don't forget to put file in the folder uploads): */


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/actors.csv'
REPLACE INTO TABLE actor CHARACTER SET UTF8MB4
FIELDS TERMINATED BY ';'IGNORE 1 LINES (first_name, last_name);