{{
  config(
    tags = 'shop_store_2',
    schema = 'silver',
    unique_key = ['order_id','order_date'],
    materialized = 'incremental',
    on_schema_change = 'sync_all_columns'
  ) 
}}

{{ union_tables_by_prefix(
     database='ANALYTICS_DEV',
     schema='bronze',
     prefix='bronze_shop_raw_'
) }}