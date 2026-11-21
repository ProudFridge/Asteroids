extends Node2D

@export var hull_size: Vector2 = Vector2(32, 16)

@onready var hull: Sprite2D = $Hull

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hull.texture.width = hull_size.x
	hull.texture.height = hull_size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
