extends Node3D
			
@export var mesh_override: Node3D
@export var rotation_config: RotationConfig
@export var t_scale := 1.0
var t:= 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * t_scale * Engine.time_scale
	apply_rotation()

func apply_rotation():
	# Modulo operator doesn't work for floats
	var t_mod = t - floorf(t)
	var curve_output = rotation_config.curve.sample_baked(t_mod)
	var curve_output_remapped = remap(curve_output, 0.0, 1.0, rotation_config.curve_range_min, rotation_config.curve_range_max)
	
	var rotation_amount = rotation_config.rotation_amount * curve_output_remapped
	get_mesh().rotation_degrees += rotation_amount

func get_mesh() -> Node3D:
	if(mesh_override):
		return mesh_override
	return self
