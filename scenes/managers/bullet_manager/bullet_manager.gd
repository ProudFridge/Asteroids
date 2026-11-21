extends Node
class_name BulletManager

@export var shooter: Player
var bulletSpeed: float = 500

var bullet_instances: Array[Bullet] = []

const BULLET: Resource = preload("uid://c4bego3ny732p")

func _ready() -> void:
	if References.bullet_manager == null:
		References.bullet_manager = self
	else:
		push_error("Trying to add a reference to a second bullet manager node in the References singleton")

func instantiate_bullet(position: Vector2, rotation: float) -> void:
	var bullet_instance: Bullet = BULLET.instantiate()
	
	bullet_instances.append(bullet_instance)
	bullet_instance.rotation = rotation
	bullet_instance.position = position
	bullet_instance.speed = bulletSpeed
	# Make the bullets velocity realistic: makes it relative
	bullet_instance.velocity = bullet_instance.speed * Vector2.from_angle(rotation).normalized() + shooter.linear_velocity
	add_child(bullet_instance)
	
