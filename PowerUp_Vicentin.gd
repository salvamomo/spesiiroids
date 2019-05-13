extends "res://PowerUp.gd"

const TYPE = 1

func _ready():
	pass

func _on_PowerUp_Vicentin_area_entered(area):
	if (area.is_in_group("Ship")):
		area.add_power_up(self)
		hide()
#		queue_free()
		# body.shooting_speed += @todo

func grant_effects(player):
	print("activated vicentin")
	player.speed += 400
	player.shooting_speed = 0.1
	yield(get_tree().create_timer(2.5), "timeout")
	player.speed -= 400
	player.shooting_speed = 0.3