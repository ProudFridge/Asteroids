extends RigidBody2D
class_name Player

var max_fuel: float = 1000
var current_fuel: float = max_fuel:
	set(new_fuel):
		current_fuel = clamp(new_fuel, 0, max_fuel)
		#current_fuel = 1
var fuel_consumption: float = 20 # u/s
var rot_fuel_consumption: float = 5

const accel: float = 200.0
var max_speed: float = 8000
@export var rot_speed: float = 500 # deg/s

var currentAccel: float = accel
var current_rot_speed: float = rot_speed
var current_fuel_consumption: float = fuel_consumption
var current_rot_fuel_consumption: float = rot_fuel_consumption

var bounceDamp: float = 0.5
var health: float = 100:
	set(newHealth):
		if newHealth > 0:
			health = newHealth
		else:
			health = 0
			die()
		
var isAlive: bool = true

var impulseMagnitude: float = 400
var sideThrusterCooldown: float = 1

@export_group("Components")
@export var boost_component: BoostComponent
@export var impulse_component: ImpulseComponent
@export var matter_component: MatterComponent
@export_group("")

@export var bullet_manager: BulletManager
@onready var damage_timer: Timer = $DamageTimer

# Sprites used for the thruster plumes
@onready var left_thruster_sprite: Sprite2D = $ThrusterSprites/LeftThrusterSprite
@onready var right_thruster_sprite: Sprite2D = $ThrusterSprites/RightThrusterSprite
@onready var main_thruster_sprite: Sprite2D = $ThrusterSprites/MainThrusterSprite

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@export var playerSize: Vector2 = Vector2(15, 30)
@onready var ship: Node2D = $Ship

var hull_size: Vector2 = Vector2(32, 8) # x: pixels long, y: pixels wide

signal died()
signal health_lost(currentHealth: float)

func _ready() -> void:
	left_thruster_sprite.hide()
	right_thruster_sprite.hide()
	main_thruster_sprite.hide()
	
	AudioSingleton.reset_audio_count(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_THRUST)
	
	body_entered.connect(_on_body_entered)
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	
	# Instantiate holders
	var holder_amount: int = 4
	var holder_per_side: int = ceil(float(holder_amount) / 2)
	
	var holder_amount_left: int = holder_per_side
	var holder_amount_right: int = floor(float(holder_amount) / 2)
	
	var holder_seperation: float = hull_size.x / holder_per_side
	
	for i: int in holder_amount_left:
		var holder_position: Vector2 = Vector2(hull_size.x / holder_per_side / 2 + holder_seperation * i - 16, -hull_size.y)
		Holder.instantiate(self, holder_position)
		
	for i: int in holder_amount_right:
		var holder_position: Vector2 = Vector2(hull_size.x / holder_per_side / 2 + holder_seperation * i - 16, hull_size.y)
		Holder.instantiate(self, holder_position, true)


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	linear_velocity = linear_velocity.limit_length(max_speed)


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction : float = Input.get_axis("backwards", "forwards")
	
	if direction and current_fuel > 0:
		main_thruster_sprite.visible = true
		apply_central_force(direction * Vector2.from_angle(rotation) * currentAccel)
		current_fuel -= current_fuel_consumption * delta
	else:
		main_thruster_sprite.visible = false
	
	# Apply torque to spin the ship
	if Input.is_action_pressed("turn_left"):
		right_thruster_sprite.visible = true
		apply_torque(-current_rot_speed)
		current_fuel -= rot_fuel_consumption * delta
	else:
		right_thruster_sprite.hide()
		
	if Input.is_action_pressed("turn_right"):
		left_thruster_sprite.visible = true
		apply_torque(current_rot_speed)
		current_fuel -= rot_fuel_consumption * delta
	else:
		left_thruster_sprite.hide()


func die() -> void:
	died.emit()
	isAlive = false
	hide()

func _on_body_entered(body: Node) -> void:
	if body is Asteroid && damage_timer.is_stopped() && isAlive:
		health -= ((body as Asteroid).linear_velocity - linear_velocity).length() * 0.1
		
		$Camera2D.add_trauma(0.5)
		AudioSingleton.play_2d_audio_at_location(position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_ASTEROID_COLLISION)
		health_lost.emit(health)
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


## Creates a PackedVector2Array that contains the points for a triangle with its pivot at the center
static func create_centered_triangle(width: float, height: float) -> PackedVector2Array:
	var poly: PackedVector2Array = [
		Vector2(-height / 2, -width / 2),
		Vector2(height / 2, 0),
		Vector2(-height / 2, width / 2)
	]
	
	return poly
