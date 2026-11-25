
select * from transactions
limit 10;

-- Find where the transaction is_fraud or is_flagged_fraud

select 
	count(*) as total_fraud_txns
from transactions
where is_fraud = 1 or is_flagged_fraud = 1; -- 8213

-- Calculate the total amount

select 
	sum(amount) as total_amount
from transactions -- 1144392944759.77 (1,144.39 Billion)

-- BR-01. Calculate the total fraud amount

select 
	sum(amount) as total_amount
from transactions
where is_fraud = 1; -- 12056415427.84 (12.06 Billion)

-- BR-01. Calculate the percentage of total transaction amount that comes from fraudulent transactions
select
	round((select 
	sum(amount) as total_amount
from transactions
where is_fraud = 1) * 100.0 / sum(amount), 4) as fraud_amt_percentage
from transactions; -- 1.0535 %


-- BR-01. Calculate the total transaction amount separately for fraudulent and normal transactions

select
	case when is_fraud = 1 then 'Fraud' -- 12056415427.84 (12.06 billion)
	     else 'Normal'                  -- 1132336529331.93 (1,132.34 billion)
		 end as transaction_type,
	sum(amount) as total_amount
from transactions
group by is_fraud;


-- BR-02. Find the average transaction amount for each transaction type

select
	transaction_type,
	round(avg(amount), 2) as average_amount
from transactions
group by transaction_type
order by average_amount desc;

-- BR-03. Which transaction types carry fraud? Also calculate the fraud rate percentage

select
	transaction_type,
	sum(case when is_fraud = 1 then 1
	     else 0
		 end) as fraud_count,
	round(sum(case when is_fraud = 1 then 1
	     else 0
		 end) * 100.0 / count(*), 3) as fraud_rate_percentage
from transactions
group by transaction_type
order by fraud_count desc;


-- BR-04. At what hours does fraud peak?

select
  hour_of_day,
  sum(txns) as txns,
  sum(total_frauds) as total_frauds,
  round(sum(total_frauds) * 100.0 / sum(txns), 2) as fraud_rate_pct
from vw_fraud_summary
group by hour_of_day
order by fraud_rate_pct desc;

-- Total fraud count between hour 1 to 5

select
	'1_to_5' as hour_is,
	sum(total_frauds) as total_frauds
from vw_fraud_summary
where hour_of_day between 1 and 5;


-- BR-05: Is fraud rising, falling or steady?

select
  day_no,
  sum(txns) as txns,
  sum(total_frauds) as frauds,
  round(sum(total_frauds) * 100.0 / sum(txns), 3) as fraud_rate_pct
from vw_fraud_summary
group by day_no
order by day_no asc;

-- hours where every transaction is fraud (expected: 320)
select
count(*) as fraud_only_hours
from (
	  select time_step
	  from transactions
	  group by time_step
	  having count(*) = sum(is_fraud)
     ) t;

-- BR-06: Which amounts are risky?

select
	amount_band,
	sum(txns) as total_txns,
	sum(total_frauds) as total_frauds,
	round(sum(total_frauds) * 100.0 / sum(txns), 3) as fraud_rate_pct
from vw_fraud_summary
group by amount_band
order by fraud_rate_pct desc;

























