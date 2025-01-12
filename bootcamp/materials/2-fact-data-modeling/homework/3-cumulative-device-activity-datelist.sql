with cte_datelist as
(
select 	e.user_id,
		d.device_id,
		d.browser_type,
		array_agg(distinct e.event_time::date) as device_datelist
from	devices d
join	events e 
using 	(device_id)
group by 	e.user_id,
			d.device_id,
			d.browser_type 
--order by 1,2
)
select	cd.user_id,
		array_agg(row(cd.device_id,
			cd.browser_type,
			cd.device_datelist)::device_activity) as device_activity
from 	cte_datelist cd
group by cd.user_id
order by cd.user_id 
;