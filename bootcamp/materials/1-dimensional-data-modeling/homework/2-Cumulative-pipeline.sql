--work in progress query
-- think about how the yesterday and today will work toghether when you have more than one record for an actor each year

with 
yesterday_stats as
(
select * 
from actors a
where a.current_year = 1969
),
today_stats as 
(
select * 
from actor_films af
where af.year = 1970
),
cumulative_stats as (
select 
coalesce(t.actorid,y.actorid) as actorid,
coalesce(t.actor,y.actor) as actor,
case when y.films is null 
	then array[row(t.filmid,
					t.film,
					t.votes,
					t.rating,
					t.year
				)::films]
when t.year is not null 
	then y.films || array[row(t.filmid,
					t.film,
					t.votes,
					t.rating,
					t.year
				)::films]
else y.films
end as films,
case when t.year is not null then --fix the quality_class logic
	(case when t.rating > 7.5 then 'star'
		when t.rating > 5 then 'good'
		when t.rating > 2.5 then 'average'
	else 'poor' end)::quality_class
else y.quality_class end as quality_class,
case when t.year is null then false else true end as is_active,
coalesce (t.year,y.current_year + 1) as current_year
from yesterday_stats y
full outer join today_stats t
on t.actorid = y.actorid
)
merge into actors a
using cumulative_stats cs
on cs.actorid = a.actorid
when matched then 
	update set a.films = a.films || cs.films
	a.quality_class = cs.quality_class
when not matched then 

;