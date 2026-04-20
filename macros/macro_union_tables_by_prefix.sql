{#-
  union_tables_by_prefix
  This macro dynamically unions all tables in a given database and schema
  whose names start with a specified prefix.
  It uses `dbt_utils.get_relations_by_prefix` to discover matching tables
  at compile time and generates a `UNION ALL` query across them.

  Parameters:
    database (string): The target database name
    schema   (string): The target schema name
    prefix   (string): The table name prefix to match

  Returns:
    A SQL query that selects all columns from each matching table
    and combines them using `UNION ALL`.

  Example usage:
    {{ union_tables_by_prefix(
        database='raw',
        schema='events',
        prefix='events_'
    ) }}

  Notes:
    - All tables must have the same column structure
    - New tables matching the prefix will be automatically included
      without code changes
-#}

{% macro union_tables_by_prefix(database, schema, prefix) %}

  {%- set tables = dbt_utils.get_relations_by_prefix(
      database=database,
      schema=schema,
      prefix=prefix
  ) -%}

  {% for table in tables %}
    {%- if not loop.first -%}
      union all
    {%- endif %}

    select *
    from {{ table.database }}.{{ table.schema }}.{{ table.name }}

  {% endfor -%}

{% endmacro %}