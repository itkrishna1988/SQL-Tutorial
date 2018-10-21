Select 1/0
print 'Statement Termination . WIll print this'

go
Select CONVERT(int,'Madhu')
print 'Batch Termination . This WIll not print '
go
-- both the above statement have same severity level but different behaviour. One statement termination and other batch
-- Explain GO (batch terminator) 
-- If a batch termination happens inside an SP , the further statements are not processed

	Create proc sp_test
	as

	Select CONVERT(int,'Madhu')
	print 'Batch Termination . This WIll not print '

	Go
	Exec sp_test
	
	
-- This exception is thrown even before the batch is executed. During compile 
Select *From table_which_doesnot_exists
print 'Scope/execution Termination . This WIll not print '
go
Select *From from table
print 'Scope/execution Termination . This WIll not print '

--To prove this was a Scope termination let us use Dynamic sql

Exec ('Select *From from table')
print 'Scope/execution Termination . This WIll print because it is a scope termination. ie parsing/compilation issue '
go

Exec ('Select *From table_which_doesnot_exists')
print 'Scope/execution Termination . This WIll print because it is a scope termination. ie parsing/compilation issue '
go

-- Batch termination using dynamic sql
	exec ('Select CONVERT(int,''Madhu'')')
	print 'Batch Termination . This WIll not print because it is a batch termination'

-- Where all the error messages are stored
Select *from sys.messages where language_id=1033 and severity=11


--Explain Set XACT_ABORT ON impact on Termination

Set XACT_ABORT ON 
Select 1/0
print 'Statement Termination . WIll NOT print this'


-- Explain how to use RAISERROR
--Raiserror is a statement aborting exception till Severity 18
Raiserror( 'Raise Error exception ',16,1)
/*
Msg 50000, Level 16, State 1, Line 1
Raise Error exception 

*/

--How to pass parameter to raiserror
declare @empid int=10
 
Raiserror( 'Invalid employeeId %i',16,1,@empid ) 
--multiple token being used
Raiserror( 'Invalid employeeId %i,%i,%i',16,1,@empid ,@empid,@empid) 

-- Loggin info to SQL Server log using Raiserror 

Raiserror( 'Raiserror with logging ',16,1 )  with log

-- Use sp_addmessage to persiste error message and use that in Raiserror

Exec sp_addmessage @msgnum=500006,@severity=16,@msgtext='Invalid employeeId %i,%i,%i'

Raiserror (500006,-1,1,10,111,12) -- -1 for severity to be taken from sys.message

-- to log the error in error log
Raiserror ('This will be logged' ,16,1)  with log