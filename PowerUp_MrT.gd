extends "res://PowerUp.gd"

const TYPE = 2

func grant_bonus_to_player(player):
	player.current_bullet_type = player.BULLET_TYPE.FIREBALL
	
func remove_bonus_from_player(player):
	player.current_bullet_type = player.BULLET_TYPE.DEFAULT
