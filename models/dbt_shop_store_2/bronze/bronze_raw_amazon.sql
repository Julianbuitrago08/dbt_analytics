{{
  config(
    tags = ['shop_store_2'],
    schema = 'bronze',
    materialized='table'
  ) 
}}

select
    $1::integer as order_id,
    $2::integer as order_amount,
    $3::date    as order_date,
    metadata$filename             as source_file_name,
    metadata$file_last_modified   as file_last_modified_ts,
    metadata$start_scan_time      as load_timestamp
from @BRONZE.MY_INTERAL_STAGE/1clgjk2p5htj-2025-11-143_43pm.csv
(
  file_format => BRONZE.FF_CSV_SKIP_HEADER
)
