extends Node3D

@export var is_active:=true
@export var target_node_override: Node3D
@export var speed:= 1.0

func _process(delta: float) -> void:
	if(!is_active):
		return
		
	get_target().global_position -= global_transform.basis.z * speed * delta

func get_target():
	if(is_instance_valid(target_node_override)):
		return target_node_override
	return self
