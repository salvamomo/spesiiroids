extends "res://PowerUp.gd"

func _ready():
	pass

func _on_PowerUp_Chiquito_area_entered(area):
	if (area.is_in_group("Ship")):
		# @todo: implement a "grant power up" function to be called when the player activates the power up.
		print ("chiquito entered")
		queue_free()
		# body.shooting_speed += @todo
