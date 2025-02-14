extends RigidBody3D
class_name Ship

signal on_death

@export var move_speed := 1.0
@export var move_lerp_speed = 0.9
@export var rotation_lerp_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	%GameManager.on_level_completed.connect(_on_level_completed)


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
	rotate_to_dominant_hand(delta)

func rotate_to_dominant_hand(delta: float):
	var dominant_hand = Globals.xr_rig.get_dominant_hand() as Node3D
	
	if(dominant_hand):
		# TODO: Also snap rotation to a point on the game plane?
		quaternion = quaternion.slerp(dominant_hand.quaternion, rotation_lerp_speed)
		
		
# Lookat non-dominant hand, up is dominant hand
func rotate_to_face_non_dominant_hand(delta: float):
	var dominant_hand = Globals.xr_rig.get_dominant_hand() as Node3D
	var non_dominant_hand = Globals.xr_rig.get_non_dominant_hand() as Node3D
	
	if(dominant_hand and non_dominant_hand):
		# TODO: Also snap rotation to a point on the game plane?
		var target_tf = transform.looking_at(non_dominant_hand.global_position, dominant_hand.global_basis.y) as Transform3D
		var target_rot = target_tf.basis.get_rotation_quaternion()
		
		quaternion = target_rot
		quaternion = quaternion.slerp(target_rot, rotation_lerp_speed * delta)


func _on_health_component_on_death() -> void:
	on_death.emit()
	time_slow(0.5, 0.5)
	$DeathTimer.start()
	await $DeathTimer.timeout
	queue_free()
	
func _on_health_component_on_damage_recieved(int: Variant) -> void:
	time_slow(0.5, 0.5)
	

func _on_level_completed() -> void:
	visible = false
	
func time_slow(time_scale: float, duration: float):
	%GameManager.request_time_scale(time_scale)
	await get_tree().create_timer(duration).timeout
	
	# TODO: Should lerp this back
	if(%GameManager.is_paused):
		return
	%GameManager.request_time_scale(1.0)
