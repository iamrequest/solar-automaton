@tool
extends WorldEnvironment

@export var axis := Vector3.ZERO
@export var speed := 0.1
@export var execute_in_editor:= false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		if(!execute_in_editor):
			return
	
	#$RotationProxy.rotation = $RotationProxy.rotation * Quaternion(axis, speed * delta)
	environment.sky_rotation = $RotationProxy.rotation_degrees
