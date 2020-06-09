extends "res://PowerUp.gd"

const TYPE = 3

const BEACON_SCENE = preload("res://PowerUp_Teresiica_Beacon.tscn")

var active_beacon

func _ready():
	# Connect this to the game, and emit a custom signal
	pass

func grant_bonus_to_player(player):
	active_beacon = BEACON_SCENE.instance()
	active_beacon.position = player.position
	var Main = get_tree().get_root().get_node("Main")
	Main.add_child(active_beacon)
	
func remove_bonus_from_player(player):
	active_beacon.destroy()
