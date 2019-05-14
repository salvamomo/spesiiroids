extends Area2D

export var velocity = Vector2()
var alive: bool

func _ready():
	alive = true
	yield($VisibilityNotifier, "screen_exited")
	queue_free()

func _process(delta):
	if (alive):
		translate(velocity * delta)

func _on_Bullet_collision(body):
	if (alive && body.has_method('hit_by_bullet')):
		alive = false
		body.call('hit_by_bullet')
		queue_free()
