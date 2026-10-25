extends ProgressBar

@export var player: Player
@export var gameManager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = player.boostTime
	value = player.currentBoostValue
	#gameManager.boostIncreased.connect(_on_game_manager_boost_increased)

#func _on_game_manager_boost_increased(newBoostValue: float) -> void:
	#if player:
		#value = newBoostValue

func _physics_process(delta: float) -> void:
	if player:
		value = player.currentBoostValue
