extends Area2D

class_name Player

## START GAME SETTINGS
const SCREEN_BOUNDARIES = 35
const HUD_TOP_BAR_SIZE = 25
## START GAME SETTINGS

enum POWER_UP_INDX {CHIQUITO, VICENTIN, TERESIICA, MRT}
var acquiredPowerUps = [null, null, null, null]

signal powerup_acquired(powerup)
signal powerup_activated(powerup)
signal hit_by_enemy
signal player_dies

var screensize
export (int) var speed

var powerUpInUse: bool = false

# Is immortal is a temporary state that can be caused by powerUps.
# god_mode can only be enabled during development (or, maybe, cheat codes).
var isImmortal: bool = false
export (bool) var god_mode = false
export (int) var lives = 3

## START MOVEMENT
var mouse_motion_threshold = 0.25
var last_mouse_motion_delta = 0
var last_mouse_position: Vector2
## END MOVEMENT

## START SHOOTING
var last_shoot = 0.3
var shooting_speed = 0.3
var shooting_bullet_speed = 700

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

	last_mouse_position = get_global_mouse_position()
	last_mouse_motion_delta = mouse_motion_threshold

	if (Input.is_joy_known(0)):
		print("Input recognised: " + Input.get_joy_name(0))

func _process(delta):
	last_shoot += delta;

	# MOVEMENT.
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position.x = clamp(position.x, 0 + SCREEN_BOUNDARIES, screensize.x - SCREEN_BOUNDARIES);
	position.y = clamp(position.y, HUD_TOP_BAR_SIZE + SCREEN_BOUNDARIES, screensize.y - SCREEN_BOUNDARIES);

	# AIMING / SHOOTING
	# Mouse aim: Rotate the ship if mouse has moved during the last few moments,
	# defined by "mouse_motion_threshold". Otherwise don't change ship rotation
	# as a gamepad controller is assumed.
	# NOTE: MacOS tracks the mouse even outside the game window. In Linux this
	# doesn't happen.
	last_mouse_motion_delta += delta
	var mouse_has_changed_position = last_mouse_position != get_global_mouse_position()
	if ((last_mouse_motion_delta < mouse_motion_threshold) or mouse_has_changed_position):
		last_mouse_position = get_global_mouse_position()
		self.set_rotation_degrees(90 + rad2deg(get_global_mouse_position().angle_to_point(position)))
		if (mouse_has_changed_position):
			last_mouse_motion_delta = 0

	# Right joystick aiming & shooting.
	var aim_direction = Input.get_vector("aim_left", "aim_right", "aim_top", "aim_down")
	if aim_direction.length() > 0:
		# The ship's default direction is upwards. That's equivalent -90º, given
		# Godot yAxis is top -> down. Add extra 90º to the rotation to compensate.
		self.set_rotation_degrees(90 + rad2deg(aim_direction.angle()))

		if (last_shoot >= shooting_speed):
			last_shoot = 0;
			shoot_bullet(aim_direction)
	# If there wasn't movement in the joystick, get aim from the last mouse position.
	elif last_mouse_position.length() > 0:
		aim_direction = position.direction_to(last_mouse_position)
	# If that wasn't possible, simply aim to wherever the ship is looking.
	else:
		aim_direction = Vector2(cos(self.rotation - deg2rad(90.0)), sin(self.rotation - deg2rad(90.0)))

	# Button-triggered shooting.
	if Input.is_action_pressed("shoot"):
		if (last_shoot >= shooting_speed):
			last_shoot = 0;
			shoot_bullet(aim_direction)

	_handle_power_up_usage()

func _handle_power_up_usage():
	if Input.is_action_pressed("PowerUp_1"):
		activate_power_up(POWER_UP_INDX.CHIQUITO)
	if Input.is_action_pressed("PowerUp_2"):
		activate_power_up(POWER_UP_INDX.VICENTIN)
	if Input.is_action_pressed("PowerUp_3"):
		activate_power_up(POWER_UP_INDX.TERESIICA)
	if Input.is_action_pressed("PowerUp_4"):
		activate_power_up(POWER_UP_INDX.MRT)

func shoot_bullet(target_direction: Vector2):
	var bullet = availableBullets[current_bullet_type].instance()
	bullet.position = $Sprite.global_position
	bullet.velocity = shooting_bullet_speed * target_direction.normalized()
	# Make sure the bullet doesn't move with the Player, by adding it as a child of the parent scene.
	Main.add_child(bullet)

func make_immortal():
	isImmortal = true

func make_mortal():
	isImmortal = false

func is_immortal() -> bool:
	return isImmortal

func add_power_up(powerUp):
	if (acquiredPowerUps[powerUp.TYPE] == null):
		acquiredPowerUps[powerUp.TYPE] = powerUp
		emit_signal("powerup_acquired", powerUp)

func has_power_up(powerUpType):
	return acquiredPowerUps[powerUpType] != null

func has_powerup_in_use() -> bool:
	return powerUpInUse

func _on_PowerUp_effects_expired(_powerUp):
	powerUpInUse = false

func activate_power_up(powerUpIdx):
	if has_powerup_in_use():
		return

	if acquiredPowerUps[powerUpIdx] != null:
		emit_signal("powerup_activated", acquiredPowerUps[powerUpIdx])
		acquiredPowerUps[powerUpIdx].grant_effects(self)
		powerUpInUse = true
		acquiredPowerUps[powerUpIdx] = null

func activate_bouncing_shield():
	# Would it be better to have a bouncing shield scene added to the player
	# when activating the power up? If so, how'd the enemies reliable check
	# for collisions with that scene, that may or may not be attached to
	# the player?
	$BouncingArea/BouncingShield.disabled = false

func deactivate_bouncing_shield():
	$BouncingArea/BouncingShield.disabled = true

func acquire_extra_life():
	lives += 1
	$ExtraLifeSound.play()
	print("Granted life to player")

func _on_Player_collision(body):
	if body.is_in_group("Enemies"):
		_hit_by_enemy(body)

func _on_BouncingArea_body_entered(body):
	body.set_bounce_back(true)

func _on_BouncingArea_body_exited(body):
	body.set_bounce_back(false)

func hit_by_bullet():
	if $BouncingArea/BouncingShield.disabled:
		lives -= 1
		emit_signal("hit_by_enemy")
		_check_death()

func _hit_by_enemy(body):
	body.hit_by_player()
	Globals.add_hit()

	if !is_immortal():
		$HitTakenSound.play()
		var default_modulate = get_modulate()
		# Original color was more like Color(0.69, 0.91, 0.2). (greenish)
		var modulate_color = Color(0.91, 0.69, 0.2)

		$Sprite/sprite_tweener.interpolate_property($Sprite, "modulate", default_modulate, modulate_color, 0.2)
		$Sprite/sprite_tweener.interpolate_property($Sprite, "modulate", modulate_color, default_modulate, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
		$Sprite/sprite_tweener.start()

		if !god_mode:
			lives -= 1
			_check_death()

	emit_signal("hit_by_enemy")

func _on_HitModulateTimer_timeout():
	set_modulate(Color(1, 1, 1, 1))

func _check_death():
	if (lives > 0):
		# Play live lost animation.
		print("@todo: ", lives, " lives: hit animation")
	else:
		emit_signal("player_dies")	
