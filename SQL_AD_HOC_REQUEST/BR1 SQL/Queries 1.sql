select ct.city_name,
count(ft.trip_id) as total_trips,
sum(ft.fare_amount) / sum(ft.distance_travelled_km) as avg_fare_per_km,
sum(ft.fare_amount) / count(ft.trip_id) as avg_fare_per_trip,
round((count(ft.trip_id) / (select count(*)from trips_db.fact_trips)*100),2) as percentage_contribution_to_total_trips
from trips_db.fact_trips as ft , dim_city as ct
where ft.city_id = ct.city_id
group by ct.city_name
order by count(ft.trip_id) desc ;
