extends Node
class_name GameManager
## Handles lives, sends lost signal

# Made create a node that searches for other nodes in the scene tree
@export var asteroid_manager: AsteroidManager # To detect when we won
@export var player: Player # To detect when we lost

var isGameRunning: bool = false

signal won
signal lost
#signal boostIncreased(newBoostValue: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroid_manager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)
	player.died.connect(_on_player_died)
	
	player.rotate(randf_range(-PI, PI))
	
	# Pause game when it loads
	get_tree().paused = true

# Detect the closest asteorids and add more if necessary
func _process(delta: float) -> void:
	var rad: float = Global.windowSize.x
	var amount: int = 100
	var count: int = 0
	for asteroid: Asteroid in asteroid_manager.asteroidInstances:
		if asteroid != null:
			if (asteroid.global_position - player.global_position).length() < rad:
				count += 1
			
	while count < amount:
		var length: float = randf_range(1000, Global.windowSize.x)
		var angle: float = randf_range(-PI, PI)
		asteroid_manager.instantiate_asteroid(Vector2(cos(angle) * length, sin(angle) * length) + player.position)
		count += 1
		

func _on_asteroid_manager_asteroid_removed(_asteroid: Asteroid) -> void:
	if asteroid_manager.asteroidInstances.size() <= 0:
		won.emit()


func _on_player_died() -> void:
	lost.emit()
