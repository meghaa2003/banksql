#DISPLAY THE ENTIRE TABLE
select * from bank.bank_tab;

#CUSTOMER COUNT BY GEOGRPAHY AND GENDER
select geography,
count(*) as total_customers,
concat(round(100.0*count(case when gender='Female' then 1 end)/count(*), 2), '%') as female_perct,
concat(round(100.0*count(case when gender='Male' then 1 end)/count(*), 2), '%') as male_perct
from bank.bank_tab
group by geography
order by total_customers desc;

#average credit score by gender
select gender,
avg(creditscore) as avg_cs
from bank.bank_tab
group by gender
order by avg_cs desc;

#avg credit score by geo
select geography,
avg(creditscore) as avg_cs
from bank.bank_tab
group by geography
order by avg_cs desc;

#avg credit score by gender and gepgraphy
select geography, gender,
avg(creditscore) as avg_cs
from bank.bank_tab
group by geography, gender
order by avg_cs desc;

#balance and credit score by age
with cte as (
select age, balance, creditscore, 
case when age <= 18 then 'teen'
when age > 18 and age <= 30 then 'new adult' 
when age > 30 and age <= 50 then 'middle age'
when age > 50 then 'senior'
end as age_group
from bank.bank_tab
)
select age_group,
round(avg(balance), 2) as avg_bal,
round(avg(creditscore), 2) as avg_cs
from cte
group by age_group
order by avg_bal desc;

#NO OF ACTIVE MEMBERS WHO HAVE EXITED AND STAYED
select
case when isactivemember=1 then 'yes' else 'no' end as isactivemember,
concat(round(100.0*count(case when exited=1 then 1 end)/count(*), 2), '%') as stayed,
concat(round(100.0*count(case when exited=0 then 1 end)/count(*), 2), '%') as exited
from bank.bank_tab
group by isactivemember;

#EXPLORING OTHER ATTRIBUTES WITH RESPECT TO EXITED OR NOT
select 
case when exited=0 then 'no' else 'yes' end as exited,
round(avg(balance), 2) as avg_bal,
round(avg(estimatedsalary), 2) as avg_sal,
round(avg(creditscore), 2) as avg_cs,
count(numofproducts) as num_products_bought,
round(avg(tenure), 2) as avg_tenure,
round(avg(age), 2) as avg_age,
concat(round(100.0*count(case when isactivemember=1 then 1 end)/count(*), 2), '%') as perct_active_members 
from bank.bank_tab
group by exited;

#EXIT OR NOT AND ACTIVE MEMBERS BY GEOGRAPHY
select geography, gender,
concat(round(100.0*count(case when exited=1 then 1 end)/count(*), 2), '%') as exited_perc,
concat(round(100.0*count(case when isactivemember=1 then 1 end)/count(*), 2), '%') as active_member_perc
from bank.bank_tab
group by geography, gender
order by geography, exited_perc desc;

