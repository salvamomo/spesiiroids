extends "res://PowerUp.gd"

const TYPE = 1
	
func grant_bonus_to_player(player):
	player.speed += 400
	player.shooting_speed = 0.1
	
func remove_bonus_from_player(player):
	player.speed -= 400
	player.shooting_speed = 0.3