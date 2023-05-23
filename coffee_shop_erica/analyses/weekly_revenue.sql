select
    date_trunc(sold_at, week) as week
    , is_first_order
    , sum(order_total) as revenue

from {{ ref('orders') }}

group by 1, 2
order by 1, 2