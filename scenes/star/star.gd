extends Polygon2D
class_name Star

var size: float = 100
@export_range(0, 1)
var cornerRatio: float = 0.1 # Value between 0 and 1

func _ready() -> void:
	var shape: PackedVector2Array = []

	shape.append(Vector2(size, 0))
	shape.append(Vector2(size * cornerRatio, size * cornerRatio))

	shape.append(Vector2(0, size))
	shape.append(Vector2(-size * cornerRatio, size * cornerRatio))
	
	shape.append(Vector2(-size, 0))
	shape.append(Vector2(-size * cornerRatio, -size * cornerRatio))
	
	shape.append(Vector2(0, -size))
	shape.append(Vector2(size * cornerRatio, -size * cornerRatio))

	polygon = shape
