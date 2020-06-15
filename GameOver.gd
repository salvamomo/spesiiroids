extends TextureRect

func _process(delta):
	if (Input.is_action_pressed("Start_Pause")):
		self.queue_free()
		get_tree().change_scene("res://Main.tscn")
	if (Input.is_action_pressed("Exit_Back")):
		get_tree().quit()
