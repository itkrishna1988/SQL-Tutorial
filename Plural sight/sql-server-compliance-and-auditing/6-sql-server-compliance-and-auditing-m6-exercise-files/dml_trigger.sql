
CREATE TRIGGER RequireChangeAudit 
   ON  GeneralLedger 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	
	IF ORIGINAL_LOGIN() <> 'svc_AbacosApplication'
	BEGIN
		INSERT INTO AbacosFinancials.dbo.AuditLog 
			(LogKey, EntryDate, EntryBy, NonSystem)
		VALUES
			(1, GetDate(), Original_LOGIN(), 1);
	END

END
GO