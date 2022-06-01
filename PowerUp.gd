extends Area2D

class_name PowerUp

var velocity = Vector2(0, 0)
export var duracion = 3
export var time_available = 7

var timer_ttl: SceneTreeTimer

signal powerup_effects_expired(powerup)

const MIN_VEL = -20
const MAX_VEL = 20
const MIN_ROT = -2
const MAX_ROT = 2

enum State {PICKABLE, ACQUIRED, ACTIVATED, RESPAWN_READY, TEMPORARILY_DISABLED}
var currentState
var stopMusicOnUsage = false

func _ready():
	currentState = State.RESPAWN_READY
	var Main = get_tree().get_root().get_node("Main")
	var Player = get_tree().get_root().get_node("Main/Player")
	# warning-ignore:return_value_discarded
	self.connect("powerup_effects_expired", Main, "_on_PowerUp_effects_expired")
	# warning-ignore:return_value_discarded
	self.connect("powerup_effects_expired", Player, "_on_PowerUp_effects_expired")
	hide()

func disable_temporarily():
	if (currentState == State.PICKABLE):
		currentState = State.TEMPORARILY_DISABLED
		hide()

func reenable():
	if (currentState == State.TEMPORARILY_DISABLED):
		currentState = State.PICKABLE
		show()

func grant_effects(player):
	var SoundManager = get_tree().get_root().get_node("Main/SoundManager")
		
	if self.has_method("grant_bonus_to_player"):
		self.call("grant_bonus_to_player", player)
		
		if (stopMusicOnUsage):
			SoundManager.pause_music()
		
		handle_powerup_sound_effect()
		
		yield(get_tree().create_timer(self.duracion, false), "timeout")
		
		if (stopMusicOnUsage):
			SoundManager.resume_music()

		self.call("remove_bonus_from_player", player)
		fade()
		reset()

func handle_powerup_sound_effect():
	if self.has_method("play_sound_effect"):
		self.call("play_sound_effect")
	else:
		$AudioStreamPlayer.play()

func _process(delta):
	if currentState == State.PICKABLE:
		translate(velocity * delta)

		# Useful to debug powerup generation.
		#$DebugTTL.text = timer_ttl.get_time_left() as String

func _on_VisibilityNotifier2D_screen_exited():
	reset()

func reset():
	currentState = State.RESPAWN_READY
	hide()

func set_state_acquired():
	currentState = State.ACQUIRED
	hide()
	
func respawn():
	currentState = State.PICKABLE
	show()
	
	timer_ttl = get_tree().create_timer(time_available, false)
	yield(timer_ttl, "timeout")
	# Allow to stay on the map for a limited amount of time.
	# State is checked here because it may have changed between
	# the moment it was set, and the moment the timer returned.
	if currentState in [State.PICKABLE, State.TEMPORARILY_DISABLED]:
		reset()
	
func is_ready_for_respawn():
	return currentState == State.RESPAWN_READY
	
func fade():
	print("Power up faded.")
	emit_signal("powerup_effects_expired", self)

func _on_PowerUp_area_entered(area):
	if area.is_in_group("Ship"):
		area.add_power_up(self)
		set_state_acquired()
