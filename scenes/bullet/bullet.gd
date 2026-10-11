extends CharacterBody2D
class_name Bullet

var damage: float = 50
var speed: float = 500

func _ready() -> void:
	velocity = speed * Vector2.from_angle(rotation) 

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		var body: Node = collision.get_collider()
		if body is Asteroid:
			body.take_damage(damage)
			disappear()
			
func disappear() -> void:
	queue_free()
