extends StaticBody3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var actual_level = LevelData.level


func _on_area_3d_body_entered(player):
	LevelData.level += 1
	#var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	var scene_path = "res://scenes/results.tscn"
	#var game_scene = load(scene_path).instantiate()
	#get_tree().root.add_child(game_scene)
	get_parent().get_node("FadeIn").start_fade_out(scene_path)
	#get_parent().queue_free()
	#me falta petar la escena anterior pa que no pasen cosas feas
