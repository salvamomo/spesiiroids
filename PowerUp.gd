extends Area2D

var velocity = Vector2(0, 0)
export var duracion = 3

signal powerup_effects_expired(powerup)

const MIN_VEL = -20
const MAX_VEL = 20
const MIN_ROT = -2
const MAX_ROT = 2

enum State {PICKABLE, ACQUIRED, ACTIVATED, RESPAWN_READY}
var currentState

func _ready():
	currentState = State.RESPAWN_READY
	var Main = get_tree().get_root().get_node("Main")
	var Player = get_tree().get_root().get_node("Main/Player")
	self.connect("powerup_effects_expired", Main, "_on_PowerUp_effects_expired")
	self.connect("powerup_effects_expired", Player, "_on_PowerUp_effects_expired")
	hide()

func grant_effects(player):
	if self.has_method("grant_bonus_to_player"):
		self.call("grant_bonus_to_player", player)
		yield(get_tree().create_timer(self.duracion), "timeout")
		self.call("remove_bonus_from_player", player)
		fade()
		reset()

func _process(delta):
	if currentState == State.PICKABLE:
		translate(velocity * delta)

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
	
func is_ready_for_respawn():
	return currentState == State.RESPAWN_READY
	
func fade():
	print("Power up faded.")
	emit_signal("powerup_effects_expired", self)

func _on_PowerUp_area_entered(area):
	if area.is_in_group("Ship"):
		area.add_power_up(self)
		set_state_acquired()