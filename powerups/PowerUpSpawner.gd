extends Node

class_name PowerUpSpawner

const MIN_RESPAWN_TIME = 2
const MAX_RESPAWN_TIME = 3

var screen_size
var Player
var LevelManager

var availablePowerUps = [null, null, null, null]
export(Array, PackedScene) var powerUps

enum powerUpsIdx {CHIQUITO, VICENTIN, MRT, TERESIICA}

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	Player = get_tree().get_root().get_node("Main/Player")
	LevelManager = get_tree().get_root().get_node("Main/LevelManager")
	
	# Instantiate all power ups up front (we just have 4) and add them to the scene.
	availablePowerUps[0] = powerUps[0].instance()
	availablePowerUps[1] = powerUps[1].instance()
	availablePowerUps[2] = powerUps[2].instance()
	availablePowerUps[3] = powerUps[3].instance()
	.add_child(availablePowerUps[0])
	.add_child(availablePowerUps[1])
	.add_child(availablePowerUps[2])
	.add_child(availablePowerUps[3])
	
func get_power_up(powerUpIdx: int):
	return availablePowerUps[powerUpIdx]

# This is a signal callback connected from LevelManager
func level_transition(phase):
	match phase:
		LevelManager.LEVEL_TRANSITION_PHASE.START:
			for powerUp in availablePowerUps:
				powerUp.disable_temporarily()
		LevelManager.LEVEL_TRANSITION_PHASE.END:
			for powerUp in availablePowerUps:
				powerUp.reenable()

# Tries to spawn a Power Up, if any is available.
func spawn_powerup():
	randomize()	
	
	var nextPowerUp = null
	var availableIndexes = []

	# Refresh info about available power ups in the map.
	for i in range(4):
		if availablePowerUps[i].is_ready_for_respawn():
			availableIndexes.append(i) 

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

	$RespawnTimer.start(rand_range(MIN_RESPAWN_TIME, MAX_RESPAWN_TIME))

func _on_RespawnTimer_timeout():
	spawn_powerup()
