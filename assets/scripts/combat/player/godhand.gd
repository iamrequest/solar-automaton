extends Node3D

var init_hand_pos:= Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	init_hand_pos = $LeftPhysicsHand.position

func toggle(is_active: bool) -> void:
	$LeftPhysicsHand.visible = is_active
	if(is_active):
		$LeftPhysicsHand.position = Vector3.DOWN * 100
	else:
		$LeftPhysicsHand.position = init_hand_pos
	$XRToolsFunctionPickup.enabled = is_active
