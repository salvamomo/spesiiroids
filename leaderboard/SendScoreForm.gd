extends Control

export (PackedScene) var SCENE_LEADERBOARD

var score_sent: bool
var final_score: int

func _ready():
	score_sent = false
	final_score = Globals.get_final_score()
	$Name.grab_focus()

func _process(_delta):
	if (!$Name.has_focus()):
		$Name.grab_focus()	

	var username = $Name.text

	if (Input.is_action_just_pressed("Start_Pause") and !score_sent and (username.length() > 3)):
		var metadata = {}
		metadata["hits"] = Globals.get_hits()

		SilentWolf.Scores.persist_score(username, final_score, Globals.get_leaderboard_id(), metadata)
		score_sent = true
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(SCENE_LEADERBOARD);
