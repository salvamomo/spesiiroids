extends KinematicBody2D

const DEG2RAD90 = 1.5708

var playerIdx
export (int) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	playerIdx = get_parent().get_child(2)
	pass # Replace with function body.

func _process(delta):
	var player = get_parent().get_child(2)
	var velocity = Vector2()
	var toPlayerDirection = (player.position - self.position)
	var direction = toPlayerDirection.normalized()
	rotation = toPlayerDirection.angle() - DEG2RAD90

	velocity = direction * speed
	position += velocity * delta

func die():
	# @todo: Play death animation.
	queue_free()

func hit_by_bullet():
	die()
	
func hit_by_player():
	die()




