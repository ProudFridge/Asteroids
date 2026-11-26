extends Button

@onready var tutorial_layer: CanvasLayer = $"../../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_pressed() -> void:
	tutorial_layer.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		tutorial_layer.hide()
