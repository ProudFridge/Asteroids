extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		get_tree().paused = !get_tree().paused
		visible = !visible
