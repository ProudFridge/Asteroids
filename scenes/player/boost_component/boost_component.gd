extends Node2D
class_name BoostComponent
## Modifies the acceleration of the player

@export var player: Player

var boost_accel: float = 1500
var boost_rot_speed: float = 10
@export var boost_fuel_consumption: float = 50

var isBoostActivated: bool = false

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var parent: Node = get_parent()
	#if parent is Player:
		#player = parent


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		isBoostActivated = true
		player.currentAccel = boost_accel
		player.current_rot_speed = boost_rot_speed
		player.current_fuel_consumption = boost_fuel_consumption
	elif event.is_action_released("shift"):
		isBoostActivated = false
		player.currentAccel = player.accel
		player.current_rot_speed = player.rot_speed
		player.current_fuel_consumption = player.fuel_consumption
