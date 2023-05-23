{{ config(
    materialized='table'
 ) }}

with customer_orders as (
  select
     customer_id
     , count(*) as n_orders
     , min(created_at) as first_order_at
  from {{ ref('stg_coffee_shop_orders') }}
  -- from `analytics-engineers-club.coffee_shop.orders` 
  group by 1
)

select 
  customers.customer_id
  , customers.name
  , customers.email
  , coalesce(customer_orders.n_orders, 0) as n_orders
  , customer_orders.first_order_at
from {{ ref('stg_coffee_shop_customers') }} as customers
-- from `analytics-engineers-club.coffee_shop.customers` as customers
left join  customer_orders
  on  customers.customer_id = customer_orders.customer_id