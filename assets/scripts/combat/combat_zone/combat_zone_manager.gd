extends Node3D
class_name CombatZoneManager

signal on_level_end
signal on_speed_updated()

@export var spawn_marker: Marker3D
@export var despawn_marker: Marker3D
@export var xr_rig_marker: Marker3D

@export var level_config: LevelConfig
var num_zones_spawned:= 0
var current_combat_zone: CombatZone

# Debug
@export var move_speed := 5
var is_turbo_active
var move_speed_turbo_multiplier := 10

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	spawn_combat_zone()

func _process(delta: float) -> void:
	if(Globals.debug_mode_enabled):
		if(Globals.xr_rig.get_non_dominant_hand().get_input("secondary_click")):
			is_turbo_active = !is_turbo_active
			update_speed(move_speed)

func spawn_combat_zone():
	if(%GameManager.is_game_over):
		return
	
	# If we fail loading the combat zone, just end the level
	if(!try_instantiate_combat_zone()):
		on_level_end.emit()
	current_combat_zone.init(self)
	
	# If we're on the last zone, finish the level at the end of it
	# Otherwise, spawn the next zone at a point that lines up with the current one
	if(num_zones_spawned >= level_config.spawnable_zones.size()):
		current_combat_zone.zone_completed.connect(on_last_combat_zone_completed)
	else:
		current_combat_zone.on_zone_end_reached.connect(on_combat_zone_end)

func try_instantiate_combat_zone() -> bool:
	var prefab = level_config.get_zone(num_zones_spawned)
	var instance = prefab.instantiate()
	add_child(instance)
	
	num_zones_spawned += 1
	if(instance as CombatZone):
		current_combat_zone = instance as CombatZone
		return true
	
	return false


func on_combat_zone_end(zone: CombatZone):
	spawn_combat_zone()
		
func on_last_combat_zone_completed(zone: CombatZone):
	on_level_end.emit()

func set_speed(speed: float):
	move_speed = speed
	update_speed(speed)
	
func update_speed(speed: float):
	if(is_turbo_active):
		on_speed_updated.emit(speed * move_speed_turbo_multiplier)
	else:
		on_speed_updated.emit(speed)
