extends Node

export (bool) var MUSIC_SHOULD_PLAY = true

var DEFAULT_VOLUME_DB = -19.5

func init_music():
	if (MUSIC_SHOULD_PLAY):
		$BackgroundMusic.play()
		set_volume(DEFAULT_VOLUME_DB)

func _process(_delta):
	if (!MUSIC_SHOULD_PLAY and is_music_playing()):
		$BackgroundMusic.set_stream_paused(true)

func _toggle_music(force_toggle = false):
	if (!MUSIC_SHOULD_PLAY and !force_toggle):
		return

	var toggle_to_play = is_music_playing()

	$BackgroundMusic.set_stream_paused(toggle_to_play)
	MUSIC_SHOULD_PLAY = !toggle_to_play

	# Ensure the stream is actually started.
	if (MUSIC_SHOULD_PLAY and !$BackgroundMusic.is_playing()):
		$BackgroundMusic.play()

# Music could be NOT playing if:
#  1.- The stream is paused.
#  2.- The stream may not be paused, but it was never started in first place, or
#      it was stopped at some point.
func is_music_playing():
	return !$BackgroundMusic.get_stream_paused() && $BackgroundMusic.is_playing()

func pause_music():
	if (MUSIC_SHOULD_PLAY):
		$BackgroundMusic.set_stream_paused(true)

func pause_music_for_seconds(seconds: float):
	if (MUSIC_SHOULD_PLAY):
		$BackgroundMusic.set_stream_paused(true)
		yield(get_tree().create_timer(seconds), "timeout")
		$BackgroundMusic.set_stream_paused(false)

func resume_music():
	if (MUSIC_SHOULD_PLAY):
		$BackgroundMusic.set_stream_paused(false)

func restart_music():
	$BackgroundMusic.play()

func stop_music():
	$BackgroundMusic.stop()

func set_volume(volume_db: float):
	$BackgroundMusic.set_volume_db(volume_db)
