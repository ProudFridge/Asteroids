extends RigidBody2D
class_name AsteroidShard

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
var polygon: PackedVector2Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = scale_points(0.5)
	collision_polygon_2d.polygon = polygon_2d.polygon


func scale_points(scale: float) -> PackedVector2Array:
	var scaledPolygon: PackedVector2Array = []
	
	for i: int in range(polygon.size()):
		scaledPolygon.append(polygon[i] * scale)
		
	return scaledPolygon

func set_polygon(points: PackedVector2Array) -> void:
	polygon = points
