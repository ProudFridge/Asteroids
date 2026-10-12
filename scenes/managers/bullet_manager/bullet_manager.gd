extends Node
class_name BulletManager

@export var shooter: Player

const BULLET: Resource = preload("uid://c4bego3ny732p")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var bulletInstance: Bullet = BULLET.instantiate()
		bulletInstance.rotation = shooter.rotation
		bulletInstance.position = shooter.position
		# Make the bullets velocity realistic: makes it relative
		#bulletInstance.velocity = bulletInstance.speed * Vector2.from_angle(shooter.rotation).normalized() + shooter.velocity
		add_child(bulletInstance)
	
