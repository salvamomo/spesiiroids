extends VBoxContainer

func _ready():
	$Score.text = Globals.get_final_score() as String
	$Hits_Count.text = Globals.get_hits() as String
