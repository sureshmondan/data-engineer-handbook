create type films as(
    filmid text,
    film text,
    votes integer,
    rating REAl,
    year integer
)
;

create type quality_class as enum ('star', 'good', 'average', 'poor')
;

--drop table actors;

create table actors ( 
	actorid text,
    actor TEXT,
    films films [],
    quality_class quality_class,
    is_active BOOLEAN,
    primary key (actorid)
)
;