@tool
extends Control
class_name LinedProgressBar

@export var sections: int = 10:
	set(new_value):
		sections = new_value
		queue_redraw()
@export var line_width: float = 2:
	set(new_value):
		line_width = new_value
		queue_redraw()
@export var line_color: Color = Color.WHITE:
	set(new_value):
		line_color = new_value
		queue_redraw()

var seperation: float

#region progress_bar
@export_category("Range")
@export var value: float = 0:
	set(new_value):
		value = new_value
		queue_redraw()
@export var min_value: float = 0:
		set(new_value):
			min_value = new_value
			queue_redraw()
@export var max_value: float = 100:
		set(new_value):
			max_value = new_value
			queue_redraw()
@export_category("")
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(size.x)
	seperation = size.x / sections

func _draw() -> void:
	#await get_tree().process_frame
	seperation = size.x / (sections - 1)
	for i: int in sections:
		var remapped_value: float = remap(value, min_value, max_value, 0, sections)
		var line_opacity: float = remapped_value - int(remapped_value)
		
		# Draw the last line with a different opacity than the rest
		if remapped_value - i < 1 && remapped_value - i > 0:
			draw_line(Vector2(i * seperation, 0), Vector2(i * seperation, size.y), Color(line_color, line_opacity), line_width)
		elif i < remapped_value:
			draw_line(Vector2(i * seperation, 0), Vector2(i * seperation, size.y), line_color, line_width)
	
	#draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#value += 10 * delta
	#if value > max_value:
		#value = min_value
	#queue_redraw()
