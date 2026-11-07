/**
========================================================================
                        00_init_db.sql
Database initialization and creation of tables for all 5 financialo statements,
with data imported from processed CSV files using BULK INSERT.
Warning: Existing tables are dropped and recreated, so all previously
stored data in those tables will be deleted.
========================================================================
**/

-- Creating database
IF DB_ID('Analysis_SP500') IS NULL
	CREATE DATABASE Analysis_SP500;
GO

USE Analysis_SP500;
GO


CREATE OR ALTER PROCEDURE dbo.INIT_DB
AS
BEGIN
    SET NOCOUNT ON;

    /**
    ========================================================================
                                Balance Sheet
    ========================================================================
    **/

    IF OBJECT_ID(N'tb_balance', N'U') IS NOT NULL
    DROP TABLE tb_balance;

    CREATE TABLE tb_balance (
            [Ticker] VARCHAR(10) NULL,
            [Fiscal Year] INT NULL,
            [Report Date] DATE NULL,
            [Cash, Cash Equivalents & Short Term Investments] DECIMAL(20,2) NULL,
            [Inventories] DECIMAL(20,2) NULL,
            [Total Current Assets] DECIMAL(20,2) NULL,
            [Total Assets] DECIMAL(20,2) NULL,
            [Short Term Debt] DECIMAL(20,2) NULL,
            [Total Current Liabilities] DECIMAL(20,2) NULL,
            [Long Term Debt] DECIMAL(20,2) NULL,
            [Total Liabilities] DECIMAL(20,2) NULL,
            [Retained Earnings] DECIMAL(20,2) NULL,
            [Total Equity] DECIMAL(20,2) NULL,
            [Total Liabilities & Equity] DECIMAL(20,2) NULL,
            [Accounts & Notes Receivable] DECIMAL(20,2) NULL
        );
    

        BULK INSERT dbo.tb_balance
    FROM 'D:\Analysis-of-the-Financial-Stability-of-Companies-in-the-S-P-500\dataset\processed\balance_cleaned.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        CODEPAGE = '65001',
        ROWTERMINATOR = '0x0a',
        KEEPNULLS,
        TABLOCK
    );
    


    /**
    ========================================================================
                                Cash Flow
    ========================================================================
    **/

    IF OBJECT_ID(N'tb_cashflow', N'U') IS NOT NULL
    DROP TABLE tb_cashflow;

    CREATE TABLE dbo.tb_cashflow (
       [Ticker] VARCHAR(10) NULL,
       [Fiscal Year] INT NULL,
       [Report Date] DATE NULL,
       [Net Cash from Operating Activities] DECIMAL(20,2) NULL,
       [Change in Fixed Assets & Intangibles] DECIMAL(20,2) NULL,
       [Depreciation & Amortization] DECIMAL(20,2) NULL,
       [Dividends Paid] DECIMAL(20,2) NULL,
       [Cash from (Repayment of) Debt] DECIMAL(20,2) NULL,
       [Cash from (Repurchase of) Equity] DECIMAL(20,2) NULL,
       [CapEx] DECIMAL(20,2) NULL,
       [Free Cash Flow] DECIMAL(20,2) NULL
    );
    

    BULK INSERT dbo.tb_cashflow
    FROM 'D:\Analysis-of-the-Financial-Stability-of-Companies-in-the-S-P-500\dataset\processed\cashflow_cleaned.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        CODEPAGE = '65001',
        ROWTERMINATOR = '0x0a',
        KEEPNULLS,
        TABLOCK
    );
    


    /**
    ========================================================================
                                Companies
    ========================================================================
    **/

    IF OBJECT_ID(N'dbo.tb_companies', N'U') IS NOT NULL
        DROP TABLE dbo.tb_companies;
   

    CREATE TABLE dbo.tb_companies (
        [Ticker] VARCHAR(10) NULL,
        [Company Name] VARCHAR(100) NULL,
        [Sector] VARCHAR(100) NULL,
        [Industry] VARCHAR(100) NULL,
        [End of financial year (month)] INT NULL
    );
   

    BULK INSERT dbo.tb_companies
    FROM 'D:\Analysis-of-the-Financial-Stability-of-Companies-in-the-S-P-500\dataset\processed\companies_cleaned.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        CODEPAGE = '65001',
        ROWTERMINATOR = '0x0a',
        KEEPNULLS,
        TABLOCK
    );
    


    /**
    ========================================================================
                                Income
    ========================================================================
    **/

    IF OBJECT_ID(N'tb_income', N'U') IS NOT NULL
        DROP TABLE tb_income;

    CREATE TABLE dbo.tb_income (
        [Ticker] VARCHAR(10) NULL,
        [Fiscal Year] INT NULL,
        [Report Date] DATE NULL,
        [Revenue] DECIMAL(20,2) NULL,
        [Operating Income/Loss] DECIMAL(20,2) NULL,
        [Interest Expense Net] DECIMAL(20,2) NULL,
        [Net Income] DECIMAL(20,2) NULL,
        [Shares Basic] DECIMAL(20,2) NULL,
        [Cost of Revenue] DECIMAL(20,2) NULL
    );
    

    BULK INSERT dbo.tb_income
    FROM 'D:\Analysis-of-the-Financial-Stability-of-Companies-in-the-S-P-500\dataset\processed\income_cleaned.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        CODEPAGE = '65001',
        ROWTERMINATOR = '0x0a',
        KEEPNULLS,
        TABLOCK
    );
    


    /**
    ========================================================================
                                Stock Prices
    ========================================================================
    **/

    IF OBJECT_ID(N'dbo.tb_prices', N'U') IS NOT NULL
        DROP TABLE dbo.tb_prices;
    

    CREATE TABLE dbo.tb_prices (
        [Ticker] VARCHAR(10) NULL,
        [Date] DATE NULL,
        [Close] DECIMAL(20,4) NULL,
        [Adj. Close] DECIMAL(20,4) NULL,
        [Shares Outstanding] DECIMAL(20,2) NULL,
        [Dividend] DECIMAL(20,4) NULL
    );
    

    BULK INSERT dbo.tb_prices
    FROM 'D:\Analysis-of-the-Financial-Stability-of-Companies-in-the-S-P-500\dataset\processed\prices_cleaned.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDQUOTE = '"',
        CODEPAGE = '65001',
        ROWTERMINATOR = '0x0a',
        KEEPNULLS,
        TABLOCK
    );

END
GO

-- Executing procedure
EXEC dbo.INIT_DB;
GO

