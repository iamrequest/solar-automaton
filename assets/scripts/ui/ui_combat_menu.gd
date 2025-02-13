extends Control

@export var scenes: SceneReferences

func _on_quit_button_pressed() -> void:
	quit_game()


func _on_retry_button_pressed() -> void:
	reload_scene()


func _on_unpause_button_pressed() -> void:
	unpause()
	
func _on_next_level_button_pressed() -> void:
	Globals.game_manager.load_next_level()

func unpause():
	# Viewport isn't in the tree I guess?
	Globals.game_manager.toggle_pause(false)

func reload_scene():
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		print("Unable to reload scene - can't find XRToolsSceneBase")
		return
	unpause()
	scene_base.reset_scene()

func quit_game():
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		return
	unpause()
	scene_base.load_scene(scenes.get_scene_path(SceneReferences.Scenes.Title))
