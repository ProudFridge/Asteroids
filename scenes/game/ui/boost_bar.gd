extends ProgressBar

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = player.boostTime
	value = player.currentBoostValue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player:
		value = player.currentBoostValue
