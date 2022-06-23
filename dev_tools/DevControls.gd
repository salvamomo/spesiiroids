extends Control

var Main: Main
var Player
var LevelManager
var EnemyManager: EnemyManager
var PowerUpSpawner

signal music_toggled

func _ready():
	if (!ProjectSettings.get_setting("application/run/enable_dev_controls")):
		queue_free()

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
	var powerUp = PowerUpSpawner.powerUps[0].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_GenerateVicentin_pressed():
	var powerUp = PowerUpSpawner.powerUps[1].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_GenerateMrT_pressed():
	var powerUp = PowerUpSpawner.powerUps[2].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_GenerateTeresiica_pressed():
	var powerUp = PowerUpSpawner.powerUps[3].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_LevelUp_pressed():
	LevelManager.level_up()

func _on_LevelDown_pressed():
	LevelManager.level_down()

func _on_GrantLife_pressed():
	Main.grant_life_to_player()
