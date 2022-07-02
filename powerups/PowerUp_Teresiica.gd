extends PowerUp

const TYPE = 3
const NAME = "TerESIIca"

export (PackedScene) var SCENE_BEACON

var active_beacon

func grant_bonus_to_player(player):
	active_beacon = SCENE_BEACON.instance()
	active_beacon.position = player.position
	var Main = get_tree().get_root().get_node("Main")
	Main.add_child(active_beacon)
	
func remove_bonus_from_player(_player):
	if (is_instance_valid(active_beacon)):
		active_beacon.destroy()
