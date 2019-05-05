extends Sprite

var screensize
export var velocity = Vector2()

func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	translate(velocity * delta)
	
	if (position.y >= screensize.y):
		position = Vector2(0, -600)
