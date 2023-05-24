{% set product_category = get_column_values('product_category', ref('fct_product_sales')) %}

select
  date_trunc(sold_at, month) as date_month
    {% for product_category in product_category %}
    {% set product_cat_col = product_category.replace(' ', '_') %}
    , sum(case when lower(product_category) = '{{product_category}}' then product_price end) as {{product_cat_col}}_amount
    {% endfor %}
from {{ ref('fct_product_sales') }}
group by 1

{# {{ "," if not loop.last }}  #}
