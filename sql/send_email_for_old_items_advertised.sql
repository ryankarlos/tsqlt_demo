
USE AdventureWorksLT2019
GO

SP_CONFIGURE 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
GO

SP_CONFIGURE 'Database Mail XPs', 1
RECONFIGURE WITH OVERRIDE
GO

SP_CONFIGURE 'show advanced options', 0
RECONFIGURE WITH OVERRIDE
GO

CREATE OR ALTER PROCEDURE [SalesLT].ComputeCurrentYear (@currentyear NVARCHAR(4) OUTPUT)
AS
   SELECT @currentyear = YEAR(GETDATE())
GO

CREATE OR ALTER PROCEDURE [SalesLT].[SendMail]
AS
    EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'Joe Bloggs'
   ,@recipients = 'joebloggs@gmail.com'
   ,@subject = 'Email from AdventureWorks'
   ,@body = 'Item is still being advertised'
   ,@importance ='HIGH'
GO


CREATE OR ALTER PROCEDURE [SalesLT].SendEmailIfItemStillBeingAdvertised (@MaxExpiry INTEGER =3)
AS
BEGIN
    DECLARE @year NVARCHAR(4);
    EXEC [SalesLT].ComputeCurrentYear @currentyear = @year OUTPUT;

    IF (SELECT COUNT(*)
            FROM [SalesLT].Product
            WHERE (@year - YEAR(SellStartDate)) > @MaxExpiry
            ) > 0
        BEGIN
            SELECT ProductID,  Name,  ProductNumber
            FROM [SalesLT].Product
            WHERE (@year - YEAR(SellStartDate)) > @MaxExpiry;
            EXEC [SalesLT].[SendMail];
        END
    ELSE
        PRINT 'All items within expiry period'
END;
GO
