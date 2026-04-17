{{
  config(
    tags = 'jaffa_shop',
    schema = 'gold',
    materialized='table'
  ) 
}}

select 
    order_id,
    customer_id,
    lifetime_value
from {{ref('silver_orders_customer')}}
