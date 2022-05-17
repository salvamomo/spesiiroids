extends Node

const MIN_RESPAWN_TIME = 2
const MAX_RESPAWN_TIME = 3

var screen_size
var Player

var availablePowerUps = [null, null, null, null]

const powerUps = [
	preload("res://PowerUp_Chiquito.tscn"),
	preload("res://PowerUp_Vicentin.tscn"),
	preload("res://PowerUp_MrT.tscn"),
	preload("res://PowerUp_Teresiica.tscn")
]

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	Player = get_tree().get_root().get_node("Main/Player")
	
	# Instantiate all power ups up front (we just have 4) and add them to the scene.
	availablePowerUps[0] = powerUps[0].instance()
	availablePowerUps[1] = powerUps[1].instance()
	availablePowerUps[2] = powerUps[2].instance()
	availablePowerUps[3] = powerUps[3].instance()
	.add_child(availablePowerUps[0])
	.add_child(availablePowerUps[1])
	.add_child(availablePowerUps[2])
	.add_child(availablePowerUps[3])
	
# This is a signal callback connected from LevelManager
func level_transition(phase):
	match phase:
		LevelManager.LEVEL_TRANSITION_PHASE.START:
			for powerUp in availablePowerUps:
				powerUp.disable_temporarily()
		LevelManager.LEVEL_TRANSITION_PHASE.END:
			for powerUp in availablePowerUps:
				powerUp.reenable()

func spawn_powerup():
	randomize()	
	
	var nextPowerUp = null
	var availableIndexes = []

	# Refresh info about available power ups in the map.
	for i in range(4):
		if availablePowerUps[i].is_ready_for_respawn():
			availableIndexes.append(i) 

	# @todo: connect powerups with spawner, to tell it when they get fetched from the map.
	# @todo: connect powerups activation with spawner, to tell it when they're being used.
	# @todo: Apply rotation to the powerup.
	if (availableIndexes.empty() == false):
		nextPowerUp = availablePowerUps[availableIndexes[randi() % availableIndexes.size()]]
		nextPowerUp.position = Vector2(
			lerp(screen_size.x * 0.1, screen_size.x * 0.9, randf()),
			lerp(screen_size.y * 0.1, screen_size.y * 0.9, randf())
		)
		nextPowerUp.velocity = Vector2(
			lerp(nextPowerUp.MIN_VEL, nextPowerUp.MAX_VEL, randf()),
			lerp(nextPowerUp.MIN_VEL, nextPowerUp.MAX_VEL, randf())
		)
		nextPowerUp.respawn()

	# @todo: this shouldn't call start if there's no available powerUps to respawn?
	$RespawnTimer.start(rand_range(MIN_RESPAWN_TIME, MAX_RESPAWN_TIME))

func _on_RespawnTimer_timeout():
	spawn_powerup()

