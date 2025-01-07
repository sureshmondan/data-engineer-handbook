-- Create a type films with the requested fields

drop type films cascade;

create type films as(
    filmid text,
    film text,
    votes integer,
    rating REAl
)
;

-- Create a eNum type quality_class with the possible values

drop type quality_class cascade;

create type quality_class as enum ('star', 'good', 'average', 'bad')
;

-- Create the table actors with the requested fields

drop table actors;

create table actors ( 
	actorid text,
    actor TEXT,
    films films [],
    quality_class quality_class,
    is_active BOOLEAN,
    current_year integer,
    primary key (actorid,current_year)
)
;