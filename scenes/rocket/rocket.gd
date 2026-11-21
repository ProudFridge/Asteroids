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
		var m: float = INF
		
		for body: Node in area_2d.get_overlapping_bodies():
			if body is Asteroid:
				var asteroid: Asteroid = body as Asteroid
				var length: float = (asteroid.global_position - global_position).length()
				if length < m:
					m = length
					target = asteroid
	
	if target:
		var target_angle: float = (target.global_position - global_position).angle()
		var lerped_angle: float = lerp_angle(global_rotation, target_angle, 0.5 * delta)
		velocity = Vector2.from_angle(lerped_angle) * velocity.length()
	
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
