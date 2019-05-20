extends KinematicBody2D

const DEG2RAD90 = 1.5708

signal enemy_died(enemy)

var playerIdx
export (int) var speed

func _ready():
	playerIdx = get_parent().get_child(2)
	var Main = get_tree().get_root().get_node("Main")
	self.connect("enemy_died", Main, "_on_Enemy_death")

func _process(delta):
	var player = get_parent().get_child(2)
	var velocity = Vector2()
	var toPlayerDirection = (player.position - self.position)
	var direction = toPlayerDirection.normalized()
	rotation = toPlayerDirection.angle() - DEG2RAD90

	velocity = direction * speed
	position += velocity * delta

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




