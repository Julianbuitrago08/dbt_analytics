{#-
  macro_snowflake_privileges_role

  This macro grants read-only access to all current tables and views
  within a specified Snowflake schema for a given role.

  It applies the following privileges:
    - USAGE on the schema
    - SELECT on all tables in the schema
    - SELECT on all views in the schema

  By default, the macro uses the active dbt target's schema and role,
  but both can be overridden by passing explicit arguments.

  Parameters:
    schema (string): The Snowflake schema on which privileges will be granted.
                     Defaults to `target.schema`.
    role   (string): The Snowflake role that will receive the privileges.
                     Defaults to `target.role`.

  Behavior:
    - Executes GRANT statements directly in Snowflake using `run_query`
    - Logs progress messages to dbt output for visibility in dbt Cloud

  Example usage:

    {{ macro_snowflake_privileges_role(
        schema='analytics',
        role='reporting_role'
    ) }}

  Notes:
    - This macro grants privileges only on existing tables and views
    - Future tables or views will require additional grants (e.g. FUTURE GRANTS)
    - Intended for Snowflake targets only
-#}

{% macro macro_snowflake_privileges_role(schema=target.schema, role=target.role) %}

  {% set sql %}
    grant usage on schema {{ schema }} to role {{ role }};
    grant select on all tables in schema {{ schema }} to role {{ role }};
    grant select on all views in schema {{ schema }} to role {{ role }};
  {% endset %}

  {{ log(
      'Granting select on all tables and views in schema ' ~ schema ~
      ' to role ' ~ role,
      info=True
  ) }}

  {% do run_query(sql) %}

  {{ log('Privileges granted', info=True) }}

{% endmacro %}
