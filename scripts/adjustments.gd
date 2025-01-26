extends Control
@onready var controles = $TextureRect/Controles
@onready var texture_button = $TextureRect/Controles/TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_pressed():
	var scene_path = "res://scenes/main_menu.tscn"
	var game_scene = load(scene_path).instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()


func _on_controles_button_pressed():
	controles.show()
	texture_button.grab_focus()
