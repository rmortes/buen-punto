extends StaticBody3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var actual_level = LevelData.level
	prints("El nivel actual es: ", actual_level)


func _on_area_3d_body_entered(player):
	print("estoy a otro puto nivel, tontitos")
	#LevelData.level += 1
	#var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	#var game_scene = load(scene_path).instantiate()
	#get_parent().add_child(game_scene)
	#me falta petar la escena anterior pa que no pasen cosas feas
