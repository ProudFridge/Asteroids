extends HBoxContainer

@export var player: Player
@export var gameManager: GameManager
@export var progressBar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar.max_value = player.max_fuel
	progressBar.value = player.current_fuel


func _physics_process(_delta: float) -> void:
	if player:
		progressBar.value = player.current_fuel
