
CREATE OR ALTER PROCEDURE testSalesLT.[testvwProducts]
AS
BEGIN
    IF OBJECT_ID('actual') IS NOT NULL DROP TABLE actual;
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

    EXEC tSQLt.FakeTable @TableName = '[SalesLT].Product';
    EXEC tSQLt.FakeTable @TableName = '[SalesLT].ProductModelProductDescription'
    EXEC tSQLt.FakeTable @TableName = '[SalesLT].ProductModel'
    EXEC tSQLt.FakeTable @TableName = '[SalesLT].ProductDescription'


    INSERT INTO [SalesLT].Product
    (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductCategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, ThumbNailPhoto, ThumbnailPhotoFileName, rowguid, ModifiedDate)
    VALUES
            (1, 'Road Frame black', 'FR-H', 'black', 1000.2, 1400.3, '60', 1000.2, 18, 6 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (2, 'Road Frame red', 'HJ-U', 'red', 1000.2, 1400.3, '58', 1200.2, 18, 6 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (3, 'sport helmet', 'LJ-8', 'red', 100.2, 140.3, 'M', 200.2, 35, 5 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','2E1EF41A-C08A-4FF6-8ADA-BDE58B64A712','2008-06-01'),
            (4, 'sport helmet', 'DF-1', 'black', 100.2, 140.3, 'L', 300.2, 35, 5 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','A25A44FB-C2DE-4268-958F-110B8D7621E2','2008-06-01'),
            (5, 'sport helmet', 'JH1', 'blue', 100.2, 100.3, '56', 260.2, 35, 5 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','18F95F47-1540-4E02-8F1F-CC1BCB6828D0','2008-06-01'),
            (6, 'classic vest', 'HJ1', 'blue', 100.2, 140.3, 'M', NULL, 20, 8 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','161C035E-21B3-4E14-8E44-AF508F35D80A','2008-06-01'),
            (7, 'mens shorts -M', 'OK6', 'black', 60.2, 90.3, 'M', 30, 35, 9 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','FD7C0858-4179-48C2-865B-ABD5DFC7BC1D','2008-06-01'),
            (8, 'mens shorts -L', 'UC-9', 'blue', 60.2, 90.5, 'L', 30, 35, 9 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','B9EDE243-A6F4-4629-B1D4-FFE1AEDC6DE7','2008-06-01'),
            (9, 'long jersey', 'ZC-4', 'red', 90.5,105.3, 'M', 200.2, 60, 13 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','FD449C82-A259-4FAE-8584-6CA0255FAF68','2008-06-01'),
            (10, 'awc cap', 'ZC-3', 'green', 50.2, 70.3, 'M', 300.2, 10, 11 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','6A290063-A0CF-432A-8110-2EA0FDA14308','2008-06-01'),
            (11, 'cable lock', 'FS-3', NULL, 20.2, 30.3, NULL, NULL, 90, 2 ,'2008-06-01',NULL,NULL,CAST(123456 AS BINARY(2)),'EEE','34CF5EF5-C077-4EA0-914A-084814D5CBD5','2008-06-01')


    INSERT INTO [SalesLT].ProductModel
    (ProductModelID, Name, CatalogDescription, rowguid, ModifiedDate)
    VALUES
            (6, 'Road Frame black',  'durable Road Frame',  '43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (6, 'Road Frame red','durable Road Frame', '43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (5, 'sport helmet','durable sport helmet', '2E1EF41A-C08A-4FF6-8ADA-BDE58B64A712','2008-06-01'),
            (5, 'sport helmet','durable sport helmet', 'A25A44FB-C2DE-4268-958F-110B8D7621E2','2008-06-01'),
            (5, 'sport helmet','durable sport helmet', '18F95F47-1540-4E02-8F1F-CC1BCB6828D0','2008-06-01'),
            (8, 'classic vest','durable classic vest', '161C035E-21B3-4E14-8E44-AF508F35D80A','2008-06-01'),
            (9, 'mens shorts -M','durable shorts', 'FD7C0858-4179-48C2-865B-ABD5DFC7BC1D','2008-06-01'),
            (9, 'mens shorts -L','durable shorts', 'B9EDE243-A6F4-4629-B1D4-FFE1AEDC6DE7','2008-06-01'),
            (13, 'long jersey','durable jersey', 'FD449C82-A259-4FAE-8584-6CA0255FAF68','2008-06-01'),
            (11, 'awc cap','durable cap', '6A290063-A0CF-432A-8110-2EA0FDA14308','2008-06-01'),
            (2, 'cable lock','durable lock', '34CF5EF5-C077-4EA0-914A-084814D5CBD5','2008-06-01')


    INSERT INTO [SalesLT].ProductModelProductDescription
    (ProductModelID, ProductDescriptionID, Culture, rowguid, ModifiedDate)
    VALUES
            (6, 1211, 'en',  '43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (6, 1211,'en', '43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (5, 230,'fr', '2E1EF41A-C08A-4FF6-8ADA-BDE58B64A712','2008-06-01'),
            (5, 230, 'en', 'A25A44FB-C2DE-4268-958F-110B8D7621E2','2008-06-01'),
            (5, 230, 'en', '18F95F47-1540-4E02-8F1F-CC1BCB6828D0','2008-06-01'),
            (8, 700,'en', '161C035E-21B3-4E14-8E44-AF508F35D80A','2008-06-01'),
            (9, 600,'en', 'FD7C0858-4179-48C2-865B-ABD5DFC7BC1D','2008-06-01'),
            (9, 600, 'en', 'B9EDE243-A6F4-4629-B1D4-FFE1AEDC6DE7','2008-06-01'),
            (13,1300,'en','FD449C82-A259-4FAE-8584-6CA0255FAF68','2008-06-01'),
            (11,1540,'fr','6A290063-A0CF-432A-8110-2EA0FDA14308','2008-06-01'),
            (2, 340, 'en', '34CF5EF5-C077-4EA0-914A-084814D5CBD5','2008-06-01')

    INSERT INTO [SalesLT].ProductDescription
    (ProductDescriptionID, Description, rowguid, ModifiedDate)
    VALUES
            (1211, 'nice Road Frame', '43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (1211,'nice Road Frame', '43DD68D6-14A4-461F-9069-55309D90EA7E','2008-06-01'),
            (230,'nice helmet', '2E1EF41A-C08A-4FF6-8ADA-BDE58B64A712','2008-06-01'),
            (230, 'nice helmet', 'A25A44FB-C2DE-4268-958F-110B8D7621E2','2008-06-01'),
            (230, 'nice helmet', '18F95F47-1540-4E02-8F1F-CC1BCB6828D0','2008-06-01'),
            (700,'nice vest','161C035E-21B3-4E14-8E44-AF508F35D80A','2008-06-01'),
            (600,'nice shorts', 'FD7C0858-4179-48C2-865B-ABD5DFC7BC1D','2008-06-01'),
            (600, 'nice shorts', 'B9EDE243-A6F4-4629-B1D4-FFE1AEDC6DE7','2008-06-01'),
            (1300,'nice jersey','FD449C82-A259-4FAE-8584-6CA0255FAF68','2008-06-01'),
            (1540,'nice cap','6A290063-A0CF-432A-8110-2EA0FDA14308','2008-06-01'),
            (340, 'nice lock',  '34CF5EF5-C077-4EA0-914A-084814D5CBD5','2008-06-01')
	---- Create Expected Table -----

	CREATE TABLE expected (
           Name NVARCHAR(200) NOT NULL,
           Color NVARCHAR(20),
           ListPrice NUMERIC(6, 2),
           StandardCost NUMERIC(6,2),
           Description NVARCHAR(200),
           );
	INSERT INTO expected ( Name,  Color,  ListPrice, StandardCost, Description)
	VALUES
         ('cable lock' , NULL,30.30 ,20.20 ,'nice lock' ),
         ('classic vest ' ,'blue' ,140.30 ,100.20 ,'nice vest' ),
         ('long jersey' ,'red' ,105.30 ,90.50,'nice jersey'),
         ('mens shorts -L ','blue' ,90.50,60.20 ,'nice shorts' ),
         ('mens shorts -M' ,'black',90.30,60.20  ,'nice shorts'),
         ('Road Frame black','black' ,1400.30 ,1000.20 ,'nice Road Frame'),
         ('Road Frame red','red'  ,1400.30 ,1000.20 ,'nice Road Frame'),
         ('sport helmet','black',140.30,100.20 ,'nice helmet'),
         ('sport helmet' ,'blue',100.30 ,100.20 ,'nice helmet' ),
         ('sport helmet ','red'  ,140.30 ,100.20 ,'nice helmet' )


	------Assertion

    CREATE TABLE actual (
       Name NVARCHAR(200) NOT NULL,
       Color NVARCHAR(20),
       ListPrice NUMERIC(6, 2),
       StandardCost NUMERIC(6,2),
       Description NVARCHAR(200),
       );

    INSERT INTO actual
	SELECT * FROM [SalesLT].[vw_Products]

    EXEC tSQLt.AssertEqualsTable expected, actual;

END;
GO