/*
DECLARE @Prodcttbl AS OrderBulkType

insert into @Prodcttbl 
select 'Product1', 100.00, 2, 'Size~100x50,weight~100grms,color~red' union
select 'Product2', 100.00, 2, 'Size~100x50,shape~roung,color~yellow' union
select 'Product3', 100.00, 2, 'Size~100x50,weight~100grms,color~orange' union
select 'Product4', 100.00, 2, 'Size~100x50' union
select 'Product5', 100.00, 2, 'Size~100x50,weight~100grms,color~white'

EXEC USP_InsertOrder 1, @Prodcttbl, NULL
*/
CREATE PROCEDURE [dbo].[USP_InsertOrder]
(
	@UserId						INT,
	@ProductInfo OrderBulkType  READONLY,
	@Error_message				VARCHAR(1000) = NULL OUTPUT
)
AS
SET NOCOUNT ON
BEGIN

	DECLARE @TBProduct table (Id INT IDENTITY(1,1),
		PRODUCTNAME VARCHAR(100),
		UNITPRICE MONEY,
		QTY INT,
		ATTRDETAILS VARCHAR(MAX),
		[values] varchar(256),
		AttrName varchar(100),
		VALUE VARCHAR(100),
		OrderItemId INT
		)

	BEGIN TRY
	BEGIN TRANSACTION

		INSERT INTO @TBProduct (PRODUCTNAME, UNITPRICE, QTY, ATTRDETAILS, [values])
		SELECT t.*, [value]
		FROM @ProductInfo T
		CROSS APPLY STRING_SPLIT( ATTRDETAILS, ',')

		UPDATE 	@TBProduct 
		SET AttrName = substring([values], 1, charindex('~', [values])-1),
			VALUE  = stuff([values], 1, charindex('~', [values]), '')			

		UPDATE T
		SET OrderItemId = OI.OrderItemId
		FROM @TBProduct T
		INNER JOIN ORDERITEM OI ON T.PRODUCTNAME = OI.PRODUCTNAME

		UPDATE OI
		SET UNITPRICE = T.UNITPRICE,
			QTY = T.QTY,
			UPDATEDON = GETDATE(),
			UPDATEDBY = @USERID
		FROM @TBProduct T
		INNER JOIN ORDERITEM OI ON T.PRODUCTNAME = OI.PRODUCTNAME

		CREATE TABLE #Productdetails (PRODUCTNAME VARCHAR(256),ORDERITEMID INT)

		INSERT INTO ORDERITEM (CreatedBy, CreatedOn, OrderID, ProductName, Qty, UnitPrice, UserID)
		OUTPUT INSERTED.PRODUCTNAME, INSERTED.OrderItemID INTO #Productdetails
		SELECT distinct @USERID, GETDATE(), NULL, ProductName, Qty, UnitPrice, @UserID
		FROM @TBProduct
		WHERE OrderItemId IS NULL
		
		insert into OrderAttr (CREATEDBY, CREATEDON, AttrName,DeletedYN)
		select DISTINCT @UserId, GETDATE(), T.AttrName, 'N'
		from @TBProduct T
		left join OrderAttr  OA ON T.AttrName	= OA.AttrName	
		WHERE OA.AttrName IS NULL

		INSERT INTO ORDERITEMATTR(CREATEDBY, CREATEDON,ORDERITEMID,ORDERATTRID,VALUE)
		SELECT distinct @USERID, GETDATE(), P.ORDERITEMID,OA.OrderAttrID, T.VALUE
		FROM @TBProduct T
		INNER JOIN #Productdetails P ON P.ProductName  = T.PRODUCTNAME
		INNER JOIN OrderAttr OA ON OA.ATTRNAME = T.ATTRNAME

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
		SELECT @Error_message = ERROR_MESSAGE()
	END CATCH

END
SET NOCOUNT OFF
