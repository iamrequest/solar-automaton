extends Control

@onready var scenes: SceneReferences = load("res://assets/scenes/scene_references.tres")
	
func _on_start_button_pressed() -> void:
	load_level(scenes.Scenes.Sunset)


func load_level(scene_enum: SceneReferences.Scenes):
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		return
	scene_base.load_scene(scenes.get_scene_path(scene_enum))


func _on_go_to_level_select_page_button_pressed() -> void:
	go_to_page($LevelSelectPage)
	
func _on_go_to_title_page_button_pressed() -> void:
	go_to_page($TitlePage)

func go_to_page(page: Control) -> void:
	$TitlePage.visible = false
	$LevelSelectPage.visible = false
	$CreditsPage.visible = false
	page.visible = true


func _on_lv_1_pressed() -> void:
	load_level(scenes.Scenes.Sunset)
