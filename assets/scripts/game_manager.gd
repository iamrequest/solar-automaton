extends Node
class_name GameManager

signal on_level_completed
signal on_level_failed

signal on_paused
signal on_unpaused

var is_paused:= false
var is_game_over:= false

var currency:= 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Globals.game_manager = self
	
	await get_tree().process_frame 
	Globals.xr_rig.get_non_dominant_hand().button_pressed.connect(on_non_dominant_input_pressed)


func _on_ship_on_death() -> void:
	is_game_over = true
	$LevelFailedTimer.start()
	await $LevelFailedTimer.timeout
	on_level_failed.emit()


func _on_combat_zone_manager_on_level_end() -> void:
	is_game_over = true
	on_level_completed.emit()


@export var next_level: SceneReferences.Scenes
func load_next_level() -> void:
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		return
		
	var scenes = load("res://assets/scenes/scene_references.tres") as SceneReferences
	scene_base.load_scene(scenes.get_scene_path(next_level))
	

#region Pausing	
func on_non_dominant_input_pressed(name: String):
	if(name == "ax_button"):
		toggle_pause(true)
	elif(name == "by_button"):
		toggle_pause(true)
			
			
func toggle_pause(is_paused: bool) -> void:
	if(self.is_paused == is_paused):
		return
	
	self.is_paused = is_paused
	get_tree().paused = is_paused
	if(is_paused):
		on_paused.emit()
	else:
		on_unpaused.emit()

func request_time_scale(time_scale: float) -> bool:
	Engine.time_scale = time_scale
	return true
#endregion pausing
