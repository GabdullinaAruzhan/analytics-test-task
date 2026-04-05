SELECT COUNT(DISTINCT user_id) AS mau
FROM auditory_data
WHERE date BETWEEN '2023-11-01' AND '2023-11-30';

#2
SELECT AVG(daily_users) AS average_dau
FROM (
    SELECT date, COUNT(DISTINCT user_id) AS daily_users
    FROM auditory_data
    GROUP BY date
) AS daily_counts;

#3

WITH cohort AS (
    SELECT DISTINCT user_id 
    FROM auditory_data 
    WHERE date = '2023-11-01'
)
SELECT 
    (COUNT(DISTINCT a.user_id) * 100.0 / (SELECT COUNT(*) FROM cohort)) AS retention_day_1
FROM auditory_data a
JOIN cohort c ON a.user_id = c.user_id
WHERE a.date = '2023-11-02';

#5

SELECT 
    (COUNT(DISTINCT CASE WHEN view_adverts > 0 THEN user_id END) * 100.0 / COUNT(DISTINCT user_id)) AS conversion_rate
FROM auditory_data
WHERE date LIKE '2023-11%';

#6

SELECT SUM(view_adverts) / COUNT(DISTINCT user_id) AS avg_views_per_user
FROM auditory_data
WHERE date LIKE '2023-11%';

#8

SELECT 
    experiment_group,
    COUNT(DISTINCT user_id) AS total_users,
    SUM(revenue) AS total_revenue,
    SUM(revenue) / COUNT(DISTINCT user_id) AS arpu
FROM ab_test_results
WHERE experiment_num = 1
GROUP BY experiment_group;

#9  

SELECT 
    SUM(revenue) / COUNT(DISTINCT user_id) AS avg_revenue_per_user
FROM listers_data;

#10

SELECT AVG(age) AS median_age
FROM (
    SELECT age, 
           ROW_NUMBER() OVER (ORDER BY age) as row_id, 
           COUNT(*) OVER () as total_count
    FROM listers_data
) AS sub
WHERE row_id IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2));