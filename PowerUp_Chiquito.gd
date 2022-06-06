extends "res://PowerUp.gd"

const TYPE = 0
const NAME = "Chiquito"

var default_duration

func _ready():
	default_duration = duracion
	._ready()

func grant_bonus_to_player(player):
	player.activate_bouncing_shield()
	
func remove_bonus_from_player(player):
	player.deactivate_bouncing_shield()

func play_sound_effect():
	var effect_to_play = randi() % 20 + 1
	var audio_sfx = load('res://assets/audio/effects/chiquito/chiquito' + str(effect_to_play) + '.wav')
	$AudioStreamPlayer.set_stream(audio_sfx)

	var audio_duration = $AudioStreamPlayer.get_stream().get_length()
	duracion = max(default_duration, audio_duration)

	$AudioStreamPlayer.play()
