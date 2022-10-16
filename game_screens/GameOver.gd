extends Node

export (PackedScene) var SCENE_MAIN

func _process(_delta):
	if (Input.is_action_pressed("Exit_Back")):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(SCENE_MAIN)
