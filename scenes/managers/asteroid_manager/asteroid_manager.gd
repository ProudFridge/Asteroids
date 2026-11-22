extends Node
class_name AsteroidManager
## Generates asteroid field, keeps track of current asteroids

# Called when the node enters the scene tree for the first time.
const ASTEROID: Resource = preload("res://scenes/asteroid/asteroid.tscn")

## Used to get the colors of the asteroid 
#@export var color_gradient: GradientTexture2D
@export var color_gradient: Gradient
@export var areaSize: Vector2 = Global.windowSize 
@export var instantiation_location: Vector2 = Vector2.ZERO
@export var asteroid_num: int = 10

@export var world_noise_map: FastNoiseLite

var asteroid_instances: Array[Asteroid] = []


signal asteroid_added
signal asteroid_removed(asteroid: Asteroid)


func _ready() -> void:
	instantiate_asteroids_in_area(asteroid_num, areaSize,instantiation_location, 100)
	

## Instantiates asteroids in a specified area
func instantiate_asteroids_in_area(asteroidNum: int, area: Vector2, location: Vector2, exclusionZoneRadius: float) -> void:
	for i: int in asteroidNum:
		#var asteroid: Asteroid = ASTEROID.instantiate()
		
		# Todo: replace with actual scren size, maybe use a singleton to store the screen size
		var position: Vector2 = Vector2(randf_range(location.x - area.x / 2, location.x + area.x / 2), randf_range(location.y - area.y / 2, location.y + area.y / 2))
		var velocity: Vector2 = (Vector2(Global.windowSize / 2) - position).normalized() * randf_range(10, 30)
		
		while position.distance_to(area / 2) < exclusionZoneRadius:
			position.x = randf_range(location.x - area.x / 2, location.x + area.x / 2)
			position.y = randf_range(location.y - area.y / 2, location.y + area.y / 2)
		
		instantiate_asteroid(position, velocity)


func instantiate_asteroid(position: Vector2, velocity: Vector2 = Vector2.ZERO) -> Asteroid:
	var size_modifier: float = 1
	var random_num: float = randf_range(0, 1)
	
	if random_num > 0.8:
		size_modifier = 0.3
	elif random_num < 0.95 && random_num >= 0.8:
		size_modifier = 1
	else:
		size_modifier = 2
	
	var asteroid_instance: Asteroid = ASTEROID.instantiate()
	
	asteroid_instance.boundingBox = asteroid_instance.boundingBox * 0.0001 * position.length() * size_modifier
	asteroid_instance.modulate = color_gradient.sample(position.length() / 50000)
	asteroid_instance.position = position
	asteroid_instance.linear_velocity = velocity
	asteroid_instance.angular_velocity = randf_range(-1, 1)
	asteroid_instance.died.connect(_on_asteroid_death.bind(asteroid_instance))
	asteroid_instances.append(asteroid_instance)
	
	asteroid_added.emit()
	add_child(asteroid_instance)
	
	return asteroid_instance


func _on_asteroid_death(asteroid: Asteroid) -> void:
	asteroid_instances.erase(asteroid)
	asteroid_removed.emit(asteroid)
