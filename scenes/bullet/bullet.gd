extends Projectile
class_name Bullet

var damage_multiplier: float = 0.05

@onready var lifetime_timer: Timer = $LifetimeTimer
const HIT_POPUP: Resource = preload("uid://bhd64dff6sk8k")

func _ready() -> void:
	super._ready()
	#velocity = speed * Vector2.from_angle(rotation) 
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout)

func _physics_process(_delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
	
	if collision:
		var body: Node = collision.get_collider()
		if body is Asteroid:
			var damage: float = (damage_multiplier * (body.linear_velocity - linear_velocity)).length()
			
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
			else:
				disappear()
	
func _on_lifetime_timer_timeout() -> void:
	disappear()
