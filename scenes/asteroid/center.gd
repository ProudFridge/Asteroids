extends Node2D


@onready var asteroid: Asteroid = $".."

func _draw() -> void:
	draw_ellipse(asteroid.center, 2, 2, Color.WHITE)
