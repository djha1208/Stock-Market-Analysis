
set sql_safe_updates=0;

-- Change the format of date in bajaj_auto,eicher_motors,hero_motocorp,infosys,tcs,tvs_motors
update bajaj
set Date=str_to_date(Date,'%d-%M-%Y');

update eicher
set Date=str_to_date(Date,'%d-%M-%Y');

update hero
set Date=str_to_date(Date,'%d-%M-%Y');

update infosys
set Date=str_to_date(Date,'%d-%M-%Y');

update tcs
set Date=str_to_date(Date,'%d-%M-%Y');

update tvs
set Date=str_to_date(Date,'%d-%M-%Y');

-- Change the column name from Date to `Date` in bajaj_auto, eicher_motors, hero_motocorp, infosys, tcs, tvs_motors

alter table bajaj
change Date `Date` date;

alter table eicher
change Date `Date` date;

alter table hero
change Date `Date` date;

alter table infosys
change Date `Date` date;

alter table tcs
change Date `Date` date;

alter table tvs
change Date `Date` date;


-- Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA from Bajaj Auto--
-- Bajaj1 ---------------------------------------------------------
-- * START * ---------------
create table bajaj1 as
select  `Date`, Close_Price as 'Close Price', case when row_number() over (order by `Date`)>19 
	    then avg(Close_Price) over (order by `Date` rows between 19 preceding and current row) 
        end as '20 Day MA' , case when row_number() over (order by `Date`) >49
	    then avg(Close_Price) over (order by `Date` rows between 49 preceding and current row)
 		end as '50 Day MA'
from bajaj
order by `Date`;

select *
from bajaj1;

-- * END * --------------

-- Create a new table named 'eicher1' containing the date, close price, 20 Day MA and 50 Day MA from Eicher Motors--
-- Eicher1 ---------------------------------------------------------------------
-- * START * -------------------------------------------------------

create table eicher1 as
select  `Date`, Close_Price as 'Close Price', case when row_number() over (order by `Date`)>19 
	    then avg(Close_Price) over (order by `Date` rows between 19 preceding and current row) 
        end as '20 Day MA' , case when row_number() over (order by `Date`) >49
	    then avg(Close_Price) over (order by `Date` rows between 49 preceding and current row)
 		end as '50 Day MA'
from eicher
order by `Date`;

select *
from eicher1;

-- * END * ---------------------------


-- Create a new table named 'hero1' containing the date, close price, 20 Day MA and 50 Day MA from Hero Motocorp table--
-- Hero1 ------------------------------------------------------------------------------------------
-- * START * -----------------------------------------------------------------------

create table hero1 as
select  `Date`, Close_Price as 'Close Price', case when row_number() over (order by `Date`)>19 
        then avg(Close_Price) over (order by `Date` rows between 19 preceding and current row) 
        end as '20 Day MA' , case when row_number() over (order by `Date`) >49
        then avg(Close_Price) over (order by `Date` rows between 49 preceding and current row)
		end as '50 Day MA'
from hero
order by `Date`;

select *
from hero1;

-- * END * -------------------------------------


-- Create a new table named 'infosys1' containing the date, close price, 20 Day MA and 50 Day MA from Infosys table--
-- infosys1 ----------------------------------------------------------------------------------------------
-- * START * ----------------------------------------------------------------------

create table infosys1 as
select `Date`, Close_Price as 'Close Price', case when row_number() over (order by `Date`)>19 
	    then avg(Close_Price) over (order by `Date` rows between 19 preceding and current row) 
        end as '20 Day MA' , case when row_number() over (order by `Date`) >49
        then avg(Close_Price) over (order by `Date` rows between 49 preceding and current row)
		end as '50 Day MA'
from infosys
order by `Date`;

select *
from infosys1;

-- * END * ------------------------------------


-- Create a new table named 'tcs1' containing the date, close price, 20 Day MA and 50 Day MA from TCS table--
-- tcs1 -----------------------------------------------------------------------------------------------
-- * START * --------------------------------------------------------------

create table tcs1 as
select `Date`, Close_Price as 'Close Price', case when row_number() over (order by `Date`)>19 
	   then avg(Close_Price) over (order by `Date` rows between 19 preceding and current row) 
	   end as '20 Day MA' , case when row_number() over (order by `Date`) >49
	   then avg(Close_Price) over (order by `Date` rows between 49 preceding and current row)
	   end as '50 Day MA'
from tcs
order by `Date`;

select *
from tcs1;

-- * END * ----------------------------------------


-- Create a new table named 'tvs1' containing the date, close price, 20 Day MA and 50 Day MA from TVS Motors --
-- tvs1 ---------------------------------------------------------------------------------------
-- * START *---------------------------------------------------------------------

create table tvs1 as
select  `Date`, Close_Price as 'Close Price', case when row_number() over (order by `Date`)>19 
	    then avg(Close_Price) over (order by `Date` rows between 19 preceding and current row) 
        end as '20 Day MA', case when row_number() over (order by `Date`) >49
        then avg(Close_Price) over (order by `Date` rows between 49 preceding and current row)
		end as '50 Day MA'
from tvs
order by `Date`;

