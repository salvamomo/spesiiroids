extends VBoxContainer

var drawn: bool = false

func _process(_delta):
	if (!visible):
		$FadeInTweener.stop_all()
		drawn = false

	if (visible and !drawn):
		$ThorinAvatar.modulate.a = 0
		$Sprite.modulate.a = 0
		$FadeInTweener.interpolate_property($Sprite, "modulate:a", 0, 1, 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.3)
		$FadeInTweener.interpolate_property($ThorinAvatar, "modulate:a", 0, 1, 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 2.3)
		$FadeInTweener.start()
		drawn = true
		SoundManager.pause_music_for_seconds(3.8)
		$ThankYouSoMuch.play()
