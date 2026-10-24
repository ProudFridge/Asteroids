extends Node
class_name BulletManager

@export var shooter: Player
var bulletAmount: int = 3
var spread: float = 10 # in degrees
var cooldown: float = 0.1
var isCooldownDone: bool = true
var bulletSpeed: float = 500

const BULLET: Resource = preload("uid://c4bego3ny732p")

func _process(delta: float) -> void:
	if  isCooldownDone && Input.is_action_pressed("space"):
		_instantiate_bullet()
		isCooldownDone = false
		get_tree().create_timer(cooldown).timeout.connect(func() -> void: isCooldownDone = true)


func _instantiate_bullet() -> void:
	var spreadInterval: float = spread / bulletAmount
	
	for i: int in bulletAmount:
		var bulletInstance: Bullet = BULLET.instantiate()
		bulletInstance.rotation = shooter.rotation - deg_to_rad(spread) / 2 + deg_to_rad(spread) * i
		bulletInstance.position = shooter.position
		bulletInstance.speed = bulletSpeed
		# Make the bullets velocity realistic: makes it relative
		#bulletInstance.velocity = bulletInstance.speed * Vector2.from_angle(shooter.rotation).normalized() + shooter.velocity
		add_child(bulletInstance)
	
