SELECT * FROM db.synthetic_ride_sharing_data;

-- Total Rides, Average Fare, and Max Fare
SELECT COUNT(ride_id) AS total_rides, 
       AVG(fare) AS average_fare, 
       MAX(fare) AS max_fare 
FROM db.synthetic_ride_sharing_data;

-- Ride Distribution by Weather Conditions 
SELECT weather, 
       COUNT(ride_id) AS ride_count, 
       AVG(fare) AS average_fare 
FROM db.synthetic_ride_sharing_data 
GROUP BY weather;


-- Ride Distribution by Distance (Customer Preferences)
SELECT distance, 
       COUNT(ride_id) AS ride_count, 
       AVG(fare) AS average_fare 
FROM db.synthetic_ride_sharing_data 
GROUP BY distance 
ORDER BY distance;


-- Extract Peak Ride Hours
SELECT EXTRACT(HOUR FROM STR_TO_DATE(ride_time, '%d-%m-%Y %H:%i:%s')) AS hour_of_day, 
       COUNT(ride_id) AS ride_count 
FROM db.synthetic_ride_sharing_data 
GROUP BY hour_of_day 
ORDER BY ride_count DESC;

-- Analyze Rides by the Same Time Slot
SELECT a.ride_time, 
       COUNT(*) AS total_rides, 
       AVG(a.fare) AS avg_fare_a,
       AVG(b.fare) AS avg_fare_b
FROM db.synthetic_ride_sharing_data a
JOIN db.synthetic_ride_sharing_data b ON STR_TO_DATE(a.ride_time, '%d-%m-%Y %H:%i:%s') = STR_TO_DATE(b.ride_time, '%d-%m-%Y %H:%i:%s')
WHERE a.ride_id <> b.ride_id
GROUP BY a.ride_time
ORDER BY total_rides DESC;


-- Peak Days (Weekday vs. Weekend)
SELECT CASE 
           WHEN DAYOFWEEK(STR_TO_DATE(ride_time, '%d-%m-%Y %H:%i:%s')) IN (1, 7) THEN 'Weekend'
           ELSE 'Weekday'
       END AS day_type, 
       COUNT(ride_id) AS ride_count 
FROM db.synthetic_ride_sharing_data 
GROUP BY day_type
ORDER BY ride_count DESC;


-- Monthly Ride Distribution
SELECT EXTRACT(MONTH FROM STR_TO_DATE(ride_time, '%d-%m-%Y %H:%i:%s')) AS month, 
       COUNT(ride_id) AS ride_count 
FROM db.synthetic_ride_sharing_data 
GROUP BY month 
ORDER BY ride_count DESC;


-- Correlating Ride Demand with Weather Conditions 
SELECT EXTRACT(HOUR FROM STR_TO_DATE(ride_time, '%d-%m-%Y %H:%i:%s')) AS hour_of_day, 
       weather, 
       COUNT(ride_id) AS ride_count, 
       AVG(fare) AS average_fare 
FROM db.synthetic_ride_sharing_data 
GROUP BY hour_of_day, weather
ORDER BY ride_count DESC;



-- Ride Demand vs. Distance Across Weather Conditions
SELECT weather, 
       distance, 
       COUNT(ride_id) AS ride_count, 
       AVG(fare) AS average_fare 
FROM db.synthetic_ride_sharing_data 
GROUP BY weather, distance 
ORDER BY weather, distance;


-- Revenue by Weather Conditions
SELECT weather, 
       SUM(fare) AS total_revenue 
FROM db.synthetic_ride_sharing_data 
GROUP BY weather;


-- Compare Fare Differences for the Same Customer on Different Days
SELECT a.customer_id, 
       DATE(STR_TO_DATE(a.ride_time, '%d-%m-%Y %H:%i:%s')) AS ride_date_a,
       a.fare AS fare_a,
       b.fare AS fare_b,
       DATE(STR_TO_DATE(b.ride_time, '%d-%m-%Y %H:%i:%s')) AS ride_date_b
FROM db.synthetic_ride_sharing_data a
JOIN db.synthetic_ride_sharing_data b ON a.customer_id = b.customer_id
WHERE DATE(STR_TO_DATE(a.ride_time, '%d-%m-%Y %H:%i:%s')) < DATE(STR_TO_DATE(b.ride_time, '%d-%m-%Y %H:%i:%s'))
ORDER BY a.customer_id, ride_date_a, ride_date_b;


-- Revenue by Hour of Day
SELECT EXTRACT(HOUR FROM STR_TO_DATE(ride_time, '%d-%m-%Y %H:%i:%s')) AS hour_of_day, 
       SUM(fare) AS total_revenue 
FROM db.synthetic_ride_sharing_data 
GROUP BY hour_of_day 
ORDER BY total_revenue DESC;


-- Calculate Monthly Revenue and Compare to Previous Month
WITH Monthly_Revenue AS (
    SELECT EXTRACT(MONTH FROM STR_TO_DATE(ride_time, '%d-%m-%Y %H:%i:%s')) AS month, 
           SUM(fare) AS total_revenue 
    FROM db.synthetic_ride_sharing_data 
    GROUP BY month
)
SELECT a.month, a.total_revenue, b.total_revenue AS previous_month_revenue
FROM Monthly_Revenue a
LEFT JOIN Monthly_Revenue b ON a.month = b.month + 1
ORDER BY a.month;


-- Analysis of Customer Preferences (Popular Ride Times for Customers)
SELECT customer_id, 
       EXTRACT(HOUR FROM STR_TO_DATE(ride_time, '%d-%m-%Y %H:%i:%s')) AS popular_hour, 
       COUNT(ride_id) AS ride_count, 
       AVG(fare) AS avg_fare 
FROM db.synthetic_ride_sharing_data 
GROUP BY customer_id, popular_hour
ORDER BY ride_count DESC;




