--Goalkeeping Statistics For Each Player
SELECT key_stats.player_name, COALESCE(goalkeeping.saved,0) as saved, COALESCE(goalkeeping.conceded,0) as conceded, COALESCE(goalkeeping.saved_penalties,0)as saved_penalties, COALESCE(goalkeeping.cleansheets,0) as cleansheets, 
COALESCE(goalkeeping.punches_made,0) as punches_made FROM goalkeeping
RIGHT JOIN key_stats ON 
key_stats.player_name = goalkeeping.player_name

--Distribution Statistics For Each Player
SELECT key_stats.player_name, COALESCE(distributon.pass_accuracy,0) as pass_accuracy, COALESCE(distributon.pass_attempted,0) as pass_attempted, 
COALESCE(distributon.pass_completed,0)as pass_completed, COALESCE(distributon.cross_accuracy,0) as cross_accuracy, COALESCE(distributon.cross_attempted,0) as cross_attempted,  
COALESCE(distributon.cross_complted,0) as cross_complted, 
COALESCE(distributon.freekicks_taken,0) as freekicks_taken FROM distributon
RIGHT JOIN key_stats ON 
key_stats.player_name = distributon.player_name

--Attacking Statistics For Each Player
SELECT key_stats.player_name, COALESCE(key_stats.goals,0) as goals, COALESCE(attacking.assists,0) as assists, COALESCE(goals.penalties,0) as penalties,
COALESCE(attacking.corner_taken,0) as corner_taken, COALESCE(attacking.offsides,0)as offsides, COALESCE(attacking.dribbles,0) as dribbles FROM attacking
RIGHT JOIN key_stats ON 
key_stats.player_name = attacking.player_name
LEFT JOIN goals ON 
key_stats.player_name = goals.player_name

--Defending Statistics For Each Player
SELECT key_stats.player_name, COALESCE(defending.balls_recoverd,0) as balls_recoverd, COALESCE(defending.tackles,0) as tackles, COALESCE(defending.tackles_won,0)as tackles_won, 
COALESCE(defending.tackles_lost,0)as tackles_lost, COALESCE(defending.clearance_attempted,0)as clearance_attempted FROM defending
RIGHT JOIN key_stats ON 
key_stats.player_name = defending.player_name

--Goalkeeping Statistics For Each Player
SELECT key_stats.player_name, COALESCE(goalkeeping.saved,0) as saved, COALESCE(goalkeeping.conceded,0) as conceded, COALESCE(goalkeeping.saved_penalties,0)as saved_penalties, COALESCE(goalkeeping.cleansheets,0) as cleansheets, 
COALESCE(goalkeeping.punches_made,0) as punches_made FROM goalkeeping
RIGHT JOIN key_stats ON 
key_stats.player_name = goalkeeping.player_name

--Disciplinary Statistics For Each Player
SELECT key_stats.player_name, COALESCE(disciplinary.yellow,0) as yellow, COALESCE(disciplinary.red,0) as red FROM key_stats
LEFT JOIN disciplinary ON
key_stats.player_name = disciplinary.player_name

