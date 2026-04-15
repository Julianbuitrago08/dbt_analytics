{{
  config(
    tag = 'jaffa_shop',
    shema = 'SILVER',
    materialized='table',
    unique_key = 'customer_id'
  ) 
}}
with customers as (
    select
        id         as customer_id,
        coalesce(first_name,'SIN REGISTRO') as first_name,
        coalesce(last_name,'SIN REGISTRO') as last_name,
        concat(first_name, ', ', last_name) as full_name
    from {{ref('bronze_customers')}}
)
select * 
from customers