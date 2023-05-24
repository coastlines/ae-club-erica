{{ config(
    materialized='table'
 ) }}

select global_session_id
  , count(*) as page_visits
  , count(distinct page_visited) as distinct_page_visits
  , timestamp_diff(session_end_time, session_start_time, second) as session_length
  , sum(distinct case when date(sold_at) = date(visited_at) then 1 else 0 end) as made_purchase
from {{ ref('stg_pageviews') }} p
left join {{ ref('fct_orders') }} as o on o.customer_id = p.customer_id
group by 1,4