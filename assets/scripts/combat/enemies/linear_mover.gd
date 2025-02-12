extends Node3D
class_name LinearMover

signal end_reached

@export var is_active:=true
@export var target_node_override: Node3D
@export var speed:= 1.0

@export var disable_at_end:= false
@export var distance_max := 0.0
var distance_elapsed:= 0.0


func _process(delta: float) -> void:
	if(!is_active):
		return
	
	get_target().global_position -= global_transform.basis.z * speed * delta
	
	distance_elapsed += speed * delta * Engine.time_scale
	if(distance_elapsed >= distance_max):
		is_active = !disable_at_end
		end_reached.emit()
	
func get_target():
	if(is_instance_valid(target_node_override)):
		return target_node_override
	return self
