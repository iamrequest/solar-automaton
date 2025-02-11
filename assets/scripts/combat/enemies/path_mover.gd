@tool
extends Path3D

@export var update_in_process:= true

@export var target_node: Node3D
@export var speed:= 1.0
@export var lerp_speed:= 0.9
@export var speedCurve: Curve

signal path_completed

func _ready() -> void:
	# Bake the curve, so we gaet better interpolation
	curve.sample_baked()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_process_editor()
		return
	
	if(update_in_process):
		do_move(delta)

func do_move(delta):
	if(!is_instance_valid(target_node)):
		return
		
	$PathFollow3D.progress += speedCurve.sample($PathFollow3D.progress_ratio) * speed * delta
	target_node.global_position = target_node.global_position.slerp($PathFollow3D.global_position, lerp_speed)
	
	if($PathFollow3D.progress_ratio >= 1.0):
		path_completed.emit()

func reset():
	$PathFollow3D.progress_ratio = 0.0

#region editor
@export_subgroup("Debug")
@export var editor_update_pos:= false
@export var editor_update_pos_ratio:= 0.0
func _process_editor():
	if(!editor_update_pos):
		return
		
	if(!target_node):
		return
	$PathFollow3D.progress_ratio = editor_update_pos_ratio
	target_node.global_position = $PathFollow3D.global_position
	
#endregion
