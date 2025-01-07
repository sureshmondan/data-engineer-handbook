update actors_history_scd ahs set end_year = a.current_year - 1
from 	actors a
where 	a.current_year = 2021
and 	a.actorid = ahs.actorid 
and		ahs.end_year = 9999
and		(ahs."quality_class" <> a.quality_class or ahs.is_active <> a.is_active)
;

insert into actors_history_scd 
select	a.actorid ,
		a.actor ,
		a."quality_class" ,
		a.is_active,
		a.current_year as start_year,
		9999 as end_year
from 	actors a 
join	actors_history_scd ahs 
on 		a.current_year = 2021
and 	a.actorid = ahs.actorid
and 	ahs.end_year = 9999
and 	(ahs.quality_class <> a.quality_class or ahs.is_active <> a.is_active)
;