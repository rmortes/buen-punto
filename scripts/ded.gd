extends Node3D

@export var level = 1

const kirbies = [
	preload("res://assets/sounds/kirby 1.wav"),
	preload("res://assets/sounds/kirby 2.wav"),
	preload("res://assets/sounds/kirby 3.wav"),
	preload("res://assets/sounds/kirby 4.wav"),
	preload("res://assets/sounds/kirby 5.wav"),
	preload("res://assets/sounds/kirby 6.wav"),
	preload("res://assets/sounds/kirby 7.wav"),
	preload("res://assets/sounds/kirby 8.wav"),
	preload("res://assets/sounds/kirby 9.wav"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelData.level = level


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.die()
		var kirbI = randi_range(0, len(kirbies)-1)
		var kirbo = kirbies[kirbI]
		SoundManager.play_sound(kirbo, "Voice")
