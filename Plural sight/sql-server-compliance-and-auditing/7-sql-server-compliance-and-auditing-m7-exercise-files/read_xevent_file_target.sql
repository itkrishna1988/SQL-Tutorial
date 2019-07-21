
WITH event_cte
AS (SELECT CAST(event_data AS XML) AS event_data
    FROM sys.fn_xe_file_target_read_file(	
	'D:\Compliance\<your file here>.xel',
    DEFAULT, 
	DEFAULT,
    DEFAULT)
    )
INSERT INTO user_decrypt_log (sql_statement,username,dbname,systemtime)
SELECT  sql_statement = event_data.value(N'(event/data[@name="statement"]/value)[1]', N'nvarchar(max)') ,
	username = event_data.value(N'(event/action[@name="username"]/value)[1]', N'nvarchar(30)') ,
	dbname = event_data.value(N'(event/action[@name="database_name"]/value)[1]', N'nvarchar(30)') ,
	systemtime = event_data.value(N'(event/action[@name="collect_system_time"]/value)[1]', N'datetime')
FROM    event_cte;