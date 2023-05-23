{{ config(
    materialized='table'
 ) }}

with orders as (
select
    id as order_id
  , created_at				
  , customer_id	
  , total as order_total		
  , address
  , state
  , zip	
  from {{ source('coffee_shop', 'orders') }} as orders
)

select * from orders