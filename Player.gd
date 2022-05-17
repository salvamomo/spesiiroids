extends Area2D

## START GAME SETTINGS
const JOYSTICK_DEAD_ZONE = 0.15
const SCREEN_BOUNDARIES = 35
## START GAME SETTINGS

enum POWER_UP_INDX {CHIQUITO, VICENTIN, TERESIICA, MRT}
var acquiredPowerUps = [null, null, null, null]

signal powerup_acquired(powerup)
signal powerup_activated(powerup)
signal hit_by_enemy
signal player_dies

var screensize
export (int) var speed

var powerUpInUse = false
export (int) var lives = 3

## START SHOOTING
var last_shoot = 0.3
var shooting_speed = 0.3

enum BULLET_TYPE {DEFAULT, FIREBALL}
export (BULLET_TYPE) var current_bullet_type
var availableBullets = {
	BULLET_TYPE.DEFAULT: preload("res://bullet.tscn"),
	BULLET_TYPE.FIREBALL: preload("res://bullet_fire.tscn"),
}
## END SHOOTING

var Main

func _ready():
	screensize = get_viewport_rect().size
	Main = get_tree().get_root().get_node('Main')

	if (Input.is_joy_known(0)):
		print("Input recognised: " + Input.get_joy_name(0))
#		var axis_string = Input.get_joy_axis_string(JOY_AXIS_3)
#		var axis_index = Input.get_joy_axis_index_from_string("Right Stick Y")
#		print(axis_string)
#		print(axis_index)

func _process(delta):
	## ROTATION
	# JOY_AXIS_0 L-> | JOY_AXIS_1 L^ | JOY_AXIS_2 R-> | JOY_AXIS_3 R^
	var xAxis = Input.get_joy_axis(0, JOY_AXIS_2)
	var yAxis = Input.get_joy_axis(0, JOY_AXIS_3)
	var rot = Vector2(xAxis, yAxis)

	last_shoot += delta;

#	@todo: Add mouse aim position (it shouldn't affect when playing with controller).
#	self.set_rotation_degrees(90 + rad2deg(get_global_mouse_position().angle_to_point(position)))
#	http://docs.godotengine.org/en/stable/classes/class_control.html might be of help,
#	as it has mouse_entered() and mouse_exited() events.
	if Input.is_action_pressed("aim_down") || Input.is_action_pressed("aim_top") || Input.is_action_pressed("aim_left") || Input.is_action_pressed("aim_right"):
		if rot.length_squared() > JOYSTICK_DEAD_ZONE:
	#		The ship's default direction is upwards. That's equivalent -90º, given 
	#		Godot yAxis is top -> down. Add extra 90º to the rotation to compensate.
			self.set_rotation_degrees(90 + rad2deg(rot.angle()))
			
			if (last_shoot >= shooting_speed):
				last_shoot = 0;
				shoot_bullet()
			
	_handle_power_up_usage()

	## MOVEMENT.
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("shoot"):
		if (last_shoot >= shooting_speed):
			last_shoot = 0;
			shoot_bullet()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	
	position.x = clamp(position.x, 0 + SCREEN_BOUNDARIES, screensize.x - SCREEN_BOUNDARIES);
	position.y = clamp(position.y, 0 + SCREEN_BOUNDARIES, screensize.y - SCREEN_BOUNDARIES);

func _handle_power_up_usage():
	if Input.is_action_pressed("PowerUp_1"):
		activate_power_up(POWER_UP_INDX.CHIQUITO)
	if Input.is_action_pressed("PowerUp_2"):
		activate_power_up(POWER_UP_INDX.VICENTIN)
	if Input.is_action_pressed("PowerUp_3"):
		activate_power_up(POWER_UP_INDX.TERESIICA)
	if Input.is_action_pressed("PowerUp_4"):
		activate_power_up(POWER_UP_INDX.MRT)

func shoot_bullet():
	var bullet = availableBullets[current_bullet_type].instance()

	bullet.position = $Sprite.global_position
	# https://godotengine.org/qa/9791/how-to-convert-a-radial-into-a-vector2
	var bulletDirX = cos(self.rotation - deg2rad(90.0))
	var bulletDirY = sin(self.rotation - deg2rad(90.0))
	bullet.velocity = 700 * Vector2(bulletDirX, bulletDirY)

	# Make sure the bullet doesn't move with the Player, by adding it as a child of the parent scene.
	Main.add_child(bullet)

func add_power_up(powerUp):
	if (acquiredPowerUps[powerUp.TYPE] == null):
		acquiredPowerUps[powerUp.TYPE] = powerUp
		emit_signal("powerup_acquired", powerUp)
	
func has_power_up(powerUpType):
	return acquiredPowerUps[powerUpType] != null

func _on_PowerUp_effects_expired(powerUp):
	powerUpInUse = false

func activate_power_up(powerUpIdx):
	if powerUpInUse:
		return

	if acquiredPowerUps[powerUpIdx] != null:
		emit_signal("powerup_activated", acquiredPowerUps[powerUpIdx])
		acquiredPowerUps[powerUpIdx].grant_effects(self)
		powerUpInUse = true
		acquiredPowerUps[powerUpIdx] = null

func has_bouncing_shield_enabled():
	return ! $BouncingShield.disabled

func activate_bouncing_shield():
	# Would it be better to have a bouncing shield scene added to the player
	# when activating the power up? If so, how'd the enemies reliable check
	# for collisions with that scene, that may or may not be attached to
	# the player?
	$BouncingShield.disabled = false

func deactivate_bouncing_shield():
	$BouncingShield.disabled = true

func _on_Player_collision(body):
	if body.is_in_group("Enemies") && $BouncingShield.disabled:
		_hit_by_enemy(body)

func hit_by_bullet():
	if $BouncingShield.disabled:
		lives -= 1
		emit_signal("hit_by_enemy")
		_check_death()

func _hit_by_enemy(body):
	body.hit_by_player()
	
	lives -= 1
	emit_signal("hit_by_enemy")
	_check_death()
	
func _check_death():
	if (lives > 0):
		# Play live lost animation.
		print("@todo: ", lives, " lives: hit animation")
	else:
		emit_signal("player_dies")	
