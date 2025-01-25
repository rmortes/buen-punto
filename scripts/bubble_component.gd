extends Node3D

var bubble_time_increase : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_destroy():
	self.queue_free()

	
func _on_area_3d_body_entered(player):
	var new_time = bubble_time_increase + player.oxygen_timer.time_left
	player.oxygen_timer.start(new_time)
	_on_destroy()
