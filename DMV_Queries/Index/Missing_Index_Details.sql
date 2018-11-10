/* Query to identify missing index details and user impact */
use OneC_TestingPMO
go

select sysd.name,sysddmig.*,sysddmid.statement as table_name,sysddmic.column_id,sysddmic.column_name,sysddmic.column_usage,
sysddmigs.user_seeks,sysddmigs.avg_total_user_cost,sysddmigs.avg_user_impact 
from sys.dm_db_missing_index_details as sysddmid 
cross apply sys.dm_db_missing_index_columns (sysddmid.index_handle) sysddmic 
inner join sys.dm_db_missing_index_groups as sysddmig on sysddmig.index_handle = sysddmid.index_handle 
inner join sys.dm_db_missing_index_group_stats as sysddmigs on sysddmig.index_group_handle = sysddmigs.group_handle 
inner join sys.databases as sysd on sysd.database_id = sysddmid.database_id  and sysd.database_id = DB_ID()
order by sysddmigs.avg_user_impact desc,sysddmig.index_group_handle,sysddmig.index_handle,sysddmic.column_id;
