extends Node
## Useful scripts for developement
## Intended to be used as a singleton

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
