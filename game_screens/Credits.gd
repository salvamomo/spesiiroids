extends Node

var current_page_index: int = 0
var pages: Array

func _ready():
	pages = [$GameInfo, $AssetCredits_1, $AssetCredits_2, $ThankYouContainer]
	$PagerPrev.hide()
	$PagerContainer/Pager.text = "1 / " + pages.size() as String
	SoundManager.set_volume(-28.00)
	SoundManager.restart_music()

func _process(_delta):
	if Input.is_action_just_pressed("Exit_Back") or Input.is_action_just_pressed("Start_Pause"):
		self.queue_free()
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://game_screens/MainMenu.tscn")
	elif Input.is_action_just_pressed("ui_left"):
		paginate_prev()
	elif Input.is_action_just_pressed("ui_right"):
		paginate_next()

	if (Input.is_action_just_pressed("FullScreen")):
		OS.window_fullscreen = !OS.window_fullscreen


func paginate_prev():
	if (current_page_index == 0):
		return

	$PagerNext.show()
	pages[current_page_index].hide()
	current_page_index -= 1
	pages[current_page_index].show()
	$PagerContainer/Pager.text = (current_page_index + 1) as String + " / " + pages.size() as String

	if (current_page_index == 0):
		$PagerPrev.hide()

func paginate_next():
	if (current_page_index >= pages.size() - 1):
		return

	$PagerPrev.show()
	pages[current_page_index].hide()
	current_page_index += 1
	pages[current_page_index].show()
	$PagerContainer/Pager.text = (current_page_index + 1) as String + " / " + pages.size() as String

	if (current_page_index == (pages.size() - 1)):
		$PagerNext.hide()

func _on_PagerArrow_pressed(prev_next: String):
	if (prev_next == 'prev'):
		paginate_prev()
		return

	paginate_next()
