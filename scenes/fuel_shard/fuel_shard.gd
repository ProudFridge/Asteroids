extends RigidBody2D
class_name FuelShard

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D

var fuel_content: float = 0
var polygon: PackedVector2Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = Geometry.generate_convex_polygon(5, Vector2(20, 20))
	polygon_2d.polygon = polygon
	collision_polygon_2d.polygon = polygon
	polygon_2d.color = Color.AQUA
