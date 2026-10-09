extends CharacterBody2D


const accel: float = 150.0
var maxSpeed: float = INF
const rotSpeed: float = 10

@export var playerSize: Vector2 = Vector2(15, 30)

var polygon: PackedVector2Array
var viewportSize: Vector2 

func _ready() -> void:
	# Temp
	position = get_viewport_rect().size / 2
	viewportSize = get_viewport_rect().size
	polygon = create_centered_triangle(playerSize.x, playerSize.y)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("backwards", "forwards")
	var rotDir : float = Input.get_axis("turn_left", "turn_right")
	
	if direction:
		velocity += transform.x * direction * accel * delta
		velocity.limit_length(maxSpeed)

	
	rotation += rotDir * rotSpeed * delta

	move_and_slide()
	
	# Makes sure the player doens't get outside the window
	if position.x > viewportSize.x:
		position.x = 0 
	
	if position.x < 0:
		position.x = viewportSize.x
		
	if position.y > viewportSize.y:
		position.y = 0
		
	if position.y < 0:
		position.y = viewportSize.y

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
