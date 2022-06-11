extends Node

class_name Main

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size

func _process(_delta):
	if (Input.is_action_just_pressed("Start_Pause")):
		get_tree().paused = !get_tree().paused
		$PauseText.visible = !$PauseText.visible
	if (Input.is_action_just_pressed("Exit_Back") and get_tree().paused):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://MainMenu.tscn")
	if (Input.is_action_just_pressed("FullScreen")):
		OS.window_fullscreen = !OS.window_fullscreen

func grant_life_to_player():
	$Player.acquire_extra_life()

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

func _on_Player_hit_by_enemy():
	$HUD.update_lives()

func _on_Player_player_dies():
	$EnemyManager.queue_free()
	$HUD.queue_free()
	self.queue_free()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://GameOver.tscn")
