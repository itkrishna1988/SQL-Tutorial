USE [TESTINGPMO_NEW]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Vh_Revenue]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Vh_Revenue](
	[Vhid] [int] IDENTITY(1,1) NOT NULL,
	[Practice] [nvarchar](50) NULL,
	[Tagging] [nvarchar](50) NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[BusinessUnit] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NULL,
	[CustomerID] [int] NOT NULL,
	[CustomerDescription] [nvarchar](100) NOT NULL,
	[ParentCustomer] [nvarchar](50) NOT NULL,
	[ProjectID] [int] NULL,
	[ProjectDescription] [nvarchar](50) NULL,
	[Bill_Type] [nvarchar](50) NULL,
	[Revenue] [numeric](18, 5) NULL,
	[DirectCost] [numeric](18, 5) NULL,
	[IndirectCost] [numeric](18, 5) NULL,
	[CP] [numeric](18, 5) NULL,
	[Mth] [int] NULL,
	[Yr] [int] NULL,
	[UpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [pk_Vhid] PRIMARY KEY CLUSTERED 
(
	[Vhid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_VerticalValues]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_VerticalValues](
	[vid] [int] IDENTITY(1,1) NOT NULL,
	[Mth] [int] NULL,
	[yr] [int] NULL,
	[Geo] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NULL,
	[SBU] [nvarchar](50) NULL,
	[Account] [nvarchar](100) NULL,
	[RevenueTarget] [numeric](18, 0) NULL,
	[RevenueActual] [numeric](18, 0) NULL,
	[revenue_variance] [numeric](18, 0) NULL,
	[rev_var_per] [numeric](18, 0) NULL,
	[rev_ach_bud_per] [decimal](10, 2) NULL,
	[rev_ytd] [numeric](18, 0) NULL,
	[rev_target_ytd] [numeric](18, 0) NULL,
	[rev_ach_bud_per_ytd] [numeric](18, 0) NULL,
	[Forecast] [numeric](18, 0) NULL,
	[CPBudget] [numeric](18, 0) NULL,
	[CPActual] [numeric](18, 0) NULL,
	[CPVariance] [numeric](18, 0) NULL,
	[CP] [numeric](18, 0) NULL,
	[cptargetamount] [numeric](18, 0) NULL,
	[impact_percentage] [numeric](18, 0) NULL,
	[cp_ytd] [decimal](10, 2) NULL,
	[cp_amount_ytd] [numeric](18, 0) NULL,
	[cp_traget_amount_ytd] [numeric](18, 0) NULL,
	[impact_percentage_ytd] [numeric](18, 0) NULL,
	[cp_target_ytd] [numeric](18, 0) NULL,
	[cp_ytd_var] [numeric](18, 0) NULL,
	[DirectCost] [numeric](18, 0) NULL,
	[InDirectCost] [numeric](18, 0) NULL,
	[CPwithKGBudget] [numeric](18, 0) NULL,
	[CPwithKGActual] [numeric](18, 0) NULL,
	[CPwithKGVariance] [numeric](18, 0) NULL,
	[PPBudget] [numeric](18, 0) NULL,
	[PPActual] [numeric](18, 0) NULL,
	[PPVariance] [numeric](18, 0) NULL,
	[SGABudget] [numeric](18, 0) NULL,
	[SGAActual] [numeric](18, 0) NULL,
	[SGAVariance] [numeric](18, 0) NULL,
	[KGBudget] [numeric](18, 0) NULL,
	[KGActual] [numeric](18, 0) NULL,
	[KGVariance] [numeric](18, 0) NULL,
	[KG_var_per] [numeric](18, 0) NULL,
	[UtilizationOnsite] [numeric](18, 0) NULL,
	[UtilizationOffshore] [numeric](18, 0) NULL,
	[UtilizationOffshoreWoCAT] [numeric](18, 0) NULL,
	[OffshoreRatio] [numeric](18, 0) NULL,
	[AtoARatio] [numeric](18, 0) NULL,
	[TraineePercentage] [numeric](18, 0) NULL,
	[SubconOnsite] [numeric](18, 0) NULL,
	[SubconOffshore] [numeric](18, 0) NULL,
	[TimesheetSubmissionOnsite] [numeric](18, 0) NULL,
	[TimesheetSubmissionOffshore] [numeric](18, 0) NULL,
	[Timesheet_Defaulter_OFFSHORE] [decimal](10, 2) NULL,
	[Timesheet_Defaulter_Onsite] [decimal](10, 2) NULL,
	[RFR] [numeric](18, 0) NULL,
	[SOCOnsite] [numeric](18, 0) NULL,
	[SOCOffshore] [numeric](18, 0) NULL,
	[GeoHeadcount] [numeric](18, 0) NULL,
	[GeoUtilizationPercentage] [numeric](18, 0) NULL,
	[COLOR] [nvarchar](10) NULL,
	[nick_name] [nvarchar](50) NULL,
	[PARENTCUSTOMER] [nvarchar](100) NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[display_flag] [int] NOT NULL,
 CONSTRAINT [pk_Verticalid] PRIMARY KEY CLUSTERED 
(
	[vid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Vertical_AllACCounts_Values]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Vertical_AllACCounts_Values](
	[Vid] [int] IDENTITY(1,1) NOT NULL,
	[MTH] [int] NULL,
	[YR] [int] NULL,
	[vertical] [nvarchar](50) NULL,
	[Account] [nvarchar](50) NULL,
	[RevenueActual] [numeric](38, 4) NOT NULL,
	[REV_YTD] [numeric](18, 2) NULL,
	[CPActual] [numeric](38, 6) NOT NULL,
	[cpbudget] [numeric](18, 2) NULL,
	[CP] [numeric](38, 4) NOT NULL,
	[cptargetamount] [numeric](18, 2) NULL,
	[DirectCost] [numeric](38, 4) NOT NULL,
	[InDirectCost] [numeric](38, 4) NOT NULL,
	[Direct_cost_per] [numeric](18, 2) NULL,
	[InDirect_cost_per] [numeric](18, 2) NULL,
	[impact_percentage] [numeric](18, 2) NULL,
	[cp_ytd] [numeric](38, 6) NOT NULL,
	[cp_amount_ytd] [numeric](18, 2) NULL,
	[cp_traget_amount_ytd] [numeric](18, 2) NULL,
	[impact_percentage_ytd] [numeric](18, 2) NULL,
	[UtilizationOnsite] [numeric](38, 6) NOT NULL,
	[UtilizationOffshore] [numeric](38, 6) NOT NULL,
	[UtilizationOffshoreWoCAT] [numeric](38, 6) NOT NULL,
	[WOCATUTIL] [numeric](18, 2) NULL,
	[CATUTIL] [numeric](18, 2) NULL,
	[SAUTIL] [numeric](18, 2) NULL,
	[AUTIL] [numeric](18, 2) NULL,
	[OffshoreRatio] [numeric](18, 2) NOT NULL,
	[onsitecount] [numeric](18, 2) NULL,
	[AtoARatio] [numeric](18, 2) NOT NULL,
	[TraineePercentage] [numeric](18, 2) NOT NULL,
	[SubconOnsite] [numeric](38, 6) NOT NULL,
	[Subconoffshore] [numeric](38, 6) NOT NULL,
	[SOCOnsite] [numeric](18, 2) NOT NULL,
	[SOCOffshore] [numeric](18, 2) NOT NULL,
	[rfr] [numeric](38, 6) NOT NULL,
	[GeoHeadcount] [numeric](18, 2) NOT NULL,
	[ONSITEHEADCNT] [numeric](18, 2) NULL,
	[OFFHEADCNT] [numeric](18, 2) NULL,
	[TimesheetSubmissionOnsite] [numeric](38, 6) NOT NULL,
	[TimesheetSubmissionOffshore] [numeric](38, 6) NOT NULL,
	[Timesheet_Defaulter_OFFSHORE] [numeric](38, 19) NOT NULL,
	[Timesheet_Defaulter_Onsite] [numeric](38, 19) NOT NULL,
	[Direct_FixedBid_Revenue] [decimal](15, 2) NOT NULL,
	[Direct_FixedBid_CP_perc] [decimal](15, 2) NOT NULL,
	[Direct_TM_Revenue] [decimal](15, 2) NOT NULL,
	[Direct_TM_CP_perc] [decimal](15, 2) NOT NULL,
	[Indirect_Fixedbid_Revenue] [decimal](15, 2) NOT NULL,
	[Indirect_Fixedbid_CPperc] [decimal](15, 2) NOT NULL,
	[VH_TM_Revenue] [decimal](15, 2) NOT NULL,
	[VH_TM_CPperc] [decimal](15, 2) NOT NULL,
	[VH_FixedBid_Revenue] [decimal](15, 2) NOT NULL,
	[VH_Fixed_Bid_CPperc] [decimal](15, 2) NOT NULL,
	[Indirect_TM_Revenue] [decimal](15, 2) NOT NULL,
	[Indirect_TM_CPperc] [decimal](15, 2) NOT NULL,
	[Previous_Month] [int] NULL,
	[Current_Month] [int] NULL,
	[Revenue_Variance] [decimal](15, 2) NULL,
	[Revenue_Variance_perc] [decimal](15, 2) NULL,
	[Total_FixedBid_Revenue] [numeric](18, 2) NULL,
	[Total_Fixedbid_CPperc] [numeric](18, 2) NULL,
	[Total_TM_Revenue] [numeric](18, 2) NULL,
	[Total_TM_CPperc] [numeric](18, 2) NULL,
	[Indirect_Fixedbid_CP] [numeric](18, 2) NULL,
	[Direct_FixedBid_cp] [numeric](18, 2) NULL,
	[DIRECT_TM_CP] [numeric](18, 2) NULL,
	[Indirect_TM_CP] [numeric](18, 2) NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[DISPLAY_FLAG] [int] NOT NULL,
 CONSTRAINT [pk_Vall] PRIMARY KEY CLUSTERED 
(
	[Vid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Vertical_AccountMapping]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Vertical_AccountMapping](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ParentCustomer] [nvarchar](100) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Vertical] [nvarchar](50) NOT NULL,
 CONSTRAINT [pk_Vertical_Accountid] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Util]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Util](
	[UtilID] [int] IDENTITY(1,1) NOT NULL,
	[AssociateID] [int] NOT NULL,
	[Grade] [nvarchar](50) NOT NULL,
	[GradeGrouping] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NULL,
	[ONOFF] [nvarchar](50) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Mth] [int] NOT NULL,
	[Yr] [int] NOT NULL,
	[AssociateName] [nvarchar](100) NOT NULL,
	[ProjectDescription] [nvarchar](100) NOT NULL,
	[CustomerID] [int] NULL,
	[CustomerDescription] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[DepartmentDescription] [nvarchar](50) NULL,
	[SubVertical] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[SubHorizontal] [nvarchar](50) NULL,
	[Horizontal] [nvarchar](50) NULL,
	[ParentCustomer] [nvarchar](100) NOT NULL,
	[BilledFTE] [numeric](18, 5) NULL,
	[TotalFTE] [numeric](18, 5) NULL,
	[Category] [nvarchar](50) NULL,
	[AvailableHrs] [numeric](18, 5) NULL,
	[BilledHrs] [numeric](18, 5) NULL,
	[UpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [pk_Utilid] PRIMARY KEY CLUSTERED 
(
	[UtilID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Timesheet_Defaulters]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Timesheet_Defaulters](
	[tid] [int] IDENTITY(1,1) NOT NULL,
	[PeriodEndDate] [date] NOT NULL,
	[AssociateID] [int] NOT NULL,
	[AssociateName] [nvarchar](100) NOT NULL,
	[Employee_Contractor] [nvarchar](50) NOT NULL,
	[SubmissionStatus] [nvarchar](50) NOT NULL,
	[Designation] [nvarchar](50) NULL,
	[HCMSupervisorId] [int] NOT NULL,
	[HCMSupervisorName] [nvarchar](100) NOT NULL,
	[DepartmentID] [int] NULL,
	[DepartmentDescription] [nvarchar](50) NULL,
	[LocationCode] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[Onsite_Offshore] [nvarchar](50) NOT NULL,
	[Percentage_Allocation] [numeric](18, 2) NULL,
	[Associate_Billability] [nvarchar](50) NULL,
	[PracticeType] [nvarchar](50) NULL,
	[PracticeID] [int] NULL,
	[PracticeName] [nvarchar](50) NULL,
	[ProjectID] [int] NULL,
	[ProjectDescription] [nvarchar](50) NULL,
	[ProjectManagerId] [int] NULL,
	[ProjectManagerName] [nvarchar](100) NULL,
	[CustomerVertical] [nvarchar](50) NULL,
	[CustomerSubVertical] [nvarchar](50) NULL,
	[CustomerID] [int] NULL,
	[CustomerName] [nvarchar](50) NULL,
	[ClientPartnerId] [int] NULL,
	[ClientPartnerName] [nvarchar](100) NULL,
	[CustomerVerticalDescription] [nvarchar](50) NULL,
	[CustomerSubVerticalID] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[SBU1] [nvarchar](100) NULL,
	[SBU2] [nvarchar](100) NULL,
	[BusinessUnit] [nvarchar](100) NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [pk_Timeid] PRIMARY KEY CLUSTERED 
(
	[tid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Sbu_Master]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Sbu_Master](
	[SBUID] [int] IDENTITY(1,1) NOT NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[ParentCustomer] [nvarchar](100) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Offshore_Portfolio_Manager] [nvarchar](50) NOT NULL,
	[Onsite_Portfolio_Manager] [nvarchar](100) NOT NULL,
	[Region_Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [pk_Sbuid] PRIMARY KEY CLUSTERED 
(
	[SBUID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Rfr_Revenue]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Rfr_Revenue](
	[rfr_id] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[BusinessUnit] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CustomerDescription] [nvarchar](500) NOT NULL,
	[ParentCustomer] [nvarchar](50) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[ProjectDescription] [nvarchar](100) NOT NULL,
	[AssociateID] [int] NOT NULL,
	[AssociateName] [nvarchar](200) NOT NULL,
	[Onsite_Offshore] [nvarchar](50) NOT NULL,
	[Revenue] [numeric](18, 5) NULL,
	[DirectCost] [numeric](18, 5) NULL,
	[IndirectCost] [numeric](18, 5) NULL,
	[Mth] [int] NOT NULL,
	[Yr] [int] NOT NULL,
	[Rfr_Type] [nvarchar](50) NULL,
	[SBU1] [nvarchar](50) NULL,
	[SBU2] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [pk_rfr_id] PRIMARY KEY CLUSTERED 
(
	[rfr_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Revenue_Hp]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Revenue_Hp](
	[HPID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[Mth] [int] NOT NULL,
	[Yr] [int] NOT NULL,
	[DirectCost] [numeric](18, 4) NOT NULL,
	[IndirectCost] [numeric](18, 4) NOT NULL,
	[Revenue] [numeric](18, 4) NOT NULL,
	[CP] [numeric](18, 4) NOT NULL,
	[BusinessUnit] [nvarchar](50) NULL,
	[GroupName] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[ProjectDescription] [nvarchar](100) NULL,
	[CustomerID] [int] NOT NULL,
	[CustomerDescription] [nvarchar](500) NULL,
	[ParentCustomer] [nvarchar](50) NOT NULL,
	[ProjectBillability] [nvarchar](50) NULL,
	[ProjectType] [nvarchar](50) NOT NULL,
	[ProjectSubType] [nvarchar](50) NOT NULL,
	[SBU1] [nvarchar](50) NULL,
	[SBU2] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [pk_HPid1] PRIMARY KEY CLUSTERED 
(
	[HPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_Practicevalues]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_Practicevalues](
	[pid] [int] IDENTITY(1,1) NOT NULL,
	[Mth] [int] NULL,
	[yr] [int] NULL,
	[Geo] [nvarchar](50) NOT NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[RevenueTarget] [numeric](18, 5) NULL,
	[RevenueActual] [numeric](18, 5) NULL,
	[CPBudget] [numeric](18, 5) NULL,
	[CPActual] [numeric](18, 5) NULL,
	[CPVariance] [numeric](18, 5) NULL,
	[CPwithKGBudget] [numeric](18, 5) NULL,
	[CPwithKGActual] [numeric](18, 5) NULL,
	[CPwithKGVariance] [numeric](18, 5) NULL,
	[PPBudget] [numeric](18, 5) NULL,
	[PPActual] [numeric](18, 5) NULL,
	[PPVariance] [numeric](18, 5) NULL,
	[SGABudget] [numeric](18, 5) NULL,
	[SGAActual] [numeric](18, 5) NULL,
	[SGAVariance] [numeric](18, 5) NULL,
	[KGBudget] [numeric](18, 5) NULL,
	[KGActual] [numeric](18, 5) NULL,
	[KGVariance] [numeric](18, 5) NULL,
	[UtilizationOnsite] [numeric](18, 5) NULL,
	[UtilizationOffshore] [numeric](18, 5) NULL,
	[UtilizationOffshoreWoCAT] [numeric](18, 5) NULL,
	[OffshoreRatio] [numeric](18, 5) NULL,
	[AtoARatio] [numeric](18, 5) NULL,
	[TraineePercentage] [numeric](18, 5) NULL,
	[SubconOnsite] [numeric](18, 5) NULL,
	[SubconOffshore] [numeric](18, 5) NULL,
	[TimesheetSubmissionOnsite] [numeric](18, 5) NULL,
	[TimesheetSubmissionOffshore] [numeric](18, 5) NULL,
	[RFR] [numeric](18, 5) NULL,
	[SOCOnsite] [numeric](18, 5) NULL,
	[SOCOffshore] [numeric](18, 5) NULL,
	[GeoBudget] [numeric](18, 5) NULL,
	[GeoActual] [numeric](18, 5) NULL,
	[GeoVariance] [numeric](18, 5) NULL,
	[GeoHeadcount] [numeric](18, 5) NULL,
	[GeoUtilizationPercentage] [numeric](18, 5) NULL,
	[UpdatedOn] [datetime] NULL,
	[RevenueActualPercentage] [numeric](18, 2) NULL,
	[Admin_Cost] [numeric](18, 2) NULL,
	[KG] [numeric](18, 2) NULL,
	[PDP] [numeric](18, 2) NULL,
	[KGCount] [numeric](18, 5) NULL,
	[CP_YTD] [numeric](18, 5) NULL,
	[RevenueActual_CurrMth] [numeric](18, 5) NULL,
	[CPActual_CurrMth] [numeric](18, 5) NULL,
	[CP_Percentage_CurrMth] [numeric](18, 5) NULL,
	[Direct_Fixed_Bid_Revenue_currMth] [numeric](18, 5) NULL,
	[Direct_Fixed_Bid_CP_currMth] [numeric](18, 5) NULL,
	[Direct_Fixed_Bid_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[Indirect_Fixed_Bid_Revenue_currMth] [numeric](18, 5) NULL,
	[Indirect_Fixed_Bid_CP_currMth] [numeric](18, 5) NULL,
	[Indirect_Fixed_Bid_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[Direct_TM_Revenue_currMth] [numeric](18, 5) NULL,
	[Direct_TM_CP_currMth] [numeric](18, 5) NULL,
	[Direct_TM_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[Indirect_TM_Revenue_currMth] [numeric](18, 5) NULL,
	[Indirect_TM_CP_currMth] [numeric](18, 5) NULL,
	[Indirect_TM_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[VH_FB_Revenue_currMth] [numeric](18, 5) NULL,
	[VH_FB_CP_currMth] [numeric](18, 5) NULL,
	[VH_FB_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[VH_TM_Revenue_currMth] [numeric](18, 5) NULL,
	[VH_TM_CP_currMth] [numeric](18, 5) NULL,
	[VH_TM_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[RevenuePercentage] [numeric](18, 5) NULL,
	[Onsite_Headcount] [int] NULL,
	[Offshore_Headcount] [int] NULL,
	[ELT_Headcount] [int] NULL,
	[TotalFTE] [int] NULL,
	[Lateral_TimeToBill] [int] NULL,
	[CAT_TimeToBill] [int] NULL,
	[CPwithKG_currMth] [numeric](18, 5) NULL,
	[TimesheetDefaultersOnsite] [numeric](18, 5) NULL,
	[TimesheetDefaultersOffshore] [numeric](18, 5) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [pk_Practiceid] PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_practicedashboardvalues]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_practicedashboardvalues](
	[pid] [int] IDENTITY(1,1) NOT NULL,
	[Mth] [int] NULL,
	[yr] [int] NULL,
	[Geo] [nvarchar](50) NOT NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[RevenueTarget] [numeric](18, 5) NULL,
	[RevenueActual] [numeric](18, 5) NULL,
	[CPBudget] [numeric](18, 5) NULL,
	[CPActual] [numeric](18, 5) NULL,
	[CPVariance] [numeric](18, 5) NULL,
	[CPwithKGBudget] [numeric](18, 5) NULL,
	[CPwithKGActual] [numeric](18, 5) NULL,
	[CPwithKGVariance] [numeric](18, 5) NULL,
	[PPBudget] [numeric](18, 5) NULL,
	[PPActual] [numeric](18, 5) NULL,
	[PPVariance] [numeric](18, 5) NULL,
	[SGABudget] [numeric](18, 5) NULL,
	[SGAActual] [numeric](18, 5) NULL,
	[SGAVariance] [numeric](18, 5) NULL,
	[KGBudget] [numeric](18, 5) NULL,
	[KGActual] [numeric](18, 5) NULL,
	[KGVariance] [numeric](18, 5) NULL,
	[UtilizationOnsite] [numeric](18, 5) NULL,
	[UtilizationOffshore] [numeric](18, 5) NULL,
	[UtilizationOffshoreWoCAT] [numeric](18, 5) NULL,
	[OffshoreRatio] [numeric](18, 5) NULL,
	[AtoARatio] [numeric](18, 5) NULL,
	[TraineePercentage] [numeric](18, 5) NULL,
	[SubconOnsite] [numeric](18, 5) NULL,
	[SubconOffshore] [numeric](18, 5) NULL,
	[TimesheetSubmissionOnsite] [numeric](18, 5) NULL,
	[TimesheetSubmissionOffshore] [numeric](18, 5) NULL,
	[RFR] [numeric](18, 5) NULL,
	[SOCOnsite] [numeric](18, 5) NULL,
	[SOCOffshore] [numeric](18, 5) NULL,
	[GeoBudget] [numeric](18, 5) NULL,
	[GeoActual] [numeric](18, 5) NULL,
	[GeoVariance] [numeric](18, 5) NULL,
	[GeoHeadcount] [numeric](18, 5) NULL,
	[GeoUtilizationPercentage] [numeric](18, 5) NULL,
	[UpdatedOn] [datetime] NULL,
	[RevenueActualPercentage] [numeric](18, 2) NULL,
	[Admin_Cost] [numeric](18, 2) NULL,
	[KG] [numeric](18, 2) NULL,
	[PDP] [numeric](18, 2) NULL,
	[KGCount] [numeric](18, 5) NULL,
	[CP_YTD] [numeric](18, 5) NULL,
	[RevenueActual_CurrMth] [numeric](18, 5) NULL,
	[CPActual_CurrMth] [numeric](18, 5) NULL,
	[CP_Percentage_CurrMth] [numeric](18, 5) NULL,
	[Direct_Fixed_Bid_Revenue_currMth] [numeric](18, 5) NULL,
	[Direct_Fixed_Bid_CP_currMth] [numeric](18, 5) NULL,
	[Direct_Fixed_Bid_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[Indirect_Fixed_Bid_Revenue_currMth] [numeric](18, 5) NULL,
	[Indirect_Fixed_Bid_CP_currMth] [numeric](18, 5) NULL,
	[Indirect_Fixed_Bid_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[Direct_TM_Revenue_currMth] [numeric](18, 5) NULL,
	[Direct_TM_CP_currMth] [numeric](18, 5) NULL,
	[Direct_TM_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[Indirect_TM_Revenue_currMth] [numeric](18, 5) NULL,
	[Indirect_TM_CP_currMth] [numeric](18, 5) NULL,
	[Indirect_TM_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[VH_FB_Revenue_currMth] [numeric](18, 5) NULL,
	[VH_FB_CP_currMth] [numeric](18, 5) NULL,
	[VH_FB_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[VH_TM_Revenue_currMth] [numeric](18, 5) NULL,
	[VH_TM_CP_currMth] [numeric](18, 5) NULL,
	[VH_TM_CP_Percentage_currMth] [numeric](18, 5) NULL,
	[RevenuePercentage] [numeric](18, 5) NULL,
	[Onsite_Headcount] [int] NULL,
	[Offshore_Headcount] [int] NULL,
	[ELT_Headcount] [int] NULL,
	[TotalFTE] [int] NULL,
	[Lateral_TimeToBill] [int] NULL,
	[CAT_TimeToBill] [int] NULL,
	[CPwithKG_currMth] [numeric](18, 5) NULL,
	[TimesheetDefaultersOnsite] [numeric](18, 5) NULL,
	[TimesheetDefaultersOffshore] [numeric](18, 5) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [pk_Practiceid1] PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_OSP_CSP_SAP_UTIL]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_OSP_CSP_SAP_UTIL](
	[Utilid] [int] IDENTITY(1,1) NOT NULL,
	[FileType] [nvarchar](50) NULL,
	[AssociateID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Grade] [nvarchar](50) NOT NULL,
	[Month_Of_Joining] [int] NOT NULL,
	[Year_Of_Joining] [int] NOT NULL,
	[Category] [nvarchar](50) NULL,
	[SubCategory] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[LocationGrouping] [nvarchar](50) NULL,
	[OnOff] [nvarchar](50) NULL,
	[ProjectID] [int] NULL,
	[ProjectName] [nvarchar](100) NULL,
	[ProjectType] [nvarchar](50) NULL,
	[ProjectBillability] [nvarchar](50) NULL,
	[CustomerID] [int] NULL,
	[Level1CustomerName] [nvarchar](100) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[DepartmentName] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NULL,
	[Horizontal] [nvarchar](50) NULL,
	[Subvertical] [nvarchar](100) NULL,
	[SubHorizontal] [nvarchar](100) NULL,
	[ManagerID] [int] NULL,
	[ManagerName] [nvarchar](100) NULL,
	[WeightedAverage] [numeric](18, 5) NULL,
	[Location_Avlb_Hrs] [numeric](18, 5) NULL,
	[AvailableHrs] [numeric](18, 5) NULL,
	[BilledHrs] [numeric](18, 5) NULL,
	[BilledStatus] [nvarchar](200) NULL,
	[BilledFTE] [numeric](18, 5) NULL,
	[TotalFTE] [numeric](18, 5) NULL,
	[UnbilledFTE] [numeric](18, 5) NULL,
	[BU] [nvarchar](100) NULL,
	[ParentCustomer] [nvarchar](100) NULL,
	[CPID] [int] NULL,
	[CPName] [nvarchar](100) NULL,
	[ODD_ID] [int] NULL,
	[ODDName] [nvarchar](100) NULL,
	[DM] [nvarchar](500) NULL,
	[AM] [nvarchar](500) NULL,
	[GlobalMarket] [nvarchar](100) NULL,
	[AllocationPercentage] [numeric](18, 3) NULL,
	[ResourceBillability] [nvarchar](100) NULL,
	[AllocationStartDate] [datetime] NULL,
	[AllocationEndDate] [datetime] NULL,
	[ExpInMonths] [int] NULL,
	[CriticalFlag] [nvarchar](10) NULL,
	[LocationCode] [nvarchar](50) NULL,
	[LocationDescription] [nvarchar](100) NULL,
	[JobCode] [nvarchar](50) NULL,
	[Designation] [nvarchar](50) NULL,
	[Operation_Role] [nvarchar](100) NULL,
	[Mth] [int] NOT NULL,
	[Yr] [int] NOT NULL,
	[UploadedOn] [datetime] NOT NULL,
 CONSTRAINT [pk_Sapid] PRIMARY KEY CLUSTERED 
(
	[Utilid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Nicknames]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Nicknames](
	[Nid] [int] IDENTITY(1,1) NOT NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[ParentCustomer] [nvarchar](100) NOT NULL,
	[Nick_name] [nvarchar](10) NOT NULL,
 CONSTRAINT [pk_Nid] PRIMARY KEY CLUSTERED 
(
	[Nid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Lateral_Timetobill]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Lateral_Timetobill](
	[lid] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[EmployeeName] [nvarchar](100) NOT NULL,
	[DOJ] [datetime] NOT NULL,
	[Lateral_ELT] [nvarchar](50) NOT NULL,
	[Campus] [nvarchar](50) NOT NULL,
	[Jobcode] [nvarchar](50) NOT NULL,
	[JobcodeDescription] [nvarchar](100) NOT NULL,
	[GradeHR] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NULL,
	[SubCategory] [nvarchar](50) NULL,
	[HCM_Dept_ID] [nvarchar](50) NULL,
	[HCM_Dept_Name] [nvarchar](100) NULL,
	[Dept_Classification] [nvarchar](50) NULL,
	[Practice] [nvarchar](50) NULL,
	[Loction_Id] [nvarchar](50) NULL,
	[Location_Description] [nvarchar](100) NOT NULL,
	[Location_Grouping] [nvarchar](50) NULL,
	[REGION] [nvarchar](50) NULL,
	[Onsite_Offshore] [nvarchar](50) NOT NULL,
	[ProjectID] [int] NULL,
	[ProjectDescription] [nvarchar](100) NULL,
	[AccountID] [int] NOT NULL,
	[AccountName] [nvarchar](200) NULL,
	[BusinessUnit] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NULL,
	[SubVertical] [nvarchar](100) NULL,
	[Horizontal] [nvarchar](50) NULL,
	[HorizontalGrouping] [nvarchar](100) NULL,
	[First_Month_Billed] [datetime] NULL,
	[Billability] [nvarchar](50) NULL,
	[First_month_billed_hrs] [numeric](18, 5) NULL,
	[Billing_Start_Date] [datetime] NULL,
	[Time_taken_to_bill_in_days] [numeric](18, 5) NULL,
	[UploadedOn] [datetime] NOT NULL,
	[Mth] [int] NULL,
	[Yr] [int] NULL,
 CONSTRAINT [pk_Lateralid] PRIMARY KEY CLUSTERED 
(
	[lid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_Hp_Revenue]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_Hp_Revenue](
	[HPID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[Mth] [int] NOT NULL,
	[Yr] [int] NOT NULL,
	[DirectCost] [numeric](18, 4) NOT NULL,
	[IndirectCost] [numeric](18, 4) NOT NULL,
	[Revenue] [numeric](18, 4) NOT NULL,
	[CP] [numeric](18, 4) NOT NULL,
	[BusinessUnit] [nvarchar](50) NULL,
	[GroupName] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NOT NULL,
	[ProjectDescription] [nvarchar](100) NULL,
	[CustomerID] [int] NOT NULL,
	[CustomerDescription] [nvarchar](500) NULL,
	[ParentCustomer] [nvarchar](50) NOT NULL,
	[ProjectBillability] [nvarchar](50) NULL,
	[ProjectType] [nvarchar](50) NOT NULL,
	[ProjectSubType] [nvarchar](50) NOT NULL,
	[SBU1] [nvarchar](50) NULL,
	[SBU2] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [pk_HPid] PRIMARY KEY CLUSTERED 
(
	[HPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_FinancialTargets]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_FinancialTargets](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[TargetValue] [numeric](18, 2) NOT NULL,
	[Mth] [int] NULL,
	[Yr] [int] NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[Vertical] [nvarchar](50) NULL,
	[Geo] [nvarchar](50) NULL,
	[GroupName] [nvarchar](50) NOT NULL,
 CONSTRAINT [pk_finid] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Testingpmo_Dashboard_Country_GeoMaster]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Testingpmo_Dashboard_Country_GeoMaster](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Geo] [nvarchar](100) NOT NULL,
	[Country] [nvarchar](100) NOT NULL,
	[CountryCode] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_CNT_MASTER] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_Color_master]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_Color_master](
	[Cid] [int] IDENTITY(1,1) NOT NULL,
	[ParentCustomer] [nvarchar](100) NULL,
	[Vertical] [nvarchar](50) NULL,
	[COLOR] [nvarchar](50) NULL,
	[geo] [nvarchar](50) NULL,
 CONSTRAINT [pk_colorid] PRIMARY KEY CLUSTERED 
(
	[Cid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_CAndC_PPM]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_CAndC_PPM](
	[cc_ppm_id] [int] IDENTITY(1,1) NOT NULL,
	[Practice] [nvarchar](50) NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[DepartmentDescription] [nvarchar](100) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[ProjectDescription] [nvarchar](100) NOT NULL,
	[KG_Admin_PDP_Classification] [nvarchar](50) NULL,
	[PPM_Actual_Amount] [numeric](18, 2) NOT NULL,
	[Mth] [int] NULL,
	[Yr] [int] NULL,
	[Onsite_Offshore] [nvarchar](50) NULL,
	[Grade] [nvarchar](50) NULL,
	[Accountability] [nvarchar](50) NULL,
	[Geo] [nvarchar](50) NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[SubGroup] [nvarchar](50) NULL,
	[SGACost] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[UploadedOn] [datetime] NULL,
 CONSTRAINT [pk_CAndC_PPM] PRIMARY KEY CLUSTERED 
(
	[cc_ppm_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_CAndC_CPR]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_CAndC_CPR](
	[cc_id] [int] IDENTITY(1,1) NOT NULL,
	[Practice] [nvarchar](50) NOT NULL,
	[CPRAccountHead] [nvarchar](50) NOT NULL,
	[DepartmentID] [int] NULL,
	[DepartmentDescription] [nvarchar](100) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[ProjectDescription] [nvarchar](100) NOT NULL,
	[KG_Admin_PDP_Classification] [nvarchar](50) NULL,
	[AccountMidHead] [nvarchar](50) NULL,
	[AccountSubHead] [nvarchar](50) NULL,
	[AccountCodeDescription] [nvarchar](50) NULL,
	[CPR_Actual_Amount] [numeric](18, 2) NOT NULL,
	[Mth] [int] NULL,
	[Yr] [int] NULL,
	[Accountability] [nvarchar](50) NULL,
	[Geo] [nvarchar](50) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[SubGroup] [nvarchar](50) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[UploadedOn] [datetime] NULL,
 CONSTRAINT [pk_candc_cpr] PRIMARY KEY CLUSTERED 
(
	[cc_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_AccountDashboardValues]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_AccountDashboardValues](
	[vid] [int] IDENTITY(1,1) NOT NULL,
	[Mth] [int] NOT NULL,
	[yr] [int] NOT NULL,
	[PROJECTID] [int] NULL,
	[PROJECTDESCRIPTION] [nvarchar](50) NOT NULL,
	[Geo] [nvarchar](50) NULL,
	[Vertical] [nvarchar](50) NULL,
	[Account] [nvarchar](100) NULL,
	[SBU] [nvarchar](50) NULL,
	[RevenueTarget] [numeric](18, 2) NULL,
	[RevenueActual] [numeric](18, 2) NULL,
	[revenue_variance] [numeric](18, 2) NULL,
	[rev_var_per] [numeric](18, 2) NULL,
	[rev_ach_bud_per] [numeric](18, 2) NULL,
	[rev_ytd] [numeric](18, 2) NULL,
	[rev_target_ytd] [numeric](18, 2) NULL,
	[rev_ach_bud_per_ytd] [numeric](18, 2) NULL,
	[CPBudget] [numeric](18, 2) NULL,
	[CPActual] [numeric](18, 2) NULL,
	[CPVariance] [numeric](18, 2) NULL,
	[CP] [numeric](18, 2) NULL,
	[cptargetamount] [numeric](18, 2) NULL,
	[impact_percentage] [numeric](18, 2) NULL,
	[cp_ytd] [numeric](18, 2) NULL,
	[cp_ytd_var] [numeric](18, 2) NULL,
	[cp_amount_ytd] [numeric](18, 2) NULL,
	[cp_traget_amount_ytd] [numeric](18, 2) NULL,
	[impact_percentage_ytd] [numeric](18, 2) NULL,
	[DirectCost] [numeric](18, 2) NULL,
	[InDirectCost] [numeric](18, 2) NULL,
	[DirectCost_perc] [numeric](18, 2) NULL,
	[InDirectCost_perc] [numeric](18, 2) NULL,
	[Forecast] [numeric](18, 2) NULL,
	[UtilizationOnsite] [numeric](18, 2) NULL,
	[UtilizationOffshore] [numeric](18, 2) NULL,
	[UtilizationOffshoreWoCAT] [numeric](18, 2) NULL,
	[utilwocat] [numeric](18, 2) NULL,
	[catutil] [numeric](18, 2) NULL,
	[AUTIL] [numeric](18, 2) NULL,
	[SAUTIL] [numeric](18, 2) NULL,
	[OffshoreRatio] [numeric](18, 2) NULL,
	[AtoARatio] [numeric](18, 2) NULL,
	[TraineePercentage] [numeric](18, 2) NULL,
	[SubconOnsite] [numeric](18, 2) NULL,
	[SubconOffshore] [numeric](18, 2) NULL,
	[SOCOnsite] [numeric](18, 2) NULL,
	[SOCOffshore] [numeric](18, 2) NULL,
	[GeoHeadcount] [numeric](18, 2) NULL,
	[OffHeadCount] [numeric](18, 2) NULL,
	[Onsitecount] [numeric](18, 2) NULL,
	[OnsiteHeadCount] [numeric](18, 2) NULL,
	[TimesheetSubmissionOnsite] [numeric](18, 2) NULL,
	[TimesheetSubmissionOffshore] [numeric](18, 2) NULL,
	[Timesheet_Defaulter_OFFSHORE] [numeric](18, 2) NULL,
	[Timesheet_Defaulter_Onsite] [numeric](18, 2) NULL,
	[RFR] [numeric](18, 2) NULL,
	[COLOR] [nvarchar](10) NULL,
	[ParentCustomer] [nvarchar](100) NOT NULL,
	[upadateOn] [datetime] NULL,
	[display_flag] [int] NULL,
 CONSTRAINT [pk_accountid] PRIMARY KEY CLUSTERED 
(
	[vid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestingPmo_Dashboard_Account_Charts]    Script Date: 06/14/2012 12:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestingPmo_Dashboard_Account_Charts](
	[Chart_No] [int] IDENTITY(1,1) NOT NULL,
	[Chart_Name] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[SubCategory] [nvarchar](50) NOT NULL,
	[LiteralID] [nvarchar](50) NOT NULL,
	[FusionType] [nvarchar](50) NOT NULL,
	[XaxisName] [nvarchar](50) NOT NULL,
	[YaxisName] [nvarchar](50) NOT NULL,
	[Height] [int] NOT NULL,
	[Width] [int] NOT NULL,
	[DecimalPrecision] [int] NOT NULL,
	[YaxisMinValue] [int] NOT NULL,
	[YaxisMaxValue] [int] NOT NULL,
	[XaxisMinValue] [int] NOT NULL,
	[XaxisMaxValue] [int] NOT NULL,
	[Image_Name] [nvarchar](50) NOT NULL,
	[Benchmark] [int] NOT NULL,
	[BenchmarkID] [nvarchar](50) NOT NULL,
	[BenchmarkDescription] [nvarchar](50) NOT NULL,
	[BulletLowerLimit] [int] NOT NULL,
	[BulletUpperLimit] [int] NOT NULL,
	[Chart_Name_1] [nvarchar](100) NOT NULL,
 CONSTRAINT [pk_chartno] PRIMARY KEY CLUSTERED 
(
	[Chart_No] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
