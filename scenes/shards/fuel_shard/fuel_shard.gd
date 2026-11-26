extends RigidBody2D
class_name FuelShard

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

var fuel_content: float = 0
var matter_content: float = 1.5
var fuel_content_multiplier: float = 0.05
var polygon: PackedVector2Array = []

var is_absorbed: bool = false
var absorption_timer: SceneTreeTimer
var absorption_time: float = 1
var initial_position: Vector2
var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = Geometry.generate_convex_polygon(5, Vector2(randf_range(10, 30), randf_range(10, 30)))
	var area: float = Geometry.compute_area(polygon)
	fuel_content = area * fuel_content_multiplier
	mass = area
	collision_polygon_2d.polygon = polygon
	
	var triangles: Array[Polygon2D] = shatter()
	
	for t: Polygon2D in triangles:
		add_child(t)
	
	
func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
	if collision:
		AudioSingleton.play_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_FUEL_SHARD_COLLISION)
	
	if is_absorbed:
		var elapsed_time: float = absorption_time - absorption_timer.time_left
		position = Tween.interpolate_value(initial_position, player.position - initial_position, elapsed_time, absorption_time, Tween.TRANS_EXPO, Tween.EASE_OUT)
		scale = Tween.interpolate_value(Vector2.ONE, -Vector2(0.5, 0.5), elapsed_time, absorption_time, Tween.TRANS_EXPO, Tween.EASE_OUT)


func absorb_by_player(play: Player) -> void:
	play.current_fuel += fuel_content
	
	collision_polygon_2d.disabled = true
	initial_position = position
	player = play
	is_absorbed = true
	absorption_timer = get_tree().create_timer(absorption_time)
	absorption_timer.timeout.connect(_on_absorption_timer_timeout)

func _on_absorption_timer_timeout() -> void:
	die()
	
func die() -> void:
	# TODO: change played sound
	#AudioSingleton.play_2d_audio_at_location(position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_ASTEROID_COLLISION)
	queue_free.call_deferred()

## Shatters the polygon into multiple triangles
func shatter() -> Array[Polygon2D]:
	var delaunay: PackedInt32Array = Geometry2D.triangulate_delaunay(polygon)
	var triangles: Array[Polygon2D] = []
	
	if !delaunay.is_empty():
		for i: int in range(0, delaunay.size(), 3):
			var triangle: Polygon2D = Polygon2D.new()
			triangle.polygon = PackedVector2Array([polygon[delaunay[i]], polygon[delaunay[i + 1]], polygon[delaunay[i + 2]]])
			triangle.color = Color.from_hsv(randf_range(0.5, 0.6), 1.0, 1.0, 1.0)
			triangles.append(triangle)
			
	return triangles
