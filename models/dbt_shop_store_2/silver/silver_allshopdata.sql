{{
  config(
    tags = ['shop_store_2'],
    schema = 'silver',
    materialized='table'
  ) 
}}

{{ union_tables_by_prefix(
     database='ANALYTICS_DEV',
     schema='bronze',
     prefix='bronze_raw_'
) }}