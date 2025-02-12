extends Node
class_name LinearMoverDistanceTracker

@export var linear_mover: LinearMover
@export var disable_at_end := false

signal end_of_combat_zone_reached
signal despawn_marker_reached
var combat_zone_length := 0.0
var dist_to_despawn_marker := 0.0

var has_passed_combat_zone_length:= false
var has_passed_despawn_marker:= false

var distance_elapsed:= 0.0

func _ready() -> void:
	linear_mover.moved.connect(on_moved)

func on_moved(distance: float) -> void:
	distance_elapsed += distance
	
	if(!has_passed_combat_zone_length and distance_elapsed >= combat_zone_length):
		has_passed_combat_zone_length = true
		end_of_combat_zone_reached.emit()
		
	if(!has_passed_despawn_marker and distance_elapsed >= dist_to_despawn_marker):
		linear_mover.is_active = !disable_at_end
		has_passed_despawn_marker = true
		despawn_marker_reached.emit()
	
