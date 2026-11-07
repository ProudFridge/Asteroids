extends RigidBody2D
class_name Asteroid

const SPEED: float = 300.0
var health: float = 100:
	set(new_health):
		health = max(new_health, 0)
		
var maxHealth: float = health
var density: float = 0.001
@export var rotationSpeed: float = 1

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon
@onready var polygon_2d: Polygon2D = $Polygon2D

var polygon: PackedVector2Array = []
var boundingBox: Vector2 = Vector2(60, 60)
var center: Vector2 = Vector2.ZERO
var hasShattered: bool = false

signal died

func _ready() -> void:
	var multiplier: float = 1
	var rand: float = randf_range(0, 1)
	if rand < 0.2:
		multiplier = 3
	elif rand >= 0.2 && rand < 0.3 :
		multiplier = 6
	
	polygon = generate_convex_polygon(randi_range(5, 8), boundingBox * multiplier)
	center = get_center()
	collision_polygon.polygon = polygon
	polygon_2d.polygon = polygon
	var area: float = compute_area(polygon)
	mass = area * density
	health = area / 100
	maxHealth = health
	
	var triangles: Array[Polygon2D] = shatter(false)
	
	for t: Polygon2D in triangles:
		add_child(t)
	
func _draw() -> void:	
	# Draw the bounds
	draw_rect(Rect2(-boundingBox / 2, boundingBox), Color.WHITE, false)


# TODO: maybe replace with a component and create a die() function
func take_damage(damage: float) -> void:
	health = health - damage
	if health <= 0:
		die()
	modulate = Color.from_hsv(0, 0, lerpf(0.2, 1, health / maxHealth))


func die() -> void: 
	if !hasShattered:
		shatter(true)
		hasShattered = true
		died.emit()
		queue_free()

func get_center() -> Vector2:
	var p_center: Vector2 = Vector2.ZERO
	for v: Vector2 in polygon:
		p_center += v
	p_center /= polygon.size()
	return p_center

#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
	#
	#if collision:
		#var body: Node = collision.get_collider()
		#if body is Asteroid:
			#AudioSingleton.playSound("res://assets/sounds/shoot/laserShoot1.wav", collision.get_position())
	

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
	self.boundingBox = boundingBox
	
	# Generate two lists of n random integers
	var x_coords: Array[float] = []
	var y_coords: Array[float] = []
	
	for i: int in n:
		x_coords.append(randf_range(0, boundingBox.x))
		y_coords.append(randf_range(0, boundingBox.y))
	
	# Sort the two lists
	x_coords.sort()
	y_coords.sort()
	
	# Isolate the extreme points
	var min_x: float = x_coords[0]
	var max_x: float = x_coords[n - 1]
	var min_y: float = y_coords[0]
	var max_y: float = y_coords[n - 1]
	
	# Divide the interior points into two chains & Extract the vector components
	var x_vec: Array[float] = []
	var y_vec: Array[float] = []
	
	var last_top: float = min_x
	var last_bot: float = min_x
	
	for i: int in range(1, n - 1):
		var x: float = x_coords[i]
		
		if randi() % 2 == 0:
			x_vec.append(x - last_top)
			last_top = x
		else:
			x_vec.append(last_bot - x)
			last_bot = x
		
	x_vec.append(max_x - last_top)
	x_vec.append(last_bot - max_x)
	
	var last_left: float = min_y
	var last_right: float = min_y
	
	for i: int in range(1, n - 1):
		var y: float = y_coords[i]
		
		if randi() % 2 == 0:
			y_vec.append(y - last_left)
			last_left = y
		else:
			y_vec.append(last_right - y)
			last_right = y
	
	y_vec.append(max_y - last_left)
	y_vec.append(last_right - max_y)

	# Randomly pair up the x and y components
	y_vec.shuffle()
	
	var vec: Array[Vector2] = []
	
	for i: int in n:
		vec.append(Vector2(x_vec[i], y_vec[i]))
		
	vec.sort_custom(sort_by_angle)
	
	# Lay the points end to end and move the polygon to its original min and max coordinates
	var vec_pointer: Vector2 = Vector2.ZERO 
	var min_polygon: Vector2 = Vector2.ZERO
	var points: PackedVector2Array = []
	for i: int in n:
		points.append(vec_pointer)
		vec_pointer += Vector2(vec[i])
		min_polygon.x = min(min_polygon.x, vec_pointer.x)
		min_polygon.y = min(min_polygon.y, vec_pointer.y)
	
	var shift_x: float = min_x - min_polygon.x
	var shift_y: float = min_y - min_polygon.y
	
	for i: int in n:
		var p: Vector2 = points[i]
		points[i] = Vector2(p.x + shift_x, p.y + shift_y)
	
	## Center the polygon around (0,0)
	var c: Vector2 = Vector2.ZERO
	for v: Vector2 in points:
		c += v
	c = c / points.size()
	
	for i: int in n:
		points[i] -= c
		
	return points


## Computes the area of a polygon with the coordinates of its vertices
func compute_area(poly: PackedVector2Array) -> float:
	var totalSum: float = 0
	for i: int in poly.size():
		if i != poly.size() - 1:
			totalSum += poly[i].x * poly[i + 1].y - poly[i].y * poly[i + 1].x
		else:
			totalSum += poly[i].x * poly[0].y - poly[i].y * poly[0].x
	
	return abs(totalSum / 2)


func sort_by_angle(a: Vector2, b: Vector2) -> bool:
	if a.angle() < b.angle():
		return true
	return false


func rotate_polygon(poly: PackedVector2Array) -> PackedVector2Array:
	var rotatedPoints: PackedVector2Array = []
	for v: Vector2 in poly:
		rotatedPoints.append(v.rotated(rotation)) 
	return rotatedPoints
