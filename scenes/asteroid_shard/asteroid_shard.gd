extends RigidBody2D
class_name AsteroidShard

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var lifetime_timer: Timer = $LifetimeTimer
var polygon: PackedVector2Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = scale_points(1)
	polygon_2d.color = Color.GRAY * Color(1,1,1,0.5)
	collision_polygon_2d.polygon = polygon_2d.polygon
	lifetime_timer.start()
	lifetime_timer.timeout.connect(_on_lifetimer_timer_timeout)


func _process(delta: float) -> void:
	polygon_2d.color.a = remap(lifetime_timer.time_left,0, lifetime_timer.wait_time, 0,1)


func scale_points(scale: float) -> PackedVector2Array:
	var scaledPolygon: PackedVector2Array = []
	
	for i: int in range(polygon.size()):
		scaledPolygon.append(polygon[i] * scale)
		
	return scaledPolygon


func set_polygon(points: PackedVector2Array) -> void:
	polygon = points


func _on_lifetimer_timer_timeout() -> void:
	queue_free()
