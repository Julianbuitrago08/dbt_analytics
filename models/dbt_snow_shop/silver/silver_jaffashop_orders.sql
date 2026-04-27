{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized = 'incremental',
    unique_key = ['customer_id','order_id'],
    on_schema_change = 'sync_all_columns'
  )
}}
with payments as (
    select 
        id            as payment_id,
        orderid       as order_id,
        amount
    from {{ ref('bronze_jaffashop_payment') }}
)
select 
    o.id        as order_id,
    o.user_id   as customer_id,
    o.order_date,
    case 
        when o.status not in ('returned', 'return_pending')
        then o.order_date
        else null
    end         as valid_order_date,
    o.status    as order_status,
    sum(p.amount) as lifetime_value
from payments p
left join {{ ref('bronze_jaffashop_orders') }} o
    on p.order_id = o.id
where o.user_id is not null
group by
    o.id,
    o.user_id,
    o.order_date,
    o.status

