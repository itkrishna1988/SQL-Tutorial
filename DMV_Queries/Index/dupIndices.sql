SELECT 
      Distinct DB_NAME(DB_ID()) DatabaseName,
      TableName,
      Indexname,
      SUBSTRING(Column_List, 3, LEN(Column_List)) Column_List ,
      Unique_Type,
      PrimaryKey,
      UniqueConstraint,
      [Disabled] into #DupIndices
FROM
(
      SELECT 
      OBJECT_NAME(I.OBJECT_ID) TableName,
      i.name as Indexname,
      i.type_desc as Index_Type,
      CASE WHEN is_unique = 1 then 'Unique' ELSE 'Non Unique' END as Unique_Type,
      CASE WHEN is_primary_key = 1 then 'Yes' ELSE 'No' END as PrimaryKey,
      CASE WHEN is_unique_constraint = 1 then 'Yes' ELSE 'No' END as UniqueConstraint,
      CASE WHEN is_disabled = 1 THEN 'Yes' ELSE 'No' End as [Disabled],
      (
            SELECT 
            ' ,[' + C.NAME + CASE WHEN IC_S.is_descending_key = 0 THEN ' ASC ' ELSE ' DESC ' END + '] ' 
            FROM  SYS.COLUMNS C
            JOIN SYS.INDEX_COLUMNS IC_S
            ON C.COLUMN_ID = IC_S.COLUMN_ID
            AND C.OBJECT_ID = IC_S.OBJECT_ID
            AND IC_S.is_included_column = 0
            WHERE IC_S.OBJECT_ID = IC.OBJECT_ID
            AND IC_S.index_id = IC.index_id 
            FOR XML PATH('')
      )Column_List
      FROM sys.indexes I
      JOIN sys.index_columns IC
      ON I.OBJECT_ID = IC.OBJECT_ID
      AND I.index_id = IC.index_id 
      AND I.INDEX_ID > 0
      AND IC.is_included_column = 0
      JOIN SYS.TABLES T
      on T.OBJECT_ID = I.OBJECT_ID
      AND T.TYPE = 'U'
) Main_Data 
WHERE TableName <> 'sysdiagrams'
ORDER BY TableName, SUBSTRING(Column_List, 3, LEN(Column_List))


select TableName, Column_List, COUNT(*) from #DupIndices
group by TableName, Column_List
having COUNT(*) > 1


drop table #DupIndices