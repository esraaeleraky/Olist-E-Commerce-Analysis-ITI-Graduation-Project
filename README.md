# 🎓 ITI Graduation Project – Olist E-Commerce Data Analysis

This repository showcases our final graduation project as part of the Power BI track at the Information Technology Institute (ITI).

## 📌 Project Overview

The project simulates a real-world BI pipeline using data from **Olist**, a Brazilian e-commerce marketplace.  
We worked on enhancing raw data, designing a database and data warehouse, building ETL pipelines, and developing dashboards to extract insights that support business decisions.

---

## 📁 Repository Structure

### [`01_Data Source`](./01_Data%20Source)
- `Data Source Link.txt`: Contains the original source of the public dataset used (Olist from Kaggle).

### [`02_Enhanced Data`](./02_Enhanced%20Data)
- `Enhanced_Dataset.xlsx`: Cleaned and enhanced version of the raw data.
- `Gen logistics_companies.py`: Script for generating logistics company sample data.
- `Logical Update for Customer Data.sql`: SQL query to update the customer table.

### [`03_Database`](./03_Database)
- `01 Olist_ERD.drawio.png`: Entity Relationship Diagram (ERD) for the database.
- `02 DB_mapping.jpg`: Defines database tables.
- `03 Olist_DB_Tables.sql`: Scripts to create the Olist database tables.
- `04 DB_Bulk_Insert.sql`: Scripts to insert data into the database.

### [`04_DWH`](./04_DWH)
- `Olist_DWH_Tables.sql`: Scripts to create the data warehouse tables.
- `Star Schema.png`: Visual representation of the star schema.
- `mapping_Olist_DWH.xlsx`: Mapping between database and data warehouse tables.

### [`05_BI`](./05_BI)

#### [`1_SSIS`](./05_BI/1_SSIS) – ETL
- Includes screenshots of the SSIS control flow and data flow for dimensions and fact table.

#### [`2_SSAS`](./05_BI/2_SSAS) – OLAP Cube
- Cube screenshots showing KPIs, calculations, browser, and translation setup.

#### [`3_SSRS`](./05_BI/3_SSRS) – Reporting
- SSRS report screenshots based on both the cube and stored procedures.

### [`06_Model`](./06_Model)
- Jupyter notebook showing exploratory analysis and modeling.

### [`07_Dashboard`](./07_Dashboard)
- `Power BI`: Interactive dashboard summarizing KPIs and insights.
- `Tableau`: Shipping performance overview.

### [`08_Web Application`](./08_Web%20Application)
- A simple web application built to demonstrate how BI insights can be embedded into a user-friendly interface.

### [`09_Presentation`](./09_Presentation)
- Final presentation slide on Canva.

---

## 👥 Team Members

Project developed collaboratively by a team of ITI trainees:

- Amal Ali  
- Esraa Eleraky  
- Kenzy Osama  
- Marwa Ali  
- Rana Ehab  

---

## 📝 Note

Feel free to explore the project and its contents. We hope it serves as a helpful reference for anyone interested in building end-to-end BI solutions.
