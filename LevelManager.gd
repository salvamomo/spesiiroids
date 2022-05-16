extends Node

var kills
var score

var baseLevelPoints = 200
var extraPointsPerLevel = 175
var maxLevelPoints

export (int) var level = 1

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
	level = new_level
	maxLevelPoints = level * baseLevelPoints + (level * extraPointsPerLevel)

func level_up():
	set_level(level + 1)

func level_down():
	set_level(level - 1)
