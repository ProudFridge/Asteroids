extends Label

var isDisabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	get_tree().paused = true

	
func _input(event: InputEvent) -> void:
	if !isDisabled && event.is_action_pressed("space"):
		get_tree().paused = false
		hide()
		isDisabled = true
