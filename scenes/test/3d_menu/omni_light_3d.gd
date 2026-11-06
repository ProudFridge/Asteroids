extends OmniLight3D

var max_energy: float = 3
var min_energy: float = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var max_min: float = (max_energy - min_energy) / 2
	light_energy = max_min  * sin(float(Time.get_ticks_msec()) /450) + min_energy + max_min
	pass
