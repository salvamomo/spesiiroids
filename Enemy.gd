extends KinematicBody2D
class_name Enemy

const DEG2RAD90 = 1.5708

signal enemy_died(enemy)

var Player: Area2D
var Main
var EnemyManager
var LevelManager

var bullet_scene = preload("res://bullet.tscn")

enum State {SPAWNING, ALIVE, DYING}
var currentState = 0
var can_shoot = 0
var type
export (int) var speed

func _ready():
	Main = get_tree().get_root().get_node("Main")
	Player = Main.get_node("Player")
	EnemyManager = Main.get_node("EnemyManager")
	LevelManager = Main.get_node("LevelManager")
	
	self.connect("enemy_died", LevelManager, "_on_Enemy_death")

	currentState = State.SPAWNING
	$SpawnSprite/SpawnAnimation.play("spawn")
#	$DebugSpeed.text = speed as String

func _physics_process(delta):
	var toTargetDirection = (EnemyManager.get_target_position() - self.position)

	if (currentState == State.ALIVE):
		var velocity = Vector2()
		var direction = toTargetDirection.normalized()
		velocity = direction * speed

		if (Player.has_bouncing_shield_enabled() && Player.overlaps_body(self)):
			velocity = -velocity * 2

		position += velocity * delta

#		If doing this against a KinematicBody2D, it'd be done by using
#		move_and_collid() and move_and_slide() calls. Example:
#		var collision = move_and_collide(velocity * delta) as KinematicCollision2D
#		if (collision != null):
#			if (Player.has_bouncing_shield_enabled() and collision.collider == Player):
#				velocity = -velocity * 8
#				move_and_slide(velocity)

func _process(delta):
	if (currentState == State.ALIVE):
		var toTargetDirection = (EnemyManager.get_target_position() - self.position)
		rotation = toTargetDirection.angle() - DEG2RAD90

func set_type(enemy_type):
	type = enemy_type

func get_type():
	return type

func set_textures(sprite_texture, spawn_texture):
	$Sprite.set_texture(sprite_texture)
	$SpawnSprite.set_texture(spawn_texture)

func die():
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

	$Explosion.set_emitting(true)
	$Sprite.hide()
	yield(get_tree().create_timer(1), "timeout")
	queue_free()

func hit_by_bullet():
	die()
	
func hit_by_player():
	die()


func _on_SpawnAnimation_animation_finished(anim_name):
	$SpawnSprite.hide()
	$Sprite.show()
	$CollisionShape2D.set_disabled(false)
	currentState = State.ALIVE

func _on_ShootCountdown_timeout():
	shoot_bullet()

func shoot_bullet():
	var bullet = bullet_scene.instance()
	bullet.bulletTarget = bullet.Target.PLAYER

	bullet.position = $Sprite.global_position
	# https://godotengine.org/qa/9791/how-to-convert-a-radial-into-a-vector2
	var bulletDirX = cos(self.rotation + deg2rad(90))
	var bulletDirY = sin(self.rotation + deg2rad(90))
	bullet.velocity = 700 * Vector2(bulletDirX, bulletDirY)

	Main.add_child(bullet)
