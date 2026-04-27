{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized = 'incremental',
    unique_key = ['customer_id','order_id'],
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
        id      as order_id,
        user_id as customer_id,
        order_date,
        status  as order_status
    from {{ ref('bronze_orders') }}

),

payments as (

    select 
        orderid as order_id,
        sum(
            case 
                when payment_status <> 'fail' then amount 
                else 0 
            end
        ) as amount_cents
    from {{ ref('bronze_payment') }}
    group by orderid

),

final as (

    select
        o.order_id,
        c.customer_id,
        {{ cents_to_dollars('coalesce(p.amount_cents, 0)') }} as lifetime_value
    from customers c
    left join orders o
        on c.customer_id = o.customer_id
    left join payments p
        on o.order_id = p.order_id

)

select *
from final
where order_id is not null


