CREATE OR ALTER PROC testSalesLT.[testAdventureWorksRequiredTablesCreated]
AS
BEGIN
    EXEC tSQLt.AssertObjectExists 'SalesLT.Customer';
	EXEC tSQLt.AssertObjectExists 'SalesLT.Address';
	EXEC tSQLt.AssertObjectExists 'SalesLT.CustomerAddress';
	EXEC tSQLt.AssertObjectExists 'SalesLT.Product';
	EXEC tSQLt.AssertObjectExists 'SalesLT.ProductCategory';
	EXEC tSQLt.AssertObjectExists 'SalesLT.ProductModel';
	EXEC tSQLt.AssertObjectExists 'SalesLT.ProductDescription';
	EXEC tSQLt.AssertObjectExists 'SalesLT.ProductModelProductDescription';
	EXEC tSQLt.AssertObjectExists 'SalesLT.SalesOrderDetail';
	EXEC tSQLt.AssertObjectExists 'SalesLT.SalesOrderHeader';
END;
GO

CREATE OR ALTER PROC testSalesLT.[testAdventureWorksCheckViewsDeleted]
AS
BEGIN
    EXEC tSQLt.AssertObjectDoesNotExist 'SalesLT.vProductModelCatalogDescription';
    EXEC tSQLt.AssertObjectDoesNotExist 'SalesLT.vProductAndDescription';
END;
GO