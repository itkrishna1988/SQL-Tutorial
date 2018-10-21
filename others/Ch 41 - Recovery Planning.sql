-----------------------------------------------------------
-- SQL Server 2008 Bible 
-- Wiley Publishing 
-- Uttam Parui

-- Chapter 41 - Recovery Planning

-----------------------------------------------------------
-----------------------------------------------------------

-- Setting Recovery Model
USE AdventureWorks2008;
ALTER DATABASE AdventureWorks2008 SET Recovery FULL;

SELECT name, recovery_model_desc 
  FROM sys.databases;

-- Backup Database
BACKUP DATABASE AdventureWorks2008
  TO DISK = 'e:\AdventureWorks2008Backup.bak'
  WITH 
    NAME = 'AdventureWorks2008Backup';

-- Differential Backup
BACKUP DATABASE AdventureWorks2008
  TO DISK = 'e:\AdventureWorks2008Backup.bak'
  WITH 
    DIFFERENTIAL,
    NAME = 'AdventureWorks2008Backup';

-- Verify Backup
RESTORE VERIFYONLY  
  FROM DISK =  'e:\AdventureWorks2008Backup.bak'

-- Backup Transaction Log
BACKUP LOG AdventureWorks2008
  TO DISK = 'e:\AdventureWorks2008Backup.bak'
  WITH 
    NAME = 'AdventureWorks2008Backup';

BACKUP LOG Databasename
  TO DISK = 'file location'
  WITH NO_TRUNCATE;


-- BackUp and recovery example

CREATE DATABASE Plan2Recover;

USE Plan2Recover;

CREATE TABLE T1 (
  PK INT Identity PRIMARY KEY,
  Name VARCHAR(15)
  );
Go
INSERT T1 VALUES ('Full');
go
BACKUP DATABASE Plan2Recover
  TO DISK = 'e:\P2R.bak'
  WITH 
    NAME = 'P2R_Full',
    INIT;

INSERT T1 VALUES ('Log 1');
go
BACKUP Log Plan2Recover
  TO DISK = 'e:\P2R.bak'
  WITH 
    NAME = 'P2R_Log';

INSERT T1 VALUES ('Log 2');
go
BACKUP Log Plan2Recover
  TO DISK = 'e:\P2R.bak'
  WITH 
    NAME = 'P2R_Log';

SELECT * FROM T1;

Use Master;
RESTORE DATABASE Plan2Recover
  FROM DISK = 'e:\P2R.bak'
  With FILE = 1, NORECOVERY;

RESTORE LOG Plan2Recover
  FROM DISK = 'e:\P2R.bak'
  With FILE = 2, NORECOVERY;

RESTORE LOG Plan2Recover
  FROM DISK = 'e:\P2R.bak'
  With FILE = 3, RECOVERY;

USE Plan2Recover;
Select * from T1;

USE Master;
DROP DATABASE Plan2Recover;