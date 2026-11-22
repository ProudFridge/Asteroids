extends HBoxContainer

@export var player: Player
@export var progressBar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar.max_value = player.matter_component.current_matter
	progressBar.value = player.matter_component.current_matter


func _physics_process(_delta: float) -> void:
	if player:
		progressBar.value = player.matter_component.current_matter
