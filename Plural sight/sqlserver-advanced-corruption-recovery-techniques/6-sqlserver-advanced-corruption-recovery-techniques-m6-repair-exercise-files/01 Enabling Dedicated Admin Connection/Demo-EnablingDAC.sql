-- Demo script for Enabling DAC demo.

-- Can I access hidden system tables?
SELECT * FROM sys.sysrscols;
GO

-- Try connecting to the DAC...

-- Enabling the SQL Browser, and try again...

-- Test by querying a hidden system table
SELECT * FROM sys.sysrscols;
GO

-- Disconnect from the DAC when done
