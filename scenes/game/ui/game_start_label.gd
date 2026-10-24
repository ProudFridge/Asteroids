extends Label

@export var gameManager: GameManager
var isDisabled: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	get_tree().paused = true


func _process(delta: float) -> void:
	modulate = Color.from_hsv(0, 0, 0.7 + 0.3 * sin(float(Time.get_ticks_msec()) / 300))


func _input(event: InputEvent) -> void:
	if !isDisabled && event.is_action_pressed("space"):
		get_tree().paused = false
		hide()
		isDisabled = true
		gameManager.isGameRunning = true
