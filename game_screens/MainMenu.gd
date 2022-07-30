extends TextureRect

export (PackedScene) var SCENE_MAIN

# Replacing this with a packed scene results in cyclic reference errors, because
# MainMenu is also loaded from the credits.
const SCENE_CREDITS_PATH: String = "res://game_screens/Credits.tscn"

func _ready():
	get_tree().paused = false
	# Stop music. It could be running from a recent run or coming from credits.
	SoundManager.stop_music()

func _process(_delta):
	if (Input.is_action_just_pressed("Start_Pause")):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(SCENE_MAIN)
	if (Input.is_action_just_pressed("Exit_Back")):
		get_tree().quit()

	if (Input.is_action_just_pressed("Credits")):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene(SCENE_CREDITS_PATH)
		
