-----------------------------------------------------------------------
-- Course: SQL Server: Optimizing Stored Procedure Performance - Part 2
-- Module: Special Considerations
--   Demo: Resource Governor and recompilation
-----------------------------------------------------------------------

USE [Credit];
GO

CREATE USER [Kimberly] 
FOR LOGIN [KimberlyTest];
GO

CREATE USER [Paul] 
FOR LOGIN [PaulTest];
GO

-- SETUP
UPDATE [dbo].[member]
    SET [lastname] = 'Tripp'
    WHERE [member_no] = 1234;

UPDATE [dbo].[member]
    SET [lastname] = 'Randal'
    WHERE [lastname] = 'Ryan'; 
GO

CREATE INDEX [MemberLastName]
ON [dbo].[member] ([lastname]);
GO

IF OBJECTPROPERTY(OBJECT_ID(N'dbo.GetMemberInfo'), 'IsProcedure') = 1
    DROP PROCEDURE [dbo].[GetMemberInfo];
GO

CREATE PROCEDURE [dbo].[GetMemberInfo]
(
	@LastName	VARCHAR (30)
)
AS 
SET NOCOUNT ON;
SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] LIKE @LastName;
GO

GRANT EXECUTE ON [dbo].[GetMemberInfo] TO PUBLIC;
GRANT SHOWPLAN TO Kimberly, Paul;
GO

-- Open up the window and run the query for Kimberly

-- Open up another window and run the query for Paul

EXEC [dbo].[ProcedurePlanState] 'dbo', 'GetMemberInfo';
GO