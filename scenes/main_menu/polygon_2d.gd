extends Polygon2D

var size: Vector2 = Vector2(300, 450)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = Player.create_centered_triangle(size.x, size.y)
	rotate(deg_to_rad(-130))
	$ThrusterParticles.position = Vector2(-size.x / 2, 0)
	$ThrusterParticles.emitting = true
