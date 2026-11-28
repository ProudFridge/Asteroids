extends RigidBody2D
class_name Asteroid

const SPEED: float = 300.0
var health: float = 100:
	set(new_health):
		health = max(new_health, 0)
		
var maxHealth: float = health
var density: float = 0.001
var area: float
@export var rotationSpeed: float = 1

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon

var generated_polygon: PackedVector2Array = []
var closed_polygon: PackedVector2Array = []
var populated_polygon: PackedVector2Array = []

var boundingBox: Vector2 = Vector2(60, 60)
var center: Vector2 = Vector2.ZERO
var has_shattered: bool = false
var fuel_shard_amount: int = 5

var original_color: Color

@export_group("Debug Options")
@export var is_outline_visible: bool = false
@export var is_bounding_box_visible: bool = false
@export var is_polygon_points_visible: bool = false
@export_group("")

signal died
signal removed

func _ready() -> void:
	generated_polygon = Geometry.generate_convex_polygon(randi_range(5, 8), boundingBox)
	closed_polygon = Geometry2D.convex_hull(generated_polygon)
	populated_polygon = Geometry.populate_with_random_points(generated_polygon)
	center = Geometry.get_center(generated_polygon)
	collision_polygon.polygon = generated_polygon
	area = Geometry.compute_area(generated_polygon)
	mass = area * density
	health = area / 100
	maxHealth = health
	original_color = modulate
	
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
	modulate = Color.from_hsv(original_color.h, original_color.s, lerpf(original_color.v, 0, 1 - health / maxHealth))


func die() -> void: 
	if !has_shattered:
		shatter(true)
		has_shattered = true
		died.emit()
		delete()

func delete() -> void:
	#died.emit()
	removed.emit()
	queue_free.call_deferred()


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
		var asteroidShard: Resource = preload("uid://c1nqdkbt0ygnc")
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
		
		
		#fuel_shard_amount = int(round(area / 500))
		fuel_shard_amount = int(round(sqrt(area / 10)))
		for i: int in fuel_shard_amount:
			(get_parent() as AsteroidManager).instantiate_fuel_shard(global_position)
			
		
		var matter_shard_amount: int = int(round(sqrt(area / 50)))
		for i: int in matter_shard_amount:
			(get_parent() as AsteroidManager).instantiate_matter_shard(global_position)
		
		
	return triangles

func disable(is_disabled: bool) -> void:
	if is_disabled:
		process_mode = Node.PROCESS_MODE_DISABLED
		modulate = Color.DARK_RED
	else:
		process_mode =Node.PROCESS_MODE_INHERIT
		modulate = original_color
