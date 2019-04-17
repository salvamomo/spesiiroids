extends Area2D

var screensize
export (int) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size
#	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x);
	position.y = clamp(position.y, 0, screensize.y);


#extends Area2D
#
#signal hit
#var screensize
#
#func _ready():
#	screensize = get_viewport_rect().size
#	hide()
#
#func _process(delta):
#	if velocity.length() > 0:
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
#
#	position += velocity * delta
#	position.x = clamp(position.x, 0, screensize.x)
#	position.y = clamp(position.y, 0, screensize.y)
#
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "right"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
#
#func _on_Player_body_entered(body):
#	hide()
#	emit_signal('hit')
#	$CollisionShape2D.disabled = true
#
#func start(pos):
#	position = pos
#	show()
#	$CollisionShape2D.disabled = false