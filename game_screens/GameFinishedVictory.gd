extends Node

func _ready():
	$ScoreBox/Score.text = Globals.get_final_score() as String
	$ScoreBox/Hits_Count.text = Globals.get_hits() as String


func _process(_delta):
	if Input.is_action_just_pressed("Exit_Back") or Input.is_action_just_pressed("Start_Pause"):
		queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://game_screens/Credits.tscn")
