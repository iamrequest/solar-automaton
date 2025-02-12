extends Node3D

signal on_level_end

@export var level_config: LevelConfig
@export var despawn_marker: Marker3D
@export var move_speed:= 1.0

var num_zones_spawned:= 0
var current_combat_zone: CombatZone

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	spawn_combat_zone()


func spawn_combat_zone():
	if(%GameManager.is_game_over):
		return
		
	if(is_instance_valid(current_combat_zone)):
		current_combat_zone = current_combat_zone
	
	# If we fail loading the combat zone, just end the level
	if(!try_instantiate_combat_zone()):
		on_level_end.emit()
	
	# Actually init the zone
	current_combat_zone.init(global_position, move_speed, despawn_marker.global_position)
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


func on_combat_zone_end():
	destroy_combat_zone(current_combat_zone)
	
	if(num_zones_spawned >= level_config.num_zones):
		on_level_end.emit()
	else:
		# TODO: If nothing left, end round
		spawn_combat_zone()

func destroy_combat_zone(combat_zone: CombatZone):
	if(!is_instance_valid(combat_zone)):
		return
	
	if(combat_zone.on_zone_end_reached.is_connected(on_combat_zone_end)):
		combat_zone.on_zone_end_reached.disconnect(on_combat_zone_end)
	
	combat_zone.destroy_self()
