{{ config(
    materialized='table'
 ) }}
 
select
    date_trunc(sold_at, week) as week
    , product_category
    , sum(product_price) as revenue

from {{ ref('fct_product_sales') }}

group by 1, 2
order by 1, 2