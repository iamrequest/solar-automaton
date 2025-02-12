extends Node3D
class_name CombatZone

signal on_zone_end_reached(CombatZone)
signal zone_completed(CombatZone)

@export var linear_mover: LinearMover
@export var distance_tracker: LinearMoverDistanceTracker

# TODO: Support path movers when necessary
#@export var path_mover: PathMover

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_PAUSABLE

func init(spawn_position: Vector3, current_combat_speed: float, despawn_marker_pos: Vector3) -> void:
	# Move this node so that the combat zone start aligns with the spawn position
	var dirToStart = $CombatZoneStart.global_position - global_position
	global_position = spawn_position + dirToStart
	
	# TODO: Move static env relative to player?
	
	# Configure linear/path mover
	if(linear_mover):
		linear_mover.speed = current_combat_speed
		
		distance_tracker.combat_zone_length = ($CombatZoneEnd.global_position - $CombatZoneStart.global_position).length()
		distance_tracker.dist_to_despawn_marker = ($CombatZoneEnd.global_position - despawn_marker_pos).length()
		
		if(distance_tracker.combat_zone_length == 0.0):
			distance_tracker.combat_zone_length = 0.1		
		if(distance_tracker.dist_to_despawn_marker == 0.0):
			distance_tracker.dist_to_despawn_marker = 0.1
		
		distance_tracker.end_of_combat_zone_reached.connect(_on_mover_complete)
		distance_tracker.despawn_marker_reached.connect(_on_depawn_marker_reached)
#	elif(path_mover):
#		path_mover.speed = current_combat_speed
#		path_mover.path_completed.connect(on_mover_complete)

func _on_mover_complete() -> void:
	on_zone_end_reached.emit(self)

func _on_depawn_marker_reached():
	zone_completed.emit(self)
	
	# TODO: Maybe have a short delay before queueing free, to let static env fade out?
	queue_free()
