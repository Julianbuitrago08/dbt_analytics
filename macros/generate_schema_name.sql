{#-
  generate_schema_name

  This macro customizes the schema name that dbt uses when creating models.
  It overrides dbt’s default schema generation behavior.

  If no custom schema is provided (or it is empty),
  the macro returns the target schema defined in the active dbt profile.

  If a valid custom schema name is provided, the macro uses that value
  after trimming leading and trailing whitespace.

  Parameters:
    custom_schema_name (string | none):
      The custom schema defined in the model configuration.
      If `none` or empty, the default target schema is used.

    node (dict):
      The dbt node object representing the current model.
      (Included to match dbt's macro signature; not used directly.)

  Returns:
    A string representing the schema name that dbt will use
    when creating the model.

  Example usage:

    -- In dbt_project.yml
    models:
      my_project:
        +schema: silver

    -- In a model
    {{ config(schema='gold') }}

  Resulting behavior:
    - schema not defined or empty → uses target.schema
    - schema defined → uses the custom schema value

  Notes:
    - Commonly used for medallion architectures
      (bronze / silver / gold schemas)
    - Executed at compile time
-#}

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none
          or custom_schema_name | trim == '' -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}