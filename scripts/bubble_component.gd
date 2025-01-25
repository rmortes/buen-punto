extends Node3D

var bubble_time_increase : float = 5.0
const pops = [
	preload("res://assets/sounds/bubble-1.mp3"),
	preload("res://assets/sounds/bubble-2.mp3"),
	preload("res://assets/sounds/bubble-3.mp3"),
	preload("res://assets/sounds/bubble-4.mp3"),
	preload("res://assets/sounds/bubble-5.mp3"),
];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_destroy():
	# self.queue_free()
	var popI = randi_range(0, len(pops)-1)
	SoundManager.play_sound(pops[popI]).volume_db = 24
		
	var animation := (Anima.Node(self)
		.anima_scale3D(Vector3.ONE * 3, .075)
		.anima_easing(ANIMA.EASING.EASE_OUT)
		.play())
		
	animation.animation_completed.connect(func(): queue_free())

	
func _on_area_3d_body_entered(player: Node3D):
	if player.is_in_group("player"):
		var new_time = bubble_time_increase + player.oxygen_timer.time_left
		player.oxygen_timer.start(new_time)
		_on_destroy()
