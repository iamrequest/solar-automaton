extends Button

var haptics_hover_intensity = 0.05
var haptics_hover_duration = 0.1

@export var haptics_press_intensity = 0.2
@export var haptics_press_duration = 0.2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	Globals.xr_rig.trigger_haptics(true, haptics_hover_intensity, haptics_hover_duration)
	Globals.xr_rig.trigger_haptics(false, haptics_hover_intensity, haptics_hover_duration)

func _on_pressed() -> void:
	Globals.xr_rig.trigger_haptics(true, haptics_press_intensity, haptics_press_duration)
	Globals.xr_rig.trigger_haptics(false, haptics_press_intensity, haptics_press_duration)
