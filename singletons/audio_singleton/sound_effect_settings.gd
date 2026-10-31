extends Resource
class_name SoundEffectSettings

enum SOUND_EFFECT_TYPE {
	ON_ASTEROID_COLLISION,
	ON_SHOOT,
	TEST
}

## Amount of AudioPlayers that can be on the scene at the same time
@export_range(0, 10) var limit: int = 5
## The sound effect type associated with each SoundEffectSettings
@export var type: SOUND_EFFECT_TYPE
## Array of streams that will be played. If the array only has 1 stream, the singleton will always play that one
@export var sound_effect: Array[AudioStreamWAV] = []
## Volume of the stream
@export_range(-40, 20) var volume: float = 0
## Pitch scale of the stream
@export_range(0.0, 4.0, 0.01) var pitch_scale: float = 1.0
## Determines the random value that will be added to pitch scale
@export_range(0.0, 1.0, 0.01) var pitch_randomness: float = 0.0

var audio_count: int = 0

## Current AudioStreamPlayers playing this sound
var audio_stream_players: Array[AudioStreamPlayer2D] = []

func change_audio_count(amount: int) -> void:
	audio_count = max(0, audio_count + amount)
	
func has_open_limit() -> bool:
	return audio_count < limit
	
func on_audio_finished() -> void:
	change_audio_count(-1)
