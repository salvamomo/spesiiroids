extends "res://PowerUp.gd"

const TYPE = 0
	
func grant_bonus_to_player(player):
	print("chiquito + ")
	
func remove_bonus_from_player(player):
	print("chiquito -")

func play_sound_effect():
	var effect_to_play = randi() % 21
	var audio_sfx = load('res://assets/audio/effects/chiquito/chiquito' + str(effect_to_play) + '.wav')
	$AudioStreamPlayer.set_stream(audio_sfx)
	$AudioStreamPlayer.play()
