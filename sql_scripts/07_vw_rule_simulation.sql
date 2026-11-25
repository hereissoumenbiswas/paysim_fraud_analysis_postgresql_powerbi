-- view 5: vw_rule_simulation
-- power bi pages 9 and 10

-- one row = one rule. flagged = transactions the rule would stop,
-- caught = flagged transactions that are real fraud.
-- rules 3 to 5 use only amount and time (no balance columns).
-- ---------------------------------------------------------------------

drop view if exists vw_rule_simulation;

-- Create view

create view vw_rule_simulation as

with totals as
(
  select
	  sum(is_fraud) as total_frauds
  from transactions
),

rules as
(
  select 1 as rule_no,
  'Current system alert' as rule_name,
   count(*) as flagged,
   sum(is_fraud) as caught
  from transactions
  where is_flagged_fraud = 1

  union all
  
  select 2, 
  'Transfers above 200K',
  count(*),
  sum(is_fraud)
  from transactions
  where transaction_type = 'TRANSFER' and amount > 200000

  union all
  
  select 3, 
  'Amount above 500K (TRANSFER, CASH_OUT)',
  count(*),
  sum(is_fraud)
  from transactions
  where transaction_type in ('TRANSFER', 'CASH_OUT') and amount > 500000

  union all
  
  select 4,
  'Amount above 1M (TRANSFER, CASH_OUT)',
  count(*),
  sum(is_fraud)
  from transactions
  where transaction_type in ('TRANSFER', 'CASH_OUT') and amount > 1000000

  union all
  
  select 5,
  'Night hours 0 to 5 (TRANSFER, CASH_OUT)',
  count(*),
  sum(is_fraud)
  from transactions
  where transaction_type in ('TRANSFER', 'CASH_OUT')
  and (time_step - 1) % 24 between 0 and 5
)

select
  r.rule_no,
  r.rule_name,
  r.flagged,
  r.caught,
  t.total_frauds,
  round(100.0 * r.caught / nullif(r.flagged, 0), 2) as precision_pct,
  round(100.0 * r.caught / t.total_frauds, 2)       as recall_pct
from rules as r
cross join totals as t;


-- Check view

select 
	rule_no,
	rule_name,
	flagged,
	caught,
	total_frauds,
	precision_pct,
	recall_pct
from vw_rule_simulation
order by rule_no asc;





