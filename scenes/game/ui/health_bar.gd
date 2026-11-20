extends ProgressBar

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = player.health
	max_value = player.health
	player.health_lost.connect(_on_player_health_lost)


func _on_player_health_lost(currentHealth: float) -> void:
	value = currentHealth
