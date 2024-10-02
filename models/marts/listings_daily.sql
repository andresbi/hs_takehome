select 
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
  consecutive_days_available,
  vacancy_block_size_in_days,
  has_air_conditioning,
  has_lockbox,
  has_first_aid_kit,
  all_amenities
from {{ref('int_listings_daily_joined_windowed')}} 
order by listing_id, date