extends Camera2D

@export var player: Player
@export var gameManager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Global.windowSize / 2
	gameManager.won.connect(_on_game_manager_won)
	gameManager.lost.connect(_on_game_manager_lost)
	

func _on_game_manager_won() -> void:
	position = player.position
	zoom = Vector2(2,2)


func _on_game_manager_lost() -> void:
	position = player.position
	zoom = Vector2(2,2)
