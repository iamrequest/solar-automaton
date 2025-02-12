extends Control


@export var scenes: SceneReferences


func _on_quit_button_pressed() -> void:
	quit_game()


func _on_retry_button_pressed() -> void:
	reload_scene()

func _on_unpause_button_pressed() -> void:
	unpause()

func unpause():
	%GameManager.toggle_pause(false)


func reload_scene():
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		print("Unable to reload scene - can't find XRToolsSceneBase")
		return
	scene_base.reset_scene()

func quit_game():
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
			return
	scene_base.load_scene(scenes.title.resource_path)
