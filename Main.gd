extends Node

var screen_size
const ENEMY_SCENE = preload("res://Enemy.tscn")

var kills
var score
var pointsUntilNextLife = 10000

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	kills = 0
	screen_size = get_viewport().get_visible_rect().size
	_spawn_test_enemies()

func _spawn_test_enemies():
	var enemy1 = ENEMY_SCENE.instance()
	enemy1.position = Vector2(100, 100)
	var enemy2 = ENEMY_SCENE.instance()
	enemy2.position = Vector2(700, 100)
	var enemy3 = ENEMY_SCENE.instance()
	enemy3.position = Vector2(100, 500)
	var enemy4 = ENEMY_SCENE.instance()
	enemy4.position = Vector2(700, 500)
	.add_child(enemy1)
	.add_child(enemy2)
	.add_child(enemy3)
	.add_child(enemy4)

func _process(delta):
	if Input.is_action_just_pressed("Spawn_Enemy"):
		_spawn_test_enemies()

func _on_Enemy_death(enemy):
	var playerPointBonus = 1
	var enemType = 1
	var addedPoints = (10 * playerPointBonus * 1) * (pow(1 + enemType / 8, 2) + 1)
	kills += 1
	score += addedPoints
	pointsUntilNextLife -= addedPoints
	
	if pointsUntilNextLife <= 0:
		pointsUntilNextLife = 10000
		$Player.lives += 1
	

func _on_Player_powerup_activated(powerup):
	# HUD Updates.
	.get_node("HUD/acquired_powerups/powerup_" + (powerup.TYPE + 1) as String).hide()
	.get_node("HUD/powerup_animation/powerup_" + (powerup.TYPE + 1) as String).show()

	# @todo: If powerUp is TerESIIca, it has a special effect.
	#   1.- Drop an instance of it for enemies to chase.
	#       - Drop it at the player position. And get THAT position. (this can be done in the powerup itself).
	#       - Pass the position to this main function.
	#         
	#   2.- Get the EnemySpawner (or Manager) to control enemy movement, until the
	#       expired signal is triggered.
	#		- Call a `fixEnemiesDirection` function.
	#       - On each enemy process function, check for that fixed position and use it, if present.
	#       - upon expiration, just remove that fixed direction.
	# @todo: For Chiquito, it is similar. Make enemies bounce on it.
	#   1.- When activating:
	#       - Call a fixEnemyMinDistanceToPlayer() on the manager that sets the distance given by the powerup.
	#       - Make enemies use that distance when processing their movement.

func _on_Player_powerup_acquired(powerup):
	.get_node("HUD/acquired_powerups/powerup_" + (powerup.TYPE + 1) as String).show()

func _on_PowerUp_effects_expired(powerup):
	.get_node("HUD/powerup_animation/powerup_" + (powerup.TYPE + 1) as String).hide()