--UCL Clubs Info

--Using key_stats Table:
--Club Names
SELECT DISTINCT club FROM key_stats
ORDER BY club

--Total Club Players, Total Forwarders, Total Midfielders, Defenders And Goalkeepers
SELECT club, COUNT(player_name) as total_players,
SUM(CASE WHEN position = 'Forward' THEN 1 ELSE 0 END) AS total_forwards,
SUM(CASE WHEN position = 'Midfielder' THEN 1 ELSE 0 END) AS total_midfielders,
SUM(CASE WHEN position = 'Defender' THEN 1 ELSE 0 END) AS total_defenders, 
SUM(CASE WHEN position = 'Goalkeeper' THEN 1 ELSE 0 END) AS total_goalkeepers FROM key_stats
GROUP BY club
ORDER BY club

--Total Goals and Assists of Each Club
SELECT club, SUM(goals) as total_goals, sum(assists) as total_assists FROM key_stats
GROUP BY club
ORDER BY club

--Average Mintes Played of Each Club
SELECT club, ROUND(AVG(minutes_played/match_played),2) as average_minutes_played FROM key_stats
GROUP BY club
ORDER BY club

--Average Distance Covered of Each Club
SELECT club, ROUND(AVG(distance_covered/match_played),2) as average_distance_covered FROM key_stats
GROUP BY club
ORDER BY club

--Average Goals of Each Club
SELECT club, ROUND(CAST(SUM(goals) as FLOAT)/MAX(match_played),2) as average_goals FROM key_stats
GROUP BY club

--Using goals Table:
--Total Penalties of Each Club
SELECT club, SUM(penalties) as total_penalties FROM goals
GROUP BY club
ORDER BY club 

--Top 5 Scorers/Assistors of Each Club
SELECT club, player_name, goals, assists, total_goals_assists FROM(
SELECT club, player_name, position, goals, assists, goals + assists as total_goals_assists,
ROW_NUMBER() OVER (PARTITION BY club ORDER BY  goals + assists DESC, goals DESC) AS row_num
FROM key_stats) ranked
WHERE row_num <= 5 AND (goals != 0 OR assists != 0) 

--Top 3 Forwarders of Each Club
SELECT club, player_name, goals, assists, total_goals_assists FROM(
SELECT club, player_name, position, goals, assists, goals + assists as total_goals_assists,
ROW_NUMBER() OVER (PARTITION BY club ORDER BY  goals + assists DESC, goals DESC) AS row_num
FROM key_stats
WHERE position = 'Forward') ranked
WHERE row_num <= 3 AND (goals != 0 OR assists != 0) 

--Using disciplinary Table:
--Total disciplinary of Each Club
SELECT club, SUM(fouls_committed) as total_fouls_commited, SUM(fouls_suffered) as total_fouls_suffered, SUM(red+yellow) as total_cards, SUM(red) as total_red_cars, SUM(yellow) as total_yellow_cards FROM disciplinary
GROUP BY club
ORDER BY club

--Using defending Table:
--Top 5 Defenders of Each Club
--(My Formula Weights: 
-- balls_recovered - 15%; tackles - 25%; tackles_won - 30%; tackles_lost - -20%; clearance_attempted - 10%)
SELECT player_name, club, defensive_index  FROM (
SELECT club, player_name, (0.15 * balls_recoverd) + (0.25 * tackles) + (0.30 * tackles_won) - (0.20 * tackles_lost) + (0.10 * clearance_attempted) AS defensive_index,
ROW_NUMBER() OVER (PARTITION BY club ORDER BY (0.15 * balls_recoverd) + (0.25 * tackles) + (0.30 * tackles_won) - (0.20 * tackles_lost) + (0.10 * clearance_attempted) DESC) AS row_num
FROM defending
WHERE position = 'Defender'
) ranked
WHERE row_num <= 5
ORDER BY club, defensive_index DESC;

--Top 5 Midfielders of Each Club
--(My Formula Weights: 
-- goals - 30%, assists - 20%, balls_recovered - 10%; tackles - 20%; tackles_won - 20%; tackles_lost - -10%; clearance_attempted - 10%)
SELECT player_name, club, midfielder_index  FROM (
SELECT defending.club, defending.player_name, (0.3 * key_stats.goals) + (0.2 * key_stats.assists) + (0.1 * balls_recoverd) + (0.2 * tackles) + (0.2 * tackles_won) - (0.1 * tackles_lost) + (0.1 * clearance_attempted) AS midfielder_index,
ROW_NUMBER() OVER (PARTITION BY defending.club ORDER BY (0.3 * key_stats.goals) + (0.2 * key_stats.assists) + (0.1 * balls_recoverd) + (0.2 * tackles) + (0.2 * tackles_won) - (0.1 * tackles_lost) + (0.1 * clearance_attempted) DESC) AS row_num
FROM defending
INNER JOIN key_stats ON
key_stats.player_name = defending.player_name
WHERE defending.position = 'Midfielder'
) ranked
WHERE row_num <= 5
ORDER BY club, midfielder_index DESC;

--Using goalkeeping Table:
--Top Goalkeeper Of Each Club
SELECT player_name, club, saved, conceded, saved_penalties, cleansheets, punches_made, goalkeeper_index FROM (
SELECT club, player_name, (0.3 * saved) + (0.25 * conceded) + (0.2 * saved_penalties) + (0.15 * cleansheets) + (0.1 * punches_made) AS goalkeeper_index, saved, conceded, saved_penalties, cleansheets, punches_made,
ROW_NUMBER() OVER (PARTITION BY club ORDER BY (0.3 * saved) + (0.25 * conceded) + (0.2 * saved_penalties) + (0.15 * cleansheets) + (0.1 * punches_made) DESC) AS row_num
FROM goalkeeping
WHERE position = 'Goalkeeper'
) ranked
WHERE row_num <= 1
ORDER BY club;
