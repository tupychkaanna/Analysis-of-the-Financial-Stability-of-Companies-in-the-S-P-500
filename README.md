# Analysis-of-the-Financial-Stability-of-Companies-in-the-S-P-500
Analysis of 20 S&P 500 companies from the Retail, Technology, Energy and Consumer Goods sectors.  
Data processing, calculation of financial ratios, pattern discovery, and comparison of companies’ financial condition based on five years of financial statements, using SQL and Python. Creation of an interactive Power BI dashboard to visualize the insights.

## Data Source

### Where the data comes from
Financial data was collected with the [`simfin`](https://www.simfin.com) Python package, which provides standardized financial statements and share prices for US-listed companies.

| Dataset | Description | File |
|---------|-------------|------|
| Income statement | Revenue, operating income, interest expense, net income | `income.csv` |
| Balance sheet | Assets, liabilities, equity, debt, inventories | `balance.csv` |
| Cash flow statement | Operating cash flow, CapEx | `cashflow.csv` |
| Share prices | Daily close and adjusted close | `prices.csv` |
| Companies | Ticker, company name, sector, industry | `companies.csv` |

## Financial Ratios Used
The ratios are used in three main approaches:
- **Trend analysis:** comparing a company's ratios across years to see how its financial position changes over time.
- **Cross-sectional analysis:** comparing companies with each other in the same year.
- **DuPont analysis (5-factor):** breaking ROE into five components to see what drives it.

| Category | Ratio | Formula |
|----------|-------|---------|
| Liquidity | Current Ratio | Current Assets / Current Liabilities |
| Liquidity | Quick Ratio | (Current Assets − Inventory) / Current Liabilities |
| Liquidity | Cash Ratio | Cash & Cash Equivalents / Current Liabilities |
| Profitability | Net Profit Margin | Net Income / Revenue |
| Profitability | EBIT Margin | EBIT / Revenue |
| Profitability | Return on Assets (ROA) | Net Income / Total Assets |
| Profitability | Return on Equity (ROE) | Net Income / Total Equity |
| Leverage | Debt-to-Equity | Total Interest-Bearing Debt / Total Equity |
| Leverage | Debt-to-Assets | Total Interest-Bearing Debt / Total Assets |
| Leverage | Equity Multiplier | Total Assets / Total Equity |
| Efficiency | Asset Turnover | Revenue / Total Assets |
| Efficiency | Inventory Turnover | COGS / Inventory |
| Efficiency | Days Sales Outstanding | Accounts Receivable / (Revenue / 365) |
| Efficiency | Days Inventory Outstanding | Inventory / (COGS / 365) |
| Market Value | Price-to-Earnings | Share Price / Earnings Per Share |
| Market Value | Price-to-Book | Share Price / Book Value Per Share |
| Market Value | EV / EBITDA | Enterprise Value / EBITDA |
| Market Value | Dividend Yield | Annual Dividends Per Share / Share Price |
| ROE decomposition | The 5-factor DuPont Formula | Tax Burden × Interest Burden × EBIT Margin × Asset Turnover × Equity Multiplier |

  

### Companies analyzed

| Category | Company Names |
|---|---|
| Retail | Walmart Inc., Target Corporation, The Kroger Co., The Home Depot, Inc., Lowe's Companies, Inc., Dollar General Corporation, Dollar Tree, Inc., Best Buy Co., Inc. |
| Technology | Intel Corporation |
| E-commerce | Amazon.com, Inc. |
| Energy | Exxon Mobil Corporation, Chevron Corporation, ConocoPhillips, SLB Limited, Phillips 66 |
| Consumer Staples | The Coca-Cola Company, PepsiCo, Inc., Colgate-Palmolive Company, Mondelez International, Inc. |
| Financial Services | Aon plc |

## Project Structure
