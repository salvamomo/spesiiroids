extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit_by_bullet():
	# @todo: Play animation before delete.
	queue_free()