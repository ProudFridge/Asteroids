extends CharacterBody2D


const accel: float = 150.0
var maxSpeed: float = 500
const rotSpeed: float = 10

@export var playerSize: Vector2 = Vector2(15, 30)

var polygon: PackedVector2Array

func _ready() -> void:
	# Temp
	position = get_viewport_rect().size / 2
	
	polygon = create_centered_triangle(playerSize.x, playerSize.y)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("backwards", "forwards")
	var rotDir : float = Input.get_axis("turn_left", "turn_right")
	
	if direction:
		velocity += transform.x * direction * accel * delta
		velocity.limit_length(maxSpeed)
	#else:
		#velocity += velocity.move_toward(Vector2.ZERO, SPEED)
	
	rotation += rotDir * rotSpeed * delta

	move_and_slide()

func _draw() -> void:
	draw_colored_polygon(polygon, Color.BLACK)

## Creates a PackedVector2Array that contains the points for a traignle with its pivot at the center
func create_centered_triangle(width: float, height: float) -> PackedVector2Array:
	var polygon: PackedVector2Array = [
		Vector2(-height / 2, -width / 2),
		Vector2(height / 2, 0),
		Vector2(-height / 2, width / 2)
	]
	
	return polygon
