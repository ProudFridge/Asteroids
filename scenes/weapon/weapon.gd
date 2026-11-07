extends Node2D

var auto_aim_radius: float = 500
var closest_asteroid: Asteroid = null
@export var lock_on_texture: Texture2D
@export var pointer_size: Vector2 = Vector2(50,50)
@export var player: Player

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape_2d.shape.radius = auto_aim_radius

# Draws the lock on texture
func _draw() -> void:
	if closest_asteroid:
		draw_texture(lock_on_texture, closest_asteroid.global_position - global_position - lock_on_texture.get_size() / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = player.position
	var min: float = INF
	
	if area_2d.has_overlapping_bodies():
		#print("Has overlapping bodies: ", area_2d.get_overlapping_bodies().size())
		for node: Node2D in area_2d.get_overlapping_bodies():
			if node is Asteroid:
				var asteroid: Asteroid = node as Asteroid
				
				# Manually lock onto asteroids that are closest to the mouse
				if Input.is_action_pressed("right_click"):
					var distance: Vector2 = asteroid.global_position - get_global_mouse_position()
					
					if (asteroid.global_position - global_position).length() < auto_aim_radius:
						if distance.length() < min:
							min = distance.length()
							closest_asteroid = asteroid
				# Lock onto the closest asteroids
				else:
					var distance: Vector2 = asteroid.global_position - global_position
				
					if distance.length() < auto_aim_radius:
						if distance.length() < min:
							min = distance.length()
							closest_asteroid = asteroid
	else:
		closest_asteroid = null
			
	if closest_asteroid:
		sprite_2d.rotation = (closest_asteroid.global_position - global_position).angle() + PI / 2
	queue_redraw()
