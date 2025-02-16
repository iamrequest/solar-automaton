extends Node
class_name GameManager

signal on_level_completed
signal on_level_failed

signal on_paused
signal on_unpaused

@export var next_level: SceneReferences.Scenes

# Yes @OnReady exists, but I was getting race conditions between when @onready was initializing the var
var combat_zone_manager: CombatZoneManager:
	get:
		return %CombatZoneManager
		
var bgm_manager: BGMManager:
	get:
		return %OvaniPlayer

var is_paused:= false
var can_toggle_pause:= true
var is_game_over:= false
var currency:= 0
@export var pause_on_mission_complete:= true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Globals.game_manager = self
	
	await get_tree().process_frame 
	Globals.xr_rig.get_non_dominant_hand().button_pressed.connect(on_non_dominant_input_pressed)


func _on_ship_on_death() -> void:
	is_game_over = true
	$LevelFailedTimer.start()
	await $LevelFailedTimer.timeout
	toggle_pause(true, true)
	on_level_failed.emit()


func _on_combat_zone_manager_on_level_end() -> void:
	set_level_completed()

func set_level_completed() -> void:
	is_game_over = true
	on_level_completed.emit()
	if(pause_on_mission_complete):
		toggle_pause(true, true)


func load_next_level() -> void:
	# Find the XRToolsSceneBase ancestor of the current node
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		return
		
	toggle_pause(false, true)
	var scenes = load("res://assets/scenes/scene_references.tres") as SceneReferences
	scene_base.load_scene(scenes.get_scene_path(next_level))
	

#region Pausing	
func on_non_dominant_input_pressed(name: String):
	if(name == "ax_button"):
		toggle_pause(true)
	elif(name == "by_button"):
		toggle_pause(true)
			
			
func toggle_pause(is_paused: bool, force:= false) -> void:
	if(!can_toggle_pause):
		return
		
	if(self.is_paused == is_paused):
		return
	
	self.is_paused = is_paused
	get_tree().paused = is_paused
	
	# Some bug w/ the retry button I think
	request_time_scale(1.0)
	
	if(!force):
		if(is_paused):
			on_paused.emit()
		else:
			on_unpaused.emit()

func request_time_scale(time_scale: float) -> bool:
	Engine.time_scale = time_scale
	return true
#endregion pausing
