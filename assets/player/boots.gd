extends Node

# The audios commented are not needed
const steps = [
	preload("res://assets/paso-01.mp3"),
	preload("res://assets/paso-03.mp3"),
	preload("res://assets/paso-02.mp3"),
	#preload("res://assets/paso-04.mp3"),
	preload("res://assets/paso-05.mp3"),
	preload("res://assets/paso-06.mp3"),
	#preload("res://assets/paso-07.mp3"),
	#preload("res://assets/paso-08.mp3"),
	#preload("res://assets/paso-09.mp3"),
	#preload("res://assets/paso-10.mp3"),
	#preload("res://assets/paso-11.mp3"),
];

func _on_timeout() -> void:
	if (Input.is_action_pressed("ui_up")
		or Input.is_action_pressed("ui_down")
		or Input.is_action_pressed("ui_left")
		or Input.is_action_pressed("ui_right")
		):
		var step = randi_range(0, len(steps)-1)
		SoundManager.play_sound(steps[step])
