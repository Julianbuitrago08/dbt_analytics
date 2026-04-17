{{
  config(
    tags = ['jaffle_shop'],
    schema = 'bronze',
    materialized='table'
  ) 
}}

select
    $1::integer        as id,
    $2::integer        as orderid,
    $3::string         as paymentmethod,
    $4::string         as payment_status,
    $5::numeric(18,2)  as amount,
    $6::timestamp      as created,
    metadata$filename             as source_file_name,
    metadata$file_last_modified   as file_last_modified_ts,
    metadata$start_scan_time      as load_timestamp
from @BRONZE.MY_INTERAL_STAGE/h3p8toeofdbb-stripe_payments.csv
(
  file_format => BRONZE.FF_CSV_SKIP_HEADER
)
