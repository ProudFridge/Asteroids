extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_axis_velocity(Vector2(10,0))

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	angular_velocity = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
