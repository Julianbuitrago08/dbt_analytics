{{
  config(
    tags = ['shop_store_2'],
    schema = 'bronze',
    materialized='table'
  ) 
}}

select *
from (
  {{ union_tables_by_prefix(
       database='ANALYTICS_DEV',
       schema='silver',
       prefix='raw_'
  ) }}
)
