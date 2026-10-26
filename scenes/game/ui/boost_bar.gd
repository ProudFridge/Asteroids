extends PanelContainer

@export var player: Player

@onready var progressBar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar.max_value = 2
	player.impulse_refilled.connect(_on_player_impulse_refilled)
	player.impulse_depleated.connect(_on_player_impulse_depleated)

func _on_player_impulse_depleated() -> void:
	progressBar.value -= 1

func _on_player_impulse_refilled() -> void:
	progressBar.value += 1
