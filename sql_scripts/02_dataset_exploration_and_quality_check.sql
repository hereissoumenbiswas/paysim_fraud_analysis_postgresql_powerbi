-- Verify the load

select
	count(*) as total_rows,
	sum(is_fraud) as total_fraud,
	sum(is_flagged_fraud) as total_flagged_fraud
from transactions;



-- Datasets exploration

-- 1. Total transactions
select
count(sender_id) as total_transactions
from transactions; -- 6362620

-- 2. Total unique senders
select
count(distinct sender_id) as total_unique_senders
from transactions; -- 6353307

-- 3. Total unique receivers
select
count(distinct receiver_id) as total_unique_receivers
from transactions; -- 2722362

-- 4. Check minimum and maximum transaction amount
select
	min(amount) as min_amount, -- 0.00
	max(amount) as max_amount -- 92445516.64
from transactions;

-- 5. Find the customers who made more than one transactions
select
	sender_id,
	count(*) as total_transactions
from transactions
group by sender_id
having count(*) > 1
order by total_transactions desc;

-- 6. Total fraud percentage

select
	count(*) as total_transactions,
	sum(is_fraud) as total_frauds,
	round(sum(is_fraud) * 100.0 / count(*), 4) as fraud_percentage,
	sum(is_flagged_fraud) as total_flagged_frauds,
	round (sum(is_flagged_fraud) * 100.0 / count(*), 4) as flagged_fraud_percentage
from transactions;



-- Quality check

-- 7. Missing values in every column

select
	count(*) filter(where time_step is null) as null_time_Stamp,
	count(*) filter(where transaction_type is null) as null_type,
	count(*) filter(where amount is null) as null_amount,
	count(*) filter(where sender_id is null) as null_sender_id,
	count(*) filter(where sender_balance_before is null) as null_sender_balance_before,
	count(*) filter(where sender_balance_after is null) as null_sender_balance_after,
	count(*) filter(where receiver_balance_before is null) as null_receiver_balance_before,
	count(*) filter(where receiver_balance_after is null) as null_receiver_balance_after,
	count(*) filter(where is_fraud is null) as null_is_fraud,
	count(*) filter(where is_flagged_fraud is null) as null_is_flagged_fraud
from transactions;

-- 8. Duplicate rows check
select
	time_step,
	transaction_type,
	amount, sender_id,
	sender_balance_before,
	sender_balance_after,
	receiver_id,
	receiver_balance_before,
	receiver_balance_after,
	is_fraud,
	is_flagged_fraud,
	count(*) as duplicate_count
from transactions
group by time_step, transaction_type, amount, sender_id, sender_balance_before, sender_balance_after, receiver_id, receiver_balance_before,
receiver_balance_after, is_fraud, is_flagged_fraud
having count(*) > 1
order by duplicate_count desc;

-- 9. Transaction types

select
	transaction_type,
	count(*) as total_txns_count
from transactions
group by transaction_type
order by total_txns_count desc;

-- 10. Flag columns hold only 0 and 1

select
	'is_fraud' as column_name,
	is_fraud as value,
	count(*) as txns
from transactions
group by is_fraud

union all

select
	'is_flagged_fraud',
	is_flagged_fraud,
	count(*)
from transactions
group by is_flagged_fraud
order by column_name, value;

-- 11. Time range (1 step = 1 hour)

select
	min(time_step) as first_step,
	max(time_step) as last_step,
	count(distinct time_step) as distinct_steps
from transactions;

-- 12. Amount sanity

select
	count(*) filter(where amount < 0) as negative_amount,
	count(*) filter(where amount = 0) as zero_amounts,
	min(amount) as min_amount,
	max(amount) As max_amount
from transactions;

-- 13. The zero-amount rows (document them, do NOT delete them)

select
	time_step,
	transaction_type,
	amount,
	is_fraud,
	is_flagged_fraud
from transactions
where amount = 0
order by time_step;

-- 14. Negative balances

select
	count(*) as ngative_balance_rows
from transactions
where sender_balance_before < 0 or sender_balance_after < 0
   or receiver_balance_before < 0 or receiver_balance_after < 0;

-- 15. Where does fraud occur?

select
	transaction_type,
	count(*) as total_txns,
	sum(is_fraud) as total_frauds
from transactions
group by transaction_type
order by total_frauds;

-- 16. What does the system alert (is_flagged_fraud) cover?

select
	transaction_type,
	count(*) as flagged_rows,
	sum(is_fraud) as of_which_fraud
from transactions
where is_flagged_fraud = 1
group by transaction_type;





