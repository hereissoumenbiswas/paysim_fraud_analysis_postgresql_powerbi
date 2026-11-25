-- VIEW 2: vw_receiver_type_summary
-- Power BI page 7
-- One row = receiver type (Customer or Merchant)
-- ---------------------------------------------------------------------

drop view if exists vw_receiver_type_summary;

-- Create view

create view vw_receiver_type_summary as
select
  case when substring(receiver_id, 1, 1) = 'M' then 'Merchant'
  else 'Customer'
  end as receiver_type,
  count(*) as txns,
  sum(is_fraud) as total_frauds,
  sum(amount) as total_amount,
  sum(case when is_fraud = 1 then amount else 0 end) as fraud_amount
from transactions
GROUP BY receiver_type;


-- Check view

select * from vw_receiver_type_summary;



