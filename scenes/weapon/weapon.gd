extends Node2D
class_name Weapon

@export var shooter: Player
var bulletAmount: int = 1
var spread: float = 20 # in degrees,
var cooldown: float = 0.1
var isCooldownDone: bool = true
var bulletSpeed: float = 500

const BULLET: Resource = preload("uid://c4bego3ny732p")


var auto_aim_radius: float = 500
var closest_asteroid: Asteroid = null
var bullet_manager: BulletManager
@export var lock_on_texture: Texture2D
@export var pointer_size: Vector2 = Vector2(50,50)
@export var player: Player

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet_manager = shooter.bullet_manager
	collision_shape_2d.shape.radius = auto_aim_radius

func _instantiate_bullet() -> void:
	var rot: float = shooter.rotation
	
	if closest_asteroid:
		rot = (closest_asteroid.global_position - global_position).angle()
		#var spreadInterval: float = deg_to_rad(spread) / bulletAmount
		
	for i: int in bulletAmount:
		var bulletInstance: Bullet = BULLET.instantiate()
		bulletInstance.top_level = true
		#bulletInstance.rotation = (closest_asteroid.global_position - global_position).angle() - deg_to_rad(spread) / 2 + spreadInterval * i- deg_to_rad(spread) / 2 + spreadInterval * i
		bulletInstance.rotation = rot
		bulletInstance.position = shooter.global_position
		bulletInstance.speed = bulletSpeed
		# Make the bullets velocity realistic: makes it relative
		#bulletInstance.velocity = bulletInstance.speed * Vector2.from_angle(shooter.rotation).normalized() + shooter.linear_velocity
		add_child(bulletInstance)
		

# Draws the lock on texture
func _draw() -> void:
	if closest_asteroid:
		draw_texture(lock_on_texture, closest_asteroid.global_position - global_position - lock_on_texture.get_size() / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = player.position
	var min: float = INF
	
	if area_2d.has_overlapping_bodies():
		#print("Has overlapping bodies: ", area_2d.get_overlapping_bodies().size())
		for node: Node2D in area_2d.get_overlapping_bodies():
			if node is Asteroid:
				var asteroid: Asteroid = node as Asteroid
				
				# Manually lock onto asteroids that are closest to the mouse
				if Input.is_action_pressed("right_click"):
					var distance: Vector2 = asteroid.global_position - get_global_mouse_position()
					
					if (asteroid.global_position - global_position).length() < auto_aim_radius:
						if distance.length() < min:
							min = distance.length()
							closest_asteroid = asteroid
				# Lock onto the closest asteroids
				else:
					var distance: Vector2 = asteroid.global_position - global_position
				
					if distance.length() < auto_aim_radius:
						if distance.length() < min:
							min = distance.length()
							closest_asteroid = asteroid
	else:
		closest_asteroid = null
			
	if closest_asteroid:
		sprite_2d.rotation = (closest_asteroid.global_position - global_position).angle()
	else:
		sprite_2d.rotation = shooter.rotation
		
	# Redraw the lock on sprite
	queue_redraw()
	
	# Spawn a bullet
	if isCooldownDone && Input.is_action_pressed("space") && shooter.isAlive:
		var rot: float = shooter.rotation
	
		if closest_asteroid:
			rot = (closest_asteroid.global_position - global_position).angle()
		#var spreadInterval: float = deg_to_rad(spread) / bulletAmount
		
		AudioSingleton.play_2d_audio_at_location(shooter.position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SHOOT)
		bullet_manager.instantiate_bullet(shooter.global_position, rot)
		isCooldownDone = false
		get_tree().create_timer(cooldown).timeout.connect(func() -> void: isCooldownDone = true)
	
