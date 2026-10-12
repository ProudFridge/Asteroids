extends Node

var currentScene: Node = null

func _ready() -> void:
	var root: Window = get_tree().root
	currentScene = root.get_child(-1)


func goto_scene(path: String) -> void:
	_deferred_goto_scene.call_deferred(path)
	

func _deferred_goto_scene(path: String) -> void:
	currentScene.free()
	
	var s: Resource = ResourceLoader.load(path)
	
	currentScene = s.instantiate()
	
	get_tree().root.add_child(currentScene)
	
	get_tree().current_scene = currentScene
