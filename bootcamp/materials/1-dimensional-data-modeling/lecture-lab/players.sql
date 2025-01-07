 CREATE TYPE season_stats AS (
                         season Integer,
                         pts REAL,
                         ast REAL,
                         reb REAL,
                         weight INTEGER
                       );
 CREATE TYPE scoring_class AS
     ENUM ('bad', 'average', 'good', 'star');


 CREATE TABLE players (
     player_name TEXT,
     height TEXT,
     college TEXT,
     country TEXT,
     draft_year TEXT,
     draft_round TEXT,
     draft_number TEXT,
     seasons season_stats[],
     scoring_class scoring_class,
     years_since_last_active INTEGER,
     is_active BOOLEAN,
     current_season INTEGER,
     PRIMARY KEY (player_name, current_season)
 );

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