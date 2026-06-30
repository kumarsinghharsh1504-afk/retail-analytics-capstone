**Retail Analytics Case Study**



**Project Title**



Retail Analytics Capstone | Customer, Product and Revenue Performance Analysis



**Project Summary**



This project analysed over 1 million cleaned retail transaction rows to understand sales performance, customer value, product demand and market concentration.



The final output is a four page Power BI dashboard supported by Python data cleaning, PostgreSQL storage, SQL analysis views and DAX measures.



Business Problem



The business needed to understand:



1 | When revenue peaks occur

2 | Which customers generate the most value

3 | Which products lead revenue versus volume

4 | How much sales performance depends on the UK market

5 | Which customer and product groups need business action



The goal was not only to show charts, but to turn transaction data into business decisions.



**Tools Used**



Python | PostgreSQL | SQL | Power BI | DAX | Excel



**Data Pipeline**



1 | Python



Python was used to inspect and clean the raw Excel data.



Main tasks included:



1 | Reading multiple Excel sheets

2 | Combining transaction data into one dataset

3 | Checking data types and missing values

4 | Removing duplicate rows

5 | Separating cancelled invoices

6 | Removing invalid negative quantities and zero or negative prices

7 | Creating clean transaction files

8 | Creating validation checks to confirm cleaning quality



2 | PostgreSQL and SQL



PostgreSQL was used to store the cleaned sales data.



SQL was used to create business ready tables and views, including:



1 | Clean sales fact table

2 | Product dimension

3 | Customer dimension

4 | Date dimension

5 | Country dimension

6 | Monthly revenue analysis

7 | Product revenue and units sold analysis

8 | Customer segmentation outputs

9 | Market split analysis



3 | Power BI



Power BI was used to build the final dashboard.



Main tasks included:



1 | Connecting Power BI to PostgreSQL

2 | Building relationships between fact and dimension tables

3 | Creating DAX measures

4 | Designing dashboard pages

5 | Adding slicers and recommendations

6 | Formatting the final dashboard for portfolio use



**Dashboard Pages**



Executive Overview



The Executive Overview page shows total revenue, orders, units sold, identified customers, average order value, monthly revenue trend, top products, market split and customer segment revenue.



Customer Analysis



The Customer Analysis page uses RFM based segmentation to compare customer value, customer count and average recency by segment.



Customer groups include Champions, Loyal customers, At risk high value customers, Needs attention, Hibernating and New or promising customers.



Product Analysis



The Product Analysis page compares top products by merchandise revenue and top products by units sold.



This separates revenue leaders from volume leaders, which helps the business understand both sales value and demand volume.



Project Summary



The Project Summary page explains the business problem, tools used, key findings and recommendations.



Key Insights



1 | Revenue peaks in autumn



Revenue rises strongly around October and November. This suggests the business should prepare stock, staffing and operations before the autumn sales peak.



2 | The UK dominates sales



The UK contributes the majority of total revenue, while international markets are much smaller. This shows the business is heavily dependent on the UK market.



3 | Champions generate the most customer revenue



Champion customers produce the highest customer revenue even though they are not necessarily the largest customer group by count. These customers should be protected through retention activity.



4 | Hibernating customers are large in count but lower in value



Hibernating customers are a large group, but they do not contribute revenue at the same level as Champions. They should receive low cost campaigns rather than expensive retention efforts.



5 | Revenue leaders and volume leaders are different



Some products generate high revenue, while other products sell in high quantities. This matters because revenue leaders support sales value, while volume leaders support demand planning and stock availability.



6 | Administrative charges and outliers should be separated



Administrative charges and unusual one off bulk orders should not be treated as normal product demand because they can distort product performance analysis.



**Business Recommendations**



1 | Prepare stock and staffing before autumn peak months.



2 | Protect Champion customers through retention campaigns.



3 | Reactivate At risk high value customers selectively.



4 | Use low cost campaigns for Hibernating customers.



5 | Track both revenue leading and volume leading products.



6 | Separate administrative charges and outlier transactions from normal product demand.



7 | Monitor UK dependency and international sales cautiously.



**Limitations**



1 | The dataset is historical and does not represent current retail performance.



2 | The dataset does not include profit margin, so revenue does not equal profitability.



3 | The dataset does not include marketing cost or customer acquisition cost.



4 | RFM segmentation is based only on transaction behaviour.



5 | Product recommendations are based on revenue and quantity, not stock cost or supplier constraints.



**What This Project Demonstrates**



This project demonstrates practical ability in:



1 | Data cleaning using Python

2 | SQL transformation and business analysis

3 | PostgreSQL database handling

4 | Power BI data modelling

5 | DAX measure creation

6 | Dashboard design

7 | Customer segmentation

8 | Product analysis

9 | Business recommendation writing



**Relevance To Target Roles**



This project is relevant for:



Business Analyst

Data Analyst

Operations Analyst

Market Research Analyst

Healthcare Analyst

Management Consulting analyst roles



It shows the ability to move from raw data to business insights, which is exactly what analyst and consulting roles require.



