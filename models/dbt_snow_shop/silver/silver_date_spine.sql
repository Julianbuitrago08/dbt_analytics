{{
  config(
    tags = 'jaffa_shop',
    schema = 'silver',
    materialized = 'incremental',
    on_schema_change = 'sync_all_columns',
    unique_key = 'date_day'
  ) 
}}

{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2026-01-01' as date)",
    end_date="cast('2027-01-01' as date)"
   )
}}

