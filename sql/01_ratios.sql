/*
Creating views that group financial ratios by category:
Liquidity, Profitability, Leverage, Efficiency, Market Value, and ROE Decomposition.
*/

USE Analysis_SP500;
GO

/*
============================================================================
						Liquidity Ratios
============================================================================
*/

CREATE OR ALTER VIEW dbo.vw_liquidity AS
SELECT 
    Ticker,
    [Fiscal Year],
    CAST([Total Current Assets] * 1.0 /
        NULLIF([Total Current Liabilities], 0) AS DECIMAL(10,2)) AS Current_Ratio,
    CAST(([Total Current Assets] - ISNULL(Inventories, 0)) * 1.0 /
        NULLIF([Total Current Liabilities], 0) AS DECIMAL(10,2)) AS Quick_Ratio,
    CAST([Cash, Cash Equivalents & Short Term Investments] * 1.0 /
        NULLIF([Total Current Liabilities], 0) AS DECIMAL(10,2)) AS Cash_Ratio
FROM dbo.tb_balance;
GO

/*
============================================================================
						 Profitability Margin
============================================================================
*/

CREATE OR ALTER VIEW dbo.vw_prof_margin AS
SELECT 
    Ticker,
    [Fiscal Year],
    [Report Date],
    CAST([Net Income] / [Revenue] AS DECIMAL(10,3)) AS Net_Profit_Margin,
    CAST([Operating Income/Loss] / [Revenue] AS DECIMAL(10,3)) AS Operating_Profit_Margin,
    CAST([Net Income] /
                    ([Operating Income/Loss]-[Interest Expense Net])
                    AS DECIMAL(10,3)) AS Tax_Burden,
    CAST(([Operating Income/Loss]-[Interest Expense Net]) / 
                    [Operating Income/Loss] 
                    AS DECIMAL(10,3)) AS Interest_Burden
FROM tb_income;
GO

/*
============================================================================
						 Profitability Returns
============================================================================
*/

CREATE OR ALTER VIEW dbo.vw_prof_returns AS
SELECT 
    inc.Ticker,
    inc.[Fiscal Year],
    CAST(inc.[Net Income] / bal.[Total Assets] AS DECIMAL(10,2)) AS Return_On_Assets,
    CAST(inc.[Net Income] / bal.[Total Equity] AS DECIMAL(10,2)) AS Return_On_Equity
FROM tb_income inc
INNER JOIN tb_balance bal
ON inc.Ticker = bal.Ticker AND inc.[Fiscal Year] = bal.[Fiscal Year];
GO

/*
============================================================================
						    Leverage
============================================================================
*/

CREATE OR ALTER VIEW dbo.vw_leverage AS
SELECT 
    Ticker,
    [Fiscal Year],
    [Report Date],
    CAST(([Short Term Debt] + [Long Term Debt]) / [Total Equity] AS DECIMAL(10,2)) AS Debt_To_Equity,
    CAST(([Short Term Debt] + [Long Term Debt]) / [Total Assets] AS DECIMAL(10,2)) AS Debt_To_Assets,
    CAST([Total Assets] / [Total Equity] AS DECIMAL(10,2)) AS Equity_Multiplier
FROM tb_balance;
GO

/*
============================================================================
						    Efficiency
============================================================================
*/

CREATE OR ALTER VIEW dbo.vw_efficiency AS
SELECT 
    inc.Ticker,
    inc.[Fiscal Year],
    CAST(inc.Revenue / bal.[Total Assets] AS DECIMAL(10,2)) AS Asset_Turnover,
    CAST(ABS(inc.[Cost of Revenue]) / bal.Inventories AS DECIMAL(10,2)) as Inventory_Turnover,

    CAST(bal.[Accounts & Notes Receivable] / 
                              (inc.Revenue/365) AS DECIMAL(10,2)) as Days_Sales_Outstanding,

    CAST(bal.Inventories / 
                              (ABS(inc.[Cost of Revenue])/365) AS DECIMAL(10,2)) as Days_Inventory_Outstanding
FROM tb_income inc
INNER JOIN tb_balance bal
ON inc.Ticker = bal.Ticker AND inc.[Fiscal Year] = bal.[Fiscal Year];
GO

/*
============================================================================
						    Market Value
============================================================================
*/

CREATE OR ALTER VIEW dbo.vw_market_value AS
SELECT 
    inc.Ticker,
    pr.[Date],
    CAST(pr.[Close] / 
         NULLIF(inc.[Net Income] / pr.[Shares Outstanding], 0)
         AS DECIMAL(10,2)) AS Price_to_Earnings,

    CAST(pr.[Close] / 
         NULLIF((bal.[Total Assets] - (bal.[Short Term Debt] + bal.[Long Term Debt])) / pr.[Shares Outstanding], 0)
         AS DECIMAL(10,2)) AS Price_to_Book,

    CAST(
         ( (pr.[Close] * pr.[Shares Outstanding])
           + bal.[Total Liabilities]
           - bal.[Cash, Cash Equivalents & Short Term Investments] )
         / NULLIF(inc.[Operating Income/Loss] + cf.[Depreciation & Amortization], 0)
         AS DECIMAL(10,2)) AS EV_EBITDA
