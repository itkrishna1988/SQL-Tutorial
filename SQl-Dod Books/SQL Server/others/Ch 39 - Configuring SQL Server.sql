
-----------------------------------------------------------
-- SQL Server 2008 Bible 
-- Wiley Publishing 
-- Uttam Parui

-- Chapter 39 - Configuring SQL Server

---------------------------------------
-- Server-Level Options

SELECT @@VERSION;

SELECT
SERVERPROPERTY('ProductVersion') AS ProductVersion,
SERVERPROPERTY('ProductLevel') AS ProductLevel,
SERVERPROPERTY('Edition') AS Edition;

EXEC sp_configure;

EXEC xp_msver;

---------------------------------------
-- Database-Level Options

ALTER DATABASE AdventureWorks2008 SET SINGLE_USER;

SELECT * FROM sys.databases WHERE name = 'AdventureWorks2008';

---------------------------------------
-- Connection-Level Options

SET ANSI_NULLS OFF;

SELECT SESSIONPROPERTY ('ANSI_NULLS');

---------------------------------------
-- Displaying Advanced Options
SELECT   name, minimum, maximum, value, value_in_use
FROM     sys.configurations
WHERE    is_advanced = 1
ORDER BY name;

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure;

---------------------------------------
-- StartUp Stored Procedure

EXEC sp_procoption @ProcName = 'ExistingSP', 
              @OptionName = 'startup', 
              @OptionValue = 'on';

EXEC sp_procoption @ProcName = 'ExistingSP', 
              @OptionName = 'startup', 
              @OptionValue = 'off';

EXEC sp_configure 'scan for startup procs', 0;
RECONFIGURE;

---------------------------------------
-- Memory Configuration

-- Dynamic Memory
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'min server memory', 1024;
RECONFIGURE;

EXEC sp_configure 'max server memory', 4096;
RECONFIGURE;

-- Fixed Memory
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'min server memory', 6144;
RECONFIGURE;
EXEC sp_configure 'max server memory', 6144;
RECONFIGURE;

-- Minimum Query Memory
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'min memory per query', 2048;
RECONFIGURE;

-- Query Wait

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'query wait', 20;
RECONFIGURE;

-- AWE Enabled
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'awe enabled', 1;
RECONFIGURE;

-- Index Create Memory
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'index create memory', 8096;
RECONFIGURE;

---------------------------------------
-- Processor Properties

-- Processor Affinity
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'affinity mask', 15;
RECONFIGURE;
EXEC sp_configure 'affinity I/O mask', 48;
RECONFIGURE;

-- Max Worker Threads
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'max worker threads', 128;
RECONFIGURE;

-- Priority Boost
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'priority boost', 1;
RECONFIGURE;

-- Lightweight Pooling
EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'lightweight pooling', 1;
RECONFIGURE;

-- Parallelism
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'max degree of parallelism', 4;
RECONFIGURE;

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'cost threshold for parallelism', 30;
RECONFIGURE;

---------------------------------------
-- Security Properties

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'c2 audit mode', 1;
RECONFIGURE;

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'common criteria compliance enabled', 1;
RECONFIGURE;

EXEC sp_configure 'cross db ownership chaining', 1;
RECONFIGURE;

---------------------------------------
-- Connection Properties

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
GO
EXEC sp_configure 'user connections', 10240;
RECONFIGURE;

SELECT @@MAX_CONNECTIONS;

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'query governor cost limit', 300;
RECONFIGURE;

SET QUERY_GOVERNOR_COST_LIMIT 15; 

EXEC sp_configure 'remote access', 0;
RECONFIGURE;

EXEC sp_configure 'remote login timeout', 30;
RECONFIGURE;

EXEC sp_configure 'remote query timeout', 600;
RECONFIGURE;

EXEC sp_configure 'remote proc trans', 1;
RECONFIGURE;

EXEC sp_configure 'network packet size', 2048;
RECONFIGURE;

---------------------------------------
-- Advanced Server Configuration Properties

EXEC sp_configure 'filestream_access_level', 2;
RECONFIGURE;

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'EKM provider enabled', 1;
RECONFIGURE;

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'default full-text language', 1033;
RECONFIGURE;

EXEC sp_configure 'default language', 23;
RECONFIGURE;

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'two digit year cutoff', 2041;
RECONFIGURE;

EXEC sp_configure 'max text repl size', 131072;
RECONFIGURE;

-------------------------------
-- Database Auto Settings

ALTER DATABASE AdventureWorks2008 SET AUTO_CLOSE ON;

ALTER DATABASE AdventureWorks2008 SET AUTO_SHRINK OFF;

