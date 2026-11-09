extends Node2D
class_name ImpulseComponent

@export var player: Player

var impulse_magnitude: float = 400
var impulse_cooldown: float = 1

@onready var right_timer: Timer = $RightTimer
@onready var left_timer: Timer = $LeftTimer

@onready var right_thruster_particles: GPUParticles2D = $RightThrusterParticles
@onready var left_thruster_particles: GPUParticles2D = $LeftThrusterParticles

signal impulse_depleated()
signal impulse_refilled()

func _ready() -> void:
	right_timer.wait_time = impulse_cooldown
	left_timer.wait_time = impulse_cooldown
	
	left_thruster_particles.position.y = -6
	right_thruster_particles.position.y = 6
	
	right_timer.timeout.connect(_on_right_timer_timeout)
	left_timer.timeout.connect(_on_left_timer_timeout)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("q") && right_timer.is_stopped():
		player.apply_central_impulse(Vector2.from_angle(player.rotation - PI / 2) * impulse_magnitude)
		right_thruster_particles.emitting = true
		right_timer.start()
		impulse_depleated.emit()
		
	if event.is_action_pressed("e") && left_timer.is_stopped():
		player.apply_central_impulse(Vector2.from_angle(player.rotation + PI / 2) * impulse_magnitude)
		left_thruster_particles.emitting = true
		left_timer.start()
		impulse_depleated.emit()
		

func _on_right_timer_timeout() -> void:
	impulse_refilled.emit()
	
	
func _on_left_timer_timeout() -> void:
	impulse_refilled.emit()
