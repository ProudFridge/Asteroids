extends PanelContainer

@export var player: Player

@onready var position_value: Label = $GridContainer/PositionValue
@onready var distance_from_center_value: Label = $GridContainer/DistanceFromCenterValue
@onready var velocity_value: Label = $GridContainer/VelocityValue
@onready var speed_value: Label = $GridContainer/SpeedValue
@onready var angular_velocity_value: Label = $GridContainer/AngularVelocityValue
@onready var fuel_value: Label = $GridContainer/FuelValue

func _ready() -> void:
	_set_label_values()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_set_label_values()

func _set_label_values() -> void:
	position_value.text = str(snappedf(player.global_position.x, 0.01)) + ", " + str(snappedf(player.global_position.y, 0.01))
	distance_from_center_value.text = str(snappedf(player.global_position.length(), 0.01))
	velocity_value.text = str(snappedf(player.linear_velocity.x, 0.01)) + ", " + str(snappedf(player.linear_velocity.y, 0.01))
	speed_value.text = str(snappedf(player.linear_velocity.length(), 0.01))
	angular_velocity_value.text = str(snappedf(player.angular_velocity, 0.01))
	fuel_value.text = str(snappedf(player.current_fuel, 0.01))
