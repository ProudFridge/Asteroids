extends Node2D

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Global.windowSize), Color.WHITE_SMOKE, false)
