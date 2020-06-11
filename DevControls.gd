extends Control

var Main
var Player

const powerUps = [
	preload("res://PowerUp_Chiquito.tscn"),
	preload("res://PowerUp_Vicentin.tscn"),
	preload("res://PowerUp_MrT.tscn"),
	preload("res://PowerUp_Teresiica.tscn")
]

func _ready():
	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")

func _process(delta):
	if Input.is_action_just_pressed("ToggleDevControls"):
		self.visible = !self.visible

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
