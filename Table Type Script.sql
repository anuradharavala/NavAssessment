CREATE TYPE OrderBulkType AS TABLE
(
PRODUCTNAME VARCHAR(100),
UNITPRICE MONEY,
QTY INT,
ATTRDETAILS VARCHAR(MAX)
)