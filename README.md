# Optimizing Online Sports Retail Revenue 

This project involves creating and analyzing a structured retail product database using SQL. It covers database design, data cleaning, and complex revenue analytics focused on brands like Nike and Adidas.

## Objective:
The goal of this project is to improve revenue of online Retail Company and produce recommendations for its marketing and sales teams.

<img width="500" height="400" alt="Screenshot (144)" src="https://github.com/user-attachments/assets/efce5bd1-fd76-4f2c-b82a-097f0ba1732b" />
<img width="500" height="400" alt="Screenshot (145)" src="https://github.com/user-attachments/assets/be55ec53-eccf-471b-a4e7-8a234b3bac9d" />

## Schema Design:
The database contains the following core tables:
- `info(product_id, product_name, description)`
- `finance(product_id, listing_price, sale_price, discount, revenue)`
- `brands(product_id, brand)`
- `reviews(product_id, rating, reviews)`
- `traffic(product_id, last_visited)`
## Insights:
- Initializes the database schema by creating tables for product info, financials, reviews, brands, and traffic.
-  Performs data quality checks and removes records with missing or unimportant values.
- Executes various business insights and aggregations including brand revenue, discount strategies, product rankings, and more.



##  Data Cleaning Highlights:

- Identified products with:
  - Missing brand names
  - Missing finance details
  - Missing last visited timestamps
  - Removed all such inconsistent records across all tables using a temporary table approach.
  
## Key Queries:
🔹 **Brand-wise Revenue** & their percentage share in total revenue  
🔹 **Revenue by Discount Strategy** for Adidas and Nike  
🔹 **Product Price Categorization** (Low/Medium/High/Very High)  
🔹 **Correlation** between revenue and review count  
🔹 **Impact of Description Length** on average product rating  
🔹 **Top Revenue Generating Products**  
🔹 **Footwear vs Clothing Median Revenue Comparison**  
🔹 **Monthly Review Activity by Brand**
