extends VBoxContainer

var transition_time: float = 0.1
var position_offset: Vector2 = Vector2(20, 0)
var tween: Tween

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	tween = get_tree().create_tween()
	
	
	# Enable offset transform and tween each button when they're hovered
	for i: int in get_children().size():
		var node: Node = get_children()[i]
		if node is Button:
			node.offset_transform_enabled = true
			node.offset_transform_position += (get_children().size() - i) * Vector2(35, 0)
	
	for node: Node in get_children():
		if node is Button:
			var originalOffset: Vector2 = node.offset_transform_position
			var tween: Tween
			node.mouse_entered.connect(_on_mouse_or_focus_entered.bind(node))
			node.focus_entered.connect(_on_mouse_or_focus_entered.bind(node))
			
			# Temporary fix, should also find a way to contain these inside a method like above
			node.mouse_exited.connect(
				func() -> void:
					if tween:
						tween.kill()
					tween = get_tree().create_tween()
					tween.tween_property(node, "offset_transform_position", originalOffset, transition_time)
					tween.set_ease(Tween.EASE_OUT)
					tween.set_trans(Tween.TRANS_EXPO)
					)
					
			node.focus_exited.connect(
				func() -> void:
					if tween:
						tween.kill()
					tween = get_tree().create_tween()
					tween.tween_property(node, "offset_transform_position", originalOffset, transition_time)
					tween.set_ease(Tween.EASE_OUT)
					tween.set_trans(Tween.TRANS_EXPO)
					)
			
			node.pressed.connect(
				func() -> void:
					AudioSingleton.play_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.UI_PRESSED)
			)
			
	# Focus the play button
	(get_children()[0] as Button).grab_focus.call_deferred()
	
	
func _on_mouse_or_focus_entered(button: Button) -> void:
	button.grab_focus.call_deferred()
	
	var originalOffset: Vector2 = button.offset_transform_position
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(button, "offset_transform_position", originalOffset + position_offset, transition_time)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
