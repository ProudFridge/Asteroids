extends Node
## Useful scripts for developement
## Intended to be used as a singleton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit") and OS.is_debug_build():
		get_tree().quit()
