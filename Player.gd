extends Area2D

const JOYSTICK_DEAD_ZONE = 0.15
const SCREEN_BOUNDARIES = 35

enum POWER_UP_INDX {CHIQUITO, VICENTIN, TERESIICA, MRT}
var acquiredPowerUps = [null, null, null, null]

signal powerup_activated(powerup)

var screensize
var last_shoot = 0.3
var shooting_speed = 0.3
export (int) var speed


# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size

	if (Input.is_joy_known(0)):
		print("Input recognised: " + Input.get_joy_name(0))
#		var axis_string = Input.get_joy_axis_string(JOY_AXIS_3)
#		var axis_index = Input.get_joy_axis_index_from_string("Right Stick Y")
#		print(axis_string)
#		print(axis_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## ROTATION
	# JOY_AXIS_0 L-> | JOY_AXIS_1 L^ | JOY_AXIS_2 R-> | JOY_AXIS_3 R^
	var xAxis = Input.get_joy_axis(0, JOY_AXIS_2)
	var yAxis = Input.get_joy_axis(0, JOY_AXIS_3)
	var rot = Vector2(xAxis, yAxis)

#	@todo: Add mouse aim position (it shouldn't affect when playing with controller).
#	self.set_rotation_degrees(90 + rad2deg(get_global_mouse_position().angle_to_point(position)))
#	http://docs.godotengine.org/en/stable/classes/class_control.html might be of help,
#	as it has mouse_entered() and mouse_exited() events.
	if Input.is_action_pressed("aim_down") || Input.is_action_pressed("aim_top") || Input.is_action_pressed("aim_left") || Input.is_action_pressed("aim_right"):
		if rot.length_squared() > JOYSTICK_DEAD_ZONE:
	#		The ship's default direction is upwards. That's equivalent -90º, given 
	#		Godot yAxis is top -> down. Add extra 90º to the rotation to compensate.
			self.set_rotation_degrees(90 + rad2deg(rot.angle()))

	_handle_power_up_usage()

	## MOVEMENT.
	last_shoot += delta;
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
			# Is there a need to yield until shoot_bullet is finished?
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
	var bullet = preload("res://Bullet.tscn").instance()

	# Make sure the bullet doesn't move with the Player, by adding it as a child of the parent scene.
	bullet.position = $Sprite.global_position
	# https://godotengine.org/qa/9791/how-to-convert-a-radial-into-a-vector2
	var bulletDirX = cos(self.rotation - deg2rad(90.0))
	var bulletDirY = sin(self.rotation - deg2rad(90.0))
	bullet.velocity = 700 * Vector2(bulletDirX, bulletDirY)
	get_parent().add_child(bullet)

#
#func _process(delta):
#	if velocity.length() > 0:
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
#
#	position += velocity * delta
#	position.x = clamp(position.x, 0, screensize.x)
#	position.y = clamp(position.y, 0, screensize.y)
#
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "right"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
#
#func _on_Player_body_entered(body):
#	hide()
#	emit_signal('hit')
#	$CollisionShape2D.disabled = true
#
#func start(pos):
#	position = pos
#	show()
#	$CollisionShape2D.disabled = false

func add_power_up(powerUp):
	# @todo: Emit signal to update HUD with powerUp?
	if (acquiredPowerUps[powerUp.TYPE] == null):
		acquiredPowerUps[powerUp.TYPE] = powerUp
		print("added pw type: " + powerUp.TYPE as String)
	
func has_power_up(powerUpType):
	return acquiredPowerUps[powerUpType] != null
	
func activate_power_up(powerUpIdx):
	# @todo: prevent activation when power up is in use.
	if acquiredPowerUps[powerUpIdx] != null:
		emit_signal("powerup_activated", acquiredPowerUps[powerUpIdx])
		acquiredPowerUps[powerUpIdx].grant_effects(self)
		acquiredPowerUps[powerUpIdx] = null
	# @todo: wait for effect disappear.

func _on_Player_collision(body):
	if body.has_method('hit_by_player'):
		body.hit_by_player()
		# Assume for now it's always an enemy.
		# @todo: kill player.





