extends Node
## Intended to be used as a singleton


func playSound(path: String, position: Vector2) -> void:
	var audioStreamPlayer: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audioStreamPlayer.stream = AudioStreamWAV.load_from_file(path, {"force/max_rate": true, "force/max_rate_hz": 11025})
	audioStreamPlayer.position = position
	add_child(audioStreamPlayer)
	
	#audioStreamPlayer.volume_db = 10
	audioStreamPlayer.play()
	
	audioStreamPlayer.finished.connect(func() -> void: audioStreamPlayer.queue_free())
