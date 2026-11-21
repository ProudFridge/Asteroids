extends Label

@export var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "Time Left: " + str(snappedf(game_manager.game_timer.time_left, 1))
