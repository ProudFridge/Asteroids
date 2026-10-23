extends Node
class_name StarsManager
# TODO: add variable for the amount of parallax and maybe all of this into a shader

var starAmount: int = 60 # star amount in a container with the size of repeat_size
var repeatSize: Vector2 = Vector2(1024, 1024)
var repeatTimes: int = 3
var layers: int = 3

var scrollScales: Array[Vector2] = [
	Vector2(0.05, 0.05), # smallStars
	Vector2(0.15, 0.15), # mediumStars
	Vector2(0.3, 0.3) # largeStars
]
var starAmountMultiplier: Array[float] = [5, 2, 1]
var starSizeRanges: Array[Vector2] = [Vector2(1, 2), Vector2(2, 3), Vector2(3, 5)]

# Array of main-sequence star colors taken from https://en.wikipedia.org/wiki/Stellar_classification
var starColors: Array[Color] = [
	Color("9bb0ff"),
	Color("aabfff"),
	Color("cad7ff"),
	Color("f8f7ff"),
	Color("fff4ea"),
	Color("ffd2a1"),
	Color("ffda9bff")]
	#Color("ffcc6f")]

func _ready() -> void:
	for i: int in layers:
		var layer: Parallax2D = Parallax2D.new()
		
		layer.scroll_scale = scrollScales[i]
		layer.repeat_size = repeatSize
		layer.repeat_times = repeatTimes
		layer.z_index = -10
		
		add_child(layer)
		
		for j: int in starAmount * starAmountMultiplier[i]:
			var star: Star = Star.new()
			star.size = randf_range(starSizeRanges[i].x , starSizeRanges[i].y)
			star.cornerRatio = randf_range(0, 0.5)
			star.position = Vector2(randf_range(0, repeatSize.x), randf_range(0, repeatSize.y))
			star.starVertices = randi_range(4, 8)
			star.color = generate_star_color()
			star.rotate(randf_range(0, 2 * PI))
			layer.add_child(star)
		

func generate_star_color() -> Color:
	var rand: int = randi_range(0, starColors.size() - 1)
	
	return starColors[rand]
