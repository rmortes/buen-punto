extends StaticBody3D

@export var unkillable := false

@onready var field_hint: MeshInstance3D = $FieldHint
const ACTIVAR_BOTAS = preload("res://assets/sounds/activar_botas.wav")
const DESACTIVAR_BOTAS = preload("res://assets/sounds/desactivar_botas.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_sound(ACTIVAR_BOTAS)
	(Anima.Node(field_hint)
		.anima_scale3D(Vector3.ONE, 0.3)
		.anima_from(Vector3.ZERO)
		.anima_easing(ANIMA.EASING.EASE_IN_OUT)
		.play())

func kys() -> void:
	if unkillable:
		# then don't
		return
	SoundManager.play_sound(DESACTIVAR_BOTAS)
	var size_animation := (Anima.Node(field_hint)
		.anima_scale3D(Vector3.ZERO, 0.3)
		.anima_from(Vector3.ONE)
		.anima_easing(ANIMA.EASING.EASE_IN_OUT))
	size_animation.play().animation_completed.connect(
		func(): queue_free())
