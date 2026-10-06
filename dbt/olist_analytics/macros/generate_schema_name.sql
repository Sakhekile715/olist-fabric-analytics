{#-
    DBT_SCHEMA_PREFIX is unset locally, so schemas stay silver and gold.
    CI sets it (e.g. ci_) so its builds land in ci_silver and ci_gold instead.
-#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set prefix = env_var('DBT_SCHEMA_PREFIX', '') -%}
    {%- if custom_schema_name is none -%}
        {{ prefix ~ target.schema }}
    {%- else -%}
        {{ prefix ~ (custom_schema_name | trim) }}
    {%- endif -%}
{%- endmacro %}
