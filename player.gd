extends CharacterBody2D


const SPEED = 300.0
const rotSpeed: float = 10

var polygon: PackedVector2Array

func _ready() -> void:
	polygon = create_centered_triangle(20, 40)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("backwards", "forwards")
	var rotDir : float = Input.get_axis("turn_left", "turn_right")
	
	if direction:
		#velocity = Vector2(cos(rotation), sin(rotation)) * direction * SPEED
		velocity = transform.x * direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
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
