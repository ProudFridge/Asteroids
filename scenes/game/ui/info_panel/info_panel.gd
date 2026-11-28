extends Control

@onready var player: Player = $"../../Player"

@export var health_bar: LinedProgressBar
@export var fuel_bar: LinedProgressBar
@export var matter_bar: LinedProgressBar

@export var integrity: Label
@export var fuel: Label
@export var matter: Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	fuel_bar.max_value = player.max_fuel
	
	matter_bar.min_value = 0
	matter_bar.max_value = player.matter_component.max_matter


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_bar.value = player.health
	fuel_bar.value = player.current_fuel
	matter_bar.value = player.matter_component.current_matter
	
	integrity.text = str(int(player.health))
	fuel.text = str(int(player.current_fuel))
	matter.text = str(int(player.matter_component.current_matter))
