extends Node
class_name AsteroidManager
## Generates asteroid field, keeps track of current asteroids

# Called when the node enters the scene tree for the first time.
const ASTEROID: Resource = preload("res://scenes/asteroid/asteroid.tscn")

## Used to get the colors of the asteroid 
@export var color_gradient: Gradient
@export var area_radius: float = Global.windowSize.x
@export var instantiation_location: Vector2 = Vector2.ZERO
@export var asteroid_num: int = 10

#@export var world_noise_map: FastNoiseLite
@export var noise_map: NoiseTexture2D

var asteroid_instances: Array[Asteroid] = []

signal asteroid_added
signal asteroid_removed(asteroid: Asteroid)

func _ready() -> void:
	#instantiate_asteroids_in_area(asteroid_num, area_radius, instantiation_location, 500)
	instantiate_asteroids_in_grid(Vector2(20, 20), Vector2(256, 256), instantiation_location)

## Instantiates asteroids in a specified area
func instantiate_asteroids_in_area(asteroid_amount: int, area_radius: float, location: Vector2, exclusion_zone_radius: float) -> void:
	for i: int in asteroid_amount:
		var random_length: float = randf_range(exclusion_zone_radius, area_radius)
		var random_angle: float = randf_range(-PI, PI)
		var position: Vector2 = Vector2.from_angle(random_angle) * random_length + location
		
		var velocity: Vector2 = Vector2.from_angle(randf_range(-PI, PI)) * randf_range(10, 30)
		
		instantiate_asteroid(position, velocity)

func instantiate_asteroids_in_grid(grid_size: Vector2, spacing: Vector2, location: Vector2) -> void:
	for i: int in grid_size.x:
		for j: int in grid_size.y:
			var pos_x: float = i * spacing.x 
			var pos_y: float = j * spacing.y
		
			instantiate_asteroid(Vector2(pos_x, pos_y) + spacing / 2, Vector2.ZERO)

func instantiate_asteroid(position: Vector2, velocity: Vector2 = Vector2.ZERO) -> Asteroid:
	var size_modifier: float = 1
	size_modifier = max(abs(noise_map.noise.get_noise_2d(position.x, position.y)), 0.2) * 5
	#var random_num: float = randf_range(0, 1)
	#
	#if random_num > 0.8:
		#size_modifier = 0.3
	#elif random_num < 0.95 && random_num >= 0.8:
		#size_modifier = 1
	#else:
		#size_modifier = 2
	
	#var noise_value: float = world_noise_map.get_noise_2d(position.x, position.y)
	#var size_multiplier: float = 1
	#if abs(noise_value) < 0.2:
		#size_multiplier = 100
	
	var asteroid_instance: Asteroid = ASTEROID.instantiate()
	
	#asteroid_instance.boundingBox = asteroid_instance.boundingBox * 0.0001 * position.length() * size_modifier
	asteroid_instance.boundingBox = asteroid_instance.boundingBox * size_modifier
	#asteroid_instance.boundingBox = asteroid_instance.boundingBox * 0.1 * size_modifier * size_multiplier
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
