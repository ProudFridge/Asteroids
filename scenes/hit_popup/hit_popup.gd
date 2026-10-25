extends Label
class_name HitPopup

var lifetime: float = 1
var floatSpeed: float = 3

const HIT_POPUP: Resource = preload("uid://bhd64dff6sk8k")
var timer: SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(func() -> void: self.queue_free())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a = remap(timer.time_left, 0, lifetime, 0,1)

	position.y += floatSpeed * delta


static func instantiagePopup(pos: Vector2, node: Node, txt: String) -> void:
	var hitPopup: HitPopup = HIT_POPUP.instantiate()
	hitPopup.text = txt
	hitPopup.position = pos
	node.add_child(hitPopup)
