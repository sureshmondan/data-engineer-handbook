insert into actors
with 
yesterday_stats as
(
select * 
from actors a
where a.current_year = 2021
),
today_stats as 
(
select af.actorid,
	af.actor,
	af.year,
	array_agg(row(af.filmid,
		af.film,
		af.votes,
		af.rating
	)::films) as films_array,
	avg(af.rating) as avg_rating
from actor_films af
where af.year = 2022
group by 1,2,3
)
select 
coalesce(t.actorid,y.actorid) as actorid,
coalesce(t.actor,y.actor) as actor,
case when t.year is null then y.films
else
	y.films || t.films_array
end as films,
case when t.year is null then y.quality_class
else 
	(case when t.avg_rating > 8 then 'star'
		when t.avg_rating > 7 and t.avg_rating <=8 then 'good'
		when t.avg_rating > 6 and t.avg_rating <=7 then 'average'
		when t.avg_rating <=6 then 'bad'
	else 'bad' end
	)::quality_class
end as quality_class,
case when t.year is null then false else true end as is_active,
coalesce (t.year,y.current_year + 1) as current_year
from yesterday_stats y
full outer join today_stats t
on t.actorid = y.actorid
;