extends Node

@export var looker: Node3D;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var players := get_tree().get_nodes_in_group("player")
	if not len(players): return
	var player = players[0]
	if player == null: return
	var camera = player.find_child("Camera")
	if camera == null: return
	looker.look_at(camera.global_position, Vector3.UP, true)
