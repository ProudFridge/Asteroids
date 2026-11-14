extends Node2D
class_name Holder

@export var tool: Tool
@onready var tool_location: Marker2D = $ToolLocation
#const WEAPON : Resource = preload("uid://cju3pee43b3e8")

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var weapon_instance: GunTest = WEAPON.instantiate()
	##weapon_instance.position -= (weapon_instance.tool_base.position - tool_location.position)
	#add_child(weapon_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
