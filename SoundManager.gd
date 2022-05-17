extends Node

var MUSIC_SHOULD_PLAY = false

func _ready():
	MUSIC_SHOULD_PLAY = $BackgroundMusic.is_autoplay_enabled()

func _process(delta):
	if (!MUSIC_SHOULD_PLAY and _is_music_playing()):
		$BackgroundMusic.set_stream_paused(true)

func _toggle_music(force_toggle = false):
	if (!MUSIC_SHOULD_PLAY and !force_toggle):
		return

	var toggle_to_play = _is_music_playing()

	$BackgroundMusic.set_stream_paused(toggle_to_play)
	MUSIC_SHOULD_PLAY = !toggle_to_play

	# Ensure the stream is actually started.
	if (MUSIC_SHOULD_PLAY and !$BackgroundMusic.is_playing()):
		$BackgroundMusic.play()

# Music could be NOT playing if:
#  1.- The stream is paused.
#  2.- The stream may not be paused, but it was never started in first place, or
#      it was stopped at some point.
func _is_music_playing():
	return !$BackgroundMusic.get_stream_paused() && $BackgroundMusic.is_playing()

func pause_music():
	if (MUSIC_SHOULD_PLAY):
		$BackgroundMusic.set_stream_paused(true)

func resume_music():
	if (MUSIC_SHOULD_PLAY):
		$BackgroundMusic.set_stream_paused(false)
