create database spotify;

use spotify;

create table Spotify_streams (
track_name varchar(100) unique primary key,
artist_name varchar(100) , 
artist_count int, 
released_year int,
released_month int,
released_day int,
in_spotify_playlists int,
in_spotify_charts int,
streams int,
in_apple_playlists int,
in_apple_charts int,
in_deezer_playlists int,
in_deezer_charts int,
in_shazam_charts int,
bpm int,
keyused varchar(100) ,
mode varchar(10),
danceability_percent int,
valence_percent int,
energy_percent int,
acousticness_percent int,
instrumentalness_percent int,
liveness_percent int,
speechiness_percent int
)


select *
from Spotify_streams;

/* Finding all the songs that begin with the ' to have better clarity on the data. */


select track_name,streams
from Spotify_streams
order by streams desc, track_name;


/* 1. Finding the highest party rated songs based on danceability. Write a query to find the top 10 songs that are most used for dancing. */

select *
from Spotify_streams
where released_year = '2023'
order by danceability_percent desc
limit 10;


/* 2. Find which month of 2023 had the most number of songs that were released. Return the year, month. */


select released_year, 
released_month , 
count(released_month) as Song_count
from Spotify_streams
where released_year = 2023 
group by released_year, released_month 
order by Song_count desc,released_year;



/* 3. Find the 2nd highest streams for 2023. */


with second_highest_streams as (
select *,
dense_rank() over(partition by released_year order by streams desc) as ranking
from Spotify_streams 
where released_year = 2023)

select track_name,artist_name,streams, ranking
from second_highest_streams
where ranking = 2;


/* 4. We want to find the top 3 highest danced percentage songs based on the entire dataset. Write a query to find that 
and return the song name along with the danceability percentage. */


with most_danced as (
select track_name, artist_name, released_year, released_month,released_day, streams,danceability_percent,
dense_rank() over(order by danceability_percent desc) as Ranking 
from Spotify_streams
)

select track_name, artist_name, released_year, released_month,released_day, streams, danceability_percent,
Ranking
from most_danced
where ranking <=3 ;


/* 5. Find the top 10 songs released in 2023 based on the spotify streams. Rank them from 1 to 10 based on streams. */


with top_rated as (
select *,
dense_rank() over(partition by released_year order by streams desc) as Highest_streamed
from Spotify_streams
where released_year = 2023
)
select *,
Highest_streamed
from top_rated 
where Highest_streamed <= 10; 


/* 6. Find the songs released by Bad Bunny and his count of tracks for the whole tracklist. */

select artist_name, count(artist_name) as No_of_songs
from Spotify_streams
where artist_name like 'Bad Bunny%';





/* 7. Find the percentage of songs released in each month of the year 2023. Return the track name,artist name,released_year,month 
and the percentage in desc order. */


with Month_name as (
select track_name,artist_name,released_year,
MONTHNAME(str_to_date(released_month,'%m')) as MonthName 
from Spotify_streams
where released_year = '2023')

select MonthName,
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY released_year) AS percentage
from Month_name
group by MonthName
order by percentage desc; 

/* 8. Find the percentage of single artists that have collaborated in the 2023. */


select artist_count,
count(*) * 100/sum(count(*)) over(partition by released_year) as Percent
from Spotify_streams
where released_year = 2023
group by artist_count
order by Percent desc;


select *
from Spotify_streams 
