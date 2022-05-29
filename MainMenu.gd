extends TextureRect

func _ready():
	get_tree().paused = false

func _process(_delta):
	if (Input.is_action_just_pressed("Start_Pause")):
		self.queue_free()
		get_tree().change_scene("res://Main.tscn")
	if (Input.is_action_just_pressed("Exit_Back")):
		get_tree().quit()
	if (Input.is_action_just_pressed("FullScreen")):
		OS.window_fullscreen = !OS.window_fullscreen
		
 
