extends Button
class_name PolygonButton

var polygonData: PackedVector2Array = []

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#polygonData.append(Vector2(0,0))
	#polygonData.append(Vector2(100,0))
	#polygonData.append(Vector2(100,100))
	#polygonData.append(Vector2(0,100))
#
#func _draw() -> void:
	#draw_colored_polygon(polygonData, Color.WHITE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
### distanceToVanishingPoint: distance from the center of the rectangle to the vanishing point
#func create_perspective_rectangle(distanceToVanishingPoint: Vector2, rectSize: Vector2) -> PackedVector2Array:
	#var rectangle: PackedVector2Array = []
	#
	
