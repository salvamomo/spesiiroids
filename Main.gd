extends Node

var screen_size
const ENEMY_SCENE = preload("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
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

func _on_Player_powerup_activated(powerup):
	.get_node("HUD/acquired_powerups/powerup_" + (powerup.TYPE + 1) as String).hide()
	.get_node("HUD/powerup_animation/powerup_" + (powerup.TYPE + 1) as String).show()


func _on_Player_powerup_acquired(powerup):
	.get_node("HUD/acquired_powerups/powerup_" + (powerup.TYPE + 1) as String).show()

func _on_PowerUp_effects_expired(powerup):
	print("MAIN: Power up faded.")
	.get_node("HUD/powerup_animation/powerup_" + (powerup.TYPE + 1) as String).hide()