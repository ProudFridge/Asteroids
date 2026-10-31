extends Node
## Intended to be used as a singleton
## Adapted from this video: https://www.youtube.com/watch?v=Egf2jgET3nQ

@export var sound_effect_settings: Array[SoundEffectSettings]

var sound_effect_dict: Dictionary[SoundEffectSettings.SOUND_EFFECT_TYPE, SoundEffectSettings] = {}

func _ready() -> void:
	for sound_effect_setting: SoundEffectSettings in sound_effect_settings:
		sound_effect_dict[sound_effect_setting.type] = sound_effect_setting

func play_2d_audio_at_location(position: Vector2, sound_effect_type: SoundEffectSettings.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(sound_effect_type):
		var sound_effect_setting: SoundEffectSettings = sound_effect_dict[sound_effect_type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var audio_stream_player_2d: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(audio_stream_player_2d)
			
			# Assign all the variables
			audio_stream_player_2d.position = position
			
			var random_stream: AudioStreamWAV = sound_effect_setting.sound_effect[randi_range(0, sound_effect_setting.sound_effect.size() - 1)]
			audio_stream_player_2d.stream = random_stream
			audio_stream_player_2d.volume_db = sound_effect_setting.volume
			audio_stream_player_2d.pitch_scale = sound_effect_setting.pitch_scale
			audio_stream_player_2d.pitch_scale += randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			audio_stream_player_2d.finished.connect(sound_effect_setting.on_audio_finished)
			audio_stream_player_2d.finished.connect(audio_stream_player_2d.queue_free)
			
			audio_stream_player_2d.play()
		else:
			push_error("Audio Singleton failed to find setting for type: ", sound_effect_type)

	
func play_audio(sound_effect_type: SoundEffectSettings.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(sound_effect_type):
		var sound_effect_setting: SoundEffectSettings = sound_effect_dict[sound_effect_type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(audio_stream_player)
			
			# Assign all the variables
			var random_stream: AudioStreamWAV = sound_effect_setting.sound_effect[randi_range(0, sound_effect_setting.sound_effect.size() - 1)]
			audio_stream_player.stream = random_stream
			audio_stream_player.volume_db = sound_effect_setting.volume
			audio_stream_player.pitch_scale = sound_effect_setting.pitch_scale
			audio_stream_player.pitch_scale += randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			audio_stream_player.finished.connect(sound_effect_setting.on_audio_finished)
			audio_stream_player.finished.connect(audio_stream_player.queue_free)

			audio_stream_player.play()
	else:
		push_error("Audio Singleton failed to find setting for type: ", sound_effect_type)
#
#func stop_playing_audio(sound_effect_type: SoundEffectSettings.SOUND_EFFECT_TYPE) -> void:
	#if sound_effect_dict.has(sound_effect_type):
		#var sound_effect_setting: SoundEffectSettings = sound_effect_dict[sound_effect_type]
		#sound_effect_setting.audio_stream_players.all(AudioStreamPlayer.stop)
