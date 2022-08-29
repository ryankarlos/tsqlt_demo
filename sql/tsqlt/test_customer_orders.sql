
CREATE OR ALTER PROCEDURE testSalesLT.[testGetCustomerOrderDetails]
AS
BEGIN
    IF OBJECT_ID('actual') IS NOT NULL DROP TABLE actual;
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

	---- Create Expected Table -----

	CREATE TABLE expected (
    OrderQty SMALLINT,
    Name NVARCHAR(200),
    ListPrice NUMERIC(6, 2)
	);

	INSERT INTO expected (OrderQty, Name, ListPrice)
	VALUES
            (23,'Classic Vest, S', 63.50),
            (11 ,  'Water Bottle - 30 oz.',4.99 ),
            (12 ,  'Sport-100 Helmet, Black', 34.99 ),
            (15 , 'Short-Sleeve Classic Jersey, XL', 53.99),
            (16 , 'Short-Sleeve Classic Jersey, L', 53.99),
            (17 , 'Bike Wash - Dissolver' ,7.95 )

	------Execution

	CREATE TABLE actual (
    OrderQty SMALLINT,
    Name NVARCHAR(200),
    ListPrice NUMERIC(6, 2)
	);

    DECLARE @custid SMALLINT;
    SET @custid = 29796

    INSERT INTO actual
    EXEC  [SalesLT].GetCustomerOrderDetails @custid
	------Assertion

    EXEC tSQLt.AssertEqualsTable expected, actual;

END;
GO