extends Node2D
class_name Weapon

const LOCK_ON_TEXTURE: Resource = preload("uid://vn17ge5tjuwo")

@export var shooter: Player
var cooldown: float = 0.1
var isCooldownDone: bool = true

var is_auto_aiming: bool = false
var auto_aim_radius: float = 500
var rotation_speed: float = 0.1 # deg/s
var rot_tween: Tween

var closest_asteroid: Asteroid = null
var bullet_manager: BulletManager
var lock_on_texture: LockOnTexture
@export var pointer_size: Vector2 = Vector2(50,50)

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Sprite2D/Muzzle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_on_texture = LOCK_ON_TEXTURE.instantiate()
	lock_on_texture.hide()
	
	add_child(lock_on_texture)
	
	bullet_manager = shooter.bullet_manager
	collision_shape_2d.shape.radius = auto_aim_radius
	
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	area_2d.body_exited.connect(_on_area_2d_body_exited)

## Draws the lock on texture
#func _draw() -> void:
	#if closest_asteroid:
		#draw_texture(lock_on_texture, closest_asteroid.global_position - global_position - lock_on_texture.get_size() / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position = player.position
	var min: float = INF
	
	if is_auto_aiming:
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
			sprite_2d.global_rotation = (closest_asteroid.global_position - global_position).angle()
			lock_on_texture.global_position = closest_asteroid.global_position
			lock_on_texture.visible = true
		else:
			sprite_2d.rotation = 0
			lock_on_texture.hide()	
	else:
		sprite_2d.rotation = 0
		lock_on_texture.hide()	
		
	# Redraw the lock on sprite
	queue_redraw()
	
	# Spawn a bullet
	if isCooldownDone && Input.is_action_pressed("space") && shooter.isAlive:
		var rot: float = sprite_2d.global_rotation
	#
		AudioSingleton.play_2d_audio_at_location(shooter.position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SHOOT)
		bullet_manager.instantiate_bullet(muzzle.global_position, rot)
		isCooldownDone = false
		get_tree().create_timer(cooldown).timeout.connect(func() -> void: isCooldownDone = true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		(body as Asteroid).is_outline_visible = true
		body.queue_redraw()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Asteroid:
		(body as Asteroid).is_outline_visible = false
		body.queue_redraw()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ctrl"):
		is_auto_aiming = !is_auto_aiming
