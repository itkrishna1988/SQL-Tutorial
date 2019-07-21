-- Demo script for Probe Residual demo.

-- Demo databases can be downloaded from
-- http://bit.ly/10fKpbS (that's a zero).

-- Download the 2008 Credit sample database from the link 
-- above and unzip into D:\Pluralsight.

-- Restore as follows:
USE [master];
GO

IF DATABASEPROPERTYEX (N'Credit', N'Version') > 0
BEGIN
	ALTER DATABASE [Credit] 
		SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Credit];
END
GO

RESTORE DATABASE [Credit]
FROM DISK = N'D:\Pluralsight\CreditBackup100.bak'
WITH
    MOVE N'CreditData'
		TO N'D:\Pluralsight\CreditData.mdf',
	MOVE N'CreditLog' 
		TO N'D:\Pluralsight\CreditLog.ldf';
GO

USE [Credit];
GO

-- Just as with an implicit_conversion, you can have
-- inefficiencies in your joins if you join two columns
-- on data types that are only implicitly compatible

-- It's a bit less obvious in a join (doesn't show as 
-- a warning or as an IMPLICIT_CONVERSION)

-- Create a copy of the member table but change the 
-- member_no to a decimal type

-- This checks for the table and if it exists, 
-- drops it.
IF OBJECTPROPERTY (OBJECT_ID (N'dbo.member2')
		, N'IsUserTable') = 1
	DROP TABLE [dbo].[member2];
GO

SELECT CONVERT (DECIMAL (12, 0), [member_no]) AS [member_no]
      ,[lastname]
      ,[firstname]
      ,[middleinitial]
      ,[street]
      ,[city]
      ,[state_prov]
      ,[country]
      ,[mail_code]
      ,[phone_no]
      ,[photograph]
      ,[issue_dt]
      ,[expr_dt]
      ,[region_no]
      ,[corp_no]
      ,[prev_balance]
      ,[curr_balance]
      ,[member_code]
INTO [dbo].[member2]
FROM [dbo].[member];
GO

CREATE UNIQUE CLUSTERED INDEX [Member2PK]
ON [dbo].[Member2] ([member_no]);
GO

SET STATISTICS IO ON;
GO

SELECT [m].[member_no]
	, [m].[lastname]
	, [c].[charge_amt]
FROM [dbo].[member] AS [m]
    JOIN [dbo].[charge] AS [c]
        ON [m].[member_no] = [c].[member_no];
GO

SELECT [m].[member_no]
	, [m].[lastname]
	, [c].[charge_amt]
FROM [dbo].[member2] AS [m]
    JOIN [dbo].[charge] AS [c]
        ON [m].[member_no] = [c].[member_no];
GO