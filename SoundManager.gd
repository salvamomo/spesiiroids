extends Node

var MUSIC_SHOULD_PLAY = false

func _ready():
	$BackgroundMusic.play()
	MUSIC_SHOULD_PLAY = true

func _process(delta):
	if (!MUSIC_SHOULD_PLAY and _is_music_playing()):
		$BackgroundMusic.set_stream_paused(true)

func _toggle_music():
	var toggle_to_play = _is_music_playing()
	$BackgroundMusic.set_stream_paused(toggle_to_play)
	MUSIC_SHOULD_PLAY = !toggle_to_play

func _is_music_playing():
	return !$BackgroundMusic.get_stream_paused()
