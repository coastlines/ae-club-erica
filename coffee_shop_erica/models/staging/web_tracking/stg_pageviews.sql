{{ config(
    materialized='table'
 ) }}
 
with first_id as (
  select
    id as pageview_id
    , visitor_id
    , device_type
    , timestamp as visited_at
    , page as page_visited
    , customer_id
    , first_value(visitor_id) over (partition by customer_id order by timestamp) as first_visitor_id
    , first_value(customer_id ignore nulls) over (partition by visitor_id order by timestamp) as first_customer_id
  from {{ source('web_tracking', 'pageviews')}}
  order by visitor_id
  -- -- from analytics-engineers-club.web_tracking.pageviews
)

, unified_ids as (
  select 
    pageview_id
    , coalesce(first_visitor_id, visitor_id) as visitor_id
    , device_type
    , visited_at
    , page_visited
    , coalesce(customer_id, first_customer_id) as customer_id
  from first_id
)

, sessionized as (
  select 
    ui.*
    , sum(is_new_session) over (order by ui.visitor_id, ui.visited_at) as global_session_id
    , sum(is_new_session) over (partition by ui.visitor_id order by ui.visited_at) as user_session_id
  from unified_ids ui
  left join (
    select *
      , case when unix_seconds(visited_at) - unix_seconds(last_event) >= (60 * 30) or last_event is null then 1 else 0 end as is_new_session
    from (
      select ui2.*
        , lag(visited_at, 1) over (partition by visitor_id order by visited_at) as last_event
      from unified_ids ui2
    ) last_event_query
  ) as final on ui.pageview_id = final.pageview_id
)

select *
  , min(visited_at) over (partition by visitor_id, global_session_id) as session_start_time
  , max(visited_at) over (partition by visitor_id, global_session_id) as session_end_time
from sessionized