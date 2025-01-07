--Still being worked on will need to be completed after the day2 training

drop table actors_history_scd;

create table actors_history_scd (
    actorid text,
    actor TEXT,
    quality_class quality_class,
    is_active BOOLEAN,
    start_year int,
    end_year int,
    primary key (actorid, start_year,end_year)
);