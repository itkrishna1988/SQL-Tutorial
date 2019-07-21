
-- Buffer Pool Extensions (BPE) Demonstration
-- Glenn Berry
-- SQLskills

-- Get instance configuration values (unfortunately, BPE configuration is not in sys.configurations)
SELECT name, value, value_in_use, [description]
FROM sys.configurations 
ORDER BY name;


-- See if buffer pool extensions (BPE) is enabled 
SELECT [path], state_description, current_size_in_kb, 
CAST(current_size_in_kb/1048576.0 AS DECIMAL(10,2)) AS [Size (GB)]
FROM sys.dm_os_buffer_pool_extension_configuration;

-- BPE is available in both Standard Edition and Enterprise Edition
-- It is a more interesting feature for Standard Edition

-- Buffer Pool Extension to SSDs in SQL Server 2014
-- http://blogs.technet.com/b/dataplatforminsider/archive/2013/07/25/buffer-pool-extension-to-ssds-in-sql-server-2014.aspx


-- Enable BPE and create 64GB cache file
ALTER SERVER CONFIGURATION
SET BUFFER POOL EXTENSION ON (FILENAME = 'L:\SSDCACHE\BPEFile.BPE', SIZE = 64 GB);

-- Generate some activity that allows SQL Server to use the BPE cache file
-- This can be difficult in a test environment


-- Look at buffer descriptors to see BPE usage by database 
SELECT DB_NAME(database_id) AS [Database Name], COUNT(page_id) AS [Page Count],
CAST(COUNT(*)/128.0 AS DECIMAL(10, 2)) AS [Buffer size(MB)], 
AVG(read_microsec) AS [Avg Read Time (microseconds)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id <> 32767
AND is_in_bpool_extension = 1
GROUP BY DB_NAME(database_id) 
ORDER BY [Buffer size(MB)] DESC;

-- You will see no results if BPE is not enabled or if there is no BPE usage


-- Disable BPE and delete the cache file
ALTER SERVER CONFIGURATION
SET BUFFER POOL EXTENSION OFF;