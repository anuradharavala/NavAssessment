--exec [USP_OrderItemsReport] 1
CREATE PROCEDURE [dbo].[USP_OrderItemsReport]
(
	@UserId INT
)
AS
SET NOCOUNT ON
BEGIN

	SELECT OI.ProductName, OI.UnitPrice, OI.Qty, OA.AttrName, OIA.Value, Oi.CreatedOn
	INTO #TempOrders
	FROM OrderItem OI 
	INNER JOIN ORDERITEMATTR OIA ON OIA.OrderItemId = OI.OrderItemId
	INNER JOIN OrderAttr OA ON OA.OrderAttrID = OIA.OrderAttrID
	WHERE Oi.userid = @UserId

	DECLARE @Attrs VARCHAR(256) = ''

	SELECT @Attrs = @Attrs  + ',' + QUOTENAME(AttrName )
	FROM (SELECT DISTINCT AttrName FROM #TempOrders) T

	SELECT @Attrs  = STUFF(@Attrs , 1, 1, '')

	DECLARE @STRSQL VARCHAR(4000)

	SELECT @STRSQL  = 'SELECT ProductName, UnitPrice, Qty, ' + @Attrs   + ', CreatedOn
	FROM (SELECT * FROM #TempOrders)  TBL
	PIVOT 
	(MAX(Value) FOR AttrName IN (' + @Attrs  + ')) AS PVT'

	EXEC (@STRSQL)  

END
SET NOCOUNT OFF

