@tool
extends CharacterBody2D
class_name Asteroid

const SPEED: float = 300.0
@export var rotationSpeed: float = 1

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon
@onready var polygon_2d: Polygon2D = $Polygon2D

var polygon: PackedVector2Array = []

func _ready() -> void:
	polygon = generate_convex_polygon(10, Vector2(50,50))
	collision_polygon.polygon = polygon
	polygon_2d.polygon = polygon

func _physics_process(delta: float) -> void:
	#velocity = Vector2(100,100)
	rotation += rotationSpeed * delta
	move_and_slide()

func _draw() -> void:
	draw_polyline(polygon, Color.BLACK, 10)

## Generates a convex polygon with n vertices
## taken from https://web.archive.org/web/20260416133431/https://cglab.ca/~sander/misc/ConvexGeneration/convex.html
func generate_convex_polygon(n: int, boundingBox: Vector2) -> PackedVector2Array:
	# Generate two lists of n random integers
	var xCoords: Array[float] = []
	var yCoords: Array[float] = []
	
	for i: int in n:
		xCoords.append(randf_range(0, boundingBox.x))
		yCoords.append(randf_range(0, boundingBox.y))
	
	# Sort the two lists and store their maximum and minium element
	xCoords.sort()
	yCoords.sort()
	
	var maxX: float = xCoords[0]
	var minX: float = xCoords[xCoords.size() - 1]
	var maxY: float = yCoords[0]
	var minY: float = yCoords[yCoords.size() - 1]
	
	var x1: Array[float] = []
	var x2: Array[float] = []
	var y1: Array[float] = []
	var y2: Array[float] = []
	
	x1.append(minX)
	x2.append(minX)
	y1.append(minY)
	y2.append(minY)
	
	for i: int in range(1, xCoords.size()):
		var numX: float = xCoords[i]
		var numY: float = yCoords[i]
		
		if i % 2 == 0:
			x1.append(numX)
		else:
			x2.append(numX) 
		
		if i % 2 == 0:
			y1.append(numY)
		else:
			y2.append(numY)
	
	x1.append(maxX)
	x2.append(maxX)
	y1.append(maxY)
	y2.append(maxY)
	
	var XVec: Array[float] = []
	var YVec: Array[float] = []
	
	for i: int in range(0, x1.size() - 1):
		XVec.append(x1[i + 1] - x1[i])
		YVec.append(y1[i + 1] - y1[i])
	
	for i: int in range(0, x2.size() - 1):
		XVec.append(x2[i] - x2[i + 1])
		YVec.append(y2[i] - y2[i + 1])
	
	var vectors: Array[Vector2] = []
	YVec.shuffle()
	XVec.shuffle()

	for i: int in range(XVec.size()):
		vectors.append(Vector2(XVec[i], YVec[i]))	
	
	vectors.sort_custom(sort_by_angle)
	
	var nextPoint: Vector2 = vectors[0]
	var points: PackedVector2Array = []
	for i: int  in range(1, vectors.size()):
		points.append(nextPoint)
		nextPoint += vectors[i]
	
	# Shift points
	var smallestPointValues: Vector2 = Vector2(INF, INF)
	for v: Vector2 in points:
		if v.x < smallestPointValues.x:
			smallestPointValues.x = v.x
		if v.y < smallestPointValues.y:
			smallestPointValues.y = v.y
	
	for i: int in range(points.size()):
		points[i] -= smallestPointValues
		points[i] -= boundingBox / 2
		
	return points

func sort_by_angle(a: Vector2, b: Vector2) -> bool:
	if a.angle() < b.angle():
		return true
	return false
