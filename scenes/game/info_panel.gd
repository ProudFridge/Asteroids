extends Control

@export var player: Player
@export var asteroid_manager: AsteroidManager

@export var position_value: Label
@export var distance_from_center_value: Label
@export var velocity_value: Label
@export var speed_value: Label
@export var angular_velocity_value: Label
@export var fuel_value: Label
@export var matter_value: Label
@export var asteroids_value: Label

func _ready() -> void:
	_set_label_values()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_set_label_values()

func _set_label_values() -> void:
	position_value.text = str(snappedf(player.global_position.x, 0.01)) + ", " + str(snappedf(player.global_position.y, 0.01))
	distance_from_center_value.text = str(snappedf(player.global_position.length(), 0.01))
	velocity_value.text = str(snappedf(player.linear_velocity.x, 0.01)) + ", " + str(snappedf(player.linear_velocity.y, 0.01))
	speed_value.text = str(snappedf(player.linear_velocity.length(), 0.01))
	angular_velocity_value.text = str(snappedf(player.angular_velocity, 0.01))
	fuel_value.text = str(snappedf(player.current_fuel, 0.01))
	matter_value.text = str(snappedf(player.matter_component.current_matter, 0.01))
	asteroids_value.text = str(asteroid_manager.asteroid_instances.size())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tab"):
		visible = !visible
