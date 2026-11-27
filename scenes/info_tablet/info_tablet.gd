extends RigidBody2D

@onready var panel_container: PanelContainer = $PanelContainer
@export var label: RichTextLabel
var message_delay: float = 5
var message_idx: int = 0

const messages: Array[String] = [
	"Blast imminent in 10 minutes",
	"Distance yourselves from the station"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioSingleton.play_2d_audio_at_location(global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.RADIO_CHATTER)
	label.visible_ratio = 0.2
	_next_message()

## Switch to the next message after a set delay
func _next_message() -> void:
	_tween_visible_ratio()
	label.text = messages[message_idx]
	get_tree().create_timer(message_delay).timeout.connect(
		func() -> void:
			if message_idx + 1 < messages.size():
				message_idx += 1
			else:
				message_idx = 0
			_next_message()
				)
## Tweens the [param visible_ratio] property of the label
func _tween_visible_ratio() -> void:
	label.visible_ratio = 0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1, message_delay * 0.5)

func _process(_delta: float) -> void:
	#panel_container.global_position = global_position + Vector2(20, -20)
	label.global_position = global_position - Vector2(0, 10)
