extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_quit_button_pressed)


func _on_quit_button_pressed() -> void:
	get_tree().quit()	
