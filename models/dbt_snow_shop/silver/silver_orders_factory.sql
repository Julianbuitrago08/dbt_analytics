{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized='table',
    unique_key = ['customer_id','order_id']
  )
}}
{%- set payment_methods = ['bank_transfer', 'credit_card', 'coupon', 'gift_card'] -%}

with payments as (

    select *
    from {{ ref('bronze_payment') }}

),
re_factory as (
    select
        id as order_id,
        {% for payment_method in payment_methods %}
        sum(
            case
                when payment_status = '{{ payment_method }}'
                then amount
                else 0
            end
        ) as {{ payment_method }}_amount
        {%- if not loop.last -%}, {% endif -%}
        {% endfor %}
    from payments
    group by order_id
)
select *
from re_factory