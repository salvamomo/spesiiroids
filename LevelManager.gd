extends Node

class_name LevelManager

var kills
var score

signal level_transition_started()

export (int) var level = 1
export (int) var baseLevelPoints = 200 # Should start at 2000
export (int) var extraPointsPerLevel = 175
export (int) var bonusLifeScoreCycle = baseLevelPoints * 5

enum LEVEL_TRANSITION_PHASE {START, END}

var basePointsPerEnemy = 10
var maxLevelPoints
var bonusLivesAcquired = 0

var Main: Main
var Player: Player
var EnemyManager
var PowerUpSpawner

func _ready():
	score = 0
	kills = 0
	maxLevelPoints = baseLevelPoints
	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node('Player')
	EnemyManager = Main.get_node('EnemyManager')
	PowerUpSpawner = Main.get_node('PowerUpSpawner')
	# warning-ignore:return_value_discarded
	self.connect("level_transition_started", EnemyManager, 'level_transition')
	# warning-ignore:return_value_discarded
	self.connect("level_transition_started", PowerUpSpawner, 'level_transition')

func _on_Enemy_death(enemy: Enemy):
	var playerPointBonus = 3 if Player.has_powerup_in_use() else 1
	var enemType = enemy.get_type()
	var enemTypeBonus = 1 if (enemType > 3) else 0

	var addedPoints = (basePointsPerEnemy * playerPointBonus) * (2 + enemTypeBonus)
	#	print("Added points: ", addedPoints)
	kills += 1
	score += addedPoints
	check_level_completed()
	check_acquire_extra_life()

func check_level_completed():
	if (score > maxLevelPoints):
		print("Level Completed: Moving to level ", level + 1)
		set_level(level + 1)

func check_acquire_extra_life():
	if (score > (bonusLifeScoreCycle * (bonusLivesAcquired + 1))):
		bonusLivesAcquired += 1
		Main.grant_life_to_player()

func set_level(new_level):
	$LevelStartLabel.text = 'Comenzando Nivel ' + new_level as String
	$LevelStartLabel.visible = true

	emit_signal("level_transition_started", LEVEL_TRANSITION_PHASE.START)

	level = new_level
	maxLevelPoints = level * baseLevelPoints + (level * extraPointsPerLevel)

	yield(get_tree().create_timer(1), "timeout")
	$LevelStartLabel.visible = false

	emit_signal("level_transition_started", LEVEL_TRANSITION_PHASE.END)

func level_up():
	set_level(level + 1)

func level_down():
	set_level(level - 1)
