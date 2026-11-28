extends PanelContainer

@export var game_manager: GameManager
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var label: Label = $VBoxContainer/MarginContainer/Label

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	game_manager.lost.connect(_on_game_manager_lost)
	game_manager.won.connect(_on_game_manager_won)
	restart_button.pressed.connect(_on_restart_button_pressed)


func _on_game_manager_lost() -> void:
	visible = true
	label.text = "Game Over!"
	
func _on_game_manager_won() -> void:
	print("Game won")
	visible = true
	label.text = "You Won!"


func _on_restart_button_pressed() -> void:
	SwitcherSingleton.goto_scene("res://scenes/game/game.tscn")
