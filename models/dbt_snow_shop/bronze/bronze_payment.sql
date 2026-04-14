{{
  config(
    tag = 'jaffa_shop',
    materialized='table'
  ) 
}}

select
    $1::integer        as id,
    $2::integer        as orderid,
    $3::string         as paymentmethod,
    $4::string         as status,
    $5::numeric(18,2)  as amount,
    $6::timestamp      as created
from @JAFFLE_SHOP.MY_INTERAL_STAGE/h3p8toeofdbb-stripe_payments.csv
(
  file_format => BRONZE.FF_CSV_SKIP_HEADER
)
