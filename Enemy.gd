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

func _process(delta):
	var velocity = Vector2()
	var toTargetDirection = (EnemyManager.get_target_position() - self.position)
	var direction = toTargetDirection.normalized()
	rotation = toTargetDirection.angle() - DEG2RAD90

	velocity = direction * speed
	position += velocity * delta

func set_texture(texture):
	$Sprite.set_texture(texture)

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




