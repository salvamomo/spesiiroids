extends Area2D

export var velocity = Vector2()
var alive: bool

enum Target {PLAYER, ENEMY}
var bulletTarget = Target.ENEMY

func _ready():
	alive = true
	$ShootingSound.play()
	yield($VisibilityNotifier, "screen_exited")
	queue_free()

func _process(delta):
	if (alive):
		translate(velocity * delta)

func _on_Bullet_collision(body):
	if (alive && bulletTarget == Target.ENEMY and body.is_in_group("Enemies")):
		alive = false
		body.call('hit_by_bullet')
		queue_free()

func _on_Bullet_area_entered(area):
	if (bulletTarget == Target.PLAYER and area.is_in_group("Ship")):
		alive = false
		area.call('hit_by_bullet')
		queue_free()
