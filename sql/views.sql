USE [AdventureWorksLT2019]
GO


IF OBJECT_ID('SalesLT.vw_Products') IS NOT NULL BEGIN
 DROP VIEW [SalesLT].vw_Products;
END;
GO
CREATE VIEW [SalesLT].vw_Products AS (
    SELECT DISTINCT P.Name, P.Color, P.ListPrice, P.StandardCost, PD.Description
    FROM [SalesLT].Product AS P
    INNER JOIN [SalesLT].ProductModel AS PM ON PM.ProductModelID = P.ProductModelID
    INNER JOIN [SalesLT].ProductModelProductDescription AS PMD ON PMD.ProductModelID = PM.ProductModelID
    INNER JOIN [SalesLT].ProductDescription AS PD ON PMD.ProductDescriptionID = PD.ProductDescriptionID
    WHERE PD.Description NOT LIKE '%?%' AND PMD.Culture = 'en'
 );
GO
