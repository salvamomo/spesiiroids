extends Control

var Player
var LevelManager
var time_start = 0

func _ready():
	time_start = OS.get_unix_time()
	var Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")
	LevelManager = Main.get_node("LevelManager")
	update_lives()

func _process(delta):
	$top_bar/Kills.text = "Kills: " + LevelManager.kills as String
	$top_bar/Score.text = "Score: " + LevelManager.score as String

func update_lives():
	if Player.lives > 4:
		$bottom/ship_life_plus/total_lives.text = "x" + Player.lives as String
		$bottom/ship_life_plus/total_lives.show()
	elif Player.lives <= 4:
		$bottom/ship_life_plus/total_lives.hide()
		for i in range(1,5):
			if Player.lives >= i:
				.get_node("bottom/ship_life_" + i as String).show()
			else:
				.get_node("bottom/ship_life_" + i as String).hide()

func _on_RefreshTimer_timeout():
	$top_bar/Timer.text = "Time: " + (OS.get_unix_time() - time_start) as String
