{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized = 'incremental',
    unique_key = ['customer_id','order_id'],
    on_schema_change = 'sync_all_columns'
  )
}}

with 

orders as (

  select * from {{ ref('bronze_orders') }}

),

payments as (

  select *
  from {{ ref('bronze_payment') }}

),

completed_payments as (
  select 
    orderid as order_id,
    max(created) as payment_finalized_date,
    sum(amount) as total_amount_paid
  from payments
  where payment_status <> 'fail'
  group by 1

),

paid_orders as (

  select 
    orders.id as order_id,
    orders.user_id as customer_id,
    orders.order_date,
    orders.status as order_status,
    completed_payments.total_amount_paid,
    completed_payments.payment_finalized_date
  from orders
 left join completed_payments on orders.id = completed_payments.order_id
)

select * from paid_orders

