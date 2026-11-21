extends Projectile
class_name Rocket

var target: Asteroid
var steering_force: float = 50
var homing_acceleration: Vector2 = Vector2.ZERO

@onready var area_2d: Area2D = $Area2D
@onready var thruster_particles: GPUParticles2D = $ThrusterParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	thruster_particles.emitting = true
	is_bouncy = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	apply_central_force(linear_velocity.normalized() * 5)
	
	if target == null:
		var m: float = INF
			
		for body: Node in area_2d.get_overlapping_bodies():
			if body is Asteroid:
				var asteroid: Asteroid = body as Asteroid
				var length: float = (asteroid.global_position - global_position).length()
				if length < m:
					m = length
					target = asteroid
	
	# Handle the projectile homing
	homing_acceleration += _seek()
	linear_velocity += homing_acceleration * delta
	linear_velocity = linear_velocity.limit_length(speed)

	rotation = linear_velocity.angle()
	
	var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
	
	if collision:
		var body: Node2D = collision.get_collider()
		if body is Asteroid:
			var asteroid: Asteroid = body as Asteroid
			asteroid.take_damage(100)
			
			if is_bouncy:
				if bounces_left > 0:
					bounces_left -= 1
				else:
					disappear()
			else:
				disappear()

## Computes the steering force of the rocket
func _seek() -> Vector2:
	var steer: Vector2 = Vector2.ZERO
	if target:
		var desired: Vector2 = (target.global_position - global_position).normalized() * speed
		steer = (desired - linear_velocity).normalized() * steering_force
	return steer
		
