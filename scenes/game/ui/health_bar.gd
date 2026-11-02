extends ProgressBar

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = player.lives
	player.health_lost.connect(_on_player_health_lost)
	pass # Replace with function body.


func _on_player_health_lost(currentHealth: float) -> void:
	value = currentHealth
