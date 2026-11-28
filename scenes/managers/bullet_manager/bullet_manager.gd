extends Node
class_name BulletManager

@export var shooter: Player
var bulletSpeed: float = 500

var bullet_instances: Array[Projectile] = []

const BULLET: Resource = preload("uid://c4bego3ny732p")
const ROCKET: Resource = preload("uid://ci132hknrggin")

var selected_bullet: Resource

func _ready() -> void:
	if References.bullet_manager == null:
		References.bullet_manager = self
	else:
		push_error("Trying to add a reference to a second bullet manager node in the References singleton")

func instantiate_bullet(position: Vector2, rotation: float, initial_velocity: Vector2, bullet_type: BULLET_TYPE) -> void:
	_select_bullet_type(bullet_type)
	var bullet_instance: Projectile = selected_bullet.instantiate()
	
	bullet_instances.append(bullet_instance)
	bullet_instance.rotation = rotation
	bullet_instance.position = position
	bullet_instance.speed = bulletSpeed
	# Make the bullets velocity realistic: makes it relative
	bullet_instance.linear_velocity = bullet_instance.speed * Vector2.from_angle(rotation).normalized() + initial_velocity
	add_child(bullet_instance)

enum BULLET_TYPE {
	BULLET,
	ROCKET
}

func _select_bullet_type(bullet_type: BULLET_TYPE) -> void:
	match bullet_type:
		BULLET_TYPE.BULLET:
			selected_bullet = BULLET
		BULLET_TYPE.ROCKET:
			selected_bullet = ROCKET
