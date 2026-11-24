extends Node2D
class_name MatterComponent

@export var player: Player

var max_matter: float = 500
 
var current_matter: float = max_matter:
	set(new_value):
		current_matter = max(0, new_value)
