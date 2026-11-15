extends Label

@export var asteroid_manager: AsteroidManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Asteroids: " + str(asteroid_manager.asteroidInstances.size())
	asteroid_manager.asteroid_added.connect(_on_asteroid_manager_asteroid_added)
	asteroid_manager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)

func _on_asteroid_manager_asteroid_added() -> void:
	text = "Asteroids: " + str(asteroid_manager.asteroidInstances.size())

func _on_asteroid_manager_asteroid_removed(_asteroid: Asteroid) -> void:
	text = "Asteroids: " + str(asteroid_manager.asteroidInstances.size())
