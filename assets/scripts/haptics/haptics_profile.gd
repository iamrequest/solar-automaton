extends Resource
class_name HapticsProfile

@export_range(0.0, 1.0) var intensity_primary:= 0.5
@export_range(0.0, 1.0) var intensity_secondary:= 0.5
@export var intensity_duration:= 0.5

func fire():
	if(intensity_primary > 0):
		Globals.xr_rig.trigger_haptics(Globals.xr_rig.is_right_handed, intensity_primary, intensity_secondary)
	if(intensity_secondary > 0):
		Globals.xr_rig.trigger_haptics(Globals.xr_rig.is_right_handed, intensity_secondary, intensity_secondary)
