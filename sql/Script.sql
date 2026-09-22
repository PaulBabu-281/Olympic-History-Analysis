select * from athlete_events_clean;

--1
SELECT key AS column_name, value AS distinct_value, COUNT(*) AS n
FROM athlete_events_clean t,
     jsonb_each_text(to_jsonb(t))
WHERE key not in ('name','id','event')
GROUP BY key, value
ORDER BY key, n DESC;

--Trent over time

select 
	year,
	games,
	season,
	count(distinct(id)) as number_of_athletes,
	count(distinct (noc)) as number_of_countries,
	count(distinct (event)) as number_of_events
from athlete_events_clean 
group by games,year,season 
order by year,season;


--female particpation

select
	year,
	season,
	count(distinct id) as total_athletes,
	count(distinct  id ) filter (where sex='F') as female_athletes,
	round(100*count( distinct id ) filter (where sex = 'F'):: numeric/count( distinct id),1) as pct_of_women
from athlete_events_clean
group by year,season
order by year,season;
	

--2

--avg age/height/weight drift by sport over time

select sport,
		year,
		round(avg(age)::numeric,1) as avg_age,
		lag(round(avg(age)::numeric,1)) over (partition by sport order by year) as prev_avg_age,
		round(avg(height)::numeric,1)as avg_height
from athlete_events_clean 
where age is not null 
group by sport,year 
order by sport,year;

--height and weight spread per sport

select 
		sport,
		count(*) as n,
		round(avg(height)::numeric,1) as avg_height,
		round(stddev(height)::numeric,1) as stddev_height,
		round(avg(weight)::numeric,1) as avg_weight,
		round(stddev(weight)::numeric,1) as stddev_weight
from athlete_events_clean 
where height is not null and weight is not null 
group by sport 
having count(*) >50
order by avg_height desc;



-- height and weight spread of medalists vs non meadlists 

select 
		sport,
		(medal is not null) as is_medalist,
		round(avg(height)::numeric,1) as avg_height,
		round(avg(weight)::numeric,1) as avg_weight,
		round(avg(age)::numeric,1) as avg_age,
		count(*) as n
from athlete_events_clean
order by sport, is_medalist desc
where height is not null and weight is not null and age is not null 
group by sport, (medal is not null)
order by sport, is_medalist desc;
		
		

		

		
		
		
		
		
		
		
		
		
		
		













