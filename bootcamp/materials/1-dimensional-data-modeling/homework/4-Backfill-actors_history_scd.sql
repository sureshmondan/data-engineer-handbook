insert into actors_history_scd
with actor_stats as /*actor_stats finds the current, previous and next stats that are being tracked for the actor*/
(
select 	a.actorid,
		a.actor,
		a."quality_class" as curr_quality_class,
		lag(a."quality_class", 1) over (partition by a.actorid order by a.current_year) as prev_quality_class,
		lead(a."quality_class", 1) over (partition by a.actorid order by a.current_year) as next_quality_class,
		a.is_active as curr_is_active,
		lag(a.is_active, 1) over (partition by a.actorid order by a.current_year) as prev_is_active,
		lead(a.is_active, 1) over (partition by a.actorid order by a.current_year) as next_is_active,
		a.current_year
from actors a
--where  a.actorid in ('nm0000001','nm0000003') 
/*and	a.current_year in (2020,2021)*/
--order by a.actorid,a.current_year
),
ast_windowed as /*finding the start and end years*/
(
select	ast.*,
		case 	when ast.prev_quality_class is null and ast.prev_is_active is null then ast.current_year
				when ast.curr_quality_class <> ast.prev_quality_class or ast.curr_is_active <> ast.prev_is_active then ast.current_year
				else null 
		end as start_year,
		case 	when ast.next_quality_class is null and ast.next_is_active is null then 9999
				when ast.curr_quality_class <> ast.next_quality_class or ast.curr_is_active <> ast.next_is_active then ast.current_year
				else null
		end as end_year
from	actor_stats ast
--order by ast.current_year
)
/*Build the SCD backfill query*/
select	aw_sd.actorid,
		aw_sd.actor,
		aw_sd.curr_quality_class as quality_class,
		aw_sd.curr_is_active as is_active,
		min(aw_sd.start_year) as start_year,
		min(aw_ed.end_year) as end_year
from 	ast_windowed aw_sd
join 	ast_windowed aw_ed
on	 	aw_sd.actorid = aw_ed.actorid
and 	aw_ed.current_year >= aw_sd.current_year
and 	aw_ed.end_year is not null
where	aw_sd.start_year is not null
group by aw_sd.actorid, aw_sd.actor, aw_sd.curr_quality_class, aw_sd.curr_is_active, aw_sd.current_year
order by aw_sd.actorid, aw_sd.current_year
;