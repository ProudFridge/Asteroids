extends RigidBody2D
class_name Asteroid

const SPEED: float = 300.0
var health: float = 100
var density: float = 0.001
@export var rotationSpeed: float = 1

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon
@onready var polygon_2d: Polygon2D = $Polygon2D

var polygon: PackedVector2Array = []
var boundingBox: Vector2 = Vector2(60,60)
var center: Vector2 = Vector2.ZERO
var hasShattered: bool = false

signal died

func _ready() -> void:
	polygon = generate_convex_polygon(randi_range(5, 80), boundingBox)
	center = get_center()
	collision_polygon.polygon = polygon
	polygon_2d.polygon = polygon
	mass = compute_area(polygon) * density
	
	var triangles: Array[Polygon2D] = shatter(false)
	
	for t: Polygon2D in triangles:
		add_child(t)
	
	
func _draw() -> void:
	# TODO: come back, polygon is supposed to fit inside the bounding box
	draw_rect(Rect2(Vector2.ZERO, boundingBox), Color.WHITE, false, 5)
	pass


# TODO: maybe replace with a component and create a die() function
func take_damage(damage: float) -> void:
	health = health - damage
	if health <= 0 && !hasShattered:
		shatter(true)
		hasShattered = true
		died.emit()
		queue_free()
	modulate = Color.RED


func get_center() -> Vector2:
	var center: Vector2 = Vector2.ZERO
	for v: Vector2 in polygon:
		center += v
	center /= polygon.size()
	return center


## Shatters the polygon into multiple triangles
func shatter(instanceShards: bool = true, shatterVelocityMultiplier: Vector2 = Vector2(1,1)) -> Array[Polygon2D]:
	var delaunay: PackedInt32Array = Geometry2D.triangulate_delaunay(polygon)
	var triangles: Array[Polygon2D] = []
	
	if !delaunay.is_empty():
		for i: int in range(0, delaunay.size(), 3):
			var triangle: Polygon2D = Polygon2D.new()
			triangle.polygon = PackedVector2Array([polygon[delaunay[i]], polygon[delaunay[i + 1]], polygon[delaunay[i + 2]]])
			triangle.color = Color.from_hsv(0, 0, randf_range(0.2, 0.4), 1)
			triangles.append(triangle)
	
	# Instance all shards	
	if instanceShards:
		var asteroidShard: Resource = preload("res://scenes/asteroid_shard/asteroid_shard.tscn")
		for t: Polygon2D in triangles:
			var shardInstance: AsteroidShard = asteroidShard.instantiate()
			#shardInstance.set_polygon(rotate_polygon(t.polygon))
			shardInstance.set_polygon(t.polygon)
			
			# Find center
			var shardCenter: Vector2 = Vector2.ZERO
			for p: Vector2 in t.polygon:
				shardCenter += p
			shardCenter /= t.polygon.size()
			
			shardInstance.position = shardCenter + position
			shardInstance.linear_velocity = shatterVelocityMultiplier * (shardCenter - center)
			
			#get_tree().root.add_child(shardInstance)
			get_parent().add_child(shardInstance)
		
	return triangles


## Generates a convex polygon with n vertices
## taken from https://web.archive.org/web/20260416133431/https://cglab.ca/~sander/misc/ConvexGeneration/convex.html
func generate_convex_polygon(n: int, boundingBox: Vector2) -> PackedVector2Array:
	boundingBox = boundingBox
	
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
	
	# Center the polygon around (0,0)
	var c: Vector2 = Vector2.ZERO
	for v: Vector2 in points:
		c += v
	c = c / points.size()
	
	for i: int in range(points.size()):
		points[i] -= c
		
	return points

## Computes the area of a polygon with the coordinates of its vertices
func compute_area(polygon: PackedVector2Array) -> float:
	var totalSum: float = 0
	for i: int in polygon.size():
		if i != polygon.size() - 1:
			totalSum += polygon[i].x * polygon[i + 1].y - polygon[i].y * polygon[i + 1].x
		else:
			totalSum += polygon[i].x * polygon[0].y - polygon[i].y * polygon[0].x
	
	return abs(totalSum / 2)


func sort_by_angle(a: Vector2, b: Vector2) -> bool:
	if a.angle() < b.angle():
		return true
	return false


func rotate_polygon(polygon: PackedVector2Array) -> PackedVector2Array:
	var rotatedPoints: PackedVector2Array = []
	for v: Vector2 in rotatedPoints:
		rotatedPoints.append(v.rotated(rotation)) 
	return rotatedPoints
