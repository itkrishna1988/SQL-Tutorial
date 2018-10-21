use OneC_TestingPMO
go
SELECT a.index_id, 
       b.name,
       a.user_seeks,
       a.user_scans,
       a.user_lookups,
       a.user_updates,
       a.last_user_seek,
       a.last_user_scan,
       a.last_user_lookup,
       a.last_user_update,
       ((ps.used_page_count*8)/1024) AS 'Used (MB)',
       object_name (a.object_id)
FROM   sys.dm_db_index_usage_stats a
       INNER JOIN sys.indexes b
         ON a.object_id = b.object_id
            AND a.index_id = b.index_id
       INNER JOIN sys.dm_db_partition_stats ps
         ON ps.object_id = a.object_id
            AND ps.index_id = a.index_id
WHERE  a.database_id = db_id()
ORDER BY a.index_id;

GO


select i.index_id,
         i.name, 
         ios.range_scan_count,
         ios.singleton_lookup_count,
         ios.row_lock_count,
         ios.row_lock_wait_count,
         ios.row_lock_wait_in_ms,
         ios.page_lock_count,
         ios.page_lock_wait_count,
         ios.page_lock_wait_in_ms,
         ios.index_lock_promotion_attempt_count,
         ios.index_lock_promotion_count,
         ios.leaf_insert_count,
         ios.leaf_delete_count,
         ios.leaf_update_count,
         ios.leaf_ghost_count
from   sys.dm_db_index_operational_stats (
                  db_id(), 
                  NULL, 
                  NULL, 
                  NULL) ios
         inner join sys.indexes i
           on i.index_id = ios.index_id
              and i.object_id = ios.object_id
order by ios.index_id;
