extends Control

func _ready():
	$Name.grab_focus()

func _process(_delta):
	if (!$Name.has_focus()):
		$Name.grab_focus()	

	if (Input.is_action_just_pressed("Start_Pause") or Input.is_action_just_pressed("PowerUp_1")):
		var score = Globals.get_final_score()
		SilentWolf.Scores.persist_score($Name.text, score, "main")
