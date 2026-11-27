extends Node2D

@export var text: String = ""
@export var detection_area: PackedVector2Array = [] 
@onready var mouse_detection_area: Area2D = $MouseDetectionArea
@onready var collision_polygon_2d: CollisionPolygon2D = $MouseDetectionArea/CollisionPolygon2D
@onready var panel_container: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/Label
var parent: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is Node2D:
		parent = get_parent()
	collision_polygon_2d.polygon = detection_area
	label.text = text
	mouse_detection_area.mouse_entered.connect(_on_mouse_detection_area_mouse_entered)
	mouse_detection_area.mouse_exited.connect(_on_mouse_detection_area_mouse_exited)

func _physics_process(delta: float) -> void:
	if parent:
		panel_container.global_position = parent.global_position + Vector2(10, 10)

func _draw() -> void:
	draw_colored_polygon(detection_area, Color.WHITE)
	
func _on_mouse_detection_area_mouse_entered() -> void:
	print("Mouse entered")
	panel_container.visible = true

func _on_mouse_detection_area_mouse_exited() -> void:
	print("Mouse exited")
	panel_container.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
