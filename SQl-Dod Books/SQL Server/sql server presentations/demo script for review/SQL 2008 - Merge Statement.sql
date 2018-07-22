/* to understand the merge statement */

Use Tempdb
go

/*create  target and source tables */
Create table MergeTarget (ID Int, Name varchar(30), Address varchar(100))
go
Create table MergeSource (ID Int, Name varchar(30), Address varchar(100))
go

/* insert values into target table */
Insert MergeTarget select 1,'aaa','Chennai' -- To be updated
Insert MergeTarget select 2,'bbb','delhi'		-- Dont do anything
Insert MergeTarget select 4,'ccc','bangalore' -- Delete

/* insert values into source table */
Insert MergeSource select 1,'aaa','Hyderabad' -- Update
Insert MergeSource select 2,'bbb','delhi' -- no change
Insert MergeSource select 3,'ddd','bangalore' -- Insert

/* to display MergeTarget and MergeSource tables */
select *from MergeTarget;
select *from MergeSource;

--Points to be noted

--(a) Source table have new address value for ‘aaa’. Which needs to be updated (only address column). Ie. Row exists but different data
--(b) Source table have a new row ID=3 and name=’ddd’ which needs to be inserted to target
--(c) Target table have an extra row (ID=4 and name=’ccc’) which is not there in the Source , which needs to be deleted from target.



 /* merge query to update the address column in target table
 to match with the address column in source table for particular ID */
 
Merge Mergetarget T USING MergeSource S 
On T.ID=S.ID 
WHEN MATCHED AND S.Address IS NOT NULL THEN UPDATE SET T.Address=S.Address
WHEN NOT MATCHED THEN INSERT VALUES (ID,NAME,ADDREss) 
WHEN NOT MATCHED BY SOURCE  THEN DELETE ; 

--What I learnt here

--(a) Merge works only with single target table. 

--(b) You need terminate merge statement with semi-colon (;)
--Msg 10713, Level 15, State 1, Line 6
--A MERGE statement must be terminated by a semi-colon (;).

--(c) Merge Statement will fail when a target row matches more than one source row (Source table have duplicate rows for the given condition). For eg. In my given scenario if I have two rows for ID=3 in Source table the merge statement will fail with the following error message :-

--Msg 8672, Level 16, State 1, Line 2
--The MERGE statement attempted to UPDATE or DELETE the same row more than once. This happens when a target row matches more than one source row. A MERGE statement cannot UPDATE/DELETE the same row of the target table multiple times. Refine the ON clause to ensure a target row matches at most one source row, or use the GROUP BY clause to group the source rows.


-- with OUTPUT clause

--  OUTPUT Clause with MERGE Statement

--The OUTPUT clause (which was introduced in SQL 2005 in conjunction with Merge is very powerful. You can get which action and fired and what is the value. 



Merge Mergetarget T USING MergeSource S 
On T.ID=S.ID 
WHEN MATCHED AND S.Address IS NOT NULL THEN UPDATE SET T.Address=S.Address
WHEN NOT MATCHED THEN INSERT VALUES (ID,NAME,ADDREss) 
WHEN NOT MATCHED BY SOURCE  THEN DELETE  
OUTPUT $action-- Pseudo column
, Inserted.ID,deleted.ID; 



--Source replaced with a Query ( It can be Query / Table / View)


MERGE
Mergetarget T 
USING 
( SELECT 1 as ID,'aaa' As Name ,'Hyderabad' as Address
UNION
SELECT 2,'bbb','delhi'
UNION
SELECT 3,'ccc','bangalore' ) S 

On T.ID=S.ID 

WHEN MATCHED AND S.Address IS NOT NULL THEN UPDATE SET T.Address=S.Address
WHEN NOT MATCHED THEN INSERT VALUES (ID,NAME,ADDREss) 
WHEN NOT MATCHED BY SOURCE  THEN DELETE 

OUTPUT $Action, Inserted.ID,deleted.ID,inserted.address; 

/* drop the tables */
Drop table MergeTarget
go
Drop table MergeSource
go
 