extends KinematicBody2D
class_name Enemy

const DEG2RAD90 = 1.5708

signal enemy_died(enemy)

var Player
var Main
var EnemyManager

enum State {SPAWNING, ALIVE, DYING}
var currentState = 0
var can_shoot = 0
export (int) var speed

func _ready():
	Main = get_tree().get_root().get_node("Main")
	Player = get_tree().get_root().get_node("Main/Player")
	EnemyManager = get_tree().get_root().get_node("Main/EnemyManager")
	self.connect("enemy_died", Main, "_on_Enemy_death")

	currentState = State.SPAWNING
	$SpawnSprite/SpawnAnimation.play("spawn")

func _process(delta):
	var toTargetDirection = (EnemyManager.get_target_position() - self.position)
	rotation = toTargetDirection.angle() - DEG2RAD90

	if (currentState == State.ALIVE):
		var velocity = Vector2()
		var direction = toTargetDirection.normalized()
		velocity = direction * speed
	
		if (Player.has_bouncing_shield_enabled() && Player.overlaps_body(self)):
			velocity = -velocity * 2

		position += velocity * delta

func set_textures(sprite_texture, spawn_texture):
	$Sprite.set_texture(sprite_texture)
	$SpawnSprite.set_texture(spawn_texture)

func die():
	# @todo: Finish explosion effect.
	emit_signal("enemy_died", self)
	$Explosion.emitting = true
	$Sprite.hide()
#	yield(get_tree().create_timer(1), "timeout")
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
