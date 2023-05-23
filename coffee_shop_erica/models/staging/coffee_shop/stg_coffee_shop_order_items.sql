{{ config(
    materialized='table'
 ) }}

with order_items as (
select
  id as order_item_id
  , order_id
  , product_id	
  from {{ source('coffee_shop', 'order_items') }} as items
)

select * from order_items