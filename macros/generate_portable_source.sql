{% macro generate_portable_source(
    source_name,
    schema_name,
    freshness_loaded_at_field=None,
    warn_after=None,
    error_after=None
) %}
{#
  Macro para generar sources portables (independientes de database).

  Params:
    source_name: nombre del source (ej. raw_jaffle_shop)
    schema_name: schema físico en Snowflake (ej. raw)
    freshness_loaded_at_field: campo timestamp para freshness (opcional)
    warn_after: dict -> {count: X, period: hour|day} (opcional)
    error_after: dict -> {count: X, period: hour|day} (opcional)
#}

{% set source_yaml = [] %}
{% do source_yaml.append("version: 2") %}
{% do source_yaml.append("sources:") %}
{% do source_yaml.append("  - name: " ~ source_name) %}
{% do source_yaml.append("    schema: " ~ schema_name) %}
{% do source_yaml.append("    tables:") %}

{% for table in adapter.get_relations(
        database=target.database,
        schema=schema_name
    )
%}
{% do source_yaml.append("      - name: " ~ table.identifier) %}

{% if freshness_loaded_at_field %}
{% do source_yaml.append("        loaded_at_field: " ~ freshness_loaded_at_field) %}
{% do source_yaml.append("        freshness:") %}

{% if warn_after %}
{% do source_yaml.append("          warn_after:") %}
{% do source_yaml.append("            count: " ~ warn_after.count) %}
{% do source_yaml.append("            period: " ~ warn_after.period) %}
{% endif %}

{% if error_after %}
{% do source_yaml.append("          error_after:") %}
{% do source_yaml.append("            count: " ~ error_after.count) %}
{% do source_yaml.append("            period: " ~ error_after.period) %}
{% endif %}

{% endif %}
{% endfor %}

{{ return(source_yaml | join('\n')) }}

{% endmacro %}