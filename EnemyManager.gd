extends Node

const ENEMY_SCENE = preload("res://Enemy.tscn")

const MIN_VEL = 200
const MAX_VEL = 380

var screen_size

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	spawn()

func spawn():
	var new_enemy = ENEMY_SCENE.instance()
	new_enemy.position = Vector2(
		lerp(screen_size.x * 0.1, screen_size.x * 0.9, randf()),
		lerp(screen_size.y * 0.1, screen_size.y * 0.9, randf())
	)
	new_enemy.speed = lerp(MIN_VEL, MAX_VEL, randf())
	.add_child(new_enemy)
	
	yield(get_tree().create_timer(2), "timeout")
	spawn()
