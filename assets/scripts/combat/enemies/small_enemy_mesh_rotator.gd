@tool
extends Node3D

@export var execute_in_editor := false

@export var head_rotation: RotationConfig
@export var body_rotation: RotationConfig
@export var ring_lower_rotation: RotationConfig
@export var ring_upper_rotation: RotationConfig

var t:= 0.0

func _ready() -> void:
	t = randf_range(0, 500)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		if(!execute_in_editor):
			return
		t += delta
	else:
		t += delta * Engine.time_scale
	
	apply_rotation($enemy_small/head, head_rotation)
	apply_rotation($enemy_small/body, body_rotation)
	apply_rotation($enemy_small/ring_lower, ring_lower_rotation)
	apply_rotation($enemy_small/ring_upper, ring_upper_rotation)

func apply_rotation(target_mesh: Node3D, rotation_config: RotationConfig):
	# Modulo operator doesn't work for floats
	var t_mod = t - floorf(t)
	var curve_output = rotation_config.curve.sample_baked(t_mod)
	var curve_output_remapped = remap(curve_output, 0.0, 1.0, rotation_config.curve_range_min, rotation_config.curve_range_max)
	
	var rotation_amount = rotation_config.rotation_amount * curve_output_remapped
	target_mesh.rotation_degrees += rotation_amount
	
