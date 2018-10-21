/*============================================================================
  File:     NestedXacts.sql

  Summary:  Investigate nested transactions and savepoints

  Date:     May 2011

------------------------------------------------------------------------------
  Written by Paul S. Randal, SQLskills.com

  (c) 2011, SQLskills.com. All rights reserved.

  For more scripts and sample code, check out 
    http://www.SQLskills.com

  You may alter this code for your own *non-commercial* purposes. You may
  republish altered code as long as you include this copyright and give due
  credit, but you must obtain prior permission before blogging this code.
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/

-- Nastiness
WHILE (@@TRANCOUNT != 0) COMMIT TRAN;
GO

-- Setup
USE master;
GO
DROP DATABASE NestedXactsAreNotReal;
GO

CREATE DATABASE NestedXactsAreNotReal;
GO
USE NestedXactsAreNotReal;
GO
ALTER DATABASE NestedXactsAreNotReal SET RECOVERY SIMPLE;
GO

CREATE TABLE t1 (c1 INT IDENTITY);
GO
SET NOCOUNT ON;
GO 
CHECKPOINT;
GO

-- Test 1
BEGIN TRAN OuterTran;
GO 

INSERT INTO t1 DEFAULT Values;
GO 5 

BEGIN TRAN InnerTran;
GO 

INSERT INTO t1 DEFAULT Values;
GO 5 

SELECT COUNT (*) FROM t1;
GO 

-- Now look at the log
SELECT * FROM fn_dblog (NULL, NULL);
GO

COMMIT TRAN InnerTran;
GO 

-- Now look at the log again
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Now rollback the outer tran
ROLLBACK TRAN OuterTran;
GO 

SELECT COUNT (*) FROM t1;
GO 

-- Now look at the log again
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Test 2
CHECKPOINT;
GO

BEGIN TRAN OuterTran;
GO 

INSERT INTO t1 DEFAULT Values;
GO 5 

BEGIN TRAN InnerTran;
GO 

INSERT INTO t1 DEFAULT Values;
GO 5 

SELECT @@TRANCOUNT, COUNT (*) FROM t1;
GO 

-- Now try to rollback the inner
ROLLBACK TRAN InnerTran;
GO 

ROLLBACK TRAN;
GO 

SELECT @@TRANCOUNT, COUNT (*) FROM t1;
GO

SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Test 2
CHECKPOINT;
GO

BEGIN TRAN OuterTran;
GO

INSERT INTO t1 DEFAULT Values;
GO 5

SAVE TRAN MySavepoint;
GO

SELECT * FROM fn_dblog (NULL, NULL);
GO

INSERT INTO t1 DEFAULT Values;
GO 5
SELECT @@TRANCOUNT, COUNT (*) FROM t1;
GO
SELECT * FROM fn_dblog (NULL, NULL);
GO

ROLLBACK TRAN MySavepoint;
GO
SELECT @@TRANCOUNT, COUNT (*) FROM t1;
GO
SELECT * FROM fn_dblog (NULL, NULL);
GO
