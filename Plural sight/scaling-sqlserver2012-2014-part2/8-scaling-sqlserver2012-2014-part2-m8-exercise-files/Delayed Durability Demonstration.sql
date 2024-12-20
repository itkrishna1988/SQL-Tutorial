-- Delayed Durability Demonstration
-- Glenn Berry
-- SQLskills


-- Get delayed durability setting for all databases on instance
SELECT db.[name] AS [Database Name], db.recovery_model_desc AS [Recovery Model], 
       db.delayed_durability_desc     
FROM sys.databases AS db;

-- This is the default\legacy setting. All transactions are fully durable
ALTER DATABASE [DelayedDurabilityTest] SET DELAYED_DURABILITY = DISABLED;

-- Any individual transaction can use Delayed Durability, controlled at the transaction level
ALTER DATABASE [DelayedDurabilityTest] SET DELAYED_DURABILITY = ALLOWED;

-- All transactions use Delayed Durability. Transaction-level setting is ignored
ALTER DATABASE [DelayedDurabilityTest] SET DELAYED_DURABILITY = FORCED;


-- Committing an explicit transaction in T-SQL with Delayed Durability
COMMIT TRANSACTION WITH (DELAYED_DURABILITY = ON);


-- Flushes the transaction log of the current database to disk, 
-- which hardens all previously committed delayed durable transactions
-- Running this command periodically (every x or xx seconds) will reduce the amount of possible data loss
EXEC sys.sp_flush_log;


-- Control Transaction Durability
-- https://msdn.microsoft.com/en-us/library/dn449490(v=sql.120).aspx

-- Delayed Durability in SQL Server 2014
-- http://sqlperformance.com/2014/04/io-subsystem/delayed-durability-in-sql-server-2014

-- Delayed Durability in SQL Server 2014
-- http://www.sqlskills.com/blogs/paul/delayed-durability-sql-server-2014/



USE [master];
GO

-- Drop database if it exists
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'DelayedDurabilityTest')
	ALTER DATABASE [DelayedDurabilityTest] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [DelayedDurabilityTest];
GO

-- Create database if it does not exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'DelayedDurabilityTest')
	BEGIN
		CREATE DATABASE [DelayedDurabilityTest] CONTAINMENT = NONE
		ON  PRIMARY (NAME = N'DelayedDurabilityTest', FILENAME = N'C:\SQLData\DelayedDurabilityTest.mdf', 
		SIZE = 1000MB, FILEGROWTH = 1000MB)
		LOG ON (NAME = N'DelayedDurabilityTest_log', FILENAME = N'L:\SQLLogs\DelayedDurabilityTest.ldf', 
		SIZE = 100MB, FILEGROWTH = 1000MB)
	END;
GO



USE DelayedDurabilityTest;
GO

CREATE TABLE dbo.TestData
	(TestDataID int IDENTITY(1,1) NOT NULL,
	TestDataDescription varchar(20) NOT NULL,
	TestDataCounter int NOT NULL, CONSTRAINT [PK_TestData] PRIMARY KEY CLUSTERED (TestDataID ASC) 
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY];
GO

-- All transactions are fully durable
ALTER DATABASE [DelayedDurabilityTest] SET DELAYED_DURABILITY = DISABLED;

