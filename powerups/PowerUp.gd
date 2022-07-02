extends Area2D

class_name PowerUp

var velocity = Vector2(0, 0)
export var duracion = 3
export var time_available = 7

signal powerup_effects_expired(powerup)

const MIN_VEL = -20
const MAX_VEL = 20
const MIN_ROT = -0.1
const MAX_ROT = 0.1

var current_rotation: float

enum State {PICKABLE, ACQUIRED, ACTIVATED, RESPAWN_READY, EFFECT_JUST_EXPIRED, TEMPORARILY_DISABLED}
var currentState
var stopMusicOnUsage = false

var Main: Main
var Player: Player

func _ready():
	currentState = State.RESPAWN_READY
	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")

	if (!is_connected("powerup_effects_expired", Main, "_on_PowerUp_effects_expired")):
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

func grant_effects(player: Player):
	currentState = State.ACTIVATED
		
	if self.has_method("grant_bonus_to_player"):
		self.call("grant_bonus_to_player", player)
		
		if (stopMusicOnUsage):
			SoundManager.pause_music()
		
		handle_powerup_sound_effect()
		$EffectDurationTimer.start(self.duracion)

func remove_effects(player: Player):
	if (stopMusicOnUsage):
		SoundManager.resume_music()

	self.call("remove_bonus_from_player", player)
	expire_effect()
	reset()

func _on_EffectDurationTimer_timeout():
	remove_effects(Player)
	currentState = State.EFFECT_JUST_EXPIRED

func handle_powerup_sound_effect():
	if self.has_method("play_sound_effect"):
		self.call("play_sound_effect")
	else:
		$AudioStreamPlayer.play()

func _process(delta):
	rotation += deg2rad(current_rotation)
	if currentState == State.PICKABLE:
		translate(velocity * delta)

		# Useful to debug powerup generation.
#		if (!$DebugTTL.is_visible()):
#			$DebugTTL.show()
#		$DebugTTL.text = stepify($AvailabilityTimer.get_time_left(), 0.01) as String

func _on_VisibilityNotifier2D_screen_exited():
	# Check the timer is inside the tree. This avoid console errors caused by
	# the visibility notifier calling reset as soon as power ups load, and it
	# looks like the timer is not available at that point yet.
	if ($RespawnCooldown.is_inside_tree()):
		reset()

func reset():
	$RespawnCooldown.start()
	$CollisionBox.set_deferred("disabled", true)
	hide()
#	modulate = Color(1, 0, 0)

func set_state_acquired():
	currentState = State.ACQUIRED
	$CollisionBox.set_deferred("disabled", true)
	hide()
#	modulate = Color(0, 0, 1)
	
func respawn():
	currentState = State.PICKABLE
	current_rotation = rand_range(MIN_ROT, MAX_ROT)
	show()
#	modulate = Color(0, 1, 0)
	$CollisionBox.set_deferred("disabled", false)
	# Allow to stay on the map for a limited amount of time.
	$AvailabilityTimer.start(time_available)

func _on_AvailabilityTimer_timeout():
	# State is checked here because it may have changed between
	# the moment it was set, and the moment the timer returned.
	if currentState in [State.PICKABLE, State.TEMPORARILY_DISABLED]:
		reset()

func _on_RespawnCooldown_timeout():
	if [State.ACTIVATED, State.ACQUIRED].has(currentState):
		return

	currentState = State.RESPAWN_READY

func is_ready_for_respawn():
	return currentState == State.RESPAWN_READY
	
func expire_effect():
	emit_signal("powerup_effects_expired", self)

func _on_PowerUp_area_entered(area):
	# Filtering by Ship group to avoid detected bullets. (this should be changed to layers / mask)
	if area.is_in_group('Ship') and currentState == State.PICKABLE:
		area.add_power_up(self)
		set_state_acquired()
