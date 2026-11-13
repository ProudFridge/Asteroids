extends Node2D
class_name PickupComponent

@export var player: Player
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
var radius: float = 100
var arc_amount: int = 15
var angle_seperation: float = PI / 24
var arc_angle: float = 0.5
var arc_width: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arc_angle = (2 * PI - arc_amount * angle_seperation) / arc_amount
	collision_shape_2d.shape.radius = radius
	
	area_2d.body_entered.connect(_on_area_2d_body_entered)

## Draws a dotted outline
func _draw() -> void:
	var start_angle: float = 0
	var end_angle: float = arc_angle
	for i: int in arc_amount:
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, 50, Color.WHITE, arc_width)
		start_angle = end_angle + angle_seperation
		end_angle = start_angle + arc_angle
	
#func _process(delta: float) -> void:
	#global_rotation = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if player.current_fuel < player.max_fuel:
		if body is FuelShard:
			player.current_fuel += (body as FuelShard).fuel_content
			(body as FuelShard).die()
