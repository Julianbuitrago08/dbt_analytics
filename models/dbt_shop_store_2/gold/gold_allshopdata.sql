{{
  config(
    tags = 'shop_store_2',
    schema = 'gold',
    materialized='table'
  ) 
}}

select
    order_id,
    order_amount,
    order_date,
    source_file_name,
    file_last_modified_ts,
    load_timestamp
from {{ref('silver_allshopdata')}}