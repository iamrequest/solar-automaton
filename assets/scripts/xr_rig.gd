extends XROrigin3D
class_name XRRig

signal on_handedness_changed
@export var is_right_handed := true

func _ready() -> void:
	Globals.xr_rig = self
	
func get_dominant_hand() -> XRController3D:
	if(is_right_handed):
		return $RightHand
	return $LeftHand
	
func get_non_dominant_hand() -> XRController3D:
	if(is_right_handed):
		return $LeftHand
	return $RightHand

func _on_right_hand_button_pressed(name: String) -> void:
	print(name)

func set_handedness(is_right_handed: bool):
	if(self.is_right_handed == is_right_handed):
		pass
		
	self.is_right_handed = is_right_handed
	on_handedness_changed.emit()
