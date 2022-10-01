extends Node

export (PackedScene) var SCENE_CREDITS

func _process(_delta):
	if Input.is_action_just_pressed("Exit_Back") or Input.is_action_just_pressed("Start_Pause"):
		queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(SCENE_CREDITS)
