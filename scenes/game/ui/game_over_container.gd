extends PanelContainer

@export var gameManager: GameManager
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var label: Label = $VBoxContainer/MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	gameManager.lost.connect(_on_game_manager_lost)
	gameManager.won.connect(_on_game_manager_won)
	restart_button.pressed.connect(_on_restart_button_pressed)


func _on_game_manager_lost() -> void:
	visible = true
	label.text = "Game Over!"
	
func _on_game_manager_won() -> void:
	visible = true
	label.text = "You Won!"


func _on_restart_button_pressed() -> void:
	SwitcherSingleton.goto_scene("res://scenes/game/game.tscn")
