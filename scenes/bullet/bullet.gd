extends Projectile
class_name Bullet

var speed: float = 500

@onready var lifetime_timer: Timer = $LifetimeTimer
const HIT_POPUP: Resource = preload("uid://bhd64dff6sk8k")

func _ready() -> void:
	super._ready()
	#velocity = speed * Vector2.from_angle(rotation) 
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout)

#var total: float = 0
func _physics_process(delta: float) -> void:
	#total += delta
	#velocity = velocity.rotated(0.2 * cos(total * 20))
	#rotation = velocity.angle()
		
	var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
	
	if collision:
		var body: Node = collision.get_collider()
		if body is Asteroid:
			var damage: float = (0.005 * (body.linear_velocity - linear_velocity)).length()
			
			var popupValue: float = damage
			if (body as Asteroid).health < (body as Asteroid).health - damage:
				popupValue = (body as Asteroid).health
			
			HitPopup.instantiagePopup(collision.get_position(), get_tree().root, str(int(popupValue)))
			
			body.take_damage(damage)
			
			if is_bouncy:
				if bounces_left > 0:
					bounces_left -= 1
					linear_velocity = linear_velocity.bounce(collision.get_normal())
					rotation = linear_velocity.angle()
				else:
					disappear()
	
func _on_lifetime_timer_timeout() -> void:
	disappear()
