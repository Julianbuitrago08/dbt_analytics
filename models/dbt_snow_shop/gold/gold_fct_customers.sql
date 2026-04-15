{{
  config(
    tag = 'jaffa_shop',
    shema = 'GOLD',
    tag = 'jaffa_shop',
    shema = 'GOLD',
    materialized='table'
  ) 
}}

with customers as (
    select
        customer_id,
        first_name,
        last_name,
        full_name
    from {{ref('silver_customers')}}
)
select * 
from customers