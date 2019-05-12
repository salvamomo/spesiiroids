extends Node

const MIN_RESPAWN_TIME = 6000
const MAX_RESPAWN_TIME = 12000

var screen_size

const powerUps = [
	preload("res://PowerUp_Chiquito.tscn"),
	preload("res://PowerUp_Vicentin.tscn")
]

func _ready():
	screen_size = get_viewport().get_visible_rect().size
#	yield(get_tree().create_timer(rand_range(MIN_RESPAWN_TIME, MAX_RESPAWN_TIME)), "timeout")
	yield(get_tree().create_timer(2), "timeout")
	spawn_powerup()
	
func spawn_powerup():
	randomize()
	
	var powerUp = powerUps[randi() % powerUps.size()]
	powerUp = powerUp.instance()

	powerUp.position = Vector2(
		lerp(screen_size.x * 0.1, screen_size.x * 0.9, randf()),
		lerp(screen_size.y * 0.1, screen_size.y * 0.9, randf())
	)
	.add_child(powerUp)
	yield(get_tree().create_timer(2), "timeout")

	spawn_powerup()