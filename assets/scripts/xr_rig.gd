extends XROrigin3D
class_name XRRig

signal on_handedness_changed
@export var is_right_handed := true

var hmd : XRCamera3D:
	get:
		return $XRCamera3D

func _ready() -> void:
	Globals.xr_rig = self
	toggle_laser(false)
	
func get_dominant_hand() -> XRController3D:
	if(is_right_handed):
		return $RightHand
	return $LeftHand
	
func get_non_dominant_hand() -> XRController3D:
	if(is_right_handed):
		return $LeftHand
	return $RightHand

func set_handedness(is_right_handed: bool):
	if(self.is_right_handed == is_right_handed):
		pass
		
	self.is_right_handed = is_right_handed
	on_handedness_changed.emit()

func toggle_laser(is_enabled: bool) -> void:
	$LeftHand/FunctionPointer.enabled = is_enabled
	$LeftHand/FunctionPointer.visible = is_enabled
	$RightHand/FunctionPointer.enabled = is_enabled
	$RightHand/FunctionPointer.visible = is_enabled

func recenter() -> void:
	pass

func trigger_haptics(is_right_hand: bool, intensity: float, duration: float, delay:= 0.0):
	var hand: XRController3D
	if(is_right_hand): 
		hand = $RightHand
	else:
		hand = $LeftHand
		
	# Passing a frequency of 0.0 to let OpenXR determine a good vibration frequency for the controller
	# https://forum.godotengine.org/t/haptic-feedback/67112/2
	hand.trigger_haptic_pulse("haptic", 0.0, intensity, duration, delay)
