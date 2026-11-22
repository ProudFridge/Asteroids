extends RigidBody2D
class_name Projectile

var speed: float = 500

var is_bouncy: bool = false
var bounces_left: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE


func disappear() -> void:
	queue_free.call_deferred()
