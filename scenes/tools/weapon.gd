@abstract
class_name Weapon extends Tool

# Activates the weapon's attack
# use()
@abstract
func use_weapon() -> void

signal weapon_cooldown_done
signal weapon_cooldown_started

var timer: SceneTreeTimer
var cooldown: float = 0.5
var is_cooldown_done: bool = true

func _ready() -> void:
	weapon_cooldown_done.connect(_on_weapon_cooldown_done)
	weapon_cooldown_started.connect(_on_weapon_cooldown_started)

# Handle the weapon cooldown
func _on_weapon_cooldown_done() -> void:
	is_cooldown_done = true
	
func _on_weapon_cooldown_started() -> void:
	is_cooldown_done = false
	get_tree().create_timer(cooldown).timeout.connect(func() -> void:
		weapon_cooldown_done.emit())

# Array to store abilities of different types for weapons
# Abilities array

enum WEAPON_TYPE {
	GUN
}
