extends Node
class_name StarsManager

var starAmount: int = 50 # star amount in a container with the size of repeat_size
var repeatSize: Vector2 = Vector2(1024, 1024)
var repeatTimes: int = 8


func _ready() -> void:
	# Create parallax layers
	var smallStars: Parallax2D = Parallax2D.new()
	var mediumStars: Parallax2D = Parallax2D.new()
	var largeStars: Parallax2D = Parallax2D.new()
	
	smallStars.scroll_scale = Vector2(0.05, 0.05)
	mediumStars.scroll_scale = Vector2(0.15, 0.15)
	largeStars.scroll_scale = Vector2(0.3, 0.3)
	
	smallStars.repeat_size = repeatSize
	mediumStars.repeat_size = repeatSize
	largeStars.repeat_size = repeatSize
	
	smallStars.repeat_times = repeatTimes
	mediumStars.repeat_times = repeatTimes
	largeStars.repeat_times = repeatTimes
	
	smallStars.z_index = -10
	mediumStars.z_index = -10
	largeStars.z_index = -10
	
	add_child(smallStars)
	add_child(mediumStars)
	add_child(largeStars)
	
	# Add stars to each layer
	for i: int in starAmount:
		var star: Star = Star.new()
		star.size = randf_range(1, 2)
		star.cornerRatio = randf_range(0, 0.5)
		star.position = Vector2(randf_range(0, repeatSize.x), randf_range(0, repeatSize.y))
		smallStars.add_child(star)
	
	for i: int in starAmount:
		var star: Star = Star.new()
		star.size = randf_range(2, 3)
		star.cornerRatio = randf_range(0, 0.5)
		star.position = Vector2(randf_range(0, repeatSize.x), randf_range(0, repeatSize.y))
		mediumStars.add_child(star)
		
	for i: int in starAmount:
		var star: Star = Star.new()
		star.size = randf_range(3, 5)
		star.cornerRatio = randf_range(0, 0.5)
		star.position = Vector2(randf_range(0, repeatSize.x), randf_range(0, repeatSize.y))
		largeStars.add_child(star)
