
-- Key database properties for all databases on instance
SELECT db.[name] AS [Database Name], db.recovery_model_desc AS [Recovery Model], db.containment_desc,
db.[compatibility_level] AS [DB Compatibility Level], db.page_verify_option_desc, 
db.is_auto_create_stats_on, db.is_auto_update_stats_on, db.is_auto_update_stats_async_on, 
db.is_auto_create_stats_incremental_on, db.is_parameterization_forced, 
db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on, 
db.is_auto_close_on, db.is_auto_shrink_on, db.target_recovery_time_in_seconds, db.is_cdc_enabled, 
db.is_published, db.group_database_id, db.replica_id,
db.is_memory_optimized_elevate_to_snapshot_on, db.delayed_durability_desc     
FROM sys.databases AS db WITH (NOLOCK);