-- Set instance-level options
-- Glenn Berry, SQLskills.com

-- Get configuration values for instance 
SELECT name, value, value_in_use, [description] 
FROM sys.configurations WITH (NOLOCK)
ORDER BY name OPTION (RECOMPILE);


-- Set Instance-level options to more appropriate values

-- Enable backup checksum default
EXEC sys.sp_configure 'backup checksum default', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO


-- Enable backup compression default
EXEC sys.sp_configure 'backup compression default', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO


-- Change cost threshold for parallelism to a higher value
EXEC sys.sp_configure 'cost threshold for parallelism', 25;
GO
RECONFIGURE WITH OVERRIDE;
GO

-- Set max server memory to 27000MB
EXEC sys.sp_configure 'max server memory (MB)', 27000;
GO
RECONFIGURE WITH OVERRIDE;
GO


-- Change max degree of parallelism to 4 (number of physical cores in a NUMA node)
EXEC sys.sp_configure 'max degree of parallelism', 4;
GO
RECONFIGURE WITH OVERRIDE;
GO


-- Enable optimize for ad hoc workloads
EXEC sys.sp_configure 'optimize for ad hoc workloads', 1;
RECONFIGURE WITH OVERRIDE;
GO


-- Enable remote admin connections
EXEC sys.sp_configure 'remote admin connections', 1;
RECONFIGURE WITH OVERRIDE;
GO










