extends Node

const ASTEROID: Resource = preload("res://scenes/asteroid/asteroid.tscn")
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i: int in 10:
		var asteroid: Asteroid = ASTEROID.instantiate()
		# Todo: replace with actua lscren size, maybe use a singleton to store the screen size
		asteroid.position.x = randf_range(0, get_viewport().get_visible_rect().size.x)
		asteroid.position.y = randf_range(0, get_viewport().get_visible_rect().size.y)
		
		add_child(asteroid)
		
	player.died.connect(_on_player_died)

func _on_player_died() -> void:
	$GameOverLabel.visible = true
