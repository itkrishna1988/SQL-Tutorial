
-- Changing selected database properties

USE [master]
GO

-- Enable auto update statistsics asynchronously
ALTER DATABASE [AdventureWorksLT2008R2] SET AUTO_UPDATE_STATISTICS_ASYNC ON WITH NO_WAIT;
GO

-- Enable delayed durability
ALTER DATABASE [AdventureWorksLT2008R2] SET DELAYED_DURABILITY = ALLOWED WITH NO_WAIT;
GO

-- Enable CHECKSUM for the page verify option
ALTER DATABASE [AdventureWorksLT2008R2] SET PAGE_VERIFY CHECKSUM  WITH NO_WAIT;
GO




