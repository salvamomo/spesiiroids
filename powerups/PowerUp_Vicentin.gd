extends PowerUp

const TYPE = 1
const NAME = "Vicentin"

var player_speed_up_modifier: float = 1.45

export (Array, Resource) var music_effects

func _ready():
	stopMusicOnUsage = true
	# https://godotengine.org/qa/9244/can-override-the-_ready-and-_process-functions-child-classes
	._ready()
	
func grant_bonus_to_player(player: Player):
	player.speed *= player_speed_up_modifier
	player.shooting_speed = 0.1
	
	# Make player invulnerable for a second. In the original game, player was
	# invulnerable for the duration of the power up.
	player.make_immortal()
	$ImmortalityTimer.start()

func remove_bonus_from_player(player: Player):
	player.speed /= player_speed_up_modifier
	player.shooting_speed = 0.3

func play_sound_effect():
	$AudioStreamPlayer.set_stream(music_effects[randi() % 3])
	$AudioStreamPlayer.play()

func _on_ImmortalityTimer_timeout():
	Player.make_mortal()
