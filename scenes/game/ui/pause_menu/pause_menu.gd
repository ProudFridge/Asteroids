extends PanelContainer

@export var gameManager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	# TODO: make it so that the pause menu is still visible when the game hasn't begun yet, but you can't start the game when it's visible
	if gameManager.isGameRunning && event.is_action_pressed("pause_game"):
		get_tree().paused = !get_tree().paused
		visible = !visible
