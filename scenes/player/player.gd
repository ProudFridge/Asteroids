extends RigidBody2D
class_name Player

var max_fuel: float = 100
var current_fuel: float = max_fuel:
	set(new_fuel):
		current_fuel = clamp(new_fuel, 0, max_fuel)
var fuel_consumption: float = 20 # u/s

const accel: float = 200.0
var max_speed: float = 800
@export var rot_speed: float = 250 # deg/s

var currentAccel: float = accel
var current_rot_speed: float = rot_speed
var current_fuel_consumption: float = fuel_consumption

var ship_width: float = 15

var bounceDamp: float = 0.5
# TODO: change to health later, faster asteroids deal more damage
var lives: float = 3
var isAlive: bool = true

var impulseMagnitude: float = 400
var sideThrusterCooldown: float = 1

@export_group("Components")
@export var boost_component: BoostComponent
@export var impulse_component: ImpulseComponent
@export_group("")

var polygon: PackedVector2Array
var viewportSize: Vector2 

@export var bullet_manager: BulletManager
@onready var damage_timer: Timer = $DamageTimer
@onready var thruster_particles: GPUParticles2D = $ThrusterParticles
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@export var playerSize: Vector2 = Vector2(15, 30)
@onready var ship: Node2D = $Ship

signal died()
signal health_lost(currentHealth: float)

func _ready() -> void:
	AudioSingleton.reset_audio_count(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_THRUST)
	# Temp
	thruster_particles.position.y = 0
	#thruster_particles.position.x = -playerSize.y / 2 - thruster_particles.emission_rect_extents.y / 2 - 6

	position = Global.windowSize / 2
	viewportSize = get_viewport_rect().size
	
	self.body_entered.connect(_on_body_entered)
	damage_timer.timeout.connect(_on_damage_timer_timeout)


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
	if collision:
		var collisionPosition : Vector2 = collision.get_position()
		
		if collisionPosition.x >= Global.windowSize.x:
			position.x = collisionPosition.x - position.x
	
		if collisionPosition.x <= 0:
			position.x = Global.windowSize.x - (collisionPosition.x - position.x)
		
		if collisionPosition.y >= Global.windowSize.y:
			position.y = collisionPosition.y - position.y
			
		# Won't work without the 1
		if collisionPosition.y <= 1:
			position.y = Global.windowSize.y - (collisionPosition.y - position.y)
		
	linear_velocity = linear_velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("turn_left"):
		angular_velocity = -deg_to_rad(current_rot_speed)
	elif Input.is_action_pressed("turn_right"):
		angular_velocity = deg_to_rad(current_rot_speed)
	else:
		angular_velocity = 0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction : float = Input.get_axis("backwards", "forwards")
	
	if direction and current_fuel > 0:
		thruster_particles.emitting = true
		apply_central_force(direction * Vector2.from_angle(rotation) * currentAccel)
		current_fuel -= current_fuel_consumption * delta
	else:
		thruster_particles.emitting = false


func die() -> void:
	died.emit()
	isAlive = false
	hide()

func _on_body_entered(body: Node) -> void:
	if body is Asteroid && damage_timer.is_stopped() && isAlive:
		lives -= 1
		$Camera2D.add_trauma(0.5)
		AudioSingleton.play_2d_audio_at_location(position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_ASTEROID_COLLISION)
		health_lost.emit(lives)
		if lives <= 0:
			died.emit()
			die()
		damage_timer.start()
		
		ship.modulate = Color.RED

# Change the color of the player to indicate invincibility period
func _on_damage_timer_timeout() -> void:
	ship.modulate = Color.WHITE


var thruster_sound: AudioStreamPlayer

# Rotate the rocket and play thruster sound
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("forwards") || event.is_action_pressed("backwards")) && current_fuel > 0:
		if thruster_sound == null:
			thruster_sound = AudioSingleton.play_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_THRUST)
		else:
			thruster_sound.play()
			var tween: Tween = create_tween()
			tween.tween_property(thruster_sound, "pitch_scale", 1, 0.2)
	
	if event.is_action_released("forwards") || event.is_action_released("backwards"):
		if thruster_sound != null:
			thruster_sound.stop()
			var tween: Tween = create_tween()
			tween.tween_property(thruster_sound, "pitch_scale", 0.1, 0.2)
		
	if event.is_action_pressed("shift") && boost_component.isBoostActivated && current_fuel > 0:
		if thruster_sound:
			thruster_sound.pitch_scale = 1.5
			var tween: Tween = create_tween()
			tween.tween_property(thruster_sound, "pitch_scale", 1.5, 0.1)
		$Camera2D.add_trauma(0.5)
	
	# Handle rotation
	#if event.is_action_pressed("turn_left"):
		#angular_velocity = -deg_to_rad(current_rot_speed)
	#elif event.is_action_pressed("turn_right"):
		#angular_velocity = deg_to_rad(current_rot_speed)
#
	#if event.is_action_released("turn_left") || event.is_action_released("turn_right"):
		#angular_velocity = 0


## Creates a PackedVector2Array that contains the points for a triangle with its pivot at the center
static func create_centered_triangle(width: float, height: float) -> PackedVector2Array:
	var poly: PackedVector2Array = [
		Vector2(-height / 2, -width / 2),
		Vector2(height / 2, 0),
		Vector2(-height / 2, width / 2)
	]
	
	return poly
