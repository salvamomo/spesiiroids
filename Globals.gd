extends Node

# warning-ignore:unused_signal
signal game_finished()
# warning-ignore:unused_signal
signal level_manager_last_level_completed()

func _ready():
	# Set pause mode to "process" so that full screen key work as expected.
	pause_mode = PAUSE_MODE_PROCESS

func _process(_delta):
	if (Input.is_action_just_pressed("FullScreen")):
		OS.window_fullscreen = !OS.window_fullscreen

var final_score: int = 0
var hits: int = 0

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
