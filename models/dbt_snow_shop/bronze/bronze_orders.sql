{{
  config(
    tag = 'jaffa_shop',
    materialized='table'
  ) 
}}

select
    $1::integer as id,
    $2::integer as user_id,
    $3::date    as order_date,
    $4::string  as status
from @JAFFLE_SHOP.MY_INTERAL_STAGE/7lllisvro4xd-jaffle_shop_orders.csv

(
  file_format => BRONZE.FF_CSV_SKIP_HEADER
)
