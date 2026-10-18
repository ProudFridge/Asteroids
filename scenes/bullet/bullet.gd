extends CharacterBody2D
class_name Bullet

var damage: float = 50
var speed: float = 500

@onready var lifetime_timer: Timer = $LifetimeTimer

func _ready() -> void:
	velocity = speed * Vector2.from_angle(rotation) 
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout)


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		var body: Node = collision.get_collider()
		if body is Asteroid:
			body.take_damage(damage)
			disappear()
		
		var collisionPosition: Vector2 = collision.get_position()
		
		# Makes sure the player doens't get outside the window
		if collisionPosition.x >= Global.windowSize.x:
			disappear()
		
		if collisionPosition.x <= 0:
			disappear()
			
		if collisionPosition.y >= Global.windowSize.y:
			disappear()
			
		# Won't work without the 1
		if collisionPosition.y <= 1:
			disappear()


func _on_lifetime_timer_timeout() -> void:
	disappear()

func disappear() -> void:
	queue_free()
