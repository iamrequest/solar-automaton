extends Node3D
class_name CombatZone

signal on_zone_end_reached

@export var linear_mover: LinearMover

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
		
		linear_mover.distance_max = ($CombatZoneEnd.global_position - despawn_marker_pos).length()
		if(linear_mover.distance_max == 0.0):
			linear_mover.distance_max = 0.1
		
		linear_mover.end_reached.connect(on_mover_complete)
#	elif(path_mover):
#		path_mover.speed = current_combat_speed
#		path_mover.path_completed.connect(on_mover_complete)

func on_mover_complete() -> void:
	on_zone_end_reached.emit()

func destroy_self():
	# TODO: Maybe have a short delay before queueing free, to let static env fade out?
	queue_free()
