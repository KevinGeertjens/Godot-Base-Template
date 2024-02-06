extends Node

func change_scene(newSceneResource: Resource) -> void:
	var root = get_tree().get_root()
	var currentScene = get_tree().current_scene
	
	root.remove_child(currentScene)
	currentScene.call_deferred("free") #Frees scene from memory
	
	var newSceneInstance = newSceneResource.instantiate()
	root.add_child(newSceneInstance)
	get_tree().current_scene = newSceneInstance
