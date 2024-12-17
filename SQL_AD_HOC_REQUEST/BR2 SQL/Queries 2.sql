SELECT 
    ct.city_name,
    dt.month_name,
    COUNT(TRIP.trip_id) AS Actual_trips,
    Target.total_target_trips AS Target_trips,
    CASE 
        WHEN COUNT(TRIP.trip_id) >= Target.total_target_trips 
        THEN 'Above Target'
        ELSE 'Below Target'
    END AS Performance_status,
    ROUND(
        ((COUNT(TRIP.trip_id) - Target.total_target_trips) * 100.0 / Target.total_target_trips), 
        2
    ) AS Percentage_difference
FROM 
    trips_db.dim_city AS ct
JOIN 
    trips_db.fact_trips AS TRIP 
    ON ct.city_id = TRIP.city_id
JOIN 
    trips_db.dim_date AS dt 
    ON TRIP.date = dt.date
JOIN 
    trips_db.monthly_target_trips AS Target 
    ON TRIP.city_id = Target.city_id
    AND MONTH(TRIP.date) = MONTH(Target.month)
WHERE 
    dt.month_name IN ('January', 'February', 'March', 'April', 'May', 'June')
GROUP BY
    ct.city_name,
    dt.month_name,
    Target.total_target_trips,
    Target.month
ORDER BY 
    ct.city_name,
    FIELD(dt.month_name, 'January', 'February', 'March', 'April', 'May', 'June');
