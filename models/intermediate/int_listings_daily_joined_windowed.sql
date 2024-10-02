with joined as (
SELECT 
  a.listing_id,
  l.neighborhood,
  a.date,
  a.is_available,
  a.is_reserved,
  a._reservation_id as reservation_id,
  a.price,
  a.revenue,
  b."has_Air conditioning" as has_air_conditioning, --rename for better user experience
  b."has_Lockbox" as has_lockbox,
  b."has_First aid kit" as has_first_aid_kit,
  minimum_nights,
  maximum_nights,
  all_amenities
FROM {{ref('stg_postgres__calendar')}} a
JOIN {{ref('int_amenities_pivoted_to_listings')}} b on b.listing_id = a.listing_id and  --This is the method to join a table to a Type2 SCD
									                           a.date >= b.valid_from      and 
										                         a.date <= b.valid_to
JOIN {{ref('stg_postgres__listings')}} l on l.id = a.listing_id
)

/*
The window functions below come in 2 flavors and one objective
1) Capture information about reservations 
2) Capture information about availability 

Objective: Simplify Mart queries
*/

, setup1 as (
SELECT 
  *,
  case when is_reserved then count(1) over (partition by listing_id, reservation_id order by 1) end reservation_length_days, --For each listing and reservation, count the number of days of that reservation
  sum(case when is_available then 0 else 1 end) over (partition by listing_id order by date) as av_group --Group listing-availability-blocks together
FROM joined
)

, setup2 as (
SELECT 
  *,
  case when is_reserved then row_number() over(partition by listing_id, reservation_id order by date) else null end reservation_day_counter, 
  dense_rank() over (partition by listing_id order by reservation_id is NULL, reservation_length_days desc) reservation_length_rank_in_listing, --For each reservation, how does it rank in length against other reservations of that same listing. This can help answer questions about specific listings, such as when was the longest reservation for this listing? 
  dense_rank() over (order by reservation_id is NULL, reservation_length_days desc) reservation_length_rank_all_listings, --For each reservation, how does it rank in length against all other reservations. This could be used to find listings with consistently long reservations
  (case 
    when is_available = true 
      then rank() over (partition by listing_id, av_group order by date desc)
      else 0
    end) as av_running_count, --For each day in listing-availability-block, rank by count of days until the next reservation 
  least(maximum_nights,av_running_count) as consecutive_days_available -- Cap the availability amount to the Maximum_Nights value
  FROM setup1
)

, setup3 as (
  SELECT 
    * ,
    max(av_running_count) over (partition by listing_id,reservation_id, av_group order by 1) vacancy_block_size_in_days -- Capture the size of each vacancy block size. Answer questions like, avg time between reservations
  FROM setup2
)

SELECT 
  listing_id, 
  date,
  neighborhood, 
  is_available,
  is_reserved,
  reservation_id,
  reservation_length_days,
  reservation_day_counter,
  reservation_length_rank_in_listing,
  reservation_length_rank_all_listings,
  price,
  revenue,
  minimum_nights,
  maximum_nights,
  vacancy_block_size_in_days,
  consecutive_days_available,
  has_air_conditioning,
  has_lockbox,
  has_first_aid_kit,
  all_amenities
FROM setup3