extends HBoxContainer

@export var player: Player
@export var gameManager: GameManager
@export var progressBar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar.max_value = player.boostTime
	progressBar.value = player.currentBoostValue
	#gameManager.boostIncreased.connect(_on_game_manager_boost_increased)

#func _on_game_manager_boost_increased(newBoostValue: float) -> void:
	#if player:
		#value = newBoostValue

func _physics_process(_delta: float) -> void:
	if player:
		progressBar.value = player.currentBoostValue
