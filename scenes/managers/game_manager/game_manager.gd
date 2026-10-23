extends Node
class_name GameManager
## Handles lives, sends lost signal

# Made create a node that searches for other nodes in the scene tree
@export var asteroidManager: AsteroidManager # To detect when we won
@export var player: Player # To detect when we lost

signal won
signal lost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroidManager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)
	player.died.connect(_on_player_died)
	
	# Pause game when it loads
	get_tree().paused = true
	

func _on_asteroid_manager_asteroid_removed() -> void:
	if asteroidManager.asteroidInstances.size() <= 0:
		won.emit()


func _on_player_died() -> void:
	lost.emit()
