{% snapshot silver_orders_snapshot %}

{{
    config(
        target_schema = 'snapshots',
        strategy = 'check',
        unique_key = "concat(customer_id, '-', order_id)",
        check_cols = [
            'order_status',
            'valid_order_date',
            'lifetime_value'
        ],
        hard_deletes = 'ignore',
        dbt_valid_to_current = "to_date('9999-12-31')",
        tags = ['jaffa_shop']
    )
}}

select
    order_id,
    customer_id,
    order_date,
    valid_order_date,
    order_status,
    lifetime_value
from {{ ref('silver_orders') }}

{% endsnapshot %}