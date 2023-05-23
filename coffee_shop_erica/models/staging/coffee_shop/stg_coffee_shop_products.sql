{{ config(
    materialized='table'
 ) }}

with products as (
select
    id as product_id
    , name
    , category as category
    , created_at
  from {{ source('coffee_shop', 'products') }} as products
)

select * from products