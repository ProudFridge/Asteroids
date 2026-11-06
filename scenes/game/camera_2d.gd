extends Camera2D

@export var cameraZoom: Vector2 = Vector2(0.8, 0.8)
var zoomOutPercentage: float = 0.25

#@onready var noise: FastNoiseLite = FastNoiseLite.new()
#var noise_y: float = 0

@export var decay: float = 0.8
@export var max_offset: Vector2 = Vector2(100, 75)
@export var max_roll: float = 100

var trauma: float = 0
var trauma_power: int = 3
var noise_shake_speed: float = 10

func _ready() -> void:
	randomize()
	#noise.seed = randi()
	#noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	#noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	#noise.fractal_lacunarity = 1
	#noise.fractal_octaves = 2
	#noise.frequency = 0.01
	
	zoom = cameraZoom

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func _process(delta: float) -> void:
	#offset = (get_global_mouse_position() - global_position) * 0.01
	
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		_shake(delta)

func _shake(delta: float) -> void:
	#noise_y += noise_shake_speed * delta
	var amount: float = pow(trauma, trauma_power)
	
	#
	##rotation = max_roll * amount * noise.get_noise_2d(float(noise.seed), noise_y)
	###max_roll
	##offset.x = max_offset.x * amount * noise.get_noise_2d(float(noise.seed * 2), noise_y)
	##offset.y = max_offset.y * amount * noise.get_noise_2d(float(noise.seed * 3), noise_y)
	#
	
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", cameraZoom * (1 - zoomOutPercentage), 0.1)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
	
	if event.is_action_released("right_click"):
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "zoom", cameraZoom, 0.1)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		
	if event.is_action_pressed("shake"):
		add_trauma(300)
