{{ config(
    materialized='table'
 ) }}

with product_prices as (
select
  id as product_price_id
  , product_id
  , price
  , created_at
  , ended_at
  from {{ source('coffee_shop', 'product_prices') }} as product_prices
)

select * from product_prices