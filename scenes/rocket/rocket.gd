extends Projectile
class_name Rocket

var speed: float = 500
var target: Asteroid
@onready var area_2d: Area2D = $Area2D
@onready var thruster_particles: GPUParticles2D = $ThrusterParticles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thruster_particles.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null:
		var min: float = INF
		
		for body: Node in area_2d.get_overlapping_bodies():
			if body is Asteroid:
				var asteroid: Asteroid = body as Asteroid
				var length: float = (asteroid.global_position - global_position).length()
				if length < min:
					min = length
					target = asteroid
	
	if target:
		#velocity = velocity.rotated((target.global_position - global_position).angle() - global_rotation)
		velocity = lerp(velocity.normalized(), (target.global_position - global_position).normalized(), 0.5) * speed
	
	rotation = velocity.angle()
	
	#velocity = velocity.normalized() * speed
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		var body: Node2D = collision.get_collider()
		if body is Asteroid:
			var asteroid: Asteroid = body as Asteroid
			asteroid.take_damage(100)
			disappear()
		
	
#func disappear() -> void:
	#queue_free.call_deferred()
