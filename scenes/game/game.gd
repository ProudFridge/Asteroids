extends Node

@onready var left: CollisionShape2D = $Bounds/Left
@onready var right: CollisionShape2D = $Bounds/Right
@onready var top: CollisionShape2D = $Bounds/Top
@onready var bottom: CollisionShape2D = $Bounds/Bottom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left.position = Vector2(0,0)
	right.position = Vector2(Global.windowSize.x, 0)
	top.position = Vector2(0,0)
	bottom.position = Vector2(0, Global.windowSize.y)
	
	left.rotate(PI / 2)
	right.rotate(-PI / 2)
	top.rotate(PI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
