extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed() -> void:
	SwitcherSingleton.goto_scene("res://scenes/game/game.tscn")
