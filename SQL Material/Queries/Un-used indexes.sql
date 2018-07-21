use OneC_TestingPMO
go
SELECT  OBJECT_SCHEMA_NAME(I.OBJECT_ID) AS SchemaName,
        OBJECT_NAME(I.OBJECT_ID) AS ObjectName,
        I.NAME AS IndexName        
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
                            --and OBJECT_NAME(I.OBJECT_ID) like '%FORECAST%' 

and i.name is not null --and i.name like 'index_TestingPMO_Forecast_Commit_Status_Get_Account_Portfolio'

ORDER BY SchemaName, ObjectName, IndexName 


--SELECT  *
--FROM    sys.dm_db_index_usage_stats u
--inner join sys.indexes i on
--u.index_id = i.index_id
--and u.object_id = i.object_id
--where i.name like 'index_TestingPMO_Forecast_Commit_Status_Get_Account_Portfolio'