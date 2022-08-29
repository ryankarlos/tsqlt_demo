
CREATE OR ALTER PROCEDURE testSalesLT.[testGetLargestFreightsbyCustomer]
AS
BEGIN
    IF OBJECT_ID('actual') IS NOT NULL DROP TABLE actual;
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

	---- Create Expected Table -----

	CREATE TABLE expected (
	customerid SMALLINT,
	totalfreight INT
	);

	INSERT INTO expected (customerid, totalfreight)
	VALUES
            (29796,1951),
            (29957 ,2096),
            (29546 ,2220),
            (30050 ,2457),
            (29736, 2714)

	------Execution for year 2008

	CREATE TABLE actual (
	customerid SMALLINT,
	totalfreight INT
	);

    INSERT INTO actual
    SELECT * FROM SalesLT.GetLargestFreightsbyCustomer(2008)
	------Assertion

    EXEC tSQLt.AssertEqualsTable expected, actual;

END;
GO