extends Control
@onready var fade_in = $FadeIn


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_2_pressed():
	var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
	fade_in.start_fade_out(scene_path)
