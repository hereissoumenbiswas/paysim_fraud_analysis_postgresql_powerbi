
drop table if exists transactions;

-- Create the table

create table transactions
(
time_step int,
transaction_type varchar(30),
amount numeric(18,2),
sender_id varchar(30),
sender_balance_before numeric(18,2),
sender_balance_after numeric(18,2),
receiver_id varchar(30),
receiver_balance_before numeric(18,2),
receiver_balance_after numeric(18,2),
is_fraud smallint,
is_flagged_fraud smallint
);

-- Check the table

select * from transactions;

-- Import data

copy
transactions (time_step, transaction_type, amount, sender_id, sender_balance_before, sender_balance_after, receiver_id,
receiver_balance_before, receiver_balance_after, is_fraud, is_flagged_fraud)
from 'D:\Zidio_internship\Zidio_Internship_Project_two\Kaggle_dataset\Fraud_Detection_Data_02\Synthetic_Financial_datasets_log.csv'
with (format csv, header true, delimiter ',');

-- check the data

select * from transactions
limit 100;

select count(*) from transactions;

-- Total fraud count

select
sum(is_fraud) as total_fraud
from transactions;















