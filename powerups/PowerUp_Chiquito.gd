extends PowerUp

const TYPE = 0
const NAME = "Chiquito"

var default_duration
var AUDIO_FILES_DIRECTORY: String = 'res://assets/audio/effects/chiquito/'

func _ready():
	default_duration = duracion
	._ready()

func grant_bonus_to_player(player):
	player.activate_bouncing_shield()
	
func remove_bonus_from_player(player):
	player.deactivate_bouncing_shield()

func play_sound_effect():
	var effect_to_play = "chiquito" + str(randi() % 20 + 1) + ".wav"
	var audio_effect = load(AUDIO_FILES_DIRECTORY + effect_to_play)
	$AudioStreamPlayer.set_stream(audio_effect)
	var audio_duration = $AudioStreamPlayer.get_stream().get_length()
	duracion = max(default_duration, audio_duration)
	$AudioStreamPlayer.play()
