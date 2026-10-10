## Singleton that contains useful info
extends Node

var ViewPortSize: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().get_visible_rect().size
