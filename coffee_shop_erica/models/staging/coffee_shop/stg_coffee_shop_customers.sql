{{ config(
    materialized='table'
 ) }}

with customers as (
select
    id as customer_id
    , name
    , email
  from {{ source('coffee_shop', 'customers') }} as items
)

select * from customers