USE [AdventureWorksLT2019]
GO

CREATE OR ALTER PROCEDURE [SalesLT].GetCustomerOrderDetails (@customerid SMALLINT, @minitems SMALLINT = 10)
AS
BEGIN
	SELECT OrderQty,Name,ListPrice
	  FROM [SalesLT].SalesOrderHeader JOIN [SalesLT].SalesOrderDetail
			  ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
							JOIN [SalesLT].Product
			  ON SalesOrderDetail.ProductID=Product.ProductID
	WHERE CustomerID=@customerid
	AND OrderQty > @minitems
	ORDER BY ListPrice DESC
END;
GO

CREATE  OR ALTER PROCEDURE [SalesLT].[GetCompanyAddress] (@company NVARCHAR(100))
AS
BEGIN
	SELECT CompanyName,AddressType,AddressLine1
	  FROM [SalesLT].Customer JOIN [SalesLT].CustomerAddress
		ON (Customer.CustomerID=CustomerAddress.CustomerID)
					  JOIN [SalesLT].Address
		ON (CustomerAddress.AddressID=Address.AddressID)
	 WHERE CompanyName=@company
END;
GO

CREATE OR ALTER FUNCTION [SalesLT].GetLargestFreightsbyCustomer (@orderyear AS INT)
RETURNS @freight table (customerid SMALLINT, totalfreight INT)
BEGIN
    INSERT INTO @freight
    SELECT TOP 5 customerid, SUM(freight) AS totalfreight
    FROM SalesLT.SalesOrderHeader
    WHERE YEAR(orderdate) = @orderyear
    GROUP BY customerid
    ORDER BY totalfreight DESC;
    RETURN;
END;
GO
