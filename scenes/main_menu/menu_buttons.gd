extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i: int in get_children().size():
		var node: Node = get_children()[i]
		if node is Button:
			node.offset_transform_enabled = true
			node.offset_transform_position += (get_children().size() - i) * Vector2(35, 0)
	
	for node: Node in get_children():
		if node is Button:
			var originalOffset: Vector2 = node.offset_transform_position
			var tween: Tween
			node.offset_transform_enabled = true
			node.mouse_entered.connect(
				func() -> void:
					if tween:
						tween.kill()
					tween = get_tree().create_tween()
					tween.tween_property(node, "offset_transform_position", originalOffset + Vector2(10, 0), 0.1)
					tween.set_ease(Tween.EASE_OUT)
					tween.set_trans(Tween.TRANS_EXPO)
					)
			node.mouse_exited.connect(
				func() -> void:
					if tween:
						tween.kill()
					tween = get_tree().create_tween()
					tween.tween_property(node, "offset_transform_position", originalOffset, 0.1)
					tween.set_ease(Tween.EASE_OUT)
					tween.set_trans(Tween.TRANS_EXPO)
					)
		
