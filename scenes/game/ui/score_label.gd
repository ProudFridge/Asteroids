extends Label

@export var asteroidManager: AsteroidManager
var score: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Score: " + str(score)
	asteroidManager.asteroid_removed.connect(_on_asteroid_manager_asteroid_removed)


func _on_asteroid_manager_asteroid_removed() -> void:
	score += 10
	text = "Score: " + str(score)
