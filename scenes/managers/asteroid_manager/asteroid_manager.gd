extends Node
class_name AsteroidManager
## Generates asteroid field, keeps track of current asteroids

# Called when the node enters the scene tree for the first time.
const ASTEROID: Resource = preload("res://scenes/asteroid/asteroid.tscn")

var asteroidInstances: Array[Asteroid] = []

signal asteroid_added
signal asteroid_removed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate_asteroid_in_area(10, get_viewport().get_visible_rect().size, 10)

## Instantiates asteroids in a specified area
func instantiate_asteroid_in_area(asteroidNum: int, area: Vector2, exclusionZoneRadius: float) -> void:
	for i: int in asteroidNum:
		var asteroid: Asteroid = ASTEROID.instantiate()
		
		# Todo: replace with actual scren size, maybe use a singleton to store the screen size
		var position: Vector2 = Vector2.ZERO
		#while position.distance_to(area / 2) > exclusionZoneRadius:
			#print(area)
		position.x = randf_range(0, area.x)
		position.y = randf_range(0, area.y)
		
		asteroid.position = position
		
		# Remove asteroid from the instance array
		asteroid.died.connect(_on_asteroid_death.bind(asteroid))
		
		add_child(asteroid)
		asteroid_added.emit()
		asteroidInstances.append(asteroid)

func _on_asteroid_death(asteroid: Asteroid) -> void:
	asteroidInstances.erase(asteroid)
	asteroid_removed.emit()
