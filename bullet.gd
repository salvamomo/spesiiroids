extends Area2D

export var velocity = Vector2()

func _ready():
	yield($VisibilityNotifier, "screen_exited")
	queue_free()
	pass

func _process(delta):
	translate(velocity * delta)

func _on_Bullet_collision(body):
	if (body.has_method('hit_by_bullet')):
		body.call('hit_by_bullet')
