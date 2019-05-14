extends "res://PowerUp.gd"

const TYPE = 3

func _ready():
	pass

func _on_PowerUp_MrT_area_entered(area):
	if (area.is_in_group("Ship")):
		area.add_power_up(self)
		set_state_acquired()

func grant_effects(player):
	reset()