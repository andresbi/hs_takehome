WITH 

source as (

  SELECT * FROM {{source('postgres','raw_calendar')}}

)

, renamed as (

  SELECT 
    listing_id,
    date,
    available as is_available,
    case when reservation_id = 'NULL' then NULL else reservation_id end as _reservation_id, --Snowflake interpreted the NULL as a string, so transforming it here to proper NULL to avoid errors downstream.
    case when _reservation_id  is null then false else true end is_reserved, --Create a simple Boolean
    case when is_reserved and date < current_date() then price else 0 end as revenue, --Formula for recognizing revenue. This prevents user error of adding price across records, which would be incorrect to capture Revenue.  
    price, 
    minimum_nights,
    maximum_nights
  FROM source
  
)

SELECT * FROM renamed