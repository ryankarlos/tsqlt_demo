
This demo will introduce a package tSQLt, whcih can be used to unit test tsqlt code [1]. All the code used in the 
examples is accessible from this [github repository].

First we will restore the Adventure Works sample database. This database is based on  Adventure Works Cycles, the fictitious multinational manufacturing company created by Microsoft in 2010 [2]. 
The company manufactures and sells metal and composite bicycles to North American, European and Asian commercial markets. 

You can download the database backups  [here](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms) or
from the [db_backup] folder in the repository.
In this demo, we will use the 'AdventureWorksLT2019.bak' file corresponding to the lightweight and pared down version of the OLTP sample.
Unzip and move the content to a location where you would like to store all the backups . On Windows, you will need to install 
SQL Server Developer 2019 and SQL Server Management Studio by following this [link](https://www.sqlservertutorial.net/install-sql-server/) or this [blog](https://www.mssqltips.com/sqlservertip/6608/install-sql-server-2019-standard-edition/). 
Then you can follow the instructions on restoring the backup for AdventureWorks databse [here](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms#restore-to-sql-server)
If you are using a Mac, you can use Azure Data Studio and install sql server using docker.You can follow this [article](https://setapp.com/how-to/install-sql-server) to set this up
and backup the AdventureWorks database .bak file [3]. The only change is that you will have to replace the `AdventureWorks2019.bak` to `AdventureWorksLT2019.bak` as we will be 
using the lightweight version.

The rest of the demo, will assume you are using Management Studio which should be easy to replicate on Azure Data Studio. 
You should have a backup folder already present after installing 
Microsoft SQL server 2019.(`C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup`). Right click on Databases in the object explorer
-> Restore Database and add path to .bak file as in screenshot below. Click OK to restore the database.
Refresh the Database and you should see the `AdventureWorksLT2019` database in the object explorer.

<img src="screenshots/tsqlt/restore_db.png">

Then check to see you have all the tables in the database and run a select query on one of them.

<img src="screenshots/tsqlt/preparesql.png">

Now download [tSQLt](https://tsqlt.org/downloads/).Unzip the file to a location on your hard drive.
and execute the PrepareServer.sql file in SSMS. This will enable  CLR and installs a server certificate that allows the 
installation of the tSQLt CLR as described in the [docs](https://tsqlt.org/user-guide/quick-start/)

<img src="screenshots/tsqlt/preparesql.png">

Next we will need to install tsql to our development database (AdventureWorks), by executing the tSQLt.class.sql script 
(included in the zip file) as described in the [docs](https://tsqlt.org/user-guide/quick-start/#InstallToDevDb).
You should see a bunch of tables (tables folder), views(views folder) and stored procedures (under Programmability -> Stored Procedures)
with tSQLt schema. We will be using some of these stored procedures for testing.

<img src="screenshots/tsqlt/install_tsqlt.png">

The diagram below was generated using SQL Server Database Diagram Tool in SSMS. For more 
instructions on how to do this, check out this [article](https://www.mssqltips.com/sqlservertip/6269/sql-server-database-diagram-tool-in-management-studio/)
The tables in the database, which contain information about product details, customers, and sales orders, are related 
through primary and foreign keys, as shown here

<img src="screenshots/tsqlt/database-diagram-tool.png">
Before you create a test case, you need to create a test class where the test case will be located. 
In tSQLt, all tests are collected under a single class. A class is a schema. 
A test class is a schema configured with an extended property that tells tSQLt that it is a test class.
To create a new class, use the NewTestClass procedure. For example, 

```sql
EXEC tSQLt.NewTestClass 'testSalesLT';
```

This creates a new schema for our test cases, so we can organise and execute tests as a group.
We can add one or more test cases to the test class, so let’s get started doing that.

In tSQLt, a test case is a stored procedure that’s part of a test class and uses tSQLt elements to perform the testing. 
We can develop and test stored procedures and functions in a database.

We have a number of stored procedures in [stored_procedures.sql] and the associated tests for each of the stored procedures stored in the 
[tsqlt] folder.
Open the [stored_procedures.sql] script in SSMS console and execute it. We should see all the procedures created in the object explorer 
with the SalesLT schema.

<img src="screenshots/tsqlt/sp_saleslt.png">

Nowets start by looking at one of the test scripts, [test_company_address.sql].

We use the CREATE PROCEDURE statement to create a test case. The procedure name must start with the word “test” and be 
created in an existing test class; otherwise, making the test case is much like creating any other procedure. 
The script creates a test case named "testGetCompanyAddress" in the "testSalesLT" test class:

As you can see, we are using CREATE OR ALTER PROCEDURE statement to create a test case. The critical part of the test case 
is the main body of the procedure definition, between BEGIN and END.

We will first create a temporary tables, `expected`, to store the expected data. We will insert rows we expect the 
procedure to return when it is executed.

```SQL
	CREATE TABLE expected (
    OrderQty SMALLINT,    Name NVARCHAR(200),
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
```

Now create a temporary table `actual`, which will store data once the stored procedure is successfully run. Both temp 
tables schema are the same. We will execute the stored procedure for customer id `29796`

```SQL
	CREATE TABLE actual (
    OrderQty SMALLINT,
    Name NVARCHAR(200),
    ListPrice NUMERIC(6, 2)
	);

    DECLARE @custid SMALLINT;
    SET @custid = 29796

    INSERT INTO actual
    EXEC  [SalesLT].GetCustomerOrderDetails @custid
```

Finally, we use the tSQLt AssertEqualsTable stored procedure to compare the data in the `actual` and `expected` tables.

```SQL
  EXEC tSQLt.AssertEqualsTable expected, actual;
```

Open the [stored_procedures.sql] script in SSMS console and execute it. We should see the new procedure 

Run the test case using `EXEC tSQLt.Run testSalesLT`. When we run the test case, it should evaluate to true and return the following results:

<img src="screenshots/tsqlt/cust_orders_test_result.png">

### Faking Tables

We can also use tSQLt’s FakeTable stored procedure, which creates a unique temporary table with the same name as 
the table referenced within the actual stored procedure  we are testing. This will ensure that the data in an 
actual database and the table is not updated or deleted. Any subsequent references we make in our test case to that 
table will always point to the test table and not the actual  table in the database. Then we populate the table with 
test data.

###  Setup and teardown procedure



In all the examples, we have used a single test class `testSalesLT` and executed all the tests in the class by 
passing the class name as a parameter to `tSQLt.Run` procedure .e.g `EXEC tSQLt.Run testSalesLT`. However, if we did 
use multiple test classes and wanted to execute all the tests from different classes at once, we can also 
run `EXEC tSQLt.RunAll`, which will run our entire test suite.

## References

1. tSQLt documentation startup guide https://tsqlt.org/user-guide/quick-start/
2. Adventure Works description https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008/ms124825(v=sql.100)?redirectedfrom=MSDN
3. Setup SQL Server and Azure Data Studio on Mac https://setapp.com/how-to/install-sql-server
4. SSMS Database Diagram Tool https://www.mssqltips.com/sqlservertip/6269/sql-server-database-diagram-tool-in-management-studio/
5. Tutorial on SQL Server Unit Testing https://www.sqlshack.com/sql-unit-testing-with-the-tsqlt-framework-for-beginners/
6. Blog on SQL Server 2019 setup on Windows https://www.mssqltips.com/sqlservertip/6608/install-sql-server-2019-standard-edition/