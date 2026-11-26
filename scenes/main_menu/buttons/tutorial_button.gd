extends Button

@onready var tutorial_layer: CanvasLayer = $"../../../TutorialLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_tutorial_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tutorial_button_pressed() -> void:
	tutorial_layer.visible = true
