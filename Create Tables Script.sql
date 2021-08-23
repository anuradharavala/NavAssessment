CREATE TABLE [dbo].[User]
(
	[UserID] INT IDENTITY(1,1) PRIMARY KEY,
	First_Name VARCHAR(256),
	Last_Name VARCHAR(256),
	Addr1 VARCHAR(256),
	Addr2 VARCHAR(100),
	City VARCHAR(256),
	State VARCHAR(100),
	Zip varchar(50),
	Active_YN varchar(1)
)

CREATE TABLE [dbo].[Order](
	[OrderID] [int] IDENTITY(1,1) Primary key,
	[CreatedBy] [int],
	[CreatedOn] [datetime],
	[UpdatedBy] [int],
	[UpdatedOn] [datetime],
	[OrderNumber] [varchar](50) NULL,
	[OrderDate] [datetime],
	[UserID] [int],
	[TrackingNumber] [varchar](4000) NULL,
	[NeedByDate] [datetime] NULL,
	[RushYN] [varchar](3) NULL,
	[OrderStatus_ID] [int] NULL
)
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_User_UserId] FOREIGN KEY(UserId)
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_User_UserId]
GO


CREATE TABLE [dbo].[OrderItem](
	[OrderItemID] [int] IDENTITY(1,1) primary key,
	[CreatedBy] [int],
	[CreatedOn] [datetime],
	[UpdatedBy] [int],
	[UpdatedOn] [datetime],
	[OrderID] [int] NULL,
	ProductName VARCHAR(256),
	[Qty] [int] NULL,
	[UnitPrice] [float] NULL,
	[UserID] [int],
	[DeletedYN] [varchar](1) NULL
)
GO

ALTER TABLE [dbo].[OrderItem] ADD  CONSTRAINT [DF_OrderItem_DeletedYN]  DEFAULT ('N') FOR [DeletedYN]
GO

ALTER TABLE [dbo].[OrderItem]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_OrderItem_OrderID] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO

ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_Order_OrderItem_OrderID]
GO
ALTER TABLE [dbo].[OrderItem]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderItem_User_UserId] FOREIGN KEY(UserId)
REFERENCES [dbo].[User] ([UserID])
GO

ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_User_UserId]
GO

--To hold attribute names
CREATE TABLE OrderAttr 
(
	OrderAttrId INT IDENTITY(1,1) PRIMARY KEY, 
	[CreatedBy] [int],
	[CreatedOn] [datetime],
	[UpdatedBy] [int],
	[UpdatedOn] [datetime],
	AttrName	VARCHAR(256),
	DeletedYN	VARCHAR(1)
)

--To hold attribute values related to order
CREATE TABLE [dbo].[OrderItemAttr](
	[OrderItemAttrID] [int] IDENTITY(1,1) PRIMARY KEY,
	[CreatedBy] [int],
	[CreatedOn] [datetime],
	[UpdatedBy] [int],
	[UpdatedOn] [datetime],
	[OrderItemID] [int],
	[OrderAttrId] [INT],
	[Value] [nvarchar](2000) NULL
)

ALTER TABLE [dbo].[OrderItemAttr]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderItemAttr_OrderItem_OrderItemID] FOREIGN KEY([OrderItemID])
REFERENCES [dbo].[OrderItem] ([OrderItemID])
GO

ALTER TABLE [dbo].[OrderItemAttr] CHECK CONSTRAINT [FK_OrderItemAttr_OrderItem_OrderItemID]
GO

ALTER TABLE [dbo].[OrderItemAttr]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderItemAttr_OrderAttrId] FOREIGN KEY(OrderAttrId)
REFERENCES [dbo].OrderAttr (OrderAttrId)
GO

ALTER TABLE [dbo].[OrderItemAttr] CHECK CONSTRAINT [FK_OrderItemAttr_OrderAttrId]
GO

CREATE TABLE [dbo].[OrderItem_history](
OrderItem_historyId INT IDENTITY(1,1) PRIMARY KEY,
	[OrderItemID] [int],
	[CreatedBy] [int],
	[CreatedOn] [datetime],
	[UpdatedBy] [int],
	[UpdatedOn] [datetime],
	[OrderID] [int] NULL,
	ProductName VARCHAR(256),
	[Qty] [int] NULL,
	[UnitPrice] [float] NULL,
	[UserID] [int],
	[DeletedYN] [varchar](1) NULL
)