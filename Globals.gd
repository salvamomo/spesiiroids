extends Node

# warning-ignore:unused_signal
signal game_finished()
# warning-ignore:unused_signal
signal level_manager_last_level_completed()

var final_score: int = 0
var hits: int = 0
var player_won: bool = false

func _ready():
	# warning-ignore:return_value_discarded
	self.connect("game_finished", self, "_on_Game_Finished")

	SilentWolf.configure({
		"api_key": "{{API_KEY}}",
		"game_id": "spesiiroids",
		"game_version": "1.0.2",
		"log_level": 0,
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://game_screens/MainMenu.tscn"
	})

	# Set pause mode to "process" so that full screen key work as expected.
	pause_mode = PAUSE_MODE_PROCESS

func _process(_delta):
	if (Input.is_action_just_pressed("FullScreen")):
		OS.window_fullscreen = !OS.window_fullscreen

func add_hit():
	hits += 1

func get_hits() -> int:
	return hits

func reset_hits():
	hits = 0

func get_final_score() -> int:
	return final_score

func set_final_score(score: int):
	final_score = score

func _on_Game_Finished(player_wins):
	player_won = player_wins

func did_player_win() -> bool:
	return player_won
