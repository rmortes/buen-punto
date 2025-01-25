extends ColorRect

@export var fade_duration: float = 2.0  # Duración del fade (en segundos)
var fade_timer: float = 0.0  # Temporizador para el fade

func _ready():
	modulate.a = 1.0  # Comienza completamente transparente

func _process(delta):
	if fade_timer < fade_duration:
		# Incrementa el temporizador
		fade_timer += delta
		
		# Calcula la opacidad proporcional al tiempo transcurrido
		modulate.a = 1.0 - (fade_timer / fade_duration)
		
		# Asegúrate de que no supere 1.0
		modulate.a = clamp(modulate.a, 0.0, 1.0)
	
	else:
		queue_free()
