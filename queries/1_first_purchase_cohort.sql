-- Запрос №1: Месяц первой покупки каждого клиента
-- Автор: Глеб Юлегин
-- Дата: 2026-09-25
with first_purchase as (
select 
customer_id, 
min(date_trunc('month', invoice_date)) as first_purchase_month 
from retail
where quantity > 0
and price > 0
and customer_id is not null 
group by customer_id)
select first_purchase_month, COUNT(*) as cohort_size
from first_purchase
group by first_purchase_month
order by first_purchase_month;