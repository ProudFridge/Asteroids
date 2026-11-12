class_name Geometry

## Generates a convex polygon with n vertices
## taken from https://web.archive.org/web/20260416133431/https://cglab.ca/~sander/misc/ConvexGeneration/convex.html
static func generate_convex_polygon(n: int, boundingBox: Vector2) -> PackedVector2Array:
	
	# Generate two lists of n random integers
	var x_coords: Array[float] = []
	var y_coords: Array[float] = []
	
	for i: int in n:
		x_coords.append(randf_range(0, boundingBox.x))
		y_coords.append(randf_range(0, boundingBox.y))
	
	# Sort the two lists
	x_coords.sort()
	y_coords.sort()
	
	# Isolate the extreme points
	var min_x: float = x_coords[0]
	var max_x: float = x_coords[n - 1]
	var min_y: float = y_coords[0]
	var max_y: float = y_coords[n - 1]
	
	# Divide the interior points into two chains & Extract the vector components
	var x_vec: Array[float] = []
	var y_vec: Array[float] = []
	
	var last_top: float = min_x
	var last_bot: float = min_x
	
	for i: int in range(1, n - 1):
		var x: float = x_coords[i]
		
		if randi() % 2 == 0:
			x_vec.append(x - last_top)
			last_top = x
		else:
			x_vec.append(last_bot - x)
			last_bot = x
		
	x_vec.append(max_x - last_top)
	x_vec.append(last_bot - max_x)
	
	var last_left: float = min_y
	var last_right: float = min_y
	
	for i: int in range(1, n - 1):
		var y: float = y_coords[i]
		
		if randi() % 2 == 0:
			y_vec.append(y - last_left)
			last_left = y
		else:
			y_vec.append(last_right - y)
			last_right = y
	
	y_vec.append(max_y - last_left)
	y_vec.append(last_right - max_y)

	# Randomly pair up the x and y components
	y_vec.shuffle()
	
	var vec: Array[Vector2] = []
	
	for i: int in n:
		vec.append(Vector2(x_vec[i], y_vec[i]))
		
	vec.sort_custom(sort_by_angle)
	
	# Lay the points end to end and move the polygon to its original min and max coordinates
	var vec_pointer: Vector2 = Vector2.ZERO 
	var min_polygon: Vector2 = Vector2.ZERO
	var points: PackedVector2Array = []
	for i: int in n:
		points.append(vec_pointer)
		vec_pointer += Vector2(vec[i])
		min_polygon.x = min(min_polygon.x, vec_pointer.x)
		min_polygon.y = min(min_polygon.y, vec_pointer.y)
	
	var shift_x: float = min_x - min_polygon.x
	var shift_y: float = min_y - min_polygon.y
	
	for i: int in n:
		var p: Vector2 = points[i]
		points[i] = Vector2(p.x + shift_x, p.y + shift_y)
	
	## Center the polygon around (0,0)
	var c: Vector2 = Vector2.ZERO
	for v: Vector2 in points:
		c += v
	c = c / points.size()
	
	for i: int in n:
		points[i] -= c
		
	return points


## Populates the border of a polygon with random points 
## Currently does not work
static func populate_with_random_points(poly: PackedVector2Array) -> PackedVector2Array:
	var hull_poly: PackedVector2Array = Geometry2D.convex_hull(poly)
	var inside: int = 2
	var populated_polygon: PackedVector2Array = []
	
	for i: int in range(0, hull_poly.size() - 1):
		var vec: Vector2 = hull_poly[i + 1] - hull_poly[i]
		var length: float = vec.length()
		var unit: Vector2 = vec.normalized()
		
		var populated_segment: PackedVector2Array = []
		populated_segment.append(hull_poly[i])
		
		for r: int in inside:
			var rand: float = randf_range(1, length)
			populated_segment.append(hull_poly[i] + unit * rand)
		
		#populated_segment.sort()
		populated_polygon.append_array(populated_segment)
	
	#print(poly.size(), " ", populated_polygon.size(), " Expected:", poly.size() * (inside + 1))
	return populated_polygon
	

## Computes the area of a polygon with the coordinates of its vertices
static func compute_area(poly: PackedVector2Array) -> float:
	var totalSum: float = 0
	for i: int in poly.size():
		if i != poly.size() - 1:
			totalSum += poly[i].x * poly[i + 1].y - poly[i].y * poly[i + 1].x
		else:
			totalSum += poly[i].x * poly[0].y - poly[i].y * poly[0].x
	
	return abs(totalSum / 2)

## Sorts two vectors by their angle
static func sort_by_angle(a: Vector2, b: Vector2) -> bool:
	if a.angle() < b.angle():
		return true
	return false
