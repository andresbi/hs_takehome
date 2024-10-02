WITH 

source as (

  SELECT * FROM {{ source('postgres','raw_amenities_changelog') }}

)

, renamed as (

  SELECT 
    listing_id,
    change_at::date as valid_from, 
    coalesce(lead(change_at) over (partition by listing_id order by change_at)::date,'9999-12-31') valid_to, --Convert this table into a type2 Slowly Changing Dim for easier analysis (Same structure as a dbt Snapshot)
    amenities all_amenities
  FROM source
  
)

SELECT * FROM renamed