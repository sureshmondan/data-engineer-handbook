/*device_activity type is created to record the metrics by browser type*/
create type device_activity as (
    device_id numeric,
    browser_type text,
    activity_datelist date[]
)
;

/*the table needs to be at the user grain since the ask is the obtain the user activity by each user and broowser type*/
create table user_devices_cumulated
(
    user_id numeric,
    device_activity device_activity [],
    active_days integer,
    primary key (user_id)
)
;