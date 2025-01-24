extends CharacterBody3D


@export var acceleration: float = 15.0
@export var friction: float = 6.0
@export var terminal_speed: float = 15.0
@export var minimum_speed: float = 4.0
@export var time_to_terminal: float = 3.0
@export var jump_velocity = 4.5

var time_accelerating = 0;

# TODO: Esto lo podemos poner en las settings cuando hayan
var mouse_sensitivity = 0.002


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_pressed("ui_up"):
		time_accelerating = min(time_accelerating + delta, time_to_terminal)
	else:
		time_accelerating = max(time_accelerating - delta * friction, 0)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# var current_acceleration = min(terminal_speed, acceleration ** (time_accelerating / time_to_terminal))
	var current_acceleration = min(terminal_speed, acceleration - (time_to_terminal / ((time_to_terminal / acceleration)+time_accelerating)))
	print(current_acceleration)

	if direction:
		velocity.x = direction.x * max(current_acceleration, minimum_speed)
		velocity.z = direction.z *  max(current_acceleration, minimum_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, 1/current_acceleration)
		velocity.z = move_toward(velocity.z, 0, 1/current_acceleration)

	move_and_slide()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# TODO: Esto sabe Dios que no funciona con mando
func _input(event):
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

const JOY_DEADZONE = 0.2
const JOY_AXIS_RESCALE = 1.0/(1.0-JOY_DEADZONE)
const JOY_ROTATION_MULTIPLIER = 200.0 * PI / 180.0

func _process(delta: float):
	if Input.get_connected_joypads().size() == 0:
		return
		
	var xAxis = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	if abs(xAxis) > JOY_DEADZONE:
		if xAxis >0:
			xAxis = (xAxis-JOY_DEADZONE) * JOY_AXIS_RESCALE
		else:
			xAxis = (xAxis+JOY_DEADZONE) * JOY_AXIS_RESCALE
		
		rotate_y(-xAxis * delta * JOY_ROTATION_MULTIPLIER)
		
	var yAxis = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	if abs(yAxis) > JOY_DEADZONE:
		if yAxis >0:
			yAxis = (yAxis-JOY_DEADZONE) * JOY_AXIS_RESCALE
		else:
			yAxis = (yAxis+JOY_DEADZONE) * JOY_AXIS_RESCALE
		$Camera3D.rotate_x(-yAxis * delta * JOY_ROTATION_MULTIPLIER/2)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
