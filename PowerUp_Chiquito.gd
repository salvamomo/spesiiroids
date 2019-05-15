extends "res://PowerUp.gd"

const TYPE = 0

func _ready():
	pass

func _on_PowerUp_Chiquito_area_entered(area):
	if (area.is_in_group("Ship")):
		area.add_power_up(self)
		set_state_acquired()

func grant_effects(player):
	yield(get_tree().create_timer(2.5), "timeout")
	fade()
	reset()