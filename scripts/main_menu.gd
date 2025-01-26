extends Control

@onready var fade_in = $FadeIn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	fade_in.start_fade_out(scene_path)


func _on_texture_button_3_pressed():
	get_tree().quit()
