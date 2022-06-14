extends Control

class_name Hud

var Player
var LevelManager
var time_start = 0

func _ready():
	time_start = OS.get_unix_time()
	var Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")
	LevelManager = Main.get_node("LevelManager")
	update_lives()

func _process(_delta):
	$top_bar/Kills.text = "Kills: " + LevelManager.kills as String
	$top_bar/Score.text = "Score: " + LevelManager.score as String

func update_lives():
	var scale_to_vector = Vector2(1.2, 1.2)

	if Player.lives > 4:
		$bottom/ship_life_plus/total_lives.text = "x" + Player.lives as String
		$bottom/ship_life_plus/total_lives.show()

		# Scale up numeric counter when losing / getting a life.
		$bottom/scale_effect.interpolate_property($bottom/ship_life_plus/total_lives, "rect_scale", Vector2(1.0, 1.0), scale_to_vector, 0.1, Tween.TRANS_LINEAR)
		$bottom/scale_effect.interpolate_property($bottom/ship_life_plus/total_lives, "rect_scale", scale_to_vector, Vector2(1.0, 1.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.1)
		$bottom/scale_effect.start()
	elif Player.lives <= 4:
		$bottom/ship_life_plus/total_lives.hide()

		var current_life_node = null
		for i in range(1,5):
			if Player.lives >= i:
				current_life_node = .get_node("bottom/ship_life_" + i as String)

				# Scale up life icon when making it visible.
				if (!current_life_node.visible):
					current_life_node.show()
					$bottom/scale_effect.interpolate_property(current_life_node, "scale", Vector2(1.0, 1.0), scale_to_vector, 0.1, Tween.TRANS_LINEAR)
					$bottom/scale_effect.interpolate_property(current_life_node, "scale", scale_to_vector, Vector2(1.0, 1.0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.1)
					$bottom/scale_effect.start()
			else:
				.get_node("bottom/ship_life_" + i as String).hide()

func _on_Player_life_acquired():
	update_lives()

func _on_RefreshTimer_timeout():
	$top_bar/Timer.text = "Time: " + (OS.get_unix_time() - time_start) as String
