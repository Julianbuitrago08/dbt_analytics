{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized = 'incremental',
    unique_key = 'customer_id',
    on_schema_change = 'sync_all_columns'
  ) 
}}

with customers as (
    select
        id         as customer_id,
        first_name,
        last_name
    from {{ref('bronze_jaffashop_customers')}}
),
orders as (
    select
        o.id         as order_id,
        o.user_id    as customer_id,
        o.order_date,
        o.status,
        sum(p.amount) as amount
    from {{ref('bronze_jaffashop_orders')}} o
    left join {{ref('bronze_jaffashop_payment')}} p
        on o.id = p.orderid
    group by 
        o.id,
        o.user_id,
        o.order_date,
        o.status
),

customer_orders as (
    select
        customer_id,
        min(order_date)  as first_order_date,
        max(order_date)  as most_recent_order_date,
        count(order_id)  as number_of_orders,
        {{ dbt_utils.safe_divide('sum(amount)', 'count(order_id)') }} as avg_amount
    from orders
    group by customer_id

),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        co.first_order_date,
        co.most_recent_order_date,
        coalesce(co.number_of_orders, 0) as number_of_orders,
        coalesce(co.avg_amount, 0) as avg_amount
    from customers c
    left join customer_orders co
        on c.customer_id = co.customer_id
)
select *
from final
