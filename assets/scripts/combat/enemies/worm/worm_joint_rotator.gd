extends Node
class_name WormJointRotator

enum JointRotationMode { None, Constant, Broken }
@export var joint_rotation_mode:= JointRotationMode.Constant:
	set(value):
		if(health_component.is_alive()):
			joint_rotation_mode = value
			
@export var health_component: HealthComponent
@export var mesh: Node3D
@export var constant_rotation: RotationConfig
@export var rotation_broken: RotationConfig

var t:= 0.0

func _ready() -> void:
	if(health_component):
		health_component.on_death.connect(_on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * Engine.time_scale
		
	match joint_rotation_mode:
		JointRotationMode.Constant:
			apply_rotation(constant_rotation)
		JointRotationMode.Broken:
			apply_rotation(rotation_broken)

func apply_rotation(rotation_config: RotationConfig):
	# Modulo operator doesn't work for floats
	var t_mod = t - floorf(t)
	var curve_output = rotation_config.curve.sample_baked(t_mod)
	var curve_output_remapped = remap(curve_output, 0.0, 1.0, rotation_config.curve_range_min, rotation_config.curve_range_max)
	
	var rotation_amount = rotation_config.rotation_amount * curve_output_remapped
	mesh.rotation_degrees += rotation_amount

func set_rotation(t: float):
	mesh.rotation_degrees = constant_rotation.rotation_amount.normalized() * t

func _on_death() -> void:
	joint_rotation_mode = JointRotationMode.Broken
