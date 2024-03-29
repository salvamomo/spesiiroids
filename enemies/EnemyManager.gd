extends Node

class_name EnemyManager

export (PackedScene) var ENEMY_SCENE

export (Array, Texture) var enemyTypesTextures

export (int) var MIN_VEL = 80 # Original was 0.5f
export (int) var MAX_VEL = 120 # Original was 1.2f

export (int) var MAX_ENEMIES_LIMIT = 50
export (int) var MAX_ENEMIES_INITIAL = 5

export (float) var SPAWN_TIME_MINIMUM = 0.5
export (float) var SPAWN_TIME_REDUCTION_PER_LEVEL = 0.1

var MAX_ENEMIES_CURRENT

var Main
var Player
var LevelManager: LevelManager
var screen_size

export (bool) var can_spawn = true
var enemies_frozen := true
var current_target_node

func _ready():
	Main = get_tree().get_root().get_node("Main")
	Player = get_tree().get_root().get_node("Main/Player")
	LevelManager = Main.get_node("LevelManager")
	screen_size = get_viewport().get_visible_rect().size
	current_target_node = Player
	MAX_ENEMIES_CURRENT = MAX_ENEMIES_INITIAL
	spawn()

func kill_current_enemies():
	get_tree().call_group('Enemies', 'queue_free')

func pause_spawning():
	can_spawn = false

func resume_spawning():
	can_spawn = true

# This is a signal callback connected from LevelManager
func level_transition(phase):
	match phase:
		LevelManager.LEVEL_TRANSITION_PHASE.START:
			pause_spawning()
			kill_current_enemies()

			if (MAX_ENEMIES_CURRENT < MAX_ENEMIES_LIMIT):
				MAX_ENEMIES_CURRENT += 10

			if ($SpawnTimer.wait_time > SPAWN_TIME_MINIMUM):
				$SpawnTimer.set_wait_time($SpawnTimer.wait_time - SPAWN_TIME_REDUCTION_PER_LEVEL)

		LevelManager.LEVEL_TRANSITION_PHASE.END:
			resume_spawning()

func get_current_enemy_count():
	# https://godotengine.org/qa/248/is-there-a-function-to-return-the-number-of-instances
	return get_tree().get_nodes_in_group("Enemies").size()

func spawn():
	if (!can_spawn):
		return

	if (get_current_enemy_count() >= MAX_ENEMIES_CURRENT):
		return

	var new_enemy = ENEMY_SCENE.instance()
	var enemy_type = _resolve_new_enemy_type()
	new_enemy.set_type(enemy_type)

	var enemy_type_multiplier = (1 + (enemy_type / 10.0)) * 2

	new_enemy.position = Vector2(
		lerp(screen_size.x * 0.1, screen_size.x * 0.9, randf()),
		lerp(screen_size.y * 0.1, screen_size.y * 0.9, randf())
	)

#	print("Enemy Mult: ", enemy_type_multiplier)
#	print("Min vel: ", MIN_VEL * enemy_type_multiplier)
#	print("Max vel: ", MAX_VEL * enemy_type_multiplier)
#	print("Spawn Time: ", $SpawnTimer.get_wait_time())
	new_enemy.speed = lerp(MIN_VEL * enemy_type_multiplier, MAX_VEL * enemy_type_multiplier, randf())

	# Multiply by 2 since every type has 2 textures (sprite + spawn spritesheet).
	var enemy_type_texture_index = enemy_type * 2

	new_enemy.set_textures(enemyTypesTextures[enemy_type_texture_index], enemyTypesTextures[enemy_type_texture_index + 1]);
	.add_child(new_enemy)

func get_target_position():
	return current_target_node.position

func get_target_object():
	return current_target_node

func _resolve_new_enemy_type():
	var level = LevelManager.level

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

func enemies_can_move():
	return enemies_frozen

func freeze_enemies(value: bool):
	enemies_frozen = value

func _on_Teresiica_Beacon_Created(beacon):
	current_target_node = beacon
	
func _on_Teresiica_Beacon_Destroyed(_beacon):
	current_target_node = Player

func _on_SpawnTimer_timeout():
	spawn()
