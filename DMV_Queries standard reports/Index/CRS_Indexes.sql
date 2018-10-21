USE [OneC_TestingPMO]
GO

delete v from vw_Allocation v 
inner join
(select [Assignment_Id], [SeqNo] from vw_Allocation group by [Assignment_Id], [SeqNo]
having count(1) > 1) a on
a.[Assignment_Id] = v.[Assignment_Id] and a.[SeqNo] = v.[SeqNo]


/****** Object:  Index [PK_CentralRepository_Allocation]    Script Date: 05/02/2013 16:29:40 ******/
ALTER TABLE [dbo].[vw_Allocation] ADD  CONSTRAINT [PK_CentralRepository_Allocation] PRIMARY KEY CLUSTERED 
(
	[Assignment_Id] ASC,
	[SeqNo] ASC
)
GO


/****** Object:  Index [IX_CentralRepository_Allocation]    Script Date: 05/02/2013 16:30:26 ******/
CREATE NONCLUSTERED INDEX [IX_CentralRepository_Allocation] ON [dbo].[vw_Allocation] 
(
	[Allocation_Start_Date] ASC,
	[Allocation_End_Date] ASC
)
INCLUDE ( [Associate_ID],
[Project_ID]) 
GO


/****** Object:  Index [XIF1CentralRepository_Allocation]    Script Date: 05/02/2013 16:30:54 ******/
CREATE NONCLUSTERED INDEX [XIF1CentralRepository_Allocation] ON [dbo].[vw_Allocation] 
(
	[Associate_ID] ASC
)
GO

/****** Object:  Index [XIF2CentralRepository_Allocation]    Script Date: 05/02/2013 16:31:24 ******/
CREATE NONCLUSTERED INDEX [XIF2CentralRepository_Allocation] ON [dbo].[vw_Allocation] 
(
	[Project_ID] ASC
)
GO

/****************************************************************************************************/

ALTER TABLE [dbo].[vw_current_Allocation] ADD  CONSTRAINT [PK_CentralRepository_Current_Allocation] PRIMARY KEY CLUSTERED 
(
	[Assignment_Id] ASC,
	[SeqNo] ASC
)
GO


/****** Object:  Index [IX_CentralRepository_Allocation]    Script Date: 05/02/2013 16:30:26 ******/
CREATE NONCLUSTERED INDEX [IX_CentralRepository_Allocation] ON [dbo].[vw_Current_Allocation] 
(
	[Allocation_Start_Date] ASC,
	[Allocation_End_Date] ASC
)
INCLUDE ( [Associate_ID],
[Project_ID]) 
GO


/****** Object:  Index [XIF1CentralRepository_Allocation]    Script Date: 05/02/2013 16:30:54 ******/
CREATE NONCLUSTERED INDEX [XIF1CentralRepository_Allocation] ON [dbo].[vw_Current_Allocation] 
(
	[Associate_ID] ASC
)
GO

/****** Object:  Index [XIF2CentralRepository_Allocation]    Script Date: 05/02/2013 16:31:24 ******/
CREATE NONCLUSTERED INDEX [XIF2CentralRepository_Allocation] ON [dbo].[vw_Current_Allocation] 
(
	[Project_ID] ASC
)
GO

/****************************************************************************************************/
/****** Object:  Index [PK__CentralR__7C7EDB20143CDA05]    Script Date: 05/02/2013 16:37:40 ******/
ALTER TABLE [dbo].[vw_Associate_Details] ADD PRIMARY KEY NONCLUSTERED 
(
	[Associate_ID] ASC
)
GO


/****** Object:  Index [XPKCentralRepository_Associate_Details]    Script Date: 05/02/2013 16:38:17 ******/
CREATE UNIQUE CLUSTERED INDEX [XPKCentralRepository_Associate_Details] ON [dbo].[vw_Associate_Details] 
(
	[Associate_ID] ASC
)
GO


USE [CentralRepository]
GO

/****** Object:  Index [IX_CentralRepository_Associate_Details_Dept_ID_Associate_ID]    Script Date: 05/02/2013 16:38:41 ******/
CREATE NONCLUSTERED INDEX [IX_CentralRepository_Associate_Details_Dept_ID_Associate_ID] ON [dbo].[vw_Associate_Details] 
(
	[Dept_ID] ASC
)
INCLUDE ( [Associate_ID]) 
GO


/**********************************************************************************************/

/****** Object:  Index [PK__CentralR__8CB286B833B5855E]    Script Date: 05/02/2013 16:39:35 ******/
ALTER TABLE [dbo].[vw_Customer] ADD  CONSTRAINT [PK__CentralR__8CB286B833B5855E] PRIMARY KEY NONCLUSTERED 
(
	[Customer_ID] ASC
)
GO

/****** Object:  Index [XPKCentralRepository_Customer]    Script Date: 05/02/2013 16:40:07 ******/
CREATE UNIQUE CLUSTERED INDEX [XPKCentralRepository_Customer] ON [dbo].[vw_Customer] 
(
	[Customer_ID] ASC
)
GO

/****** Object:  Index [IX_CentralRepository_Customer]    Script Date: 05/02/2013 16:40:27 ******/
CREATE NONCLUSTERED INDEX [IX_CentralRepository_Customer] ON [dbo].[vw_Customer] 
(
	[SubVertical_ID] ASC
)
INCLUDE ( [Customer_ID]) 
GO

/**********************************************************************************************/