-- All transactions use Delayed Durability
ALTER DATABASE [DelayedDurabilityTest] SET DELAYED_DURABILITY = FORCED;
 
	-- Test Run ***************************************************

	-- Clear wait statistics
	DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);	

	SET NOCOUNT ON;
	DECLARE @CurrentIteration int = 0;
	DECLARE @StartTime datetime = GETDATE();
 
	WHILE (@CurrentIteration < 500000)
		BEGIN
			INSERT INTO dbo.TestData (TestDataDescription, TestDataCounter)
			VALUES('Insert Test', @CurrentIteration);
			SET @CurrentIteration += 1;
		END
 

	DECLARE @EndTime datetime = GETDATE();
	DECLARE @ElapsedTime int = DATEDIFF(ms, @StartTime, @EndTime);
	
	SELECT @ElapsedTime AS [Elapsed Time in ms];

	-- 30296ms Fully Durable, 500059 writes to transaction log,  247.27MB written to transaction log
	-- 6590ms  Delayed Durable, 14628 writes to transaction log, 176.27MB written to transaction log

	-- Get wait statistics
	WITH [Waits] 
	AS (SELECT wait_type, wait_time_ms/ 1000.0 AS [WaitS],
			  (wait_time_ms - signal_wait_time_ms) / 1000.0 AS [ResourceS],
			   signal_wait_time_ms / 1000.0 AS [SignalS],
			   waiting_tasks_count AS [WaitCount],
			   100.0 *  wait_time_ms / SUM (wait_time_ms) OVER() AS [Percentage],
			   ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS [RowNum]
		FROM sys.dm_os_wait_stats WITH (NOLOCK)
		WHERE [wait_type] NOT IN (
			N'BROKER_EVENTHANDLER', N'BROKER_RECEIVE_WAITFOR', N'BROKER_TASK_STOP',
			N'BROKER_TO_FLUSH', N'BROKER_TRANSMITTER', N'CHECKPOINT_QUEUE',
			N'CHKPT', N'CLR_AUTO_EVENT', N'CLR_MANUAL_EVENT', N'CLR_SEMAPHORE',
			N'DBMIRROR_DBM_EVENT', N'DBMIRROR_EVENTS_QUEUE', N'DBMIRROR_WORKER_QUEUE',
			N'DBMIRRORING_CMD', N'DIRTY_PAGE_POLL', N'DISPATCHER_QUEUE_SEMAPHORE',
			N'EXECSYNC', N'FSAGENT', N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'FT_IFTSHC_MUTEX',
			N'HADR_CLUSAPI_CALL', N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', N'HADR_LOGCAPTURE_WAIT', 
			N'HADR_NOTIFICATION_DEQUEUE', N'HADR_TIMER_TASK', N'HADR_WORK_QUEUE',
			N'KSOURCE_WAKEUP', N'LAZYWRITER_SLEEP', N'LOGMGR_QUEUE', N'ONDEMAND_TASK_QUEUE',
			N'PWAIT_ALL_COMPONENTS_INITIALIZED', 
			N'PREEMPTIVE_OS_AUTHENTICATIONOPS', N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
			N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', N'QDS_SHUTDOWN_QUEUE', 
			N'REQUEST_FOR_DEADLOCK_SEARCH',
			N'RESOURCE_QUEUE', N'SERVER_IDLE_CHECK', N'SLEEP_BPOOL_FLUSH', N'SLEEP_DBSTARTUP',
			N'SLEEP_DCOMSTARTUP', N'SLEEP_MASTERDBREADY', N'SLEEP_MASTERMDREADY',
			N'SLEEP_MASTERUPGRADED', N'SLEEP_MSDBSTARTUP', N'SLEEP_SYSTEMTASK', N'SLEEP_TASK',
			N'SLEEP_TEMPDBSTARTUP', N'SNI_HTTP_ACCEPT', N'SP_SERVER_DIAGNOSTICS_SLEEP',
			N'SQLTRACE_BUFFER_FLUSH', N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', N'SQLTRACE_WAIT_ENTRIES',
			N'WAIT_FOR_RESULTS', N'WAITFOR', N'WAITFOR_TASKSHUTDOWN', N'WAIT_XTP_HOST_WAIT',
			N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', N'WAIT_XTP_CKPT_CLOSE', N'XE_DISPATCHER_JOIN',
			N'XE_DISPATCHER_WAIT', N'XE_TIMER_EVENT')
		AND waiting_tasks_count > 0)
	SELECT
		MAX (W1.wait_type) AS [WaitType],
		CAST (MAX (W1.WaitS) AS DECIMAL (16,2)) AS [Wait_Sec],
		CAST (MAX (W1.ResourceS) AS DECIMAL (16,2)) AS [Resource_Sec],
		CAST (MAX (W1.SignalS) AS DECIMAL (16,2)) AS [Signal_Sec],
		MAX (W1.WaitCount) AS [Wait Count],
		CAST (MAX (W1.Percentage) AS DECIMAL (5,2)) AS [Wait Percentage],
		CAST ((MAX (W1.WaitS) / MAX (W1.WaitCount)) AS DECIMAL (16,4)) AS [AvgWait_Sec],
		CAST ((MAX (W1.ResourceS) / MAX (W1.WaitCount)) AS DECIMAL (16,4)) AS [AvgRes_Sec],
		CAST ((MAX (W1.SignalS) / MAX (W1.WaitCount)) AS DECIMAL (16,4)) AS [AvgSig_Sec]
	FROM Waits AS W1
	INNER JOIN Waits AS W2
	ON W2.RowNum <= W1.RowNum
	GROUP BY W1.RowNum
	HAVING SUM (W2.Percentage) - MAX (W1.Percentage) < 99 -- percentage threshold
	OPTION (RECOMPILE);


	-- I/O Statistics by file for the current database  
	SELECT DB_NAME(DB_ID()) AS [Database Name], df.physical_name AS [Physical Name], 
	vfs.num_of_reads, vfs.num_of_writes, 
	CAST(vfs.num_of_bytes_read/1048576.0 AS DECIMAL(10, 2)) AS [MB Read], 
	CAST(vfs.num_of_bytes_written/1048576.0 AS DECIMAL(10, 2)) AS [MB Written]
	FROM sys.dm_io_virtual_file_stats(DB_ID(), NULL) AS vfs
	INNER JOIN sys.database_files AS df WITH (NOLOCK)
	ON vfs.[file_id]= df.[file_id] OPTION (RECOMPILE);


