extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_pressed() -> void:
	SwitcherSingleton.goto_scene("res://scenes/main_menu/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		SwitcherSingleton.goto_scene("res://scenes/main_menu/main_menu.tscn")
