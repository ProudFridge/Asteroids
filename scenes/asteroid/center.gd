extends Node2D

@onready var asteroid: Asteroid = $".."

func _draw() -> void:
	# Draw the center
	draw_ellipse(asteroid.center, 5, 5, Color.WHITE, true)
