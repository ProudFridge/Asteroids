extends Label

@export var asteroid_manager: AsteroidManager
@export var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Remaining Asteroids: " + str(int(snappedf(game_manager.necessary_asteroids, 1)))
	asteroid_manager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)


func _on_asteroid_manager_asteroid_removed(_asteroid: Asteroid) -> void:
	text = "Remaining Asteroids: " + str(int(snapped(game_manager.necessary_asteroids - game_manager.destroyed_asteroids, 1)))
