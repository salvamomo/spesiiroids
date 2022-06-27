extends Node

# warning-ignore:unused_signal
signal game_finished()
# warning-ignore:unused_signal
signal level_manager_last_level_completed()

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
