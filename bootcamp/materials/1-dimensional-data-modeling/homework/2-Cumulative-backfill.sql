insert into actors
with
years_ls as 
(
select generate_series(min(af."year"),max(af."year")) as year_series
from actor_films af 
),
actor_year_stats as 
(
select af.actorid,
	af.actor,
	af.year,
	((case when avg(af.rating) > 8 then 'star'
			when avg(af.rating) > 7 and avg(af.rating) <= 8 then 'good'
			when avg(af.rating) > 6 and avg(af.rating) <= 7 then 'average'
			when avg(af.rating) <= 6 then 'bad'
			else null end
		)::quality_class) as yearly_rating,
	true as is_active_year
from actor_films af
--where af.actorid = 'nm0000003'
--and af.year = 1971
group by 1,2,3
)
select 	af.actorid,
		af.actor,
		array_agg(row(af.filmid,af.film,af.votes,af.rating)::films) as films,
		coalesce (ays.yearly_rating,
			(select ays2.yearly_rating from actor_year_stats ays2 where ays2.actorid = af.actorid and ays2.year < yls.year_series order by ays2.year desc limit 1)) as quality_class,
		coalesce(ays.is_active_year, false) as is_active,
		yls.year_series as current_year
from years_ls yls
join actor_films af
on af.year <= yls.year_series
left join actor_year_stats ays
on ays.actorid = af.actorid 
and ays.year = yls.year_series
--where af.actorid = 'nm0000012'
--and yls.year_series in (1970,1971,1972,1973)
group by af.actorid,af.actor,yls.year_series,ays.yearly_rating,ays.is_active_year
order by yls.year_series
;