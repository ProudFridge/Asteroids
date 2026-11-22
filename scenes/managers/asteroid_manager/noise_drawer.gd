extends Node2D

@onready var asteroid_manager: AsteroidManager = $".."
var chunk_size: float = 256
var seperation: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#func _draw() -> void:
	#for i: int in 100:
		#for j: int in 100:
			#var noise_value: float = asteroid_manager.world_noise_map.get_noise_2d(i, j)
			#draw_rect(Rect2(Vector2(i* 256, j * 256), Vector2(chunk_size - seperation, chunk_size - seperation)), Color.WHITE, false)
			#draw_rect(Rect2(Vector2(i* 256, j * 256), Vector2(chunk_size, chunk_size)), Color.from_hsv(0, 0, 1 - pow(noise_value, 2) * 100), true)
			#draw_circle(Vector2(i * 256, j * 256), pow(noise_value, 2) * 100, Color.WHITE, true)
