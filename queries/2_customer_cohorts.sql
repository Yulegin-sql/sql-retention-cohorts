-- Запрос №2: Когорты клиентов
-- Автор: Глеб Юлегин
-- Дата: 2026-09-26
select 
customer_id, 
min(date_trunc('month', invoice_date)) as first_purchase_month 
from retail
where quantity > 0
and price > 0
and customer_id is not null 
group by customer_id
order by first_purchase_month, customer_id;