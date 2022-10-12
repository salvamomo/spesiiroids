extends Node

class_name LevelManager

var kills
var score: int
var time_start = 0

signal level_transition_started()
signal level_manager_life_acquired()

export (int) var level = 1
export (int) var baseLevelPoints = 800 # Should start at 2000
export (int) var extraPointsPerLevel = 175
export (int) var bonusLifeCycleMultiplier = 10 # Original game multiplied by 5.
export (int) var bonusLifeScoreCycle = baseLevelPoints * bonusLifeCycleMultiplier
export (int) var finalLevel = 31
var baseLevelPointsIncreasePerLevel = 50

enum LEVEL_TRANSITION_PHASE {START, END}

var basePointsPerEnemy = 10
var maxLevelPoints
var bonusLivesAcquired = 0

var Main: Main
var Player: Player
var EnemyManager
var Hud: Hud
var PowerUpSpawner

func _ready():
	score = 0
	kills = 0
	time_start = OS.get_unix_time()
	maxLevelPoints = baseLevelPoints
	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node('Player')
	Hud = Main.get_node('HUD')
	EnemyManager = Main.get_node('EnemyManager')
	PowerUpSpawner = Main.get_node('PowerUpSpawner')
	# warning-ignore:return_value_discarded
	self.connect("level_transition_started", EnemyManager, 'level_transition')
	# warning-ignore:return_value_discarded
	self.connect("level_transition_started", PowerUpSpawner, 'level_transition')
	# warning-ignore:return_value_discarded
	self.connect("level_manager_life_acquired", Hud, '_on_Player_life_acquired')

func _on_Enemy_death(enemy: Enemy):
	var playerPointBonus = 3 if Player.has_powerup_in_use() else 1
	var enemType = enemy.get_type()
	var enemTypeBonus = 1 if (enemType > 3) else 0

	var addedPoints = (basePointsPerEnemy * playerPointBonus) * (2 + enemTypeBonus)
	kills += 1
	score += addedPoints
	check_level_completed()
	check_acquire_extra_life()

func check_level_completed():
	if (score > maxLevelPoints):
		check_last_level_completed()
		print("Level Completed: Moving to level ", level + 1)
		set_level(level + 1)

func check_last_level_completed():
	var game_time = (OS.get_unix_time() - time_start)
	Globals.set_final_time(game_time)

	# If this was the last level, move to victory screen.
	var run_length_baseline = 20 * 60
	if (level == finalLevel):
		# Apply bonus, accounting for hits taken.
		print("Score before bonus: ", score)
		score = score + (40000 - (Globals.get_hits() * 2000))
		print("Score after hits bonus: ", score)
		# Apply bonus based on enemies killed.
		score = score + (kills * 10)
		print("Score after kills bonus: ", score)
		# Apply bonus based on time spent.
		if (run_length_baseline - Globals.get_final_time() > 0):
			score = score + ((run_length_baseline - Globals.get_final_time()) * 50)

		print("Score after time bonus: ", score)
		Globals.set_final_score(score)
		Globals.emit_signal("level_manager_last_level_completed")

func check_acquire_extra_life():
	if (score > (bonusLifeScoreCycle * (bonusLivesAcquired + 1))):
		bonusLivesAcquired += 1
		Main.grant_life_to_player()
		emit_signal("level_manager_life_acquired")

func set_level(new_level):
	$LevelStartLabel.text = 'Starting Level ' + new_level as String
	$LevelStartLabel.visible = true

	emit_signal("level_transition_started", LEVEL_TRANSITION_PHASE.START)

	level = new_level
	adjust_level_curve(level)
	$LevelTransitionTimer.start()

func adjust_level_curve(current_level):
	if (current_level == 22):
		baseLevelPointsIncreasePerLevel += 100

	baseLevelPoints += baseLevelPointsIncreasePerLevel
#	var previousMaxLevel = maxLevelPoints
	maxLevelPoints = current_level * baseLevelPoints + (current_level * extraPointsPerLevel)
#	print("Next Level at: " + maxLevelPoints as String + ". Difference with previous: " + (maxLevelPoints - previousMaxLevel) as String)

func _on_LevelTransitionTimer_timeout():
	$LevelStartLabel.visible = false
	emit_signal("level_transition_started", LEVEL_TRANSITION_PHASE.END)

func get_score() -> int:
	return score

func level_up():
	set_level(level + 1)

func level_down():
	set_level(level - 1)
