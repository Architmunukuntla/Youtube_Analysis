# README.md — YOUTUBE VIDEO ANALYSIS (BIG DATA PROJECT)

# YouTube Video Analysis – Big Data Project (Databricks + PySpark)

## 1. Project Overview

This project performs an end-to-end Big Data analysis of YouTube video performance using **Databricks (Free Edition)**, **PySpark**, **Spark SQL**, and **Lakeview Dashboards**.

The goals are to understand:

- Which content categories receive the most views  
- How engagement varies across categories  
- How popularity changes across publishing years  
- Patterns in video performance using engineered metrics  

The workflow includes:

- Data ingestion  
- Cleaning & feature engineering  
- PySpark and SQL analysis  
- Dashboard creation with 3 KPI-based tiles  
- GitHub documentation  

## 2. Dataset Description

Source file: `YouTube_Analysis.csv`

### **Columns:**
- `Title`
- `channel_title`
- `published_at`
- `category_id`
- `view_count`
- `like_count`
- `comment_count`
- `favorite_count`
- `duration`
- `definition`
- `caption`
- `engagement_rate`
- `likes_to_views_ratio`
- `comments_to_views_ratio`
- `duration_seconds`
- `video_age_days`


## 3. Tools & Technologies

- Databricks (Free Edition)  
- PySpark  
- Spark SQL  
- Databricks Lakeview Dashboards  
- GitHub  


## 4. Data Pipeline

### 4.1 Ingestion  

Notebook: `01_ingest_and_clean_youtube.ipynb`

Steps:
1. Uploaded the CSV file into Databricks.  
2. Created raw table:


main.default.raw_youtube



### 4.2  Cleaning & Feature Engineering  

Performed in `01_ingest_and_clean_youtube.ipynb`.

Key transformations:

### Timestamp Cleanup  
- Converted `published_at` → proper timestamp  

### Numeric Casting  
Converted the following to numeric types:
- `view_count`
- `like_count`
- `comment_count`
- `favorite_count`
- `engagement_rate`
- `likes_to_views_ratio`
- `comments_to_views_ratio`
- `duration_seconds`
- `video_age_days`

### New Engineered Columns  
- `publish_year`  
- `popularity_level`
  - Low (<10,000 views)
  - Medium (10,000–100,000 views)
  - High (>100,000 views)  
- `video_age_group`:
  - Last 30 Days  
  - Last Year  
  - Older  

Final cleaned table stored as:


main.default.clean_youtube


## 5.  Exploratory Analysis  

Notebook: `02_analysis_notebook.ipynb`

### 5.1 PySpark Analysis Examples  

#### Total Views by Category
python
from pyspark.sql.functions import sum

df_views_by_category = (
    df.groupBy("category_id")
      .agg(sum("view_count").alias("total_views"))
      .orderBy("total_views", ascending=False)
)


####  Average Engagement Rate by Category

```python
from pyspark.sql.functions import avg

df_engagement = (
    df.groupBy("category_id")
      .agg(avg("engagement_rate").alias("avg_engagement_rate"))
      .orderBy("avg_engagement_rate", ascending=False)
)
```

#### Popularity Level Distribution

```python
df_popularity = df.groupBy("popularity_level").count()
```

---

### 5.2 SQL Analysis (stored in `sql_queries.sql`)

####  Total Views by Category

```sql
SELECT category_id, SUM(view_count) AS total_views
FROM main.default.clean_youtube
GROUP BY category_id
ORDER BY total_views DESC;
```

####  Engagement by Year

```sql
SELECT publish_year, AVG(engagement_rate) AS avg_engagement_rate
FROM main.default.clean_youtube
GROUP BY publish_year
ORDER BY publish_year;
```

---

## 6.  Dashboard (Lakeview)

Notebook: `03_dashboard_notebook.ipynb` creates the dashboard-ready tables:

* `dash_views_by_category`
* `dash_engagement_by_category`
* `dash_popularity`

###  Dashboard Tiles (Meaningful KPIs)

#### 1️ **Total Views by Category**

* Datasource: `dash_views_by_category`
* X-axis: `category_id`
* Y-axis: `total_views`
* Chart type: Bar
* KPI: Shows which content categories dominate in views

---

#### 2️ **Average Engagement Rate by Category**

* Datasource: `dash_engagement_by_category`
* X-axis: `category_id`
* Y-axis: `avg_engagement_rate`
* Chart type: Bar
* KPI: Measures audience interaction

---

#### 3️ **Popularity Distribution**

* Datasource: `dash_popularity`
* X-axis: `popularity_level`
* Y-axis: `count`
* Chart type: Bar or Pie
* KPI: Classifies videos by view volume

---

## 7.  Dashboard Filters (Correct + Compatible)

Because Lakeview Free Edition requires filters to come from the **same datasource as each tile**, the valid filters are:

###  Filter 1 — Category ID

* Datasource: `dash_views_by_category`
* Field: `category_id`
* Applies to: Tile 1 only



###  Filter 2 — Category ID

* Datasource: `dash_engagement_by_category`
* Field: `category_id`
* Applies to: Tile 2 only



###  Filter 3 — Popularity Level

* Datasource: `dash_popularity`
* Field: `popularity_level`
* Applies to: Tile 3 only

These filters ensure **no datasource conflicts**, while still enabling meaningful KPI slicing.


## 8.  How to Run This Project

1. Import notebooks into Databricks.
2. Attach an active cluster.
3. Run:

   * `01_ingest_and_clean_youtube.ipynb`
   * `02_analysis_notebook.ipynb`
   * `03_dashboard_notebook.ipynb`
4. Create your Lakeview Dashboard:

   * Add the 3 tiles
   * Add filters with correct datasources
5. Save & publish dashboard


## 9.  Repository Structure

```
youtube-bigdata-final/
│
├── 01_ingest_and_clean_youtube.ipynb
├── 02_analysis_notebook.ipynb
├── 03_dashboard_notebook.ipynb
├── sql_queries.sql
└── README.md
```


## 10. Conclusion

This project demonstrates a complete Big Data workflow:

* Ingesting raw YouTube data into Databricks
* Cleaning, casting, and engineering analytical fields
* Performing category-level analytics using PySpark & SQL
* Visualizing key metrics through Lakeview Dashboards
* Using GitHub for project documentation

The final dashboard provides clear insights into **YouTube viewership, engagement and popularity trends**, making it useful for content strategy and performance analysis.
