extends Node
class_name BulletManager

@export var shooter: Player
var bulletAmount: int = 4
var spread: float = 20 # in degrees,
var cooldown: float = 0.1
var isCooldownDone: bool = true
var bulletSpeed: float = 500

const BULLET: Resource = preload("uid://c4bego3ny732p")

func instantiate_bullet(position: Vector2, rotation: float) -> void:
	var bulletInstance: Bullet = BULLET.instantiate()
	bulletInstance.rotation = rotation
	bulletInstance.position = position
	bulletInstance.speed = bulletSpeed
	# Make the bullets velocity realistic: makes it relative
	bulletInstance.velocity = bulletInstance.speed * Vector2.from_angle(rotation).normalized() + shooter.linear_velocity
	add_child(bulletInstance)
	
