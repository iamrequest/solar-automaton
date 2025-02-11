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
	
	%GameManager.on_level_completed.connect(_on_level_completed)
	%GameManager.on_level_failed.connect(_on_level_completed)
	%GameManager.on_paused.connect(_on_paused)
	%GameManager.on_unpaused.connect(_on_unpaused)

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
	$RightHand/FunctionPointer.enabled = is_enabled
	$RightHand/FunctionPointer.visible = is_enabled


func _on_level_completed() -> void:
	toggle_laser(true)
	
func _on_level_failed() -> void:
	toggle_laser(true)
	
func _on_paused() -> void:
	toggle_laser(true)
	
func _on_unpaused() -> void:
	toggle_laser(false)
