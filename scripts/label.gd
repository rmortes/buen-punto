extends Label
@onready var oxygen_timer = %OxygenTimer


# Called when the node enters the scene tree for the first time
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str( oxygen_timer.time_left )
