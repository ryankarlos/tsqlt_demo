CREATE OR ALTER PROCEDURE testSalesLT.[testGetCompanyAddress]
AS
BEGIN
    IF OBJECT_ID('actual') IS NOT NULL DROP TABLE actual;
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

	---- Create Expected Table -----

	CREATE TABLE expected (
	CompanyName NVARCHAR(100),
	AddressType NVARCHAR(30),
	AddressLine1 NVARCHAR(500)
	);

	INSERT INTO expected (CompanyName, AddressType, AddressLine1)
	VALUES
			('Modular Cycle Systems', 'Main Office','800 Interchange Blvd.'),
			( 'Modular Cycle Systems','Shipping','165 North Main')

	------Execution


	CREATE TABLE actual (
	CompanyName NVARCHAR(100),
	AddressType NVARCHAR(30),
	AddressLine1 NVARCHAR(500)
	);

    DECLARE @companyname NVARCHAR(100);
    SET @companyname = 'Modular Cycle Systems';

    INSERT INTO actual
    EXEC  [SalesLT].GetCompanyAddress @companyname
	------Assertion

    EXEC tSQLt.AssertEqualsTable expected, actual;

END;
GO