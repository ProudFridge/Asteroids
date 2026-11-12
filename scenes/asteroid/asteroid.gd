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
	boundingBox *= multiplier
	
	
	polygon = Geometry.generate_convex_polygon(randi_range(5, 8), boundingBox)
	center = get_center()
	collision_polygon.polygon = polygon
	polygon = Geometry.populate_with_random_points(polygon)
	var area: float = Geometry.compute_area(polygon)
	mass = area * density
	health = area / 100
	maxHealth = health
	
	var triangles: Array[Polygon2D] = shatter(false)
	
	for t: Polygon2D in triangles:
		add_child(t)
	
func _draw() -> void:
	 #Draw the bounds
	draw_rect(Rect2(-boundingBox / 2, boundingBox), Color.WHITE, false)
	
	for v: Vector2 in polygon:
		draw_ellipse(v, 2, 2, Color.ALICE_BLUE)


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


func rotate_polygon(poly: PackedVector2Array) -> PackedVector2Array:
	var rotatedPoints: PackedVector2Array = []
	for v: Vector2 in poly:
		rotatedPoints.append(v.rotated(rotation)) 
	return rotatedPoints
