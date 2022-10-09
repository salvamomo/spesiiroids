extends Control

var Main: Main
var Player
var LevelManager
var EnemyManager: EnemyManager
var PowerUpSpawner: PowerUpSpawner

signal music_toggled

var time_start = 0

func _ready():
	if (!ProjectSettings.get_setting("application/run/enable_dev_controls")):
		queue_free()

	time_start = OS.get_unix_time()
	# warning-ignore:return_value_discarded
	Globals.connect("game_finished", self, "_on_Game_Finished")

	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")
	LevelManager = Main.get_node("LevelManager")
	EnemyManager = Main.get_node("EnemyManager")
	PowerUpSpawner = Main.get_node("PowerUpSpawner")
	# warning-ignore:return_value_discarded
	self.connect("music_toggled", SoundManager, "_toggle_music", [true])
	$Panel/VBoxContainer/ToggleEnemySpawn.set_pressed_no_signal(EnemyManager.can_spawn)
	$Panel/VBoxContainer/ToggleEnemyMovement.set_pressed_no_signal(EnemyManager.enemies_can_move())

func _process(_delta):
	if (Input.is_action_just_pressed("Start_Pause")):
		hide()

	if Input.is_action_just_pressed("ToggleDevControls"):
		self.visible = !self.visible

		# Adding this here, because the true value of whether music is playing
		# might not be final yet (Main scene may still be initializing it).
		if (visible):
			$Panel/VBoxContainer/ToggleMusic.set_pressed_no_signal(SoundManager.is_music_playing())

		if (!Main.pause_active_from_user()):
			Main.pause(self.visible, false)

func _on_ToggleMusic_toggled(_button_pressed):
	emit_signal("music_toggled")

func _on_ToggleEnemySpawn_toggled(button_pressed):
	if (button_pressed):
		EnemyManager.can_spawn = true
	else:
		EnemyManager.can_spawn = false

func _on_CheckButton_toggled(button_pressed):	
	if (button_pressed):
		Player.activate_bouncing_shield()
	else:
		Player.deactivate_bouncing_shield()

func _on_ToggleEnemyMovement_toggled(button_pressed):
	EnemyManager.freeze_enemies(button_pressed)

func _on_GenerateChiquito_pressed():
	add_power_up_to_player(PowerUpSpawner.powerUpsIdx.CHIQUITO)

func _on_GenerateVicentin_pressed():
	add_power_up_to_player(PowerUpSpawner.powerUpsIdx.VICENTIN)

func _on_GenerateMrT_pressed():
	add_power_up_to_player(PowerUpSpawner.powerUpsIdx.MRT)

func _on_GenerateTeresiica_pressed():
	add_power_up_to_player(PowerUpSpawner.powerUpsIdx.TERESIICA)

func add_power_up_to_player(powerUpIndex: int):
	var powerUp = PowerUpSpawner.get_power_up(powerUpIndex)
	Player.add_power_up(powerUp)
	powerUp.set_state_acquired()

func _on_LevelUp_pressed():
	LevelManager.level_up()
	LevelManager.score = LevelManager.maxLevelPoints

func _on_LevelDown_pressed():
	LevelManager.level_down()

func _on_GrantLife_pressed():
	Main.grant_life_to_player()

func _on_Game_Finished(_player_wins):
	var game_time = (OS.get_unix_time() - time_start) as String
	print("Game Over. Score: " + Globals.get_final_score() as String + ". Time: " + game_time + " seconds.")

func _on_WipeLeaderboardScores_pressed():
	SilentWolf.Scores.wipe_leaderboard(Globals.get_leaderboard_id())

func _on_Button_pressed():
	var name = $Panel/VBoxContainer/TestScoreSend/Name.text
	var score = $Panel/VBoxContainer/TestScoreSend/Score.text
	SilentWolf.Scores.persist_score(name, score, Globals.get_leaderboard_id())
