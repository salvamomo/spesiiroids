extends Node

const ENEMY_SCENE = preload("res://Enemy.tscn")

const MIN_VEL = 200
const MAX_VEL = 380

var enemyTypesTextures = {
	0: preload("res://assets/enemies/Enemy1.png"),
	1: preload("res://assets/enemies/Enemy2.png"),
	2: preload("res://assets/enemies/Enemy3.png"),
	3: preload("res://assets/enemies/Enemy4.png"),
	4: preload("res://assets/enemies/Enemy5.png"),
	5: preload("res://assets/enemies/Enemy6.png"),
	6: preload("res://assets/enemies/Enemy7.png"),
	7: preload("res://assets/enemies/Enemy8.png"),
}

var Main
var Player
var screen_size

var current_target_node

func _ready():
	Main = get_tree().get_root().get_node("Main")
	Player = get_tree().get_root().get_node("Main/Player")
	screen_size = get_viewport().get_visible_rect().size
	current_target_node = Player
	spawn()

func spawn():
	var new_enemy = ENEMY_SCENE.instance()
	new_enemy.position = Vector2(
		lerp(screen_size.x * 0.1, screen_size.x * 0.9, randf()),
		lerp(screen_size.y * 0.1, screen_size.y * 0.9, randf())
	)
	new_enemy.speed = lerp(MIN_VEL, MAX_VEL, randf())

#	@todo: randomize shooting.
	new_enemy.can_shoot = 0
	randi()
	new_enemy.set_texture(enemyTypesTextures[_resolve_new_enemy_type()]);
	.add_child(new_enemy)

func get_target_position():
	return current_target_node.position

func _resolve_new_enemy_type():
	var level = Main.level

	if level <= 2:
		return 0
	elif level == 3:
		return randi() % 2
	elif level == 4:
		return 1
	elif level == 5:
		return round(rand_range(1, 2)) as int
	elif level == 6:
		return round(rand_range(2, 3)) as int
	elif level == 7:
		return round(rand_range(2, 4)) as int
	elif level == 8:
		return round(rand_range(3, 5)) as int
	elif level == 9:
		return round(rand_range(4, 5)) as int
	elif level >= 10 and level < 15:
		return round(rand_range(4, 6)) as int
	elif level >= 15 and level < 25:
		return round(rand_range(5, 6)) as int
	elif level >= 25:
		return 7

func _on_Teresiica_Beacon_Created(beacon):
	current_target_node = beacon
	
func _on_Teresiica_Beacon_Destroyed(beacon):
	current_target_node = Player

func _on_SpawnTimer_timeout():
	spawn()
