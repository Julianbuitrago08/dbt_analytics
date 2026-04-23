{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized='table',
    unique_key = ['customer_id','order_id']
  )
}}
with payments as (
    select 
        id,
        orderid,
        paymentmethod,
        payment_status,
        amount,
        created,
        source_file_name,
        file_last_modified_ts,
        load_timestamp
    from {{ ref('bronze_payment') }}
)
select 
    o.id as order_id,
    o.user_id as customer_id,
    o.order_date,
    case 
        when status not in ('returned','return_pending') 
        then order_date 
    end as valid_order_date
    o.status as order_status,
    sum(p.amount) as lifetime_value
from payments p
left join {{ ref('bronze_orders') }} o
    on p.orderid = o.id
where o.user_id is not null
group by 
    o.id,
    o.user_id,
    o.order_date,
    o.status