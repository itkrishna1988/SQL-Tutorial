-- Demo script for Metadata Corruption demo.

-- Run Setup-MetadataCorruption.sql first

-- What's wrong with this database?
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- We can also try DBCC CHECKCATALOG
DBCC CHECKCATALOG (N'Company') WITH NO_INFOMSGS;
GO 

-- Explain about warning at top of output

-- To fix the errors need to boot single-user mode
-- and connect using the DAC

-- Run DBCC CHECKCATALOG again
DBCC CHECKCATALOG (N'Company') WITH NO_INFOMSGS;
GO

/*
 Errors reference:
	- sys.indexes is really sys.sysidxstats
	- sys.objects is really sys.sysschobjs
	- sys.columns is really sys.syscolpars 

 Errors mean:
	1.There's an extra row in sys.syscolpars 
	2.There's an extra row in sys.syscolpars 
	3.There's an extra row in sys.sysidxstats 
	4.There's an extra row in sys.sysschobjs 
	5.There's an extra row in sys.sysschobjs
*/

USE [Company];
GO

-- Fix broken columns
DELETE FROM [sys].[syscolpars]
WHERE [id] = XX;

DBCC CHECKCATALOG (N'Company') WITH NO_INFOMSGS;
GO

-- Fix broken indexes
DELETE FROM [sys].[sysidxstats]
WHERE [id] = XX;

DBCC CHECKCATALOG (N'Company') WITH NO_INFOMSGS;
GO

-- Fix broken objects
-- Get the two IDs, not the parent ID
DELETE FROM [sys].[sysschobjs]
WHERE [id] = XX;

DBCC CHECKCATALOG (N'Company') WITH NO_INFOMSGS;
GO

-- Final DBCC CHECKDB
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Reboot without single-user mode and drop the DAC
