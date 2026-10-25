extends RigidBody2D
class_name Player

const accel: float = 200.0
var currentAccel: float = accel
var maxSpeed: float = 400
var rotSpeed: float = 5 # rad/s
var bounceDamp: float = 0.5
# TODO: change to health later, faster asteroids deal more damage
var lives: float = 3

var boostAccel: float = 1500
var boostTime: float = 4
var currentBoostValue: float = boostTime
var boostDepletion: float = 3
var boostRefill: float = 1

var polygon: PackedVector2Array
var viewportSize: Vector2 

@onready var damage_timer: Timer = $DamageTimer
@onready var thruster_particles: CPUParticles2D = $ThrusterParticles
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var thruster: Polygon2D = $Thruster
@export var playerSize: Vector2 = Vector2(15, 30)

signal died()
signal health_lost(currentHealth: float)

func _ready() -> void:
	# Temp
	thruster_particles.position.y = 0
	thruster_particles.position.x = -playerSize.y / 2 - thruster_particles.emission_rect_extents.y / 2 - 6
	position = Global.windowSize / 2
	viewportSize = get_viewport_rect().size
	polygon = create_centered_triangle(playerSize.x, playerSize.y)
	polygon_2d.polygon = polygon
	collision_polygon_2d.polygon = polygon
	thruster.rotate(PI / 2)
	thruster.position = Vector2(-6 - playerSize.y / 2, 0)
	
	self.body_entered.connect(_on_body_entered)
	damage_timer.timeout.connect(_on_damage_timer_timeout)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
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


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction : float = Input.get_axis("backwards", "forwards")
	var rotDir : float = Input.get_axis("turn_left", "turn_right")
	
	if direction && Input.is_action_pressed("shift"):
		if currentBoostValue > boostDepletion * delta:
			currentAccel = boostAccel
			currentBoostValue -= boostDepletion * delta
	else:
		currentAccel = accel
	
	if currentBoostValue < boostTime :
		currentBoostValue += boostRefill * delta
		
	if direction:
		thruster_particles.emitting = true
		apply_central_force(direction * Vector2.from_angle(rotation) * currentAccel)
	else:
		thruster_particles.emitting = false


func die() -> void:
	died.emit()
	hide()

func _on_body_entered(body: Node) -> void:
	if body is Asteroid and damage_timer.is_stopped():
		lives -= 1
		health_lost.emit(lives)
		if lives <= 0:
			died.emit()
			die()
		damage_timer.start()
		
		polygon_2d.self_modulate = Color.DARK_RED
		thruster.self_modulate = Color.DARK_RED

# Change the color of the player to indicate invincibility period
func _on_damage_timer_timeout() -> void:
	polygon_2d.self_modulate = Color.WHITE
	thruster.self_modulate = Color.WHITE

# Rotate the rocket
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("turn_left"):
		angular_velocity = -rotSpeed
	if event.is_action_pressed("turn_right"):
		angular_velocity = rotSpeed
		
	if event.is_action_released("turn_left") || event.is_action_released("turn_right"):
		angular_velocity = 0


## Creates a PackedVector2Array that contains the points for a triangle with its pivot at the center
func create_centered_triangle(width: float, height: float) -> PackedVector2Array:
	var polygon: PackedVector2Array = [
		Vector2(-height / 2, -width / 2),
		Vector2(height / 2, 0),
		Vector2(-height / 2, width / 2)
	]
	
	return polygon
