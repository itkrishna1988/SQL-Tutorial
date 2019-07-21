
-- You'll want to create a master key for database if you don't already have one

-- Create sample symmetric key of each type
CREATE SYMMETRIC KEY DemoKey256
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY PASSWORD='DrinkYour0valtine';
GO 

CREATE SYMMETRIC KEY DemoKey192
    WITH ALGORITHM = AES_192  
    ENCRYPTION BY PASSWORD='DrinkYour0valtine';  
GO 

CREATE SYMMETRIC KEY DemoKey128
    WITH ALGORITHM = AES_128
    ENCRYPTION BY PASSWORD='DrinkYour0valtine';  
GO 


-- show existing symmetric keys
SELECT * FROM sys.symmetric_keys 
GO


-- show encryption and decryption of secret
OPEN SYMMETRIC KEY DemoKey128
  DECRYPTION BY PASSWORD = 'DrinkYour0valtine'
GO

DECLARE @MySecret VarBinary(max);
SET @MySecret = EncryptByKey(Key_GUID('DemoKey128'),'Hello');

SELECT @MySecret AS [MY SECRET ENCRYPTED];

SELECT CONVERT(VarChar(50), DecryptByKey(@MySecret)) AS [MY SECRET DECRYPTED];
GO


-- Encryption result is different every time
OPEN SYMMETRIC KEY DemoKey128
  DECRYPTION BY PASSWORD = 'DrinkYour0valtine'
GO

SELECT EncryptByKey(Key_GUID('DemoKey128'),'Hello')
UNION
SELECT EncryptByKey(Key_GUID('DemoKey128'),'Hello')
UNION
SELECT EncryptByKey(Key_GUID('DemoKey128'),'Hello')
GO



-- at first glance 192 results appear similar
OPEN SYMMETRIC KEY DemoKey192
  DECRYPTION BY PASSWORD = 'DrinkYour0valtine'
GO

SELECT EncryptByKey(Key_GUID('DemoKey192'),'Hello')
GO



-- same with 256 - true difference is very deep topic
OPEN SYMMETRIC KEY DemoKey256
  DECRYPTION BY PASSWORD = 'DrinkYour0valtine'
GO

SELECT EncryptByKey(Key_GUID('DemoKey256'),'Hello')
GO



--CLEAN UP DEMO
DROP SYMMETRIC KEY DemoKey128;
DROP SYMMETRIC KEY DemoKey192;
DROP SYMMETRIC KEY DemoKey256;