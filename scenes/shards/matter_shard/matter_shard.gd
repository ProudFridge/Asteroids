extends RigidBody2D
class_name MatterShard

var matter_content: float = 20
var matter_content_multiplier: float = 0.1
var generated_polygon: PackedVector2Array = []

var is_absorbed: bool = false
var absorption_timer: SceneTreeTimer
var absorption_time: float = 1
var initial_position: Vector2
var player: Player


@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generated_polygon = _generate_square(20 * randf_range(0.5, 1.2))
	polygon_2d.polygon = generated_polygon
	polygon_2d.color = Color.from_hsv(0, 0, randf_range(0.5, 0.7))
	matter_content = Geometry.compute_area(generated_polygon) * matter_content_multiplier
	collision_polygon_2d.polygon = generated_polygon

	
func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if is_absorbed:
		var elapsed_time: float = absorption_time - absorption_timer.time_left
		position = Tween.interpolate_value(initial_position, player.position - initial_position, elapsed_time, absorption_time, Tween.TRANS_EXPO, Tween.EASE_OUT)
		scale = Tween.interpolate_value(Vector2.ONE, -Vector2(0.5, 0.5), elapsed_time, absorption_time, Tween.TRANS_EXPO, Tween.EASE_OUT)


func absorb_by_player(play: Player) -> void:
	play.matter_component.current_matter += matter_content
	
	collision_polygon_2d.disabled = true
	initial_position = position
	player = play
	is_absorbed = true
	absorption_timer = get_tree().create_timer(absorption_time)
	absorption_timer.timeout.connect(_on_absorption_timer_timeout)

func _on_absorption_timer_timeout() -> void:
	die()

func die() -> void:
	queue_free.call_deferred()
	
## Generates a PackedVector2Array that represents a square [br]
## [param size] is the the length of one side of the square
func _generate_square(size: float) -> PackedVector2Array:
	var square: PackedVector2Array = []
	
	square.append(Vector2(-size / 2, size / 2))
	square.append(Vector2(size / 2, size / 2))
	square.append(Vector2(size / 2, -size / 2))
	square.append(Vector2(-size / 2, -size / 2))
	
	return square
