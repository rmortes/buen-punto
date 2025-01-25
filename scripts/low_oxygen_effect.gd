extends ColorRect
@onready var oxygen_timer = %OxygenTimer

@export var danger_threshold_start : float = 10.0
@export var last_moments_left : float = 5.0
@export var max_value : float = 3.0
@export var can_die := true;
@onready var player = $"../../../.."

const RESPIMAL_CRUNCHY = preload("res://assets/sounds/respimal crunchy.wav")
var has_groaned := false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_parameter("EffectStrength", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time_left = oxygen_timer.time_left - last_moments_left
	
	if oxygen_timer.time_left < last_moments_left:
		if not has_groaned:
			SoundManager.play_sound(RESPIMAL_CRUNCHY, "Voice").finished.connect(func(): $"../Subtitulos".text = '')
			$"../Subtitulos".text = "*chokes in Russian*"
			has_groaned = true
	else:
		has_groaned = false
		
	if time_left < danger_threshold_start and time_left > 0.0:
		var value = calculate_increment(time_left, danger_threshold_start, max_value)
		self.material.set_shader_parameter("EffectStrength", value if can_die else 0)
	if oxygen_timer.time_left < 0.1:
		var scene_path = LevelData.LEVEL_PATH + str(LevelData.level) + ".tscn"
		var game_scene = load(scene_path).instantiate()
		get_tree().root.add_child(game_scene)
		player.get_parent().queue_free()

func calculate_increment(time_left: float, time_start: float, max_value: float) -> float:
	# Calcula la proporción del tiempo restante
	var t = clamp(1.0 - (time_left / time_start), 0.0, 1.0)
	# Interpola el valor basado en la proporción
	return lerp(0.0, max_value, t)
