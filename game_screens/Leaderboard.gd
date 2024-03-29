extends Node

export (PackedScene) var SCENE_CREDITS

const ScoreItem = preload("../addons/silent_wolf/Scores/ScoreItem.tscn")
const SWLogger = preload("../addons/silent_wolf/utils/SWLogger.gd")

var list_index = 0
# Replace the leaderboard name if you're not using the default leaderboard
var ld_name = Globals.get_leaderboard_id()

func _ready():
	print("SilentWolf.Scores.leaderboards: " + str(SilentWolf.Scores.leaderboards))
	print("SilentWolf.Scores.ldboard_config: " + str(SilentWolf.Scores.ldboard_config))
	# var scores = SilentWolf.Scores.scores
	var scores = []
	if ld_name in SilentWolf.Scores.leaderboards:
		scores = SilentWolf.Scores.leaderboards[ld_name]
	var local_scores = SilentWolf.Scores.local_scores
	
	if len(scores) > 0: 
		render_board(scores, local_scores)
	else:
		# use a signal to notify when the high scores have been returned, and show a "loading" animation until it's the case...
		add_loading_scores_message()
		$LoadingScoresMaxTimeout.start()
		yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
		hide_message()
		render_board(SilentWolf.Scores.scores, local_scores)

func _process(_delta):
	if (Input.is_action_just_pressed("Exit_Back") or Input.is_action_just_pressed("Start_Pause")):
		change_to_next_scene()

func change_to_next_scene():
	var player_won = Globals.did_player_win()

	# Go to credits if player beat the game.
	if (player_won):
		queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(SCENE_CREDITS)
		SWLogger.info("Closing SilentWolf leaderboard, switching to CREDITS scene.")
		return

	# Go to main screen if the player reached the leaderboard from the game over screen.
	var scene_name = SilentWolf.scores_config.open_scene_on_close
	SWLogger.info("Closing SilentWolf leaderboard, switching to scene: " + str(scene_name))
	# warning-ignore:return_value_discarded
	queue_free()
	get_tree().change_scene(scene_name)

func render_board(scores, local_scores):
	var all_scores = scores
	if ld_name in SilentWolf.Scores.ldboard_config and is_default_leaderboard(SilentWolf.Scores.ldboard_config[ld_name]):
		all_scores = merge_scores_with_local_scores(scores, local_scores)
		if !scores and !local_scores:
			add_no_scores_message()
	else:
		if !scores:
			add_no_scores_message()
	if !all_scores:
		for score in scores:
			add_item(score.player_name, str(int(score.score)))
	else:
		for score in all_scores:
			add_item(score.player_name, str(int(score.score)))
			
	$Board/Continue.show()
	$Board/Continue/BlinkTimer.start()

func _on_BlinkTimer_timeout():
	if ($Board/Continue.visible):
		$Board/Continue.hide()
		return

	$Board/Continue.show()

func is_default_leaderboard(ld_config):
	var default_insert_opt = (ld_config.insert_opt == "keep")
	var not_time_based = !("time_based" in ld_config)
	return  default_insert_opt and not_time_based

func merge_scores_with_local_scores(scores, local_scores, max_scores=10):
	if local_scores:
		for score in local_scores:
			var in_array = score_in_score_array(scores, score)
			if !in_array:
				scores.append(score)
			scores.sort_custom(self, "sort_by_score");
	var return_scores = scores
	if scores.size() > max_scores:
		return_scores = scores.resize(max_scores)
	return return_scores

func sort_by_score(a, b):
	if a.score as int > b.score as int:
		return true;
	else:
		if a.score as int < b.score as int:
			return false;
		else:
			return true;

func score_in_score_array(scores, new_score):
	var in_score_array = false
	if new_score and scores:
		for score in scores:
			if score.score_id == new_score.score_id: # score.player_name == new_score.player_name and score.score == new_score.score:
				in_score_array = true
	return in_score_array

func add_item(player_name, score):
	var item = ScoreItem.instance()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score
	item.margin_top = list_index * 100
	$"Board/HighScores/ScoreItemContainer".add_child(item)

func add_no_scores_message():
	var item = $"Board/HighScores/StatusNoticeContainer/StatusNotice"
	item.text = "No scores yet!"
	$"Board/HighScores/StatusNoticeContainer/StatusNotice".show()

func add_loading_scores_message():
	var item = $"Board/HighScores/StatusNoticeContainer/StatusNotice"
	item.text = "Loading scores..."
	$"Board/HighScores/StatusNoticeContainer/StatusNotice".show()

func _on_LoadingScoresMaxTimeout_timeout():
	$"Board/HighScores/StatusNoticeContainer/StatusNotice".text = "Couldn't load scores. Check your connection."

func hide_message():
	$"Board/HighScores/StatusNoticeContainer/StatusNotice".hide()

func clear_leaderboard():
	var score_item_container = $"Board/HighScores/ScoreItemContainer"
	if score_item_container.get_child_count() > 0:
		var children = score_item_container.get_children()
		for c in children:
			score_item_container.remove_child(c)
			c.queue_free()
