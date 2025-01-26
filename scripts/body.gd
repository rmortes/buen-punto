extends CharacterBody3D
@onready var oxygen_timer = $OxygenTimer

const ASTRO_NUTS_RAGDOLL = preload("res://assets/models/astro_nuts_ragdoll.tscn")
var ragdoll_instance: RigidBody3D

@export var acceleration: float = 15.0
@export var friction: float = 2.0
@export var terminal_speed: float = 15.0
@export var minimum_speed: float = 4.0
@export var time_to_terminal: float = 3.0
@export var jump_velocity = 4.5
@export var jump_gravity_reducer := .5


var coyote_time : float = 0.5
var coyote_timer : float = 0.0

var landing_camera_tilt: float = deg_to_rad(-10)  # Ángulo de inclinación al aterrizar
var tilt_speed: float = 2.0  # Velocidad de interpolación
var camera_original_rotation: float = 0.0
var is_tilting: bool = false
var target_camera_tilt: float = 0.0
@onready var camera: Camera3D = %Camera

var landing : bool = false

var time_accelerating = 0;
var prev_speed;

# TODO: Esto lo podemos poner en las settings cuando hayan
var mouse_sensitivity = 0.002


const shouts = [
	[preload("res://assets/sounds/1 zasranets.mp3"), "Засранец", "¡Espero que tu intenstino funcione correctamente!"],
	[preload("res://assets/sounds/2 idi v banyu.mp3"), "Иди в баню!", "¡Te mereces un descanso!"],
	[preload("res://assets/sounds/3 Idi na hui.mp3"), "Иди на хуй", "¡Ve a recoger flores!"],
	[preload("res://assets/sounds/4 kozyol.mp3"), "Козёл", "¡Majete!"],
	[preload("res://assets/sounds/5 mudak.mp3"), "Мудак", "¡Burbujas!"],
	[preload("res://assets/sounds/7 svolotsch.mp3"), "Сволочь", "¡Qué pillastre!"],
	[preload("res://assets/sounds/8 hui s gory.mp3"), "Хуй с горы", "¡Es un complicado sistema de poleas!"],
];

func die() -> void:
	if ragdoll_instance == null:
		$CollisionShape3D.disabled = true
		ragdoll_instance = ASTRO_NUTS_RAGDOLL.instantiate()
		ragdoll_instance.global_position = global_position
		get_tree().root.add_child(ragdoll_instance)
		for c in ragdoll_instance.get_child(0).get_child(0).get_children():
			if c is PhysicalBone3D:
				c.apply_central_impulse(velocity)


func _physics_process(delta: float) -> void:
	# if is ded
	if ragdoll_instance != null:
		velocity = Vector3.ZERO
		Engine.time_scale = 0.5
		if (
			Input.is_action_just_pressed("ui_left")
			or Input.is_action_just_pressed("ui_right")
			or Input.is_action_just_pressed("ui_up")
			or Input.is_action_just_pressed("ui_down")
			or Input.is_action_just_pressed("jump")
			or Input.is_action_just_pressed("ui_accept")
			or Input.is_action_just_pressed("quit")):
			var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
			var game_scene = load(scene_path).instantiate()
			get_tree().root.add_child(game_scene)
			get_parent().queue_free()
		# look_at(ragdoll_instance.global_position)
		# camera.look_at(ragdoll_instance.global_position)
		
	#Coyote jump checkout
	if is_on_floor():
		coyote_timer = coyote_time
		if landing:
			landing = false
			_tilt_camera_on_landing()
	else:
		coyote_timer = max(0, coyote_timer - delta)
	
	if is_tilting:
		tilt_camera(delta)
	
	
	# Add the gravity.
	if not is_on_floor():
		print(Input.is_action_pressed("jump"))
		velocity += get_gravity() * delta * (jump_gravity_reducer if Input.is_action_pressed("jump") else 1)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and coyote_timer > 0:
		velocity.y = jump_velocity
		landing = true
		coyote_timer = 0
	
	# Handle jump (con mando de PS5)
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("jump"):
		if coyote_timer > 0:
			velocity.y = jump_velocity
		landing = true
		coyote_timer = 0
		
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
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

	if direction:
		velocity.x = lerp(velocity.x, direction.x * max(current_acceleration, minimum_speed), delta * acceleration)
		velocity.z = lerp(velocity.z, direction.z * max(current_acceleration, minimum_speed), delta * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * friction * acceleration)
		velocity.z = move_toward(velocity.z, 0, delta * friction * acceleration)

	move_and_slide()
		

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Engine.time_scale = 1

# TODO: Esto sabe Dios que no funciona con mando
func _input(event):
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

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
		camera.rotate_x(-yAxis * delta * JOY_ROTATION_MULTIPLIER/2)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	if prev_speed and prev_speed - velocity.length() > 10:
		var shoutI = randi_range(0, len(shouts)-1)
		var shout = shouts[shoutI]
		SoundManager.play_sound(shout[0], "Voice").finished.connect(func(): $Camera/CanvasLayer/Subtitulos.text = '')
		$Camera/CanvasLayer/Subtitulos.text = shout[1] + '\n' + shout[2]
	prev_speed = velocity.length()
	
func _tilt_camera_on_landing():
	if _is_any_movement_action_pressed():
		return
	
	is_tilting = true
	camera_original_rotation = camera.rotation.x  # Guarda la rotación inicial de la cámara
	target_camera_tilt = camera_original_rotation + landing_camera_tilt  # Define el objetivo de inclinación
	
	# Usa un Timer para regresar la cámara a su posición original
	var timer = Timer.new()
	timer.wait_time = 0.2  # Tiempo para mantener la inclinación
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_reset_camera_tilt"))
	timer.start()

func tilt_camera(delta : float) -> void:
	camera.rotation.x = lerp(camera.rotation.x, target_camera_tilt, tilt_speed * delta)

func _reset_camera_tilt():
	target_camera_tilt = camera_original_rotation  # Define el objetivo como la rotación original
	var timer = Timer.new()
	timer.wait_time = 0.2  # Tiempo para mantener la inclinación
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_stop_camera_tilt"))
	timer.start()
	
	
func _stop_camera_tilt():
	is_tilting = false  # Permite que el movimiento termine

func _is_any_movement_action_pressed() -> bool:
	if velocity.x != 0.0 or velocity.z != 0.0:
		return true
	
	return false
