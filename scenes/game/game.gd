extends Node

const ASTEROID: Resource = preload("res://scenes/asteroid/asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i: int in 10:
		var asteroid: Asteroid = ASTEROID.instantiate()
		# Todo: replace with actua lscren size, maybe use a singleton to store the screen size
		asteroid.position.x = randf_range(0, 800)
		asteroid.position.y = randf_range(0, 400)
		
		add_child(asteroid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
