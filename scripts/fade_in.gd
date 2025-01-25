extends ColorRect

@export var fade_duration: float = 2.0  # Duración del fade (en segundos)
var fade_timer: float = 0.0  # Temporizador para el fade
var fade := false
var scene_path := ""

func _ready():
	modulate.a = 0.0  # Comienza completamente transparente

func _process(delta):
	if fade:
		if fade_timer < fade_duration:
			# Incrementa el temporizador
			fade_timer += delta
			
			# Calcula la opacidad proporcional al tiempo transcurrido
			modulate.a = fade_timer / fade_duration
			
			# Asegúrate de que no supere 1.0
			modulate.a = clamp(modulate.a, 0.0, 1.0)
		
		else:
			level_transition()
			

func start_fade_out(level_path : String):
	print("INICIANDO TRANSICION")
	scene_path = level_path
	self.show()
	fade = true

func level_transition():
	var game_scene = load(scene_path).instantiate()
	get_tree().root.add_child(game_scene)
	get_parent().queue_free()
