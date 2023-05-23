{{ config(
    materialized='table'
 ) }}
 
with orders as (
    select * from {{ ref('stg_coffee_shop_orders') }}
),

final as (
    select
        order_id
        , customer_id
        , created_at = min(created_at) over (partition by customer_id) as is_first_order
        , order_total
        , created_at as sold_at
    from orders
)

select * 
from final