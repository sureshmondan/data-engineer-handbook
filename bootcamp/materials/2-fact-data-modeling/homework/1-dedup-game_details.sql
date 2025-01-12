with cte_rownum as -- cte to introduce the row num field by the grain of the table (game_id, team_id, player_id)
(
select 	row_number() over (partition by gd.game_id, gd.team_id, gd.player_id) as row_num,
		gd.*
from	game_details gd 
)
select	cte.* 
from	cte_rownum cte
where 	cte.row_num = 1 --filtering row_num = 1 provides only one row per the grain in the table