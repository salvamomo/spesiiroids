extends Node

class_name Main

# This paths are kept as constants since they throw cyclic reference errors
# when loaded as PackedTexture objects.
const SCENE_MAIN: String = "res://game_screens/MainMenu.tscn"
const SCENE_GAME_OVER: String = "res://game_screens/GameOver.tscn"
const SCENE_GAME_FINISHED: String = "res://game_screens/GameFinishedVictory.tscn"

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	Globals.reset_hits()
	# warning-ignore:return_value_discarded
	Globals.connect("level_manager_last_level_completed", self, "_on_last_level_completed")
	SoundManager.init_music()

func _process(_delta):
	if (Input.is_action_just_pressed("Start_Pause")):
		pause(!get_tree().paused, true)

	if (Input.is_action_just_pressed("Exit_Back") and pause_active_from_user()):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene(SCENE_MAIN)

func pause(pause_value := true, toggle_text := true):
	get_tree().paused = pause_value

	if (toggle_text):
		$PauseContainer/PauseText.visible = pause_value

func pause_active_from_user() -> bool:
	return $PauseContainer/PauseText.visible

func grant_life_to_player():
	$Player.acquire_extra_life()

func _on_Player_powerup_activated(powerUp):
	.get_node("HUD/acquired_powerups/Control" + ((powerUp.TYPE + 1) as String) + "/powerup_" + (powerUp.TYPE + 1) as String).hide()
	.get_node("HUD/powerup_animation/ImageContainer/powerup_" + (powerUp.TYPE + 1) as String).show()

func _on_Player_powerup_acquired(powerUp):
	.get_node("HUD/acquired_powerups/Control" + ((powerUp.TYPE + 1) as String) + "/powerup_" + (powerUp.TYPE + 1) as String).show()

func _on_PowerUp_effects_expired(powerUp):
	.get_node("HUD/powerup_animation/ImageContainer/powerup_" + (powerUp.TYPE + 1) as String).hide()

func _on_Player_hit_by_enemy():
	$HUD.update_lives()

func _on_Player_player_dies():
	Globals.set_final_score($LevelManager.get_score())
	finish_game(SCENE_GAME_OVER)

func _on_last_level_completed():
	finish_game(SCENE_GAME_FINISHED)

func finish_game(move_to_scene: String):
	self.queue_free()
	Globals.emit_signal("game_finished")
	# warning-ignore:return_value_discarded
	get_tree().change_scene(move_to_scene)
