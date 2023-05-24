select
    date_trunc(first_order_at, month) as signup_month,
    count(*) as new_customers
 
from {{ ref('stg_coffee_shop_customers') }}
-- `aec-students.dbt_erica.customers`
 
group by 1