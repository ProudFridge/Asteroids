extends RigidBody2D
class_name FuelShard

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D

var fuel_content: float = 0
var fuel_content_multiplier: float = 0.1
var polygon: PackedVector2Array = []

var is_absorbed: bool = false
var absorption_timer: SceneTreeTimer
var absorption_time: float = 0.5
var initial_position: Vector2
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = Geometry.generate_convex_polygon(5, Vector2(randf_range(10, 30), randf_range(10, 30)))
	var area: float = Geometry.compute_area(polygon) 
	fuel_content = area * fuel_content_multiplier
	mass = area
	polygon_2d.polygon = polygon
	collision_polygon_2d.polygon = polygon
	polygon_2d.color = Color.from_hsv(randf_range(0.5, 0.6), 1, 1)
	

func _process(delta: float) -> void:
	if is_absorbed:
		position = Tween.interpolate_value(initial_position, player.position - initial_position, absorption_time - absorption_timer.time_left, absorption_time, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	
func absorb_by_player(play: Player) -> void:
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
