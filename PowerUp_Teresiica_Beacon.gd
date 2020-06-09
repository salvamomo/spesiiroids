extends Area2D


signal teresiica_beacon_created(beacon)
signal teresiica_beacon_destroyed(beacon)

# Called when the node enters the scene tree for the first time.
func _ready():
	var EnemyManager = get_tree().get_root().get_node("Main/EnemyManager")
	self.connect("teresiica_beacon_created", EnemyManager, "_on_Teresiica_Beacon_Created")
	self.connect("teresiica_beacon_destroyed", EnemyManager, "_on_Teresiica_Beacon_Destroyed")
	emit_signal("teresiica_beacon_created", self)

func destroy():
	emit_signal("teresiica_beacon_destroyed", self)
	queue_free()
