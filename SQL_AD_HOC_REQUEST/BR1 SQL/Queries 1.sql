SELECT 
    ct.city_name,
    COUNT(ft.trip_id) AS total_trips,
    SUM(ft.fare_amount) / SUM(ft.distance_travelled_km) AS avg_fare_per_km,
    SUM(ft.fare_amount) / COUNT(ft.trip_id) AS avg_fare_per_trip,
    ROUND(
        (COUNT(ft.trip_id) / 
        (SELECT COUNT(*) FROM trips_db.fact_trips) * 100), 
        2
    ) AS percentage_contribution_to_total_trips
FROM 
    trips_db.fact_trips AS ft
JOIN 
    trips_db.dim_city AS ct
ON 
    ft.city_id = ct.city_id
GROUP BY 
    ct.city_name
ORDER BY 
    COUNT(ft.trip_id) DESC;