/****** Object:  Index [PK_CentralRepository_Designation]    Script Date: 05/02/2013 16:41:20 ******/
ALTER TABLE [dbo].[vw_Designation] ADD  CONSTRAINT [PK_CentralRepository_Designation] PRIMARY KEY CLUSTERED 
(
	[JobCode] ASC,
	[Bussiness_unit] ASC
)
GO

/**********************************************************************************************/

/****** Object:  Index [PK_CentralRepository_Grade_Master_1]    Script Date: 05/02/2013 16:42:07 ******/
ALTER TABLE [dbo].[vw_GradeMaster] ADD  CONSTRAINT [PK_CentralRepository_Grade_Master_1] PRIMARY KEY CLUSTERED 
(
	[GradeCode] ASC,
	[Business_Unit] ASC,
	[Sal_Admin_Plan] ASC
)
GO


/**********************************************************************************************/

/****** Object:  Index [PK_CentralRepository_HCMLocation]    Script Date: 05/02/2013 16:42:51 ******/
ALTER TABLE [dbo].[vw_HCMLocation] ADD  CONSTRAINT [PK_CentralRepository_HCMLocation] PRIMARY KEY CLUSTERED 
(
	[HCMLocationCode] ASC,
	[Business_Unit] ASC
)
GO

/**********************************************************************************************/

/****** Object:  Index [PK_CentralRepository_Location_Attributes]    Script Date: 05/02/2013 16:43:32 ******/
ALTER TABLE [dbo].[vw_LocationAttributes] ADD  CONSTRAINT [PK_CentralRepository_Location_Attributes] PRIMARY KEY CLUSTERED 
(
	[SetID] ASC,
	[Location] ASC,
	[Effdt] ASC
)
GO

/**********************************************************************************************/

/****** Object:  Index [PK_CentralRepository_Project]    Script Date: 05/02/2013 16:44:16 ******/
ALTER TABLE [dbo].[vw_Project] ADD  CONSTRAINT [PK_CentralRepository_Project] PRIMARY KEY CLUSTERED 
(
	[Project_ID] ASC
)
GO

/****** Object:  Index [IX_CentralRepository_Project]    Script Date: 05/02/2013 16:44:43 ******/
CREATE NONCLUSTERED INDEX [IX_CentralRepository_Project] ON [dbo].[vw_Project] 
(
	[Customer_ID] ASC
)
INCLUDE ( [Project_ID]) 
GO

/****** Object:  Index [CentralRepository_Project_efore]    Script Date: 05/02/2013 16:45:08 ******/
CREATE NONCLUSTERED INDEX [CentralRepository_Project_efore] ON [dbo].[vw_Project] 
(
	[Project_Type] ASC,
	[Bill_Type] ASC,
	[Project_End_Date] ASC
)
INCLUDE ( [Project_ID],
[Customer_ID]) 
GO

/**********************************************************************************************/

/****** Object:  Index [PK_ResourceRequest]    Script Date: 05/02/2013 16:45:57 ******/
ALTER TABLE [dbo].[vw_RMG_Request] ADD  CONSTRAINT [PK_ResourceRequest] PRIMARY KEY CLUSTERED 
(
	[BusinessUnit] ASC,
	[RMG_RR] ASC,
	[OpenServiceOrder] ASC,
	[SO_Line] ASC
)
GO

/****** Object:  Index [XIF1CentralRepository_RMG_ResourceRequest]    Script Date: 05/02/2013 16:46:48 ******/
CREATE NONCLUSTERED INDEX [XIF1CentralRepository_RMG_ResourceRequest] ON [dbo].[vw_RMG_Request] 
(
	[Project_ID] ASC
)
GO

/****** Object:  Index [XIF2CentralRepository_RMG_ResourceRequest]    Script Date: 05/02/2013 16:47:16 ******/
CREATE NONCLUSTERED INDEX [XIF2CentralRepository_RMG_ResourceRequest] ON [dbo].[vw_RMG_Request] 
(
	[JobCode] ASC
)
GO


/****** Object:  Index [PK_SUB_VERTICAL]    Script Date: 05/02/2013 16:47:44 ******/
ALTER TABLE [dbo].[vw_SubVertical] ADD  CONSTRAINT [PK_SUB_VERTICAL] PRIMARY KEY CLUSTERED 
(
	[SubVertical_ID] ASC
)
GO


/****** Object:  Index [PK_CentralRepository_RHMS_RoleMaster]    Script Date: 05/02/2013 16:59:47 ******/
ALTER TABLE [dbo].[RHMS_RoleMaster] ADD  CONSTRAINT [PK_CentralRepository_RHMS_RoleMaster] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)
GO

/****** Object:  Index [PK_CentralRepository_RHMS_RoleDetails]    Script Date: 05/02/2013 17:00:21 ******/
ALTER TABLE [dbo].[RHMS_RoleDetails] ADD  CONSTRAINT [PK_CentralRepository_RHMS_RoleDetails] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC,
	[AssociateID] ASC,
	[PortfolioId] ASC,
	[HierarchyId] ASC,
	[AlternatePortfolioId] ASC
)
GO

/****** Object:  Index [CentralRepository_RHMS_RoleDetails_efore]    Script Date: 05/02/2013 17:00:54 ******/
CREATE NONCLUSTERED INDEX [RHMS_RoleDetails_efore] ON [dbo].[RHMS_RoleDetails] 
(
	[RoleId] ASC,
	[HierarchyId] ASC
)
INCLUDE ( [AssociateID],
[UserName],
[PortfolioType],
[PortfolioId],
[ActiveFlag]) 
GO





