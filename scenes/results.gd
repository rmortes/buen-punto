extends Control
@onready var fade_in = $FadeIn
@onready var label_2 = $TextureRect/MarginContainer/VBoxContainer/Label2


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var minutes = LevelData.level_time / 60
	var seconds = LevelData.level_time % 60
	label_2.text = str(minutes) + ":" + str(seconds)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_2_pressed():
	var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	fade_in.start_fade_out(scene_path)


func _on_button_pressed():
	LevelData.level -= 1
	var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	fade_in.start_fade_out(scene_path)
