extends Node2D
class_name Holder

@export var tool: Tool
@onready var tool_location: Marker2D = $ToolLocation

const HOLDER: Resource = preload("uid://dxwoqcnyivk7s")

# TEMPORARY
var rectangle_size: Vector2 = Vector2(10, 3)
var notch_size: Vector2 = Vector2(4, 1)
var indicator_size: Vector2 =  Vector2(4, 1)

@onready var rectangle: MeshInstance2D = $Rectangle
@onready var notch: MeshInstance2D = $Notch
@onready var indicator: MeshInstance2D = $Indicator

@export var shooter: Player
#const WEAPON : Resource = preload("uid://cju3pee43b3e8")
var weapon: GunTest

static func instantiate(node: Node, pos: Vector2) -> void:
	var holder_instance: Holder = HOLDER.instantiate()
	holder_instance.position = pos
	node.add_child(holder_instance)

 #Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shooter = get_parent()
	
	tool_location.position = rectangle.position
	indicator.position = rectangle.position
	
	# Set up the look of the holder
	rectangle.mesh.size = rectangle_size
	notch.mesh.size = notch_size
	indicator.mesh.size = indicator_size
	
	rectangle.scale = Vector2.ONE
	notch.scale = Vector2.ONE
	
	rectangle.position = Vector2.ZERO
	notch.position = Vector2(0, rectangle_size.y / 2 + notch_size.y / 2)
	
	# Instantiate the weapon
	var weapon_resource: Resource = load("res://scenes/weapon/weapon.tscn")
	weapon = weapon_resource.instantiate()
	weapon.shooter = shooter
	weapon.z_index = 1
	weapon.scale *= 0.5
	add_child(weapon)
	weapon.position -= (weapon.tool_base.position - tool_location.position)
	
	weapon.cooldown_done.connect(_on_weapon_cooldown_done)
	weapon.cooldown_started.connect(_on_weapon_cooldown_started)
	
func _on_weapon_cooldown_done() -> void:
	indicator.modulate = Color.GREEN

func _on_weapon_cooldown_started() -> void:
	indicator.modulate = Color.RED
