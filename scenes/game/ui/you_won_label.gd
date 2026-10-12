extends Label

@export var gameManager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameManager.won.connect(_on_game_manager_won)


func _on_game_manager_won() -> void:
	visible = true
