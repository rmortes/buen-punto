extends StaticBody3D

var time : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var actual_level = LevelData.level


func _on_area_3d_body_entered(player):
	LevelData.level += 1
	LevelData.level_time = time
	var scene_path = "res://scenes/results.tscn"
	get_parent().get_node("FadeIn").start_fade_out(scene_path)
	$"camapana2/puerta-camapana2/AnimationPlayer".play_backwards()

func _on_timer_timeout():
	time += 1
