class_name Gun extends Weapon

const LOCK_ON_TEXTURE: Resource = preload("uid://vn17ge5tjuwo")

@export var shooter: Player
var cooldown: float = 0.1
var isCooldownDone: bool = true

var is_auto_aiming: bool = false

var bullet_manager: BulletManager

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Sprite2D/Muzzle

func use_weapon() -> void:
	AudioSingleton.play_2d_audio_at_location(shooter.position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SHOOT)
	bullet_manager.instantiate_bullet(muzzle.global_position, 0)
	isCooldownDone = false
	get_tree().create_timer(cooldown).timeout.connect(func() -> void: isCooldownDone = true)
	


# Array to store abilities of different types for weapons
# Abilities array


# Called when the node enters the scene tree for the first time.:



## Draws the lock on texture
#func _draw() -> void:
	#if closest_asteroid:
		#draw_texture(lock_on_texture, closest_asteroid.global_position - global_position - lock_on_texture.get_size() / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
