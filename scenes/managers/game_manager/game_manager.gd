extends Node
class_name GameManager
## Handles lives, sends lost signal

# Made create a node that searches for other nodes in the scene tree
@export var asteroid_manager: AsteroidManager # To detect when we won
@export var player: Player # To detect when we lost

var isGameRunning: bool = false
## The amount of time the player has to destroy the necessary amount of asteroids
var game_time: float = 10 # minutes
var necessary_asteroids: float = 25 # Require asteroids to be destroyed to beat the game
var destroyed_asteroids: int = 0 
@onready var game_timer: Timer = $GameTimer

## Variables for asteroid generation
var detection_radius: float = Global.windowSize.x
var threshold_amount: int = 500

signal won
signal lost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroid_manager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)
	player.died.connect(_on_player_died)
	
	player.rotate(randf_range(-PI, PI))
	
	# Pause game when it loads
	get_tree().paused = true
	
	game_timer.wait_time = game_time * 60
	game_timer.start()
	game_timer.timeout.connect(_on_game_timer_timeout)

# Detect the closest asteorids and add more if necessary
func _process(delta: float) -> void:
	var asteroid_count: int = 0
	for asteroid: Asteroid in asteroid_manager.asteroid_instances:
		if asteroid != null:
			if (asteroid.global_position - player.global_position).length() < detection_radius:
				asteroid_count += 1
			
	while asteroid_count < threshold_amount:
		var length: float = randf_range(2000, Global.windowSize.x)
		var angle: float = randf_range(-PI, PI)
		asteroid_manager.instantiate_asteroid(Vector2(cos(angle) * length, sin(angle) * length) + player.position)
		asteroid_count += 1
		

func _on_asteroid_manager_asteroid_removed(_asteroid: Asteroid) -> void:
	destroyed_asteroids += 1
	
	if destroyed_asteroids >= necessary_asteroids:
		won.emit()

func _on_game_timer_timeout() -> void:
	lost.emit()

func _on_player_died() -> void:
	lost.emit()
