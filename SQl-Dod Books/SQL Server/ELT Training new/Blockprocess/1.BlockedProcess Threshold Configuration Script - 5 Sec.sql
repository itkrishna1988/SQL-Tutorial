exec sp_configure 'show advanced options', 1 ;
GO
RECONFIGURE WITH OVERRIDE;

GO
exec sp_configure 'blocked process threshold', 5 ;
 
RECONFIGURE WITH OVERRIDE;

GO