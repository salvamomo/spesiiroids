extends Area2D

class_name PowerUp_Teresiica_Beacon

signal teresiica_beacon_created(beacon)
signal teresiica_beacon_destroyed(beacon)

var EnemyManager: EnemyManager

# Called when the node enters the scene tree for the first time.
func _ready():
	EnemyManager = get_tree().get_root().get_node("Main/EnemyManager")
	# warning-ignore:return_value_discarded
	self.connect("teresiica_beacon_created", EnemyManager, "_on_Teresiica_Beacon_Created")
	# warning-ignore:return_value_discarded
	self.connect("teresiica_beacon_destroyed", EnemyManager, "_on_Teresiica_Beacon_Destroyed")
	emit_signal("teresiica_beacon_created", self)

func destroy():
	emit_signal("teresiica_beacon_destroyed", self)
	queue_free()
