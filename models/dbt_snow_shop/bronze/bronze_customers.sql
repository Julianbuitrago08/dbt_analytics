{{
  config(
    tag = ['jaffle_shop'],
    shema = 'BRONZE',
    materialized='table'
  ) 
}}

select
    $1::integer  as id,
    $2::string   as first_name,
    $3::string   as last_name
from @BRONZE.MY_INTERAL_STAGE/rv8ef6lvb2uh-jaffle_shop_customers.csv
(
  file_format => BRONZE.FF_CSV_SKIP_HEADER
)
