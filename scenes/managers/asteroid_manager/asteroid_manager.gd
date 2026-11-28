extends Node
class_name AsteroidManager
## Generates asteroid field, keeps track of current asteroids

const ASTEROID: Resource = preload("res://scenes/asteroid/asteroid.tscn")
const FUEL_SHARD: Resource = preload("uid://bf7lvmej1g1g0")
const MATTER_SHARD: Resource = preload("uid://crjxi3170t00j")


## Used to get the colors of the asteroid 
@export var color_gradient: Gradient
@export var area_radius: float = Global.windowSize.x
@export var instantiation_location: Vector2 = Vector2.ZERO
@export var asteroid_num: int = 10

#@export var world_noise_map: FastNoiseLite
@export var noise_map: NoiseTexture2D

var asteroid_instances: Array[Asteroid] = []

signal asteroid_added
## Emitted when an asteroid is removed from the game
signal asteroid_removed(asteroid: Asteroid)
## Emited when an asteroid is destroyed by the player
signal asteroid_destroyed(asteroid: Asteroid)

func _ready() -> void:
	instantiate_asteroids_in_area(asteroid_num, area_radius, instantiation_location, 10000)
	#instantiate_asteroids_in_grid(Vector2(30, 30), Vector2(256, 256), instantiation_location)

## Instantiates asteroids in a specified area
func instantiate_asteroids_in_area(asteroid_amount: int, area_radius: float, location: Vector2, exclusion_zone_radius: float) -> void:
	for i: int in asteroid_amount:
		var random_length: float = randf_range(exclusion_zone_radius, area_radius)
		var position: Vector2 = Geometry.generate_random_vector(random_length)
		
		var velocity: Vector2 = Vector2.from_angle(randf_range(-PI, PI)) * randf_range(10, 30)
		
		instantiate_asteroid(position, velocity)


func instantiate_asteroids_in_grid(grid_size: Vector2, spacing: Vector2, location: Vector2) -> void:
	for i: int in grid_size.x:
		for j: int in grid_size.y:
			var pos_x: float = i * spacing.x 
			var pos_y: float = j * spacing.y
		
			instantiate_asteroid(Vector2(pos_x, pos_y) + spacing / 2, Vector2.ZERO)


func instantiate_asteroid(position: Vector2, velocity: Vector2 = Vector2.ZERO) -> Asteroid:
	#var multiplier: float = 1
	#var rand: float = randf_range(0, 1)
	#if rand < 0.2:
		#multiplier = 3
	#elif rand >= 0.2 && rand < 0.3 :
		#multiplier = 6
	#boundingBox *= multiplier
	
	var size_modifier: float = 1
	# Modify the size of the astroid based off of the noise map
	size_modifier *= max(abs(noise_map.noise.get_noise_2d(position.x, position.y)), 0.2) * 5
	# Modify the size of the asteroid based off of it's distance from the player
	size_modifier *= 0.0001 * position.length()
	# Cap the modifer value
	size_modifier = max(size_modifier, 0.2)
	
	var asteroid_instance: Asteroid = ASTEROID.instantiate()
	
	asteroid_instance.boundingBox = asteroid_instance.boundingBox * size_modifier
	#asteroid_instance.boundingBox = asteroid_instance.boundingBox * 0.1 * size_modifier * size_multiplier
	asteroid_instance.modulate = color_gradient.sample(position.length() / 50000)
	asteroid_instance.position = position
	asteroid_instance.linear_velocity = velocity
	asteroid_instance.angular_velocity = randf_range(-1, 1)
	asteroid_instance.removed.connect(_on_asteroid_removed.bind(asteroid_instance))
	asteroid_instance.died.connect(_on_asteroid_died.bind(asteroid_instance))
	asteroid_instances.append(asteroid_instance)
	
	asteroid_added.emit()
	add_child(asteroid_instance)
	
	return asteroid_instance

## Instantiates a fuel shard at the specified [param position]
func instantiate_fuel_shard(position: Vector2) -> void:
	var fuel_shard_instance: FuelShard = FUEL_SHARD.instantiate()
	var vec_length: float = randf_range(5, 15)
	var speed_multiplier: float = randf_range(0.5, 1.5)
	
	fuel_shard_instance.position = Geometry.generate_random_vector(vec_length, position)
	#fuel_shard_instance.position = position + Vector2(cos(rand_angle) * vec_length, sin(rand_angle) * vec_length)
	fuel_shard_instance.linear_velocity = (fuel_shard_instance.position - position) * 5 * speed_multiplier
	get_parent().add_child(fuel_shard_instance)

## Instantiates a matter shard at the specified [param position]
func instantiate_matter_shard(position: Vector2) -> void:
	var matter_shard_instance: MatterShard = MATTER_SHARD.instantiate()
	var vec_length: float = randf_range(5, 15)
	var speed_multiplier: float = randf_range(0.5, 1.5)
	
	matter_shard_instance.position = Geometry.generate_random_vector(vec_length, position)
	#matter_shard_instance.position = position + Vector2(cos(rand_angle) * vec_length, sin(rand_angle) * vec_length)
	matter_shard_instance.linear_velocity = (matter_shard_instance.position - position) * 5 * speed_multiplier
	get_parent().add_child(matter_shard_instance)


func _on_asteroid_removed(asteroid: Asteroid) -> void:
	asteroid_instances.erase(asteroid)
	asteroid_removed.emit(asteroid)


func _on_asteroid_died(asteroid: Asteroid) -> void:
	asteroid_instances.erase(asteroid)
	asteroid_destroyed.emit(asteroid)
