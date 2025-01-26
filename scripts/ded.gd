extends Node3D

@export var level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelData.level = level


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_area_3d_body_entered(body):
	var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	var game_scene = load(scene_path).instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()

	
