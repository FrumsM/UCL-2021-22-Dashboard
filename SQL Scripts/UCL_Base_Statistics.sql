--Basic UCL Information

-- Using key_stats Table:
--Top 2 Football Clubs 
SELECT  DISTINCT TOP(2) club, match_played  FROM key_stats
ORDER BY  match_played DESC, club DESC

--Total UCL Group Stage Clubs
SELECT COUNT(DISTINCT club) as total_clubs FROM key_stats

--Percentage of Positions
SELECT position, ROUND(CAST(COUNT(position) as FLOAT)/(SELECT COUNT(position) FROM key_stats),3)* 100 as percentage_of_position FROM key_stats
GROUP BY position

--Top 10 Scorers + Assistants
SELECT TOP(10) player_name, goals, assists, goals + assists as total_goals_assists FROM key_stats
ORDER BY total_goals_assists DESC, goals DESC

--Top 10 Minutes Played
SELECT TOP(10) player_name, minutes_played as total_minutes_played FROM key_stats
ORDER BY minutes_played DESC

--Average Distance Covered
SELECT ROUND(AVG(distance_covered/match_played),2) as average_distance_covered FROM key_stats

--Average Minutes Played
SELECT ROUND(AVG(minutes_played/match_played),2) as average_minutes_played FROM key_stats

--Total Assists
SELECT SUM(assists) as total_assists FROM key_stats

--Total Goals
SELECT SUM(goals) as total_goals FROM key_stats

--Using goals Table:
--Percentage of Goals Each Part of the Body
SELECT ROUND(CAST(SUM(right_foot) AS FLOAT)/(SELECT SUM(goals) as total_goals FROM goals),3) * 100 as percentage_of_right_foot,
	   ROUND(CAST(SUM(left_foot) AS FLOAT)/(SELECT SUM(goals) as total_goals FROM goals),3) * 100 as percentage_of_left_foot, 
	   ROUND(CAST(SUM(headers) AS FLOAT)/(SELECT SUM(goals) as total_goals FROM goals),3) * 100 as percentage_of_head, 
	   ROUND(CAST(SUM(others) AS FLOAT)/(SELECT SUM(goals) as total_goals FROM goals),3) * 100 as percentage_of_other
FROM goals

--Total Penalties
SELECT SUM(penalties) as total_penalties FROM goals

--Percentage of Goals Inside/Outside Area
SELECT ROUND(CAST(SUM(inside_area) AS FLOAT)/(SELECT SUM(goals) as total_goals FROM goals),3) * 100 as percentage_of_inside_area,
	   ROUND(CAST(SUM(outside_areas) AS FLOAT)/(SELECT SUM(goals) as total_goals FROM goals),3) * 100 as percentage_of_outside_area
FROM goals

--Using attempts Table:
--Percentage of Attempts
SELECT ROUND(CAST(SUM(on_target) AS FLOAT)/(SELECT SUM(total_attempts) FROM attempts),4) * 100 as percentage_on_target,
	   ROUND(CAST(SUM(off_target) AS FLOAT)/(SELECT SUM(total_attempts) FROM attempts),4) * 100 as percentage_off_target,
	   ROUND(CAST(SUM(blocked) AS FLOAT)/(SELECT SUM(total_attempts) FROM attempts),4) * 100 as percentage_blocked
FROM attempts

--Using disciplinary Table:

--Total Fouls Commited
SELECT SUM(fouls_committed) as total_fouls FROM disciplinary

--Percentage of Yellow/Red Cards
SELECT ROUND(CAST(SUM(yellow) as FLOAT)/SUM(red+yellow),2) * 100 as percentage_yellow,
	   ROUND(CAST(SUM(red) as FLOAT)/SUM(red+yellow),2) * 100 as percentage_red
FROM disciplinary


