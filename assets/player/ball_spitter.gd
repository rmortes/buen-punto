extends Node
class_name BallSpitter

const PHANTOM_BALL = preload("res://components/grav_ball/phantom_ball.tscn")
const GRAV_BALL = preload("res://components/grav_ball/grav_ball.tscn")
@onready var camera_3d: Camera3D = %Camera

var currentPhantomBall: Node3D;

@export var ammo := 0

@export var placement_distance := 4.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ammo <= 0: return
	
	if Input.is_action_just_pressed("game_ball"):
		currentPhantomBall = PHANTOM_BALL.instantiate()
		call_deferred("add_child",currentPhantomBall)
	if Input.is_action_pressed("game_ball") and currentPhantomBall != null:
		var camera_vector := camera_3d.get_global_transform().basis.z
		var ball_position := camera_3d.global_position - camera_vector * placement_distance
		currentPhantomBall.position = ball_position
	if Input.is_action_just_released("game_ball") and currentPhantomBall != null:
		ammo -= 1
		var new_ball = GRAV_BALL.instantiate()
		new_ball.global_position = currentPhantomBall.global_position
		currentPhantomBall.queue_free()
		currentPhantomBall = null
		call_deferred("add_child",new_ball)
