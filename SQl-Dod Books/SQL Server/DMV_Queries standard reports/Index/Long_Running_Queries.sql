use OneC_TestingPMO
go

/* Query to identify long running queries */
select name, last_execution_time, creation_time, total_seconds, average_seconds, execution_count,
Disk_Reads, Memory_Reads, Memory_Writes, CPU_Time
from 
(
SELECT dense_rank() over(partition by o.object_id, convert(date,last_execution_time) order by qs.total_elapsed_time desc) as Rank1, 
o.name, last_execution_time, creation_time, qs.total_elapsed_time / 1000000.0 AS total_seconds, 
qs.total_elapsed_time / qs.execution_count / 1000000.0 AS average_seconds, qs.total_worker_time as CPU_Time, execution_count,
qs.total_physical_reads as Disk_Reads, qs.total_logical_reads as Memory_Reads, qs.max_logical_writes as Memory_Writes
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
inner join sys.objects o on qt.objectid = o.object_id
where qt.dbid = DB_ID() --and last_execution_time >= '3/1/2013'
) a
where Rank1 = 1
order by name, last_execution_time desc


