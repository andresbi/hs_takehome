WITH 

source as (

  SELECT * FROM {{source('postgres','raw_listings')}}

)

, renamed as (

  SELECT 
    id,
    neighborhood
    --Decided to keep it simple by only bringing the truly needed fields. In a real world scenario, I would be more generous in bringing interesting or likely-needed fields, even if the use case is not 100% known. 
  FROM source
  
)

SELECT * FROM renamed