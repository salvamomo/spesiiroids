extends Node

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	var enemy =	preload("res://Enemy.tscn")
	
	var enemy1 = enemy.instance()
	enemy1.position = Vector2(100, 100)
	
	var enemy2 = enemy.instance()
	enemy2.position = Vector2(700, 100)
	var enemy3 = enemy.instance()
	enemy3.position = Vector2(100, 500)
	var enemy4 = enemy.instance()
	enemy4.position = Vector2(700, 500)
	
	.add_child(enemy1)
	.add_child(enemy2)
	.add_child(enemy3)
	.add_child(enemy4)

func _process(delta):
	pass


func _on_PowerUpTimer_timeout():
	# @todo: Randomize type of power up.
	var powerUp = preload("res://PowerUp.tscn")
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	powerUp = powerUp.instance()
	powerUp.position = Vector2(
		lerp(screen_size.x * 0.1, screen_size.x * 0.9, random.randf()),
		lerp(screen_size.y * 0.1, screen_size.y * 0.9, random.randf())
	)
	
	.add_child(powerUp)
	