extends Area2D

var velocity = Vector2(0, 0)

const MIN_VEL = -20
const MAX_VEL = 20
const MIN_ROT = -2
const MAX_ROT = 2

enum State {PICKABLE, ACQUIRED, ACTIVATED, RESPAWN_READY}
var currentState

func _ready():
	currentState = State.RESPAWN_READY
	hide()

func _process(delta):
	if currentState == State.PICKABLE:
		translate(velocity * delta)

func _on_VisibilityNotifier2D_screen_exited():
	print_debug("Removing PW")
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