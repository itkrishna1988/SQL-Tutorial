
CREATE EVENT SESSION [compliance] ON SERVER

ADD EVENT sqlserver.sql_statement_completed
(SET collect_statement=(1)
	ACTION(package0.collect_system_time,
		   sqlserver.[database_name],
		   sqlserver.[username])
	WHERE ([sqlserver].[like_i_sql_unicode_string]
	([sqlserver].[sql_text],N'%cc_decrypt%'))) 

ADD TARGET package0.event_file(
	SET filename=N'D:\Compliance\compliance.xel',
    max_file_size=(5),
	max_rollover_files=(10))

WITH (startup_state=ON)
GO

ALTER EVENT SESSION [compliance]
ON SERVER STATE = start;
GO