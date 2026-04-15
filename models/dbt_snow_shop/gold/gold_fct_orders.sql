{{
  config(
    tag = 'jaffa_shop',
    shema = 'gold',
    materialized='table'
  ) 
}}

select 
    order_id,
    customer_id,
    lifetime_value
from {{ref('silver_orders')}}