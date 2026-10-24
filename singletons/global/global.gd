## Singleton that contains useful info
extends Node

var windowSize: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#windowSize = Vector2(get_window().size)
	windowSize = Vector2(5000, 5000)
