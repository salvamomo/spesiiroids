extends "res://powerups/PowerUp.gd"

const TYPE = 3
const NAME = "TerESIIca"

const BEACON_SCENE = preload("res://powerups/PowerUp_Teresiica_Beacon.tscn")

var active_beacon

func _ready():
	# Connect this to the game, and emit a custom signal
	pass

func grant_bonus_to_player(player):
	active_beacon = BEACON_SCENE.instance()
	active_beacon.position = player.position
	var Main = get_tree().get_root().get_node("Main")
	Main.add_child(active_beacon)
	
func remove_bonus_from_player(_player):
	if (is_instance_valid(active_beacon)):
		active_beacon.destroy()