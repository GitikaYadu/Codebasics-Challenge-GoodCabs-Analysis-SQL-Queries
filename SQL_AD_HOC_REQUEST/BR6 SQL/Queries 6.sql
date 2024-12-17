WITH MRPR AS (
    SELECT 
        ct.city_name,
        MONTH(ft.month) AS month,
        ft.total_passengers,
        ft.repeat_passengers,
        CONCAT(FORMAT((ft.repeat_passengers / ft.total_passengers) * 100, 2), '%') AS monthly_repeat_passenger_rate
    FROM 
        trips_db.dim_city AS ct, 
        fact_passenger_summary AS ft
    WHERE 
        ct.city_id = ft.city_id
    GROUP BY 
        ct.city_name, ft.total_passengers, ft.repeat_passengers, month
),
CRPR AS (
    SELECT
        ct.city_name,
        SUM(ft.total_passengers) AS city_total_passenger,
        SUM(ft.repeat_passengers) AS city_total_repeat_passenger,
        CONCAT(FORMAT((SUM(ft.repeat_passengers) / SUM(ft.total_passengers)) * 100, 2), '%') AS city_repeat_passenger_rate
    FROM 
        trips_db.dim_city AS ct, 
        fact_passenger_summary AS ft
    WHERE 
        ct.city_id = ft.city_id
    GROUP BY 
        ct.city_name
)
SELECT 
    m.city_name,
    m.month,
    m.total_passengers,
    m.repeat_passengers,
    m.monthly_repeat_passenger_rate,
    c.city_repeat_passenger_rate
FROM 
    MRPR AS m
JOIN
    CRPR AS c
ON 
    m.city_name = c.city_name;
