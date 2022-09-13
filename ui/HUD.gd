extends Control

class_name Hud

var Player
var LevelManager
var time_start = 0

export (NodePath) var total_lives_path
export (NodePath) var kills_path
export (NodePath) var score_path
export (NodePath) var timer_path

onready var total_lives_label: Label = get_node(total_lives_path)
onready var kills_label: Label = get_node(kills_path)
onready var score_label: Label = get_node(score_path)
onready var timer_label: Label = get_node(timer_path)

func _ready():
	time_start = OS.get_unix_time()
	var Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")
	LevelManager = Main.get_node("LevelManager")
	update_lives()

func _process(_delta):
	kills_label.text = "Kills: " + LevelManager.kills as String
	score_label.text = "Score: " + LevelManager.score as String

func update_lives():
	var scale_to_vector = Vector2(1.2, 1.2)

	if Player.lives > 4:
		total_lives_label.text = "x" + Player.lives as String
		total_lives_label.show()

		# Scale up numeric counter when losing / getting a life.
		$bottom/scale_effect.interpolate_property(total_lives_label, "rect_scale", Vector2(1.0, 1.0), scale_to_vector, 0.1, Tween.TRANS_LINEAR)
		$bottom/scale_effect.interpolate_property(total_lives_label, "rect_scale", scale_to_vector, Vector2(1.0, 1.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.1)
		$bottom/scale_effect.start()
	elif Player.lives <= 4:
		total_lives_label.hide()

		var current_life_node = null
		for i in range(1,5):
			if Player.lives >= i:
				current_life_node = .get_node("bottom/ship_life_" + i as String)

				# Scale up life icon when making it visible.
				if (!current_life_node.visible):
					current_life_node.show()
					$bottom/scale_effect.interpolate_property(current_life_node, "rect_scale", Vector2(1.0, 1.0), scale_to_vector, 0.1, Tween.TRANS_LINEAR)
					$bottom/scale_effect.interpolate_property(current_life_node, "rect_scale", scale_to_vector, Vector2(1.0, 1.0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.1)
					$bottom/scale_effect.start()
			else:
				.get_node("bottom/ship_life_" + i as String).hide()

func _on_Player_life_acquired():
	update_lives()

func _on_RefreshTimer_timeout():
	timer_label.text = "Time: " + (OS.get_unix_time() - time_start) as String
