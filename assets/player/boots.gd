extends Timer

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

@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"

func easingFunction(x: float) -> float: 
	var c1 = 1.70158;
	var c3 = c1 + 1;

	return 1 - (1 - x) * (1 - x)


func _process(delta: float) -> void:
	var speed := character_body_3d.velocity.length() / 15
	var interval : float = lerp(4, 1, speed) / 4
	wait_time = easingFunction(interval) / 2

func _on_timeout() -> void:
	if (Input.is_action_pressed("ui_up")
		or Input.is_action_pressed("ui_down")
		or Input.is_action_pressed("ui_left")
		or Input.is_action_pressed("ui_right")
		) and character_body_3d.is_on_floor():
		var step = randi_range(0, len(steps)-1)
		SoundManager.play_sound(steps[step])
