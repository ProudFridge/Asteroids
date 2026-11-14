extends Node2D
class_name Holder

@export var tool: Tool
@onready var tool_location: Marker2D = $ToolLocation


# TEMPORARY
@export var shooter: Player
#const WEAPON : Resource = preload("uid://cju3pee43b3e8")
var weapon: GunTest

 #Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var weapon_resource: Resource = load("res://scenes/weapon/weapon.tscn")
	weapon = weapon_resource.instantiate()
	weapon.shooter = shooter
	weapon.scale *= 2.5
	add_child(weapon)
	weapon.position -= (weapon.tool_base.position - tool_location.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
