extends Control

var Main
var Player

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
