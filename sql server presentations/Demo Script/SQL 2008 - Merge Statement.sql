Use Tempdb
go
Drop table MergeTarget
go
Drop table MergeSource
go
Create table MergeTarget (Col1 Int, Name varchar(30), Address varchar(100))
go
Create table MergeSource (Col1 Int, Name varchar(30), Address varchar(100))
go
--I have target tables with rows as follows :-

Insert MergeTarget select 1,'Madhu','Chennai' -- To be updated
Insert MergeTarget select 2,'Mike','delhi'		-- Dont do anything
Insert MergeTarget select 4,'aaa','bangalore' -- Delete

--And the source table rows are as follows :-

Insert MergeSource select 1,'Madhu','Hyderabad' -- Update
Insert MergeSource select 2,'Mike','delhi' -- no change
Insert MergeSource select 3,'Ram','bangalore' -- Insert

select *from MergeTarget
select *from MergeSource

--Points to be noted

--(a) Source table have new address value for ‘Madhu’. Which needs to be updated (only address column). Ie. Row exists but different data
--(b) Source table have a new row col1=4 and name=’aaa’ which needs to be inserted to target
--© Target table have an extra row (col1=3 and name=’Ram’) which is not there in the Source , which needs to be deleted from target.



  
 Merge Mergetarget T USING MergeSource S 
On T.Col1=S.COl1 

WHEN MATCHED AND S.Address IS NOT NULL THEN UPDATE SET T.Address=S.Address
WHEN NOT MATCHED THEN INSERT VALUES (COL1,NAME,ADDREss) 
WHEN NOT MATCHED BY SOURCE  THEN DELETE ; 

--What I learnt here

--(a) Merge works only with single target table. 

--(b) You need terminate merge statement with semi-colon (;)
--Msg 10713, Level 15, State 1, Line 6
--A MERGE statement must be terminated by a semi-colon (;).

--(c) Merge Statement will fail when a target row matches more than one source row (Source table have duplicate rows for the given condition). For eg. In my given scenario if I have two rows for col1=3 in Source table the merge statement will fail with the following error message :-

--Msg 8672, Level 16, State 1, Line 2
--The MERGE statement attempted to UPDATE or DELETE the same row more than once. This happens when a target row matches more than one source row. A MERGE statement cannot UPDATE/DELETE the same row of the target table multiple times. Refine the ON clause to ensure a target row matches at most one source row, or use the GROUP BY clause to group the source rows.


-- with OUTPUT clause

--  OUTPUT Clause with MERGE Statement

--The OUTPUT clause (which was introduced in SQL 2005 in conjunction with Merge is very powerful. You can get which action and fired and what is the value. 



Merge Mergetarget T USING MergeSource S 
On T.Col1=S.COl1 

WHEN MATCHED AND S.Address IS NOT NULL THEN UPDATE SET T.Address=S.Address
WHEN NOT MATCHED THEN INSERT VALUES (COL1,NAME,ADDREss) 
WHEN NOT MATCHED BY SOURCE  THEN DELETE  
OUTPUT $action-- Pseudo column
, Inserted.Col1,deleted.col1; 



--Source replaced with a Query ( It can be Query / Table / View)


MERGE
Mergetarget T 
USING 
( SELECT 1 as Col1,'Madhu' As Name ,'Hyderabad' as Address
UNION
SELECT 2,'Mike','delhi'
UNION
SELECT 3,'Ram','bangalore' ) S 

On T.Col1=S.COl1 

WHEN MATCHED AND S.Address IS NOT NULL THEN UPDATE SET T.Address=S.Address
WHEN NOT MATCHED THEN INSERT VALUES (COL1,NAME,ADDREss) 
WHEN NOT MATCHED BY SOURCE  THEN DELETE 

OUTPUT $Action, Inserted.Col1,deleted.col1,inserted.address; 


 