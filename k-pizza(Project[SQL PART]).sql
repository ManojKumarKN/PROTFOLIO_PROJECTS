create database K_PIZZA

use k_pizza
 select * from kpizza;
----------------------------------------------------------------------------------------------------------------------------------
---changing date format (DOO into DateofOrder)
alter table kpizza						/* add a new column */
ADD DateofOrder Date;

update kpizza							/* update the new values into new column by changing the date format*/
set DateofOrder = convert(Date , DOO);

select * from kpizza;
--------------------------------------------------------------------------------------------------------------------------------------------------------------

---changing time format(Time into ConvertedTime)
alter table kpizza						/* add a new column*/
add ConvertedTime TIME;

sp_RENAME 'kpizza.Time', 'Timee', 'COLUMN' /* change the pre exisiting coulmn name from time to timee as "time" is a datatype it cant be a column name.*/


update kpizza							/* update the new values into new column by changing the time format*/
set ConvertedTime = convert(TIME ,Timee);

select * from kpizza;
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- removing unwanted columns



alter table kpizza
drop column step1,step2,step3,step4,Email

alter table kpizza
drop column DOO,Timee;

---------------------------------------------------------------------------------------------------------------------------------------------------
--changing the colunm name 

sp_RENAME 'kpizza.correctedEmail', 'Email', 'COLUMN'	/* changing names of exisiting coulmns to a meaningful column name*/
sp_RENAME 'kpizza.ConvertedTime', 'TimeofOrder', 'COLUMN'

select * from kpizza;
update  kpizza  set location = 'BTM' where id =55;
----------------------------------------------------------------------------------------------------------------------------------------------------
/* some information pulled out using sql queries from the database*/

--name wise sum of total sales
 Select name, sum(total_amount)as total from kpizza group by name having sum(total_amount)>500 order by total desc;
--chicken pizza greater than 500(total sum)
select name, sum(total_amount) as chicken_pizza from kpizza where product_type='chicken pizza' group by name having sum(total_amount)>500 order by chicken_pizza desc;
--locaion wise total sum having total sum more than 5000 overall
select location,sum(total_amount) as total from kpizza group by location  having sum(total_amount)>5000 order by total desc
--to know what is the highest sale(day wise)
select top 1 total_amount from(select top 2 total_amount from kpizza order by total_amount desc) tot order by total_amount
--location wise sum of total sales
select location,sum(total_amount) as totalamount from kpizza group by location order by totalamount desc; 
--product wise sum of total sales
select product_type,sum(total_amount) as totalamount from kpizza group by product_type order by totalamount desc;
--gender wise total sale BASED ON THE LOCATION
select gender,sum(total_amount) as totalamount from kpizza WHERE LOCATION = 'BTM'  group by gender  order by totalamount desc;
--average revenue generated in each location
select location,avg(total_amount) as totalamount from kpizza group by location order by totalamount desc; 

--------------------------------------------------------------------------------------------------------------------------------------------------