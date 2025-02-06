
use final;

select * from healthcare_dataset;

select concat(
		upper(substring(name, 1, 1)), 
        lower(substring(name, 2, locate(" ", name) -1)), 
        upper(substring(name, locate(" ", name) + 1, 1)), 
        lower(substring(name, locate(" ", name)+2)) )
        from healthcare_dataset; 
set sql_safe_updates = 0;
update healthcare_dataset 
set `Date of Admission` = cast(`Date of Admission` as date);

update healthcare_dataset
set `Discharge Date` = cast(`Discharge Date` as date);
 
update healthcare_dataset 
set `Billing Amount` = round(`Billing Amount`, 2);

-- find average billing amount for each insurance provider 
select `Insurance Provider`, avg(`Billing Amount`) as avg_price
from healthcare_dataset
group by `Insurance Provider` 
order by avg_price; 

-- find max price for each medical condition 
select `Medical Condition`, max(`Billing Amount`) as max_price
from healthcare_dataset
group by `Medical Condition`
order by max_price desc; 

-- rank doctors by total treated patients
with counts as (
select Doctor, count(*) as treated_patients
from healthcare_dataset 
group by Doctor )

select Doctor, treated_patients,
rank() over(order by  counting desc) as ranking
from counts;

-- Hospitals who charge more than average billing amount 
select Hospital, avg(`Billing Amount`) as avg_billing_amount
from healthcare_dataset
where `Billing Amount` > (select 
						avg(`Billing Amount`) 
                        from healthcare_dataset)
group by Hospital
order by avg_billing_amount desc; 


-- gives admission types for admission types whose average age is over 51
with tb1 as (
select round(avg(Age)) as avg_age, `Admission Type`
from healthcare_dataset 
group by `Admission Type`)

select `Admission Type`, avg_age
from tb1
where tb1.avg_age > 51;

-- ranking hospitals on total billing 
with tb2 as (
select Hospital, round(sum(`Billing Amount`),2) as amount
from healthcare_dataset
group by Hospital )

select tb2.Hospital, amount, 
rank() over(order by amount desc) as ranking 
from tb2;

-- number of patients admitted each year over 10000
with tb3 as (
select year(`Date of Admission`) as calendar_year, count(*) admission_count
from healthcare_dataset
group by calendar_year)

select calendar_year, admission_count
from tb3 
where admission_count > 10000
order by admission_count desc; 





