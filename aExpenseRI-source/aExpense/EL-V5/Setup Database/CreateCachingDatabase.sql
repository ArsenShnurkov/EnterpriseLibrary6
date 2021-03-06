
/****** Object:  Stored Procedure dbo.AddItem    Script Date: 8/25/2004 3:28:27 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AddItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AddItem]
GO

/****** Object:  Stored Procedure dbo.Flush    Script Date: 8/25/2004 3:28:27 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Flush]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Flush]
GO

/****** Object:  Stored Procedure dbo.GetItemCount    Script Date: 8/25/2004 3:28:27 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetItemCount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetItemCount]
GO

/****** Object:  Stored Procedure dbo.LoadItems    Script Date: 8/25/2004 3:28:27 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LoadItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[LoadItems]
GO

/****** Object:  Stored Procedure dbo.RemoveItem    Script Date: 8/25/2004 3:28:27 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RemoveItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[RemoveItem]
GO

/****** Object:  Stored Procedure dbo.UpdateLastAccessedTime    Script Date: 8/25/2004 3:28:27 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateLastAccessedTime]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateLastAccessedTime]
GO

/****** Object:  Table [dbo].[CacheData]    Script Date: 8/25/2004 3:28:27 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CacheData]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CacheData]
GO

/****** Object:  Table [dbo].[CacheData]    Script Date: 8/25/2004 3:28:27 PM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CacheData]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CacheData] (
	[StorageKey] [int] NOT NULL ,
	[PartitionName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Key] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Value] [image] NULL ,
	[RefreshAction] [image] NULL ,
	[Expirations] [image] NULL ,
	[ScavengingPriority] [int] NOT NULL ,
	[LastAccessedTime] [datetime] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

ALTER TABLE [dbo].[CacheData] WITH NOCHECK ADD 
	CONSTRAINT [PK_CacheData] PRIMARY KEY  CLUSTERED 
	(
		[StorageKey],
		[PartitionName]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.AddItem    Script Date: 8/25/2004 3:28:27 PM ******/



CREATE PROCEDURE dbo.AddItem
(
	@partitionName varchar(128),
	@storageKey int,
	@key varchar(128),
	@value image,
	@scavengingPriority int,
	@refreshAction image,
	@expirations image,
	@lastAccessedTime datetime
)
 AS
		delete from CacheData where StorageKey = @storageKey and PartitionName = @partitionName
		
		insert into CacheData (PartitionName, StorageKey, [Key], Value, RefreshAction, Expirations, ScavengingPriority, LastAccessedTime)
		values (@partitionName, @storageKey, @key, @value, @refreshAction, @expirations, @scavengingPriority, @lastAccessedTime)





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Flush    Script Date: 8/25/2004 3:28:27 PM ******/



CREATE PROCEDURE dbo.Flush
(
	@partitionName varchar(128)
)
AS
	SET NOCOUNT ON

	DELETE [dbo].[CacheData] where PartitionName = @partitionName
	 




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.GetItemCount    Script Date: 8/25/2004 3:28:27 PM ******/



CREATE PROCEDURE dbo.GetItemCount
(
	@partitionName varchar(128)
)
 AS 
	SET NOCOUNT ON

	SELECT COUNT(StorageKey) 
	  FROM [dbo].[CacheData] where PartitionName = @partitionName
	 




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.LoadItems    Script Date: 8/25/2004 3:28:27 PM ******/



CREATE PROCEDURE dbo.LoadItems
(
	@partitionName varchar(128)
)
AS
	select 
		[Key], 
		Value, 
		RefreshAction, 
		Expirations, 
		ScavengingPriority, 
		LastAccessedTime
	from CacheData where PartitionName = @partitionName
	
	SET NOCOUNT ON
	RETURN 




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.RemoveItem    Script Date: 8/25/2004 3:28:27 PM ******/



CREATE PROCEDURE dbo.RemoveItem
	(
		@partitionName varchar(128),
		@storageKey int
	)
AS
	delete from CacheData 
	where StorageKey = @storageKey and PartitionName = @partitionName
	
	SET NOCOUNT ON 
	RETURN 




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.UpdateLastAccessedTime    Script Date: 8/25/2004 3:28:27 PM ******/



CREATE PROCEDURE dbo.UpdateLastAccessedTime
	(
		@partitionName varchar(128),
		@storageKey int,
		@lastAccessedTime DateTime
	)
AS
	update CacheData 
	set LastAccessedTime = @lastAccessedTime where [StorageKey] = @storageKey and PartitionName = @partitionName
	
	SET NOCOUNT ON
	RETURN 




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

