extends Label

@export var gameManager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameManager.lost.connect(_on_game_manager_lost)


func _on_game_manager_lost() -> void:
	visible = true
