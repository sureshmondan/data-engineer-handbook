drop type films cascade;

create type films as(
    filmid text,
    film text,
    year integer,
    votes integer,
    rating REAl
)
;

drop type quality_class cascade;

create type quality_class as enum ('star', 'good', 'average', 'bad')
;

drop table actors;

create table actors ( 
	actorid text,
    actor TEXT,
    films films [],
    quality_class quality_class,
    is_active BOOLEAN,
    current_year integer,
    primary key (actorid)
)
;

drop table actors_history_scd;

create table actors_history_scd (
    
)