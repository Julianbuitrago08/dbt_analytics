{{
  config(
    tag = ['jaffle_shop'],
    shema = 'bronze',
    materialized='table'
  ) 
}}

select
    $1::integer  as id,
    $2::string   as first_name,
    $3::string   as last_name,
    metadata$filename             as source_file_name,
    metadata$file_last_modified   as file_last_modified_ts,
    metadata$start_scan_time      as load_timestamp

from @BRONZE.MY_INTERAL_STAGE/rv8ef6lvb2uh-jaffle_shop_customers.csv
(
  file_format => BRONZE.FF_CSV_SKIP_HEADER
)
