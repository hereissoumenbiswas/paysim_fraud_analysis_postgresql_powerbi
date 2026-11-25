-- VIEW 1: vw_fraud_summary
-- Power BI pages 1 to 6 and 9

-- One row = transaction_type x hour_of_day x day_no x amount_band
-- ---------------------------------------------------------------------

drop view if exists vw_fraud_summary;

-- Create view

create view vw_fraud_summary as
select
  transaction_type,
  (time_step - 1) % 24 as hour_of_day,
  (time_step - 1) / 24 + 1 as day_no,
  case when amount <= 10000 then '1. up to 10K'
       when amount <= 100000 then '2. 10K-100K'
       when amount <= 1000000 then '3. 100K-1M'
       when amount <= 10000000 then '4. 1M-10M'
       else '5. above 10M'
	   end as amount_band,
  count(*) as txns,
  sum(is_fraud) as total_frauds,
  sum(amount) as total_amount,
  sum(case when is_fraud = 1 then amount else 0 end) as fraud_amount,
  sum(is_flagged_fraud) as flagged,
  sum(case when is_flagged_fraud = 1 and is_fraud = 1 then 1 else 0 end) as flagged_and_fraud
from transactions
group by transaction_type, hour_of_day, day_no, amount_band;


-- Check view

select * from vw_fraud_summary;
















