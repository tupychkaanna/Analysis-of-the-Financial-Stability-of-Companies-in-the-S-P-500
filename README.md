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

### Companies analyzed

| Sector | Companies |
|--------|-----------|
| Retail | Walmart (WMT), Target (TGT), Kroger (KR), Home Depot (HD), Amazon (AMZN), Lowe's (LOW), Dollar General (DG), Dollar Tree (DLTR), Best Buy (BBY) |
| Technology | Alphabet (GOOGL), Intel (INTC) |
| Energy | Exxon Mobil (XOM), Chevron (CVX), ConocoPhillips (COP), Schlumberger (SLB), Phillips 66 (PSX) |
| Consumer Goods | Coca-Cola (KO), PepsiCo (PEP), Colgate-Palmolive (CL), Mondelez (MDLZ) |

Banks and insurers were excluded because their balance sheets are not comparable with other sectors (current ratio and Altman Z-score do not apply to them).

## Project Structure
