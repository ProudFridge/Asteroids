extends Node

const ASTEROID: Resource = preload("res://scenes/asteroid/asteroid.tscn")
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.died.connect(_on_player_died)

func _on_player_died() -> void:
	$UI/GameOverLabel.visible = true
