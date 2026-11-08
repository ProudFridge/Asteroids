extends Node
class_name GameManager
## Handles lives, sends lost signal

# Made create a node that searches for other nodes in the scene tree
@export var asteroidManager: AsteroidManager # To detect when we won
@export var player: Player # To detect when we lost

var isGameRunning: bool = false

signal won
signal lost
#signal boostIncreased(newBoostValue: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroidManager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)
	player.died.connect(_on_player_died)
	
	player.rotate(randf_range(-PI, PI))
	
	# Pause game when it loads
	get_tree().paused = true
	

func _on_asteroid_manager_asteroid_removed(_asteroid: Asteroid) -> void:
	# Temporarily refuel the playe when an asteroid is destroyed
	player.current_fuel += 10
	
	if asteroidManager.asteroidInstances.size() <= 0:
		won.emit()


func _on_player_died() -> void:
	lost.emit()
