extends VBoxContainer

@export var gameManager: GameManager
@onready var restart_button: Button = $RestartButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	gameManager.lost.connect(_on_game_manager_lost)
	restart_button.pressed.connect(_on_restart_button_pressed)


func _on_game_manager_lost() -> void:
	visible = true


func _on_restart_button_pressed() -> void:
	SwitcherSingleton.goto_scene("res://scenes/game/game.tscn")
