{% test average_dollars_spent_greater_than_one(model, column_name, group_by_column=None) %}

select
    {% if group_by_column %}
        {{ group_by_column }},
    {% endif %}
    avg({{ column_name }}) as average_amount

from {{ model }}

{% if group_by_column %}
group by {{ group_by_column }}
{% endif %}

having avg({{ column_name }}) < 1

{% endtest %}
