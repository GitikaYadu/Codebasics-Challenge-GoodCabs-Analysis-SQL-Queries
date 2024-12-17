WITH CityTripFrequency AS (
    SELECT 
        ct.city_name,
        drt.trip_count,
        SUM(drt.repeat_passenger_count) AS repeat_passenger_sum
    FROM 
        trips_db.dim_city AS ct
    JOIN
        trips_db.dim_repeat_trip_distribution AS drt 
        ON ct.city_id = drt.city_id
    WHERE 
        drt.trip_count BETWEEN 2 AND 10
    GROUP BY 
        ct.city_name, drt.trip_count
),
CityTotalRepeatPassengers AS (
    SELECT
        city_name,
        SUM(repeat_passenger_sum) AS total_repeat_passengers
    FROM
        CityTripFrequency
    GROUP BY 
        city_name
),
CityTripPercentage AS (
    SELECT
        ctf.city_name,
        ctf.trip_count,
        ctf.repeat_passenger_sum,
        ROUND((ctf.repeat_passenger_sum / ctrp.total_repeat_passengers) * 100, 2) AS total_percentage
    FROM 
        CityTripFrequency AS ctf
    JOIN 
        CityTotalRepeatPassengers AS ctrp
        ON ctf.city_name = ctrp.city_name
)
SELECT 
    city_name,
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '2-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "2-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '3-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "3-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '4-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "4-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '5-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "5-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '6-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "6-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '7-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "7-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '8-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "8-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '9-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "9-Trips",
    CONCAT(FORMAT(SUM(CASE WHEN trip_count = '10-Trips' THEN total_percentage ELSE 0 END), 2), '%') AS "10-Trips"
FROM   
    CityTripPercentage  
GROUP BY 
    city_name;
