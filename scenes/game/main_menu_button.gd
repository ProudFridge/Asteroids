extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_main_menu_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_main_menu_button_pressed() -> void:
	SwitcherSingleton.goto_scene("res://scenes/main_menu/main_menu.tscn")
