extends Label

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Lives: " + str(int(round(player.lives)))
	player.health_lost.connect(_on_player_health_lost)
	
func _on_player_health_lost(currentHealth: float) -> void:
	print(currentHealth)
	text = "Lives: " + str(int(round(currentHealth)))
	
