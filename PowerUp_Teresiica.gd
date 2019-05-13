extends "res://PowerUp.gd"

const TYPE = 2

func _ready():
	pass

func _on_PowerUp_Teresiica_area_entered(area):
	if (area.is_in_group("Ship")):
		area.add_power_up(self)
		# @todo: implement a "grant power up" function to be called when the player activates the power up.
		hide()
#		queue_free()
		# body.shooting_speed += @todo

func grant_effects(player):
	print("activated teresiica")