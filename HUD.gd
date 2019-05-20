extends Control

var Main
var time_start = 0
var time_elapsed = 0

func _ready():
	time_start = OS.get_unix_time()
	Main = get_tree().get_root().get_node("Main")


func _process(delta):
	$top_bar/Kills.text = "Kills: " + Main.kills as String
	$top_bar/Score.text = "Score: " + Main.score as String
	
	update_timer()

func update_timer():
	$top_bar/Timer.text = "Time: " + (OS.get_unix_time() - time_start) as String		
	yield(get_tree().create_timer(1), "timeout")
	update_timer()
