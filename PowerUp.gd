extends Area2D

var velocity = Vector2(15, 30)

func _ready():
	pass # Replace with function body.

func _process(delta):
	translate(velocity * delta)
	# @todo: Remove when off-screen.