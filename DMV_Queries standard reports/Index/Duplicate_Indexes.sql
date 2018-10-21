use OneC_TestingPMO
go
;with ind as (
    select  a.object_id
    ,       a.index_id
    ,       cast(col_list.list as varchar(max)) as list
    ,       isnull(cast(included_col_list.included_list as varchar(8000)),'') as included_list
    from    (
            select  distinct object_id
            ,       index_id
            from    sys.index_columns
            ) a
    cross apply
            (
            select  cast(col.name as varchar(100)) + ',' as [text()]
            from    sys.index_columns b
            inner join sys.columns col on
            b.column_id = col.column_id
            and b.object_id = col.object_id
            where   a.object_id = b.object_id
                    and a.index_id = b.index_id
                    and b.is_included_column = 0
            for xml path(''), type
            ) col_list (list)
     cross apply
            (
            select  cast(col.name as varchar(100)) + ',' as [text()]
            from    sys.index_columns c
            inner join sys.columns col on
            c.column_id = col.column_id
            and c.object_id = col.object_id
            where   a.object_id = c.object_id
                    and a.index_id = c.index_id
                    and c.is_included_column = 1
            for xml path(''), type
            ) included_col_list (included_list)       
)

select * from 

(select  object_name(a.object_id) as TableName
,asi.name as Index1, bsi.name as Index2,
a.list as IndexKeys1, b.list as IndexKeys2, 
a.included_list as IncludedKeys1, b.included_list as IncludedKeys2
from    ind a
join    sys.sysindexes asi
on      asi.id = a.object_id
        and asi.indid = a.index_id
join    ind b
on      a.object_id = b.object_id
       -- and (len(a.list) > len(b.list) or a.list = b.list)
        --and a.list = b.list
        and left(a.list, LEN(b.list)) = b.list
join    sys.sysindexes bsi
on      bsi.id = b.object_id
        and bsi.indid = b.index_id
        
 where object_name(a.object_id) not like 'sys%'
 and asi.name <> bsi.name
 and object_name(a.object_id) like '%dashboard%') a
 
 
 ORDER BY a.TableName, a.Index1