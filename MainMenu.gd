extends TextureRect

func _ready():
	get_tree().paused = false

func _process(delta):
	if (Input.is_action_just_pressed("Start_Pause")):
		self.queue_free()
		get_tree().change_scene("res://Main.tscn")
	if (Input.is_action_just_pressed("Exit_Back")):
		get_tree().quit()
#	@todo: Entire OS crashes when doing this several times.		
#	if (Input.is_action_pressed("FullScreen")):
#		OS.window_fullscreen = !OS.window_fullscreen
 
