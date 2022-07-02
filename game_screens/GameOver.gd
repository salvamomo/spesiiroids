extends TextureRect

export (PackedScene) var SCENE_MAIN

func _process(_delta):
	if (Input.is_action_pressed("Start_Pause")):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(SCENE_MAIN)
	if (Input.is_action_pressed("Exit_Back")):
		get_tree().quit()
