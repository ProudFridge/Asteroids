extends Polygon2D
class_name Star

var size: float = 100
@export_range(0, 1)
var cornerRatio: float = 0.5 # Value between 0 and 1
var starVertices: int = 6

func _ready() -> void:
	var shape: PackedVector2Array = []
	
	var angleDifference: float = 2 * PI / starVertices
	var totalAngle: float = 0
	
	for i: int in starVertices:
		shape.append(Vector2(cos(totalAngle), sin(totalAngle)) * size)
		shape.append(Vector2(cos(totalAngle + angleDifference / 2), sin(totalAngle + angleDifference / 2)) * size * cornerRatio)
		totalAngle += angleDifference

	polygon = shape
