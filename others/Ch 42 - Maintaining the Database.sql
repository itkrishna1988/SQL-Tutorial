-----------------------------------------------------------
-- SQL Server 2008 Bible 
-- Wiley Publishing 
-- Uttam Parui

-- Chapter 42 - Maintaining the Database

-----------------------------------------------------------
-----------------------------------------------------------

-- DBCC HELP
DBCC HELP ('CHECKDB');

DBCC HELP ('?');

-- DBCC CHECKDB
DBCC CHECKDB ('AdventureWorks2008');

ALTER DATABASE AdventureWorks2008 SET SINGLE_USER;

ALTER DATABASE AdventureWorks2008 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

ALTER DATABASE AdventureWorks2008 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
BEGIN TRANSACTION;
DBCC CheckDB ('AdventureWorks2008', REPAIR_ALLOW_DATA_LOSS);
--Check for any data loss
--ROLLBACK TRANSACTION if data loss is not acceptable else COMMIT TRANSACTION;
ALTER DATABASE AdventureWorks2008 SET MULTI_USER;

-- DBCC CHECKIDENT
Use AdventureWorks2008;
DBCC CHECKIDENT ("HumanResources.Employee");

--------------------------------
-- Index Maintainance

-- Database Fragmentation

USE Tempdb;

CREATE TABLE Frag (
  FragID UNIQUEIDENTIFIER NOT NULL DEFAULT NewID(),
  Col1 INT,
  Col2 CHAR(200),
  Created DATETIME DEFAULT GetDate(),
  Modified DATETIME DEFAULT GetDate()
  );

ALTER TABLE Frag
  ADD CONSTRAINT PK_Frag
  PRIMARY KEY CLUSTERED (FragID);

CREATE NONCLUSTERED INDEX ix_col 
  ON Frag (Col1);

CREATE PROC Add100K
AS
SET nocount on;
DECLARE @X INT;
SET @X = 0;
  WHILE @X < 100000
    BEGIN
      INSERT Frag (Col1,Col2)
        VALUES (@X, 'sample data');
      SET @X = @X + 1;
    END
GO;

EXEC Add100K;
EXEC Add100K;
EXEC Add100K;
EXEC Add100K;
EXEC Add100K;

USE tempdb;
SELECT * FROM sys.dm_db_index_physical_stats ( db_id('tempdb'), object_id('Frag'), NULL, NULL, 'DETAILED');

-- Index Defrag

USE tempdb;
ALTER INDEX PK_Frag ON Frag REORGANIZE;
ALTER INDEX ix_col ON Frag REORGANIZE;

USE tempdb;
GO
SELECT * FROM sys.dm_db_index_physical_stats ( db_id('tempdb'), object_id('Frag'), NULL, NULL, 'DETAILED');
GO

-- Index Statistics

USE AdventureWorks2008;
EXEC sp_help 'Person.Contact';
UPDATE STATISTICS Person.Contact;

USE AdventureWorks2008;
EXEC sp_updatestats;

USE tempdb;
ALTER INDEX ALL ON Frag REBUILD WITH (FILLFACTOR = 98);

DROP TABLE Frag;
DROP PROCEDURE Add100K;

---------------------------------
-- Database File Sizes

-- Monitoring File Space Usage
USE AdventureWorks2008;
SELECT name, size, max_size from sys.database_files;

USE AdventureWorks2008;
DBCC UPDATEUSAGE (AdventureWorks2008); 
EXEC sp_spaceused;

DBCC SQLPERF (LOGSPACE);

EXEC master..xp_fixeddrives;

-- Shrinking the Database
DBCC SHRINKDATABASE ('AdventureWorks2008', 10);

-- Shrinking the Transaction Log
USE AdventureWorks2008;
CREATE TABLE Test(Col1 int);
BEGIN TRAN;
INSERT INTO Test VALUES (1);
DBCC OPENTRAN;

ROLLBACK TRAN;
DROP TABLE Test;

DBCC OPENTRAN;