{{
  config(
    tag = 'jaffa_shop',
    shema = 'gold',
    materialized='table'
  ) 
}}

with customers as (
    select
        customer_id,
        first_name,
        last_name,
        full_name,
        first_order_date,
        most_recent_order_date,
        number_of_orders
    from {{ ref('silver_customers') }}

)
select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.full_name,
    c.first_order_date,
    c.most_recent_order_date,
    c.number_of_orders,
    sum(o.lifetime_value) as lifetime_value
from customers c
left join {{ ref('silver_orders') }} o
    on c.customer_id = o.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name,
    c.full_name,
    c.first_order_date,
    c.most_recent_order_date,
    c.number_of_orders