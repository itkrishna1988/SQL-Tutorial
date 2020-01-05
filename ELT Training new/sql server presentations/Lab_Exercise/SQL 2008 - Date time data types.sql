/* to understand the datetime data types */


/* create a table with columns having different datetime datatypes */

CREATE TABLE testdatetypes 
  ( 
     date_column DATE, 
     time_column TIME(3), 
     datetime2_column DATETIME2(7) NOT NULL DEFAULT Getdate(), 
     datetimeoffset_column DATETIMEOFFSET CHECK (c4<CAST (Getdate() AS DATETIMEOFFSET (0))) 
  );  
  
/* insert values into the table */
  Insert into testdatetypes(date_column,time_column,datetime2_column,datetimeoffset_column) values (
  '0001-01-01' , '23:59:59', '0001-12-21 23:59:59.1234567' , '0001-10-21 23:59:59.1234567 -07:00');
  
   Insert into testdatetypes(date_column,time_column,datetime2_column,datetimeoffset_column) values (
  '9999-12-31' , '23:59:59', '9999-12-21 23:59:59.1234567' , '1111-10-21 23:59:59.1234567 -07:00');
  
  /* query to demonstrate datetimeoffset */
	select datetimeoffset_column,  datepart(tzoffset,datetimeoffset_column) ,
	datepart(iso_week,datetimeoffset_column) ,
	datepart(microsecond,datetimeoffset_column) from testdatetypes; 

/* few more examples */  
/* Using cast on the different datetime datatypes */
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

/* temporary variable with datetimeoffset datatype */
declare @utcDatetime datetimeoffset
declare @nycDatetime datetimeoffset
set @utcDatetime = CAST('2011-03-01 05:00:00 +00:00' AS datetimeoffset)
set @nycDatetime = CAST('2011-03-01 05:00:00 -05:00' AS datetimeoffset)
select @utcDatetime, @nycDatetime


SELECT TODATETIMEOFFSET ('2008-02-10 7:45:50.71345 +4:00', '+05:30') as TODATETIMEOFFSET ;
SELECT TODATETIMEOFFSET ('2008-02-10 7:45:50.71345 -5:00', '-08:00') as TODATETIMEOFFSET; 

/* drop the test table */
DROP TABLE testdatetypes; 