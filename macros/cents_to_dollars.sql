{#-
  cents_to_dollars

  This macro converts a monetary value expressed in cents into dollars
  and rounds the result to a specified number of decimal places.

  It performs the conversion by dividing the input column by 100
  and applying the SQL `round` function.

  Parameters:
    column_name   (string): The column or expression containing the amount in cents
    decimal_places (int):   The number of decimal places to round to.
                             Defaults to 2.

  Returns:
    A SQL expression that outputs the dollar value rounded
    to the specified number of decimal places.

  Notes:
    - Assumes the input value is stored as an integer or numeric type
    - Uses floating-point division (`1.0 *`) to ensure accurate decimal results
    - Database-agnostic and safe to use across supported warehouses
-#}

{% macro cents_to_dollars(column_name, decimal_places=2) -%}
  round(1.0 * {{ column_name }} / 100, {{ decimal_places }})
{%- endmacro %}
``