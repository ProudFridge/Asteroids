extends Parallax2D

var starAmount: int = 50 # star amount in a container with the size of repeat_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i: int in starAmount:
		var star: Star = Star.new()
		star.size = randf_range(1, 5)
		star.cornerRatio = randf_range(0, 0.5)
		star.position = Vector2(randf_range(0, repeat_size.x), randf_range(0, repeat_size.y))
		add_child(star)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