select *
from tvs1;

-- * END * ---------------------------------------------------------------------


--  Create a master table containing the date and close price of all the six stocks (Column header for the price is the name of the stock)--
-- Master Table --------------------------------------------------------------------------------
-- * START * ------------------------------------------------------

create table `master table` as
select bajaj1.`Date` as 'Date', bajaj1.`Close Price` as 'Bajaj', tcs1.`Close Price` as 'TCS', tvs1.`Close Price` as 'TVS', infosys1.`Close Price` as 'Infosys', eicher1.`Close Price` as 'Eicher', hero1.`Close Price` as 'Hero'
from bajaj1, tcs1, tvs1, infosys1, eicher1, hero1
where bajaj1.`Date`=tcs1.`Date` and bajaj1.`Date`=tvs1.`Date` and bajaj1.`Date`=infosys1.`Date` and bajaj1.`Date`=eicher1.`Date` and bajaj1.`Date`=hero1.`Date`;

select *
from `master table`;

-- * END * --------------------------------------------------------


-- Generate buy,sell and hold signals for Bajaj Auto and store in new table bajaj2--
-- bajaj2----------------------------------------------------------
-- * START * --------------------------------------------

create table bajaj2 as
select `Date`, `Close Price`, case when row_number() over (order by `Date`)>50 then case when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) <0) and (`20 Day MA`-`50 Day MA`)>0 ) then 'BUY' when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) >0) and (`20 Day MA`-`50 Day MA`) <0) then 'SELL' else 'HOLD' end else 'NULL' end as 'Signal'
from bajaj1;

select *
from bajaj2;


-- * END * -----------------------------------------------


-- Generate buy,sell and hold signals for Eicher Motors and store in new table eicher2--
-- eicher2 --------------------------------------------------------
-- * START * ------------------------------------------

create table eicher2 as
select `Date`, `Close Price`, case when row_number() over (order by `Date`)>50 then case when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) <0) and (`20 Day MA`-`50 Day MA`)>0 ) then 'BUY' when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) >0) and (`20 Day MA`-`50 Day MA`) <0) then 'SELL' else 'HOLD' end else 'NULL' end as 'Signal'
from eicher1;

select *
from eicher2;

-- * END * --------------------------------------------


-- Generate buy,sell and hold signals for Hero Motocorp and store in new table hero2--
-- hero2 -----------------------------------------------------------
-- * START * ---------------------------------------------

create table hero2 as
select `Date`, `Close Price`, case when row_number() over (order by `Date`)>50 then case when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) <0) and (`20 Day MA`-`50 Day MA`)>0 ) then 'BUY' when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) >0) and (`20 Day MA`-`50 Day MA`) <0) then 'SELL' else 'HOLD' end else 'NULL' end as 'Signal'
from hero1;

select *
from hero2;

-- * END * -----------------------------------------------


-- Generate buy,sell and hold signals for Infosys and store in new table infosys2--
-- infosys2 --------------------------------------------------------
-- * START * ------------------------------------------

create table infosys2 as
select `Date`, `Close Price`, case when row_number() over (order by `Date`)>50 then case when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) <0) and (`20 Day MA`-`50 Day MA`)>0 ) then 'BUY' when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) >0) and (`20 Day MA`-`50 Day MA`) <0) then 'SELL' else 'HOLD' end else 'NULL' end as 'Signal'
from infosys1;

select *
from infosys2;

-- * END * --------------------------------------------


-- Generate buy,sell and hold signals for TCS and store in new table tcs2--
-- tcs2 ------------------------------------------------------------
-- * START * -----------------------------------------------

create table tcs2 as
select `Date`, `Close Price`, case when row_number() over (order by `Date`)>50 then case when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) <0) and (`20 Day MA`-`50 Day MA`)>0 ) then 'BUY' when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) >0) and (`20 Day MA`-`50 Day MA`) <0) then 'SELL' else 'HOLD' end else 'NULL' end as 'Signal'
from tcs1;

select *
from tcs2;

-- * END *--------------------------------------------------


-- Generate buy,sell and hold signals for TVS Motors and store in new table tvs2--
-- tvs2 --------------------------------------------------------
-- * START * ---------------------------------------

create table tvs2 as
select `Date`, `Close Price`, case when row_number() over (order by `Date`)>50 then case when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) <0) and (`20 Day MA`-`50 Day MA`)>0 ) then 'BUY' when ((lag((`20 Day MA`-`50 Day MA`),1) over (order by `Date`) >0) and (`20 Day MA`-`50 Day MA`) <0) then 'SELL' else 'HOLD' end else 'NULL' end as 'Signal'
from tvs1;

select *
from tvs2;

-- * END * -----------------------------------------


-- User defined function, that takes the date as input and returns the signal for that particular day (Buy/Sell/Hold) for the Bajaj stock--
--  UDF --------------------------------------------------------------------------------------------
-- * START *-------------------------------------------------------------------------

create function signals(d date)                # d for Date input
returns varchar(50)
deterministic
return
(
select `Signal`
from bajaj2
where `Date`=d);

select signals('2017-12-22') as 'Signals';


-- * END * --------------------------------------------------------------------
 