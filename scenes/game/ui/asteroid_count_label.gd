extends Label

@export var asteroidManager: AsteroidManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Asteroids: " + str(asteroidManager.asteroidInstances.size())
	asteroidManager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)

func _on_asteroid_manager_asteroid_removed() -> void:
	text = "Asteroids: " + str(asteroidManager.asteroidInstances.size())
