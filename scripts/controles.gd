extends TextureRect
@onready var h_slider = $"../MarginContainer/VBoxContainer/HBoxContainer/HSlider"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	self.hide()
	h_slider.grab_focus()
