-- VIEW 3: vw_fraud_receivers
-- Power BI page 7

-- One row = one receiver account that received at least one fraud
-- ---------------------------------------------------------------------

drop view if exists vw_fraud_receivers;

-- Create veiw

create view vw_fraud_receivers as
select
  receiver_id,
  count(*) as frauds,
  sum(amount) as fraud_amount,
  count(distinct sender_id)  as fraud_senders
from transactions
where is_fraud = 1
group by receiver_id;

-- Check view

select * from vw_fraud_receivers;


