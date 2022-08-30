
EXEC tSQLt.NewTestClass 'testExpiredProducts'
GO

CREATE OR ALTER PROCEDURE testExpiredProducts.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = '[SalesLT].Product';
        INSERT INTO [SalesLT].Product
    (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductCategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, ThumbNailPhoto, ThumbnailPhotoFileName, rowguid, ModifiedDate)
    VALUES
            (1, 'Road Frame black', 'FR-H', 'black', 1000.2, 1400.3, '60', 1000.2, 18, 6 ,'2009-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (2, 'Road Frame red', 'HJ-U', 'red', 1000.2, 1400.3, '58', 1200.2, 18, 6 ,'2009-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (3, 'sport helmet', 'LJ-8', 'red', 100.2, 140.3, 'M', 200.2, 35, 5 ,'2006-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','2E1EF41A-C08A-4FF6-8ADA-BDE58B64A712','2008-06-01'),
            (4, 'sport helmet', 'DF-1', 'black', 100.2, 140.3, 'L', 300.2, 35, 5 ,'2006-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','A25A44FB-C2DE-4268-958F-110B8D7621E2','2008-06-01'),
            (5, 'sport helmet', 'JH1', 'blue', 100.2, 100.3, '56', 260.2, 35, 5 ,'2009-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','18F95F47-1540-4E02-8F1F-CC1BCB6828D0','2008-06-01')
END;
GO


CREATE OR ALTER PROCEDURE testExpiredProducts.[testSendEmailIfItemStillBeingAdvertised]
AS
BEGIN
    IF OBJECT_ID('actual') IS NOT NULL DROP TABLE actual;
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

    -------Assemble

    EXEC tSQLt.SpyProcedure 'SalesLT.SendMail';
    EXEC tSQLt.SpyProcedure 'SalesLT.ComputeCurrentYear','SET @currentyear  = CAST(2011 AS NVARCHAR(4))';

    ---Expected

    CREATE TABLE expected (
           ProductID TINYINT NOT NULL,
           Name NVARCHAR(30),
           ProductNumber NVARCHAR(5),
           );
	INSERT INTO expected ( ProductID,  Name,  ProductNumber)
	VALUES
         (3, 'sport helmet ','LJ-8'),
         (4, 'sport helmet ','DF-1')

	------Assertion

    CREATE TABLE actual (
           ProductID TINYINT NOT NULL,
           Name NVARCHAR(30),
           ProductNumber NVARCHAR(5),
       );

    INSERT INTO actual
    EXEC [SalesLT].SendEmailIfItemStillBeingAdvertised
    EXEC tSQLt.AssertEqualsTable expected, actual;


END;
GO


CREATE OR ALTER PROCEDURE testExpiredProducts.[testEmailSPNotCalled]
AS
BEGIN
    IF OBJECT_ID('actual') IS NOT NULL DROP TABLE actual;
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

    -------Assemble

    EXEC tSQLt.SpyProcedure 'SalesLT.SendMail';
    EXEC tSQLt.SpyProcedure 'SalesLT.ComputeCurrentYear','SET @currentyear  = CAST(2009 AS NVARCHAR(4))';


    --- Execute sp

    EXEC [SalesLT].SendEmailIfItemStillBeingAdvertised @MaxExpiry =4;

    -------Assert SalesLT.SendMail did not get called
    IF EXISTS (SELECT 1 FROM SalesLT.SendMail_SpyProcedureLog)
       EXEC tSQLt.Fail 'SalesReport should not have called CurrentReport when @MaxExpiry =4 and @currentyear = 2009';
END;
GO

