# Lead Quality & Conversion Analysis

This project explores how lead quality affects conversion performance in a marketing funnel.  
Using SQL, Excel, and Tableau, the dataset was cleaned, enriched with new metrics, and then visualized through an interactive dashboard.

The main idea behind this analysis was to understand two things:

• Do higher quality leads convert more often?  
• Which acquisition channels bring better leads into the funnel?

The dataset contains around **1,000 marketing leads** with attributes such as acquisition channel, company information, revenue declaration, stock availability, and other lead qualification signals.

Several fields in the dataset had missing values, which made it possible to explore how **data completeness and lead readiness influence conversion outcomes.**

---

## Tools Used

SQL – building the data pipeline and feature engineering  
Excel – initial exploration and validation  
Tableau – building the interactive dashboard and visual analysis

---

## Data Preparation

A SQL pipeline was used to prepare the analysis dataset.

The main steps included:

• Joining the **leads** and **closed_deals** tables  
• Creating a binary **conversion flag**  
• Calculating a **lead readiness score** based on available information  
• Measuring **data completeness** using missing field counts  
• Cleaning categorical variables such as behaviour profile

The final analysis table (`funnel_base`) contains both the raw lead attributes and several engineered metrics used in the dashboard.

---

## Dashboard

An interactive Tableau dashboard was created to explore relationships between lead quality, acquisition channels, and conversion performance.

The dashboard focuses on:

• Lead readiness vs conversion  
• Channel performance in generating conversions  
• Distribution of lead readiness across the dataset  
• Which acquisition channels produce higher quality leads

Tableau Public Dashboard:  
*(paste your Tableau Public link here)*

---

## Key Insights

A few patterns stood out during the analysis:

• Nearly **99% of leads have a readiness score of 0**, indicating that most leads enter the funnel with very little qualifying information.

• Despite this, the overall **conversion rate is around 9%**.

• Channels such as **Paid Search and Organic Search** tend to generate slightly higher readiness leads compared to other sources.

• Improving the quality and completeness of lead data at the acquisition stage could significantly improve lead qualification and conversion outcomes.

---

## Project Structure

lead-quality-conversion-analysis  
│  
├ funnel_base.csv  
├ lead_funnel_pipeline.sql  
├ dashboard_preview.png  
└ README.md  

---

## Author

Shraddha Dangwal
