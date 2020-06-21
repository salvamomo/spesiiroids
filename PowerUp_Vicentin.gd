extends "res://PowerUp.gd"

const TYPE = 1
	
func _ready():
	stopMusicOnUsage = true
	# https://godotengine.org/qa/9244/can-override-the-_ready-and-_process-functions-child-classes
	._ready()
	
func grant_bonus_to_player(player):
	player.speed += 400
	player.shooting_speed = 0.1
	
func remove_bonus_from_player(player):
	player.speed -= 400
	player.shooting_speed = 0.3

func play_sound_effect():
	var sound_effects = ['chimo1.wav', 'chimo2.wav', 'chimo3.wav']
	var effect_to_play = sound_effects[randi() % 3]
	var audio_sfx = load('res://assets/audio/effects/chimo/' + effect_to_play)
	$AudioStreamPlayer.set_stream(audio_sfx)
	$AudioStreamPlayer.play()
