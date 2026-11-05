extends VBoxContainer

var transition_time: float = 0.1
var position_offset: Vector2 = Vector2(20, 0)

var entered_tween: Tween
var exited_tween: Tween

# Store the original offsets of each button before tweening them
var original_offsets: Dictionary[Button, Vector2] = {}

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Enable offset transform and offset each button slightly depending on how low they are
	for i: int in get_children().size():
		var node: Node = get_children()[i]
		if node is Button:
			node.offset_transform_enabled = true
			node.offset_transform_position += (get_children().size() - i) * Vector2(35, 0)
			original_offsets[(node as Button)] = node.offset_transform_position
	
	
	for node: Node in get_children():
		if node is Button:
			var button: Button = node as Button
			#original_offsets.append(node, node.offset_transform_position)
			
			node.focus_entered.connect(_on_mouse_or_focus_entered.bind(button))
			node.mouse_entered.connect(_on_mouse_or_focus_entered.bind(button))
			
			node.focus_exited.connect(_on_mouse_or_focus_exited.bind(button))
			node.mouse_exited.connect(_on_mouse_or_focus_exited.bind(button))
			
			node.pressed.connect(
				func() -> void:
					AudioSingleton.play_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.UI_PRESSED)
			)
			
	# Focus the play button
	(get_children()[0] as Button).grab_focus.call_deferred()
	
	
func _on_mouse_or_focus_entered(button: Button) -> void:
	button.grab_focus.call_deferred()
	
	if entered_tween:
		entered_tween.kill()
	entered_tween = get_tree().create_tween()
	entered_tween.tween_property(button, "offset_transform_position", original_offsets[button] + position_offset, transition_time)
	entered_tween.set_ease(Tween.EASE_OUT)
	entered_tween.set_trans(Tween.TRANS_EXPO)


func _on_mouse_or_focus_exited(button: Button) -> void:
	if exited_tween:
		exited_tween.kill()
	exited_tween = get_tree().create_tween()
	offset_transform_position = original_offsets[button]
	exited_tween.tween_property(button, "offset_transform_position", original_offsets[button], transition_time)
	exited_tween.set_ease(Tween.EASE_OUT)
	exited_tween.set_trans(Tween.TRANS_EXPO)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_viewport().gui_release_focus()
