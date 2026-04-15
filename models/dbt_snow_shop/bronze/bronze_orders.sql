{{
  config(
    tag = ['jaffle_shop'],
    shema = 'bronze',
    materialized='table'
  ) 
}}

select
    $1::integer as id,
    $2::integer as user_id,
    $3::date    as order_date,
    $4::string  as status,
    metadata$filename             as source_file_name,
    metadata$file_last_modified   as file_last_modified_ts,
    metadata$start_scan_time      as load_timestamp
from @BRONZE.MY_INTERAL_STAGE/7lllisvro4xd-jaffle_shop_orders.csv
(
  file_format => BRONZE.FF_CSV_SKIP_HEADER
)
