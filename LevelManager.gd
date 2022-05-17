extends Node

class_name LevelManager

var kills
var score

signal level_transition_started()
signal level_transition_stopped()

export (int) var level = 1
export (int) var baseLevelPoints = 200
export (int) var extraPointsPerLevel = 175

enum LEVEL_TRANSITION_PHASE {START, END}

var maxLevelPoints

var Main
var EnemyManager
var PowerUpSpawner

func _ready():
	score = 0
	kills = 0
	maxLevelPoints = baseLevelPoints
	Main = get_tree().get_root().get_node("Main")
	EnemyManager = Main.get_node('EnemyManager')
	PowerUpSpawner = Main.get_node('PowerUpSpawner')
	self.connect("level_transition_started", EnemyManager, 'level_transition')
	self.connect("level_transition_started", PowerUpSpawner, 'level_transition')

func _on_Enemy_death(enemy):
	var playerPointBonus = 1
	# @todo: Get enemy type correctly.
	var enemType = 1
	var addedPoints = (10 * playerPointBonus * 1) * (pow(1 + enemType / 8, 2) + 1)
	kills += 1
	score += addedPoints
	check_level_completed()

func check_level_completed():
	if (score > maxLevelPoints):
		print("Level Completed: Moving to level ", level + 1)
		set_level(level + 1)

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
