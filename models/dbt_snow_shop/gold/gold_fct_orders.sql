{{
  config(
    tag = 'jaffa_shop',
    shema = 'GOLD',
    materialized='table'
  ) 
}}

select 
    order_id,
    customer_id,
    lifetime_value
from {{ref('silver_orders')}}