ALTER DATABASE AdventureWorks2008 SET AUTO_CREATE_STATISTICS ON;

ALTER DATABASE AdventureWorks2008 SET AUTO_UPDATE_STATISTICS ON;

ALTER DATABASE AdventureWorks2008 SET AUTO_UPDATE_STATISTICS_ASYNC ON;

-------------------------------
-- Cursor Settings

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'cursor threshold', 10000;
RECONFIGURE;

-- Cursor Close On Commit

EXEC sp_configure 'user options', 4;
RECONFIGURE;

ALTER DATABASE AdventureWorks2008 SET CURSOR_CLOSE_ON_COMMIT ON;

SET CURSOR_CLOSE_ON_COMMIT ON; 

-- Cursor Default

ALTER DATABASE AdventureWorks2008 SET CURSOR_DEFAULT LOCAL;

-------------------------------
-- ANSI Settings

-- ANSI Defaults
SET ANSI_DEFAULTS ON;

-- ANSI Null Default
ALTER DATABASE AdventureWorks2008 SET ANSI_NULL_DEFAULT ON;

SET ANSI_NULL_DFLT_ON ON;

SET ANSI_NULL_DFLT_OFF ON;

EXEC sp_configure 'user options', 1024;
RECONFIGURE;

EXEC sp_configure 'user options', 2048;
RECONFIGURE;

-- ANSI Nulls
SET ANSI_NULLS ON;

ALTER DATABASE AdventureWorks2008 SET ANSI_NULLS ON;

EXEC sp_configure 'user options', 32;
RECONFIGURE;

-- ANSI Padding
SET ANSI_PADDING ON;

ALTER DATABASE AdventureWorks2008 SET ANSI_PADDING ON;

EXEC sp_configure 'user options', 16;
RECONFIGURE;

-- ANSI Warnings
SET ANSI_WARNINGS ON;

ALTER DATABASE AdventureWorks2008 SET ANSI_WARNINGS ON;

EXEC sp_configure 'user options', 8;
RECONFIGURE;

-- Arithmetic Abort
SET ARITHABORT ON;

ALTER DATABASE AdventureWorks2008 SET ARITHABORT ON;

EXEC sp_configure 'user options', 64;
RECONFIGURE;

-- Arithmetic Ignore
SET ARITHIGNORE ON;

EXEC sp_configure 'user options', 128;
RECONFIGURE;

-- Numeric Round Abort
SET NUMERIC_ROUNDABORT ON;

ALTER DATABASE AdventureWorks2008 SET NUMERIC_ROUNDABORT ON;

EXEC sp_configure 'user options', 8192;
RECONFIGURE;

-- Concatenation Null Yields
SET CONCAT_NULL_YIELDS_NULL ON;

ALTER DATABASE AdventureWorks2008 SET CONCAT_NULL_YIELDS_NULL ON;

EXEC sp_configure 'user options', 4096;
RECONFIGURE;

-- Use Quoted Identifier
SET QUOTED_IDENTIFIER ON;

ALTER DATABASE AdventureWorks2008 SET QUOTED_IDENTIFIER ON;

EXEC sp_configure 'user options', 256;
RECONFIGURE;

-------------------------------
-- Trigger Configuration Settings
EXEC sp_configure 'nested triggers', 0;
RECONFIGURE;

ALTER DATABASE AdventureWorks2008 SET RECURSIVE_TRIGGERS ON;

-------------------------------
-- Database Configuration Settings

ALTER DATABASE AdventureWorks2008 SET OFFLINE;

ALTER DATABASE AdventureWorks2008 SET ONLINE;

ALTER DATABASE AdventureWorks2008 SET EMERGENCY;

ALTER DATABASE AdventureWorks2008 SET READ_ONLY;

ALTER DATABASE AdventureWorks2008 SET SINGLE_USER;

ALTER DATABASE AdventureWorks2008 SET MULTI_USER;

ALTER DATABASE AdventureWorks2008 SET COMPATIBILITY_LEVEL = 100;

-------------------------------
-- Recovery Configuration Properties

ALTER DATABASE AdventureWorks2008 SET RECOVERY BULK_LOGGED;

ALTER DATABASE AdventureWorks2008 SET PAGE_VERIFY TORN_PAGE_DETECTION;

EXEC sp_configure 'show advanced options', 1;  
RECONFIGURE; 
EXEC sp_configure 'media retention', 10;
RECONFIGURE;

EXEC sp_configure 'backup compression default', 1
RECONFIGURE

EXEC sp_configure 'show advanced options', '1';  
RECONFIGURE; 
EXEC sp_configure 'recovery interval', 5;
RECONFIGURE;