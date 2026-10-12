extends Node2D
class_name BlinkComponent
## not working rn

@onready var blink_interval_timer: Timer = $BlinkIntervalTimer

@export var blinkInterval: float = 1
@export var totalBlinks: int = 5
@export var color1: Color = Color.SLATE_GRAY
@export var color2: Color = Color.RED
@export var actor: Node2D

var originalModulate: Color 
var currentBlinks: int = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	originalModulate = actor.modulate
	blink_interval_timer.wait_time = blinkInterval
	blink_interval_timer.timeout.connect(_on_blink_interval_timer_timeout)


func blink() -> void:
	blink_interval_timer.start()
	actor.self_modulate = color1
	currentBlinks += 1


func _on_blink_interval_timer_timeout() -> void:
	if currentBlinks % 2 == 0:
		actor.modulate = color1
	else:
		actor.modulate = color2
	currentBlinks += 1

	if currentBlinks >= totalBlinks:
		blink_interval_timer.stop()
		actor.self_modulate = Color.WHEAT
		currentBlinks = 0
	else:
		_on_blink_interval_timer_timeout()
		
