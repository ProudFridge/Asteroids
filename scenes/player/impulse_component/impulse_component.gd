extends Node2D
class_name ImpulseComponent

@export var player: Player

var impulse_magnitude: float = 400
var impulse_cooldown: float = 1

var impulse_fuel_consumption: float = 25

@onready var right_timer: Timer = $RightTimer
@onready var left_timer: Timer = $LeftTimer

@onready var right_thruster_particles: GPUParticles2D = $RightThrusterParticles
@onready var left_thruster_particles: GPUParticles2D = $LeftThrusterParticles

@onready var left_impulse_sprite: Sprite2D = $ImpulseSprites/LeftImpulseSprite
@onready var right_impulse_sprite: Sprite2D = $ImpulseSprites/RightImpulseSprite
@onready var left_impulse_light: PointLight2D = $ImpulseSprites/LeftImpulseLight
@onready var right_impulse_light: PointLight2D = $ImpulseSprites/RightImpulseLight

var impulse_light_energy: float = 2
var impulse_online_color: Color = Color.ORANGE
var impulse_offline_color: Color = Color.RED


signal impulse_depleated()
signal impulse_refilled()

func _ready() -> void:
	# Set the wait time
	right_timer.wait_time = impulse_cooldown
	left_timer.wait_time = impulse_cooldown
	
	# Manually set the position of the particles
	left_thruster_particles.position.y = -6
	right_thruster_particles.position.y = 6
	
	left_impulse_light.energy = impulse_light_energy
	right_impulse_light.energy = impulse_light_energy
	
	left_impulse_sprite.modulate = impulse_online_color
	left_impulse_light.color = impulse_online_color
	
	right_impulse_sprite.modulate = impulse_online_color
	right_impulse_light.color = impulse_online_color
	
	right_timer.timeout.connect(_on_right_timer_timeout)
	left_timer.timeout.connect(_on_left_timer_timeout)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("q"):
		if player.current_fuel >= impulse_fuel_consumption && right_timer.is_stopped():
			right_impulse_sprite.modulate = impulse_offline_color
			right_impulse_light.color = impulse_offline_color
			
			player.current_fuel -= impulse_fuel_consumption
			player.apply_central_impulse(Vector2.from_angle(player.rotation - PI / 2) * impulse_magnitude)
			right_thruster_particles.emitting = true
			right_timer.start()
			impulse_depleated.emit()
		else:
			AudioSingleton.play_2d_audio_at_location(player.position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_IMPULSE_ERROR)
		
	if event.is_action_pressed("e"):
		if player.current_fuel >= impulse_fuel_consumption && left_timer.is_stopped():
			left_impulse_sprite.modulate = impulse_offline_color
			left_impulse_light.color = impulse_offline_color
			
			player.current_fuel -= impulse_fuel_consumption
			player.apply_central_impulse(Vector2.from_angle(player.rotation + PI / 2) * impulse_magnitude)
			left_thruster_particles.emitting = true
			left_timer.start()
			impulse_depleated.emit()
		else:
			AudioSingleton.play_2d_audio_at_location(player.position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_IMPULSE_ERROR)


func _on_right_timer_timeout() -> void:
	right_impulse_sprite.modulate = impulse_online_color
	right_impulse_light.color = impulse_online_color
	
	impulse_refilled.emit()
	
	
func _on_left_timer_timeout() -> void:
	left_impulse_sprite.modulate = impulse_online_color
	left_impulse_light.color = impulse_online_color
	
	impulse_refilled.emit()
