-- Set up the demo by running the code in the
-- C:\Pluralsight\SetupWorkload.sql file

-- Now start the workload by double-clicking the
-- file C:\Pluralsight\Add50Clients.cmd

WITH [Waits] AS
	(SELECT
		[wait_type],
		[wait_time_ms] / 1000.0 AS [WaitS],
		([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
		[signal_wait_time_ms] / 1000.0 AS [SignalS],
		[waiting_tasks_count] AS [WaitCount],
		100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
		ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
	FROM sys.dm_os_wait_stats
	WHERE [wait_type] NOT IN (
		N'CLR_SEMAPHORE',    N'LAZYWRITER_SLEEP',
		N'RESOURCE_QUEUE',   N'SQLTRACE_BUFFER_FLUSH',
		N'SLEEP_TASK',       N'SLEEP_SYSTEMTASK',
		N'WAITFOR',          N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
		N'CHECKPOINT_QUEUE', N'REQUEST_FOR_DEADLOCK_SEARCH',
		N'XE_TIMER_EVENT',   N'XE_DISPATCHER_JOIN',
		N'LOGMGR_QUEUE',     N'FT_IFTS_SCHEDULER_IDLE_WAIT',
		N'BROKER_TASK_STOP', N'CLR_MANUAL_EVENT',
		N'CLR_AUTO_EVENT',   N'DISPATCHER_QUEUE_SEMAPHORE',
		N'TRACEWRITE',       N'XE_DISPATCHER_WAIT',
		N'BROKER_TO_FLUSH',  N'BROKER_EVENTHANDLER',
		N'FT_IFTSHC_MUTEX',  N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
		N'DIRTY_PAGE_POLL')
	)
SELECT
	[W1].[wait_type] AS [WaitType], 
	CAST ([W1].[WaitS] AS DECIMAL(14, 2)) AS [Wait_S],
	CAST ([W1].[ResourceS] AS DECIMAL(14, 2)) AS [Resource_S],
	CAST ([W1].[SignalS] AS DECIMAL(14, 2)) AS [Signal_S],
	[W1].[WaitCount] AS [WaitCount],
	CAST ([W1].[Percentage] AS DECIMAL(4, 2)) AS [Percentage],
	CAST (([W1].[WaitS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgWait_S],
	CAST (([W1].[ResourceS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgRes_S],
	CAST (([W1].[SignalS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgSig_S]
FROM [Waits] AS [W1]
INNER JOIN [Waits] AS [W2]
	ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum], [W1].[wait_type], [W1].[WaitS], 
	[W1].[ResourceS], [W1].[SignalS], [W1].[WaitCount], [W1].[Percentage]
HAVING SUM ([W2].[Percentage]) - [W1].[Percentage] < 95; -- percentage threshold
GO

-- Now stop the workload by double-clicking the
-- file C:\Pluralsight\StopWorkload.cmd

-- Now follow the instructions in ClearingWaits2.sql