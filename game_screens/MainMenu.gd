extends TextureRect

func _ready():
	get_tree().paused = false
	# Stop music. It could be running from a recent run or coming from credits.
	SoundManager.stop_music()

func _process(_delta):
	if (Input.is_action_just_pressed("Start_Pause")):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://main/Main.tscn")
	if (Input.is_action_just_pressed("Exit_Back")):
		get_tree().quit()
	if (Input.is_action_just_pressed("FullScreen")):
		OS.window_fullscreen = !OS.window_fullscreen
	if (Input.is_action_just_pressed("Credits")):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://game_screens/Credits.tscn")
		