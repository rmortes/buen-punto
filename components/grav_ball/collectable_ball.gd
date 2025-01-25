extends Node3D

@onready var BOOL: Node3D = $BOOL
const TOUCHDOWN = preload("res://assets/sounds/touchdown.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(Anima.Node(BOOL)
		# relative movement not working but game jam haha
		.anima_position_y(global_position.y+.3, 2)
		.anima_from(global_position.y-.3)
		.anima_easing(ANIMA.EASING.EASE_IN_OUT)
		.loop_in_circle())


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("ball")
	var players := get_tree().get_nodes_in_group("player")
	if not len(players): return
	var player = players[0]
	if player == null: return
	var spitter: BallSpitter = player.find_child("BallSpitter")
	if spitter == null: return
	SoundManager.play_sound(TOUCHDOWN)
	spitter.ammo += 1
	queue_free()