FROM tb_income inc
INNER JOIN tb_prices pr
    ON inc.Ticker = pr.Ticker AND inc.[Fiscal Year] = YEAR(pr.[Date])
INNER JOIN tb_balance bal
    ON bal.Ticker = pr.Ticker AND bal.[Fiscal Year] = YEAR(pr.[Date])
INNER JOIN tb_cashflow cf
    ON cf.Ticker = pr.Ticker AND cf.[Fiscal Year] = YEAR(pr.[Date]);
GO

CREATE OR ALTER VIEW dbo.vw_dividend_yield AS
SELECT 
    pr.Ticker,
    pr.[Date],
    CAST(div.Annual_DPS / NULLIF(pr.[Close], 0) * 100 AS DECIMAL(10,2)) AS Dividend_Yield
FROM tb_prices pr
INNER JOIN (
    SELECT Ticker, YEAR([Date]) AS Fiscal_Year, SUM(Dividend) AS Annual_DPS
    FROM tb_prices
    GROUP BY Ticker, YEAR([Date])
    HAVING SUM(Dividend) IS NOT NULL
) div
    ON div.Ticker = pr.Ticker AND div.Fiscal_Year = YEAR(pr.[Date]);
GO

/*
============================================================================
						   ROE decomposition
============================================================================
*/

CREATE OR ALTER VIEW vw_roe_decomp AS
SELECT 
    mg.Ticker,
    mg.[Fiscal Year],
    (
    Tax_Burden *
    Interest_Burden *
    Operating_Profit_Margin *
    Asset_Turnover *
    Equity_Multiplier
    ) as ROE_Decomposition
FROM vw_prof_margin mg
LEFT JOIN vw_efficiency ef
ON mg.Ticker = ef.Ticker AND mg.[Fiscal Year] = ef.[Fiscal Year]
LEFT JOIN vw_leverage lv
ON mg.Ticker = lv.Ticker AND mg.[Fiscal Year] = lv.[Fiscal Year];
GO

/*
============================================================================
						   Combining all views
============================================================================
*/

CREATE OR ALTER VIEW vw_views AS
SELECT 
    liq.Ticker,
    liq.[Fiscal Year],

    -- Liquidity
    liq.Current_Ratio,
    liq.Quick_Ratio,
    liq.Cash_Ratio,

    -- Profitability margins
    mg.Net_Profit_Margin,
    mg.Operating_Profit_Margin,
    mg.Tax_Burden,
    mg.Interest_Burden,

    -- Profitability returns
    ret.Return_On_Assets,
    ret.Return_On_Equity,

    -- Leverage
    lev.Debt_To_Equity,
    lev.Debt_To_Assets,
    lev.Equity_Multiplier,

    -- Efficiency
    ef.Asset_Turnover,
    ef.Inventory_Turnover,
    ef.Days_Sales_Outstanding,
    ef.Days_Inventory_Outstanding,

    -- ROE decomposition
    roe.ROE_Decomposition
FROM vw_liquidity liq
LEFT JOIN vw_prof_margin mg
ON liq.Ticker = mg.Ticker AND liq.[Fiscal Year] = mg.[Fiscal Year]
LEFT JOIN vw_prof_returns ret
ON liq.Ticker = ret.Ticker AND liq.[Fiscal Year] = ret.[Fiscal Year]
LEFT JOIN vw_leverage lev
ON liq.Ticker = lev.Ticker AND liq.[Fiscal Year] = lev.[Fiscal Year]
LEFT JOIN vw_efficiency ef
ON liq.Ticker = ef.Ticker AND liq.[Fiscal Year] = ef.[Fiscal Year]
LEFT JOIN vw_roe_decomp roe
ON liq.Ticker = roe.Ticker AND liq.[Fiscal Year] = roe.[Fiscal Year];
GO

CREATE OR ALTER VIEW vw_shares AS
SELECT 
    mv.Ticker,
    mv.[Date], 

    -- Market Value
    mv.Price_to_Book,
    mv.Price_to_Earnings,
    mv.EV_EBITDA,

    -- Dividend Yield
    dy.Dividend_Yield
FROM vw_market_value mv
LEFT JOIN vw_dividend_yield dy 
ON mv.Ticker = dy.Ticker AND mv.[Date] = dy.[Date];
GO

/*
============================================================================
						   Overview
============================================================================
*/

SELECT *
FROM vw_views

GO

SELECT *
FROM vw_shares;

GO