extends XROrigin3D
class_name XRRig

@export var is_right_handed = true

func get_dominant_hand() -> XRController3D:
	if(is_right_handed):
		return $RightHand
	return $LeftHand
	
func get_non_dominant_hand() -> XRController3D:
	if(is_right_handed):
		return $LeftHand
	return $RightHand
