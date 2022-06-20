extends Node


export var velocity = Vector2()

func _ready():
	$stars_1.velocity = velocity
	$stars_2.velocity = velocity
	$stars_3.velocity = velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
