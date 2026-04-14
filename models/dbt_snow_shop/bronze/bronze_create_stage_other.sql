{{
  config(
    pre_hook = "
      create or replace file format BRONZE.FF_CSV_SKIP_HEADER
      type = 'CSV'
      field_delimiter = ','
      skip_header = 1
      null_if = ('','NULL');
    "
  )
}}
SELECT 1 AS DAT