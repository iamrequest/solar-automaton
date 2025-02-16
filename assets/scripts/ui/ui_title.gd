extends Control

@onready var scenes: SceneReferences = load("res://assets/scenes/scene_references.tres")
@export var health_readout: Label
@export var button_invincibility: Button

func _ready() -> void:
	button_invincibility.text = "Enabled" if Globals.invincibility_enabled else "Disabled"
	
func _on_start_button_pressed() -> void:
	load_level(scenes.Scenes.Sunset)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func load_level(scene_enum: SceneReferences.Scenes):
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		return
	scene_base.load_scene(scenes.get_scene_path(scene_enum))


func _on_go_to_level_select_page_button_pressed() -> void:
	go_to_page($LevelSelectPage)

func _on_go_to_credits_page_button_pressed() -> void:
	go_to_page($CreditsPage)
	
func _on_go_to_settings_page_button_pressed() -> void:
	go_to_page($SettingsPage)
	
func _on_go_to_title_page_button_pressed() -> void:
	go_to_page($TitlePage)

func go_to_page(page: Control) -> void:
	$TitlePage.visible = false
	$LevelSelectPage.visible = false
	$CreditsPage.visible = false
	$SettingsPage.visible = false
	page.visible = true


func _on_lv_1_pressed() -> void:
	load_level(scenes.Scenes.Sunset)


func _on_lv_2_pressed() -> void:
	load_level(scenes.Scenes.WormBoss)


func _on_health_decrease_pressed() -> void:
	Globals.health_max = max(1, Globals.health_max - 1)
	health_readout.text = str(Globals.health_max)

func _on_health_increase_pressed() -> void:
	Globals.health_max += 1
	health_readout.text = str(Globals.health_max)

func _on_health_reset_pressed() -> void:
	Globals.health_max = Globals.health_default
	health_readout.text = str(Globals.health_max)

func _on_invincibility_pressed() -> void:
	Globals.invincibility_enabled = !Globals.invincibility_enabled
	button_invincibility.text = "Enabled" if Globals.invincibility_enabled else "Disabled"
