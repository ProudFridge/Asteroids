extends Node2D

@export var camera: Camera2D
var size: Vector2 = Vector2(1024, 1024)
var star_positions: Array[Vector2] = []
var star_amount: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i: int in star_amount:
		var random_position: Vector2 = Vector2(randf_range(0, size.x), randf_range(0, size.y))
		star_positions.append(random_position)

func _draw() -> void:
	for position: Vector2 in star_positions:
		draw_circle(position / camera.zoom, 1, Color.WHITE)
