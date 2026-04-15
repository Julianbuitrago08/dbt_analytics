{{
  config(
    tag = 'jaffa_shop',
    shema = 'SILVER',
    materialized='table',
    unique_key = ['customer_id','order_id']
  ) 
}}

with customers as (
    select
        id         as customer_id,
        first_name,
        last_name
    from {{ref('bronze_customers')}}
),
orders as (
    select
        id         as order_id,
        user_id    as customer_id,
        order_date,
        status
    from {{ref('bronze_orders')}}
),
payments as (
    select 
         id,
         orderid,
         paymentmethod,
         status,
         amount,
         created
),
final as (
    select
        o.order_id,
        c.customer_id,
        sum(pa.amount) as lifetime_value
    from customers c
    left join orders o
        on c.customer_id = o.customer_id
    left join payments pa
        on o.order_id = pa.order_id
    group by 
        o.order_id,
        c.customer_id
)
select *
from final