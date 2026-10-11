extends Node2D
class_name ShootComponent

var bullet: Resource = preload("res://scenes/bullet/bullet.tscn")
@export var shooter: Player

func shoot() -> void:
	var bulletInstance: Bullet = bullet.instantiate()
	bulletInstance.rotation = shooter.rotation
	bulletInstance.position = shooter.position
	get_tree().root.add_child(bulletInstance)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()
