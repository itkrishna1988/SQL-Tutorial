
CREATE TABLE [dbo].[Wallet](
	[WalletKey] [int] NOT NULL,
	[CardHash] [varchar](64) NULL,
	[CardMask] [varchar](20) NULL,
	[CardZip] [varchar](10) NULL,
	[SecureCode] [varchar](6) NULL,
	[CardType] [varchar](1) NULL,
	[CardExp] [varchar](10) NULL,
	[PartnerToken] [varchar](64) NULL,
 CONSTRAINT [PK_Wallet] PRIMARY KEY CLUSTERED 
(
	[WalletKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE SCHEMA [ch];
GO

ALTER SCHEMA [ch] TRANSFER dbo.Wallet;
GO

CREATE FUNCTION ch.IsCardExpired(@CardExp AS VarChar(10))
RETURNS BIT
BEGIN
	RETURN 1;
	-- Homework: put better logic here
END
GO

--show schema rights for specific login
execute as [<specific login>] 
select * from fn_my_permissions('ch','SCHEMA');
GO



