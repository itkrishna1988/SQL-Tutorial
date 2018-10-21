use OneC_TestingPMO
go
SELECT  OBJECT_SCHEMA_NAME(I.OBJECT_ID) AS SchemaName,
        OBJECT_NAME(I.OBJECT_ID) AS ObjectName,
        I.NAME AS IndexName,
		Case WHEN I.index_id  =1 Then 'Clustered' ELSE 'NonClustered' END IndexType
FROM    sys.indexes I   
WHERE   -- only get indexes for user created tables
        OBJECTPROPERTY(I.OBJECT_ID, 'IsUserTable') = 1 
        -- find all indexes that exists but are NOT used
        AND EXISTS ( 
                    SELECT  index_id 
                    FROM    sys.dm_db_index_usage_stats
                    WHERE   OBJECT_ID = I.OBJECT_ID 
                            AND I.index_id = index_id 
                            -- limit our query only for the current db
                            AND database_id = DB_ID()) 
								and i.name is not null 
ORDER BY SchemaName, ObjectName, IndexName 

