extends Camera2D

@export var cameraZoom: Vector2 = Vector2(0.8, 0.8)
var zoomOutPercentage: float = 0.25

func _ready() -> void:
	zoom = cameraZoom

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", cameraZoom * (1 - zoomOutPercentage), 0.1)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
	
	if event.is_action_released("right_click"):
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", cameraZoom, 0.1)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		
