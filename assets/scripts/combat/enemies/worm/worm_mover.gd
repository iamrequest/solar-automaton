@tool
extends Path3D
class_name WormMover

# I ran into some weird bugs with getting/setting the position of the PathFollow3D multiple times per frame
# don't judge me for this lmao

var is_active:= false
@export var speed:= 1.0
@export var lerp_speed:= 0.9
@export var speedCurve: Curve

@export var progress_raw = 0.0

signal path_completed

func _ready() -> void:
	# Bake the curve, so we gaet better interpolation
	curve.sample_baked()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_process_editor()
		return

	if(is_active):
		do_move(delta)

func reset() -> void:
	progress_raw = 0
	
func do_move(delta):
	if(!is_instance_valid(%Worm)):
		return
	
	# Calculate the head position	
	progress_raw += speedCurve.sample($PathFollow3D_Head.progress_ratio) * speed * delta	
	
	# Given the raw position, go through each joint and set its transform to be a little back behind the raw curve position
	# This was some hot garbage thrown together to get around the PathFollow3D update issue - I may have been doing something wrong
	update_worm_joint(%Worm.head,             $PathFollow3D_Head,   0)
	update_worm_joint(%Worm.spine_columns[0], $PathFollow3D_Spine1, 0)
	update_worm_joint(%Worm.spine_columns[1], $PathFollow3D_Spine2, 1)
	update_worm_joint(%Worm.spine_columns[2], $PathFollow3D_Spine3, 2)
	update_worm_joint(%Worm.spine_columns[3], $PathFollow3D_Spine4, 3)
	update_worm_joint(%Worm.spine_columns[4], $PathFollow3D_Spine5, 4)
	update_worm_joint(%Worm.spine_columns[5], $PathFollow3D_Spine6, 5)
	update_worm_joint(%Worm.spine_columns[6], $PathFollow3D_Spine7, 6)
	update_worm_joint(%Worm.spine_columns[7], $PathFollow3D_Spine8, 7)
	update_worm_joint(%Worm.tail,             $PathFollow3D_Tail,   8)
	
	if($PathFollow3D_Tail.progress_ratio >= 1.0):
		path_completed.emit()
		is_active = false

func update_worm_joint(target: Node3D, joint: PathFollow3D, offset_multiplier: int):
	joint.progress = progress_raw - %Worm.spine_column_length * offset_multiplier

	target.global_position = target.global_position.lerp(joint.global_position, lerp_speed)
	
	# slerp() is complaining that the target rot is not normalized on some parts of the curve?
	# Maybe a fun PathFollower3D thing, idk
	if(joint.global_rotation.is_normalized()):
		target.global_rotation = target.global_rotation.slerp(joint.global_rotation, lerp_speed)
	else:
		target.global_rotation = joint.global_rotation

#region editor
@export_subgroup("Debug")
@export var editor_update_pos:= false
@export_range(0.0, 1.0) var editor_update_pos_ratio:= 0.0
func _process_editor():
	if(!editor_update_pos):
		return
		
	if(!%Worm):
		return
	
	#progress_raw = editor_update_pos_ratio
	update_worm_joint(%Worm.head,             $PathFollow3D_Head,   0)
	update_worm_joint(%Worm.spine_columns[0], $PathFollow3D_Spine1, 0)
	update_worm_joint(%Worm.spine_columns[1], $PathFollow3D_Spine2, 1)
	update_worm_joint(%Worm.spine_columns[2], $PathFollow3D_Spine3, 2)
	update_worm_joint(%Worm.spine_columns[3], $PathFollow3D_Spine4, 3)
	update_worm_joint(%Worm.spine_columns[4], $PathFollow3D_Spine5, 4)
	update_worm_joint(%Worm.spine_columns[5], $PathFollow3D_Spine6, 5)
	update_worm_joint(%Worm.spine_columns[6], $PathFollow3D_Spine7, 6)
	update_worm_joint(%Worm.spine_columns[7], $PathFollow3D_Spine8, 7)
	update_worm_joint(%Worm.tail,             $PathFollow3D_Tail,   8)
	
	return
	# This doesn't move all of the joints, just enough to test the setup
	$PathFollow3D_Head.progress_ratio = editor_update_pos_ratio
	%Worm.head.global_position = $PathFollow3D_Head.global_position
	%Worm.head.global_rotation = $PathFollow3D_Head.global_rotation
	
	$PathFollow3D_Spine1.progress = $PathFollow3D_Head.progress
	%Worm.spine_columns[0].global_position = $PathFollow3D_Spine1.global_position
	%Worm.spine_columns[0].global_rotation = $PathFollow3D_Spine1.global_rotation
	
	$PathFollow3D_Spine2.progress = $PathFollow3D_Spine1.progress - %Worm.spine_column_length
	%Worm.spine_columns[1].global_position = $PathFollow3D_Spine2.global_position
	%Worm.spine_columns[1].global_rotation = $PathFollow3D_Spine2.global_rotation

	
	# For some reason, I can set the progress_ratio and progress of the pathFollower only once per frame?
	# Trying to access the path follower position more than once per update (or whatever) does NOT work
	# I have 24h left, I'm making an array of path followers lol
	
	#$PathFollow3D.progress = $PathFollow3D.progress - offset
	#$PathFollow3D.progress = $PathFollow3D.progress - worm.spine_column_length
	#worm.spine_columns[1].global_position = $PathFollow3D.global_position
	#worm.spine_columns[1].global_rotation = $PathFollow3D/AlignmentOffset.global_rotation
	
	#for i in worm.spine_columns.size():
	#	$PathFollow3D.progress = maxf($PathFollow3D.progress - worm.spine_column_length, 0.0)
	#	worm.spine_columns[i].global_position = $PathFollow3D.global_position
	#	worm.spine_columns[i].global_rotation = $PathFollow3D/AlignmentOffset.global_rotation
	#$PathFollow3D.progress_ratio = editor_update_pos_ratio
	
#endregion
