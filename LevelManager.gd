extends Node

var kills
var score

export (int) var level = 1
export (int) var baseLevelPoints = 200

var extraPointsPerLevel = 175
var maxLevelPoints


func _ready():
	score = 0
	kills = 0
	maxLevelPoints = baseLevelPoints

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
		set_level(level + 1)

func set_level(new_level):
	print("Moving to level ", level)

	$LevelStartLabel.visible = true
	$LevelStartLabel.text = 'Comenzando Nivel ' + level as String
	yield(get_tree().create_timer(1), "timeout")
	$LevelStartLabel.visible = false

	level = new_level
	maxLevelPoints = level * baseLevelPoints + (level * extraPointsPerLevel)

func level_up():
	set_level(level + 1)

func level_down():
	set_level(level - 1)
