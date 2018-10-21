/* to understand the datetime data types */


/* create a table with columns having different date/time datatypes */

CREATE TABLE testdatetypes 
  ( 
     date_column DATE, 
     time_column TIME(3), 
     datetime2_column DATETIME2(7) NOT NULL DEFAULT Getdate(), 
     datetimeoffset_column DATETIMEOFFSET CHECK (datetimeoffset_column<CAST (Getdate() AS DATETIMEOFFSET (0))) 
  );  
  
/* insert values into the table */
  Insert into testdatetypes(date_column,time_column,datetime2_column,datetimeoffset_column) values (
  '0001-01-01' , '23:59:59', '0001-12-21 23:59:59.1234567' , '0001-10-21 23:59:59.1234567 -07:00');
  
   Insert into testdatetypes(date_column,time_column,datetime2_column,datetimeoffset_column) values (
  '9999-12-31' , '23:59:59', '9999-12-21 23:59:59.1234567' , '1111-10-21 23:59:59.1234567 -07:00');
 
/*DATEPART Function have few new arguments introduced to support the new data types
to detect the timezone offset,week,microsecond from datetimeoffset_column */

	select datetimeoffset_column,  datepart(tzoffset,datetimeoffset_column) ,
	datepart(iso_week,datetimeoffset_column) ,
	datepart(microsecond,datetimeoffset_column) from testdatetypes; 

/* few more examples */  
/* The following example compares the results of casting a 
    string to each date and time data type */
SELECT 
     CAST('2007-05-08 12:35:29. 1234567 +12:15' AS time(7)) AS 'time' 
    ,CAST('2007-05-08 12:35:29. 1234567 +12:15' AS date) AS 'date' 
    ,CAST('2007-05-08 12:35:29.123' AS smalldatetime) AS 
        'smalldatetime' 
    ,CAST('2007-05-08 12:35:29.123' AS datetime) AS 'datetime' 
    ,CAST('2007-05-08 12:35:29.1234567+12:15' AS datetime2(7)) AS 
        'datetime2'
    ,CAST('2007-05-08 12:35:29.1234567 +12:15' AS datetimeoffset(7)) AS 
        'datetimeoffset'
    ,CAST('2007-05-08 12:35:29.1234567+12:15' AS datetimeoffset(7)) AS
        'datetimeoffset IS08601';
 
 
-- Sample new function added in 2008- TODATETIMEOFFSET : Returns a datetimeoffset value that is translated from a datetime2 expression
DECLARE @todaysDateTime Datetime2
SELECT @todaysDateTime = GetDate();
SELECT TODATETIMEOFFSET (@todaysDateTime, '-07:00')
 

-- Usage of TODATETIMEOFFSET : Returns a datetimeoffset value that is translated from a datetime2 expression
DECLARE @todaysDateTime Datetime2
SELECT @todaysDateTime = GetDate();
SELECT TODATETIMEOFFSET (@todaysDateTime, '-07:00')
-- RETURNS 2007-08-30 15:51:34.7030000 -07:00


/* drop the test table */
DROP TABLE testdatetypes; 
