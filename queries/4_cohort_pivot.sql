-- Создаем VIEW для удобства
create or replace view retention_by_month as
with customer_cohorts as (
select 
customer_id,
min(to_char(invoice_date, 'YYYY-MM-01')::date) as cohort_month
from retail
where quantity > 0 and price > 0 and customer_id is not null
group by customer_id
),
cohort_activities as (
select 
cc.cohort_month,
cc.customer_id,
to_char(invoice_date, 'YYYY-MM-01')::date as activity_month
from retail r
join customer_cohorts cc on r.customer_id = cc.customer_id
where r.quantity > 0 and r.price > 0
group by cc.cohort_month, cc.customer_id, to_char(invoice_date, 'YYYY-MM-01')::date
),
monthly_counts as (
select 
cohort_month,
(extract(year from activity_month) - extract(year from cohort_month)) * 12 +
(extract(month from activity_month) - extract(month from cohort_month)) as month_number,
count(distinct customer_id) as customers_count
from cohort_activities
group by cohort_month, month_number
),
cohort_sizes as (
select cohort_month, customers_count as cohort_size
from monthly_counts
where month_number = 0
)
select 
    mc.cohort_month,
    mc.month_number,
    mc.customers_count,
    cs.cohort_size,
    round(100.0 * mc.customers_count / cs.cohort_size, 2) as retention_rate
from monthly_counts mc
join cohort_sizes cs on mc.cohort_month = cs.cohort_month;
-- Запрос №4: Когортная таблица (pivot)
-- Автор: Глеб Юлегин
-- Дата: 2026-09-30
select 
    cohort_month,
    max(case when month_number = 0 then retention_rate end) as m0,
    max(case when month_number = 1 then retention_rate end) as m1,
    max(case when month_number = 2 then retention_rate end) as m2,
    max(case when month_number = 3 then retention_rate end) as m3,
    max(case when month_number = 4 then retention_rate end) as m4,
    max(case when month_number = 5 then retention_rate end) as m5,
    max(case when month_number = 6 then retention_rate end) as m6,
    max(case when month_number = 7 then retention_rate end) as m7,
    max(case when month_number = 8 then retention_rate end) as m8,
    max(case when month_number = 9 then retention_rate end) as m9,
    max(case when month_number = 10 then retention_rate end) as m10,
    max(case when month_number = 11 then retention_rate end) as m11,
    max(case when month_number = 12 then retention_rate end) as m12
from retention_by_month
group by cohort_month
order by cohort_month;