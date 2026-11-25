-- VIEW 4: vw_balance_patterns
-- Power BI page 8
-- TRANSFER and CASH_OUT only.

-- WARNING: in this dataset fraud transactions are cancelled, so balance
-- columns can leak the answer. Show this page with a warning label.

-- One row = combination of the three balance flags
-- ---------------------------------------------------------------------

drop view if exists vw_balance_patterns;

-- Create view

create view vw_balance_patterns as
select
  case when sender_balance_after = 0 and sender_balance_before > 0 then 'Emptied'
	   else 'Not emptied'
	   end as sender_account_status,
  case when amount = sender_balance_before and amount > 0 then 'Full balance'
	   else 'Part of balance'
	   end as amount_vs_balance,
  case when receiver_balance_before = 0 and receiver_balance_after = 0 then 'Untouched'
	   else 'Changed'
	   end as receiver_balance_status,
  count(*) as txns,
  sum(is_fraud) as total_frauds
from transactions
where transaction_type in ('TRANSFER', 'CASH_OUT')
group by sender_account_status, amount_vs_balance, receiver_balance_status;

-- Check view

select
	sender_account_status,
	amount_vs_balance,
	receiver_balance_status,
	txns,
	total_frauds
from vw_balance_patterns;










