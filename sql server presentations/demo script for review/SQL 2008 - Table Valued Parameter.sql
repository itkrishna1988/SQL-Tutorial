 /* to understand  Table valued parameters */
/* Create a User TABLE Type */

CREATE TYPE TestTableTypeParm AS TABLE (EmpID int primary key,
EmpType varchar(10),
EmpName varchar(50), 
CHECK (EmpType IN ('MNGR', 'CLRK', 'TECH') ))


/* Create stored procedure with a Table type as input parameter */
Create PROCEDURE spTestTableTypeParm

(@TVP TestTableTypeParm READONLY,
@someotherparam int )
As 
Select *From @TVP

/* How to call this stored procedure */

Declare @TVP as TestTableTypeParm
Insert @TVP select 1,'MNGR','aaaa'
Insert @TVP select 2,'CLRK','bbb'
Insert @TVP select 3,'TECH','ccc'
Exec spTestTableTypeParm @TVP,1


/* Create a function with table type input parameter */

CREATE FUNCTION ufn_TestTablevaluedParameter(@TVP TestTableTypeParm READONLY)
RETURNS TABLE
AS
RETURN 
(
select *From @TVP
);
GO

/* How to call function with tabletype input parameter */

Declare @TVP as TestTableTypeParm
Insert @TVP select 1,'MNGR','aaaa'
Insert @TVP select 2,'CLRK','bbb'
Insert @TVP select 3,'TECH','ccc'

Select *From ufn_TestTablevaluedParameter(@TVP)

/* drop procedure and function */
drop PROCEDURE spTestTableTypeParm;

drop FUNCTION ufn_TestTablevaluedParameter

--There are many Limitations mentioned in Books online. These are probably most significant among them

--(a) SQL Server does not maintain statistics on columns of table-valued parameters.

--(b) Table-valued parameters must be passed as input READONLY parameters to Transact-SQL routines. You cannot perform DML operations such as UPDATE, DELETE, or INSERT on a table-valued parameter in the body of a routine.

--(c) You cannot use a table-valued parameter as target of a SELECT INTO or INSERT EXEC statement. A table-valued parameter can be in the FROM clause of SELECT INTO or in the INSERT EXEC string or stored-procedure.

--(d) A user-defined table type cannot be used as a column in a table or a field in a structured user-defined type.

--(e) A DEFAULT value cannot be specified in the definition of a user-defined table type.

--(f) The user-defined table type definition cannot be modified after it is created.

--(g) User-defined functions cannot be called within the definition of computed columns of a user-defined table type.
