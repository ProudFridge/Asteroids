extends Weapon
class_name RocketLauncher

@export var shooter: Player

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#super._ready()

func use_weapon() -> void:
	References.bullet_manager.instantiate_bullet(global_position, global_rotation - PI / 2, BulletManager.BULLET_TYPE.ROCKET)
	weapon_cooldown_started.emit()
	

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_pressed("space") && is_cooldown_done:
		#use_weapon()
