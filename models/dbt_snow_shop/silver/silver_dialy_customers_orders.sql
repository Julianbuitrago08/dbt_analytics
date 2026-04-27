{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized = 'incremental',
    unique_key = ['primary_key'],
    on_schema_change = 'sync_all_columns'
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
)
select 
    c.customer_id,
    o.order_date,
    {{ dbt_utils.generate_surrogate_key(['c.customer_id', 'o.order_date']) }} as primary_key,
    count(*) as quantity_orders
from customers c
left join orders o
    on c.customer_id = o.customer_id
group by 1,2

