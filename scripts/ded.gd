extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	var game_scene = load(scene_path).instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()
