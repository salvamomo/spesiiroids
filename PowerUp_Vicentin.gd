extends "res://PowerUp.gd"

const TYPE = 1
const NAME = "Vicentin"

func _ready():
	stopMusicOnUsage = true
	# https://godotengine.org/qa/9244/can-override-the-_ready-and-_process-functions-child-classes
	._ready()
	
func grant_bonus_to_player(player: Player):
	player.speed += 400
	player.shooting_speed = 0.1
	
	# Make player invulnerable for a second.
	# In the original game, player was invulnerable for the duration of the
	# power up.
	player.make_immortal()
	yield(get_tree().create_timer(1), "timeout")
	player.make_mortal()

func remove_bonus_from_player(player: Player):
	player.speed -= 400
	player.shooting_speed = 0.3

func play_sound_effect():
	var sound_effects = ['chimo1.wav', 'chimo2.wav', 'chimo3.wav']
	var effect_to_play = sound_effects[randi() % 3]
	var audio_sfx = load('res://assets/audio/effects/chimo/' + effect_to_play)
	$AudioStreamPlayer.set_stream(audio_sfx)
	$AudioStreamPlayer.play()
