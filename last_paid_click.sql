with paid_touches as (
    select
        s.visitor_id,
        s.visit_date,
        s.source,
        s.medium,
        s.campaign,
        l.lead_id,
        l.created_at,
        l.amount,
        l.closing_reason,
        l.status_id
    from
        sessions as s
    left join leads as l
        on
            s.visitor_id = l.visitor_id
            and s.visit_date <= l.created_at
    order by
        s.visitor_id asc,
        s.visit_date desc
),

last_paid_touch as (
    select distinct on
    (visitor_id) *
    from
        paid_touches
    where
        medium != 'organic'
)

select
    lpt.visitor_id,
    lpt.visit_date,
    lpt.source as utm_source,
    lpt.medium as utm_medium,
    lpt.campaign as utm_campaign,
    lpt.lead_id,
    lpt.created_at,
    lpt.amount,
    lpt.closing_reason,
    lpt.status_id
from
    last_paid_touch as lpt
order by
    lpt.amount desc nulls last,
    lpt.visit_date asc,
    utm_source asc,
    utm_medium asc,
    utm_campaign asc;