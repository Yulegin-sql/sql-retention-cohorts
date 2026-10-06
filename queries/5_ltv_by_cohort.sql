-- Запрос №5: LTV по когортам
-- Автор: Глеб Юлегин
-- Дата: 2026-10-07
with customer_cohorts as (
    select 
        customer_id,
        MIN(date_trunc('month'::text, invoice_date::timestamp)) as cohort_month
    FROM retail
    where quantity > 0 and price > 0 and customer_id is not null
    group by customer_id
)
select cc.cohort_month,
count(distinct cc.customer_id) as cohort_size,
round(SUM(r.quantity * r.price)::numeric, 2) as total_revenue,
round(SUM(r.quantity * r.price)::numeric / count(distinct cc.customer_id), 2) as ltv
from retail r 
join customer_cohorts cc on r.customer_id = cc.customer_id
where r.quantity > 0 and r.price > 0
group by cc.cohort_month  
order by cc.cohort_month;