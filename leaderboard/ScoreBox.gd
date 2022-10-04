extends HBoxContainer

func _ready():
	$FinalScoreBox/Score.text = Globals.get_final_score() as String
	$HitsBox/Hits_Count.text = Globals.get_hits() as String
