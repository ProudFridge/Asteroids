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

var generated_polygon: PackedVector2Array = []
var closed_polygon: PackedVector2Array = []
var populated_polygon: PackedVector2Array = []

var boundingBox: Vector2 = Vector2(60, 60)
var center: Vector2 = Vector2.ZERO
var hasShattered: bool = false

@export_group("Debug Options")
@export var is_outline_visible: bool = false
@export var is_bounding_box_visible: bool = false
@export var is_polygon_points_visible: bool = false
@export_group("")

signal died

func _ready() -> void:
	closed_polygon = Geometry2D.convex_hull(generated_polygon)
	
	var multiplier: float = 1
	var rand: float = randf_range(0, 1)
	if rand < 0.2:
		multiplier = 3
	elif rand >= 0.2 && rand < 0.3 :
		multiplier = 6
	boundingBox *= multiplier
	
	
	generated_polygon = Geometry.generate_convex_polygon(randi_range(5, 8), boundingBox)
	populated_polygon = Geometry.populate_with_random_points(generated_polygon)
	center = Geometry.get_center(generated_polygon)
	collision_polygon.polygon = generated_polygon
	var area: float = Geometry.compute_area(generated_polygon)
	mass = area * density
	health = area / 100
	maxHealth = health
	
	var triangles: Array[Polygon2D] = shatter(false)
	
	for t: Polygon2D in triangles:
		add_child(t)
	
func _draw() -> void:
	if is_outline_visible:
		draw_polyline(Geometry2D.convex_hull(generated_polygon), Color.WHITE, 5)
		
	 #Draw the bounds
	if is_bounding_box_visible:
		draw_rect(Rect2(-boundingBox / 2, boundingBox), Color.WHITE, false)
		
	if is_polygon_points_visible:
		for v: Vector2 in populated_polygon:
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


#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
	#
	#if collision:
		#var body: Node = collision.get_collider()
		#if body is Asteroid:
			#AudioSingleton.playSound("res://assets/sounds/shoot/laserShoot1.wav", collision.get_position())
	

## Shatters the polygon into multiple triangles
func shatter(instanceShards: bool = true, shatterVelocityMultiplier: Vector2 = Vector2(1,1)) -> Array[Polygon2D]:
	var delaunay: PackedInt32Array = Geometry2D.triangulate_delaunay(populated_polygon)
	var triangles: Array[Polygon2D] = []
	
	if !delaunay.is_empty():
		for i: int in range(0, delaunay.size(), 3):
			var triangle: Polygon2D = Polygon2D.new()
			triangle.polygon = PackedVector2Array([populated_polygon[delaunay[i]], populated_polygon[delaunay[i + 1]], populated_polygon[delaunay[i + 2]]])
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
		
		var fuel_shard: Resource = preload("res://scenes/fuel_shard/fuel_shard.tscn")
		for i: int in 4:
			var fuel_shard_instance: FuelShard = fuel_shard.instantiate()
			fuel_shard_instance.position = position
			get_parent().add_child(fuel_shard_instance)
		
	return triangles
