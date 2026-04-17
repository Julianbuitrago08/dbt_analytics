{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized='table',
    unique_key = ['customer_id','order_id']
  )
}}
with customers as (

    select
        id as customer_id,
        first_name,
        last_name
    from {{ ref('bronze_customers') }}
),
orders as (
    select
        id        as order_id,
        user_id   as customer_id,
        order_date,
        status    as order_status
    from {{ ref('bronze_orders') }}

),
payments as (
    select 
        id      as payment_id,
        orderid as order_id,
        sum (case when payment_status = 'success' then amount end) as amount
    from {{ ref('bronze_payment') }}
    group by 1,2

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
where order_id is not null
