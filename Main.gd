extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
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
