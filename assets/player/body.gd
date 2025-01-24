extends CharacterBody3D


@export var acceleration: float = 2.0
@export var terminal_speed: float = 15.0
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
		time_accelerating = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_acceleration = min(terminal_speed, terminal_speed ** (time_accelerating / time_to_terminal))

	if direction:
		velocity.x = direction.x * current_acceleration
		velocity.z = direction.z * current_acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, current_acceleration)
		velocity.z = move_toward(velocity.z, 0, current_acceleration)

	move_and_slide()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# TODO: Esto sabe Dios que no funciona con mando
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
