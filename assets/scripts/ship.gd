extends RigidBody3D

@export var move_speed := 1.0
@export var move_lerp_speed = 0.9
@export var rotation_lerp_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position(delta)
	update_rotation(delta)

func update_position(delta: float):
	# TODO: Update to snap to point on a plane if it exists
	var dominant_hand = Globals.xr_rig.get_dominant_hand() as Node3D
	
	if(dominant_hand):
		# Move towrads the target, but lerp it a little bit so it's not super sharp
		var target_pos = global_position.move_toward(dominant_hand.global_position, move_speed * delta)
		global_position = lerp(global_position, target_pos, move_lerp_speed)

func update_rotation(delta: float):
	var dominant_hand = Globals.xr_rig.get_dominant_hand() as Node3D
	var non_dominant_hand = Globals.xr_rig.get_non_dominant_hand() as Node3D
	
	if(dominant_hand and non_dominant_hand):
		# TODO: Also snap rotation to a point on the game plane?
		var target_tf = transform.looking_at(non_dominant_hand.global_position, dominant_hand.global_basis.y) as Transform3D
		var target_rot = target_tf.basis.get_rotation_quaternion()
		
		quaternion = target_rot
		quaternion = quaternion.slerp(target_rot, rotation_lerp_speed * delta)
		#rotation = transform.interpolate_with(target_rot, rotation_lerp_speed * delta).basis.get_euler()
