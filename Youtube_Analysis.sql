Youtube_analysis.sql


SELECT
  category_id,
  SUM(view_count) AS total_views
FROM raw_youtube.default.clean_youtube_recommendation_dataset
GROUP BY category_id
ORDER BY total_views DESC;

 SELECT
    publish_year,
    AVG(engagement_rate) AS avg_engagement_rate
  FROM raw_youtube.default.clean_youtube_recommendation_dataset
  GROUP BY publish_year
  ORDER BY publish_year;