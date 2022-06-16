extends Control

var Main: Main
var Player
var SoundManager
var LevelManager
var EnemyManager: EnemyManager

const powerUps = [
	preload("res://PowerUp_Chiquito.tscn"),
	preload("res://PowerUp_Vicentin.tscn"),
	preload("res://PowerUp_MrT.tscn"),
	preload("res://PowerUp_Teresiica.tscn")
]

signal music_toggled

func _ready():
	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")
	SoundManager = Main.get_node("SoundManager")
	LevelManager = Main.get_node("LevelManager")
	EnemyManager = Main.get_node("EnemyManager")
	# warning-ignore:return_value_discarded
	self.connect("music_toggled", SoundManager, "_toggle_music", [true])
	$Panel/VBoxContainer/ToggleMusic.set_pressed_no_signal(SoundManager._is_music_playing())
	$Panel/VBoxContainer/ToggleEnemySpawn.set_pressed_no_signal(EnemyManager.can_spawn)

func _process(_delta):
	if Input.is_action_just_pressed("ToggleDevControls"):
		self.visible = !self.visible

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

func _on_GenerateChiquito_pressed():
	var powerUp = powerUps[0].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_GenerateVicentin_pressed():
	var powerUp = powerUps[1].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_GenerateMrT_pressed():
	var powerUp = powerUps[2].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_GenerateTeresiica_pressed():
	var powerUp = powerUps[3].instance()
	.add_child(powerUp)
	Player.add_power_up(powerUp)

func _on_LevelUp_pressed():
	LevelManager.level_up()

func _on_LevelDown_pressed():
	LevelManager.level_down()

func _on_GrantLife_pressed():
	Main.grant_life_to_player()
