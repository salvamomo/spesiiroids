extends KinematicBody2D
class_name Enemy

const DEG2RAD90 = 1.5708

signal enemy_died(enemy)

var Player: Player
var Main
var EnemyManager
var LevelManager

export (PackedScene) var SCENE_BULLET

enum State {SPAWNING, ALIVE, DYING}
var currentState = 0

var can_shoot: bool = false

# Enemies will shot only if they get a higher randf() result than this number.
export (float) var shooting_chance_threshold = 0.6
export (float) var shooting_distance_threshold = 350
# Original threshold was type 6.
export (int) var shooting_enemy_type_threshold = 3
var shooting_bullet_speed = 700

# This is used to adjust the bouncing velocity by multiplying it for the enemy
# speed. It's used to make sure enemies with low speed don't get close to the
# player when the bouncing shield is enabled, if their speed is too low, since
# the bounce will be adjusted according to each enemy's speed.
var bounce_speed_balancer = 0.008
var bounce_back_flag = null

var type
export (int) var speed

func _ready():
	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")
	EnemyManager = Main.get_node("EnemyManager")
	LevelManager = Main.get_node("LevelManager")
	
	# warning-ignore:return_value_discarded
	self.connect("enemy_died", LevelManager, "_on_Enemy_death")

	currentState = State.SPAWNING
	$SpawnSprite/SpawnAnimation.play("spawn")
#	$DebugSpeed.text = speed as String

func set_bounce_back(value: bool):
	bounce_back_flag = value

func _physics_process(delta):
	var targetNode = EnemyManager.get_target_object()
	var toTargetDirection = (targetNode.position - self.position)

	if (currentState == State.ALIVE):
		var velocity = Vector2()
		var direction = toTargetDirection.normalized()
		velocity = direction * speed

		if (bounce_back_flag):
			velocity = -velocity * (2 + speed * bounce_speed_balancer)

		if (targetNode.is_in_group('PowerUps')):
			if targetNode.overlaps_body(self) or (toTargetDirection.length() < 75):
				velocity = -direction * (speed / 10) * 0.25

		# Allow movement if it's not disabled, or if the enemy should bounce due
		# to the chiquito powerup.
		if (EnemyManager.enemies_can_move() or bounce_back_flag):
			position += velocity * delta

#		If doing this against a KinematicBody2D, it'd be done by using
#		move_and_collid() and move_and_slide() calls. Example:
#		var collision = move_and_collide(velocity * delta) as KinematicCollision2D
#		if (collision != null):
#			if (Player.has_bouncing_shield_enabled() and collision.collider == Player):
#				velocity = -velocity * 8
#				move_and_slide(velocity)

func _process(_delta):
	if !EnemyManager.enemies_can_move():
		return

	var toTargetDirection = (EnemyManager.get_target_position() - self.position)
	if (currentState == State.ALIVE):
		rotation = toTargetDirection.angle() - DEG2RAD90
	elif (currentState == State.SPAWNING):
		rotation = toTargetDirection.angle()
		# Type 0 was originally oriented in a different angle in the spritesheet.
		if (type == 0):
			rotation = toTargetDirection.angle() - DEG2RAD90

func set_type(enemy_type):
	type = enemy_type

	if (type >= shooting_enemy_type_threshold):
		can_shoot = true

func get_type():
	return type

func set_textures(sprite_texture, spawn_texture):
	$Sprite.set_texture(sprite_texture)
	$SpawnSprite.set_texture(spawn_texture)

func die():
	# If enemy is already dying, do nothing.
	if (currentState == State.DYING):
		return

	# @todo: Finish explosion effect.
	currentState = State.DYING
	emit_signal("enemy_died", self)

	# $CollisionShape2D.set_disabled(true) or $CollisionShape2D.disabled = true
	# won't work. From the CollisionShape2D docs:
	# "A disabled collision shape has no effect in the world. 
	# This property should be changed with Object.set_deferred()."
	# It's probably related to the physics engine doing some calculations
	# when I'm trying to disable. Calling $CollisionShape2D.free() works though,
	# as it deletes the object from memory immediately. Deferring the call, as 
	# suggested by the docs:
	$CollisionShape2D.set_deferred("disabled", true)

	$ExplosionFire.set_emitting(true)
	$Sprite.hide()
	$ExplosionSmokeStartTimer.start()

	# Using a timer node for this instead of a yield, as it avoids possible
	# errors with returning code after the instance is gone (can happen if die()
	# is called too quickly and the first call has already cleared the instance
	# by the time the second returns from the yield).
	# https://godotengine.org/qa/76800/resumed-function-after-yield-but-class-instance-is-gone.

	# Total time until enemy disappearance is 0.5 for the smoke effect to play,
	# plus whatever is left on the just-started smoke timer. For some reason,
	# starting the disappear timer on the smoke start timeout, it's not properly
	# killing enemies, and they won't keep respawning.
	var total_time_to_disappear: float = $ExplosionSmokeStartTimer.get_time_left() + 0.5
	$ExplosionDisappearTimer.start(total_time_to_disappear)

func _on_ExplosionSmokeStartTimer_timeout():
	$ExplosionSmoke.set_emitting(true)

func _on_ExplosionDisappearTimer_timeout():
	queue_free()

func hit_by_bullet():
	die()

func hit_by_player():
	die()

func _on_SpawnAnimation_animation_finished(_anim_name):
	$SpawnSprite.hide()
	$Sprite.show()
	$CollisionShape2D.set_disabled(false)
	currentState = State.ALIVE

func _on_ShootCountdown_timeout():
	shoot_bullet()

func shoot_bullet():
	var distance_to_player = Player.position - position
	if (!can_shoot or randf() < shooting_chance_threshold or distance_to_player.length() < shooting_distance_threshold):
		return

	var bullet = SCENE_BULLET.instance()
	bullet.bulletTarget = bullet.Target.PLAYER

	bullet.position = $Sprite.global_position
	# https://godotengine.org/qa/9791/how-to-convert-a-radial-into-a-vector2
	var bulletDirX = cos(self.rotation + deg2rad(90))
	var bulletDirY = sin(self.rotation + deg2rad(90))
	bullet.velocity = shooting_bullet_speed * Vector2(bulletDirX, bulletDirY)

	Main.add_child(bullet)